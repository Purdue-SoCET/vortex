#include <chrono>
#include <climits>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <sstream>

#include "verilated.h"
#include "verilated_fst_c.h"
#include "Vaftx07.h"

//Vortex files 
#include "VVortex.h"
#include "VVortex__Syms.h"


uint64_t sim_time = 0;
const unsigned int MILLION = 1000000;
class MemoryMap;

struct TBCfg {
    bool trace_en;
    unsigned int cycle_limit;
    char *fname;
    Vaftx07 *dutp;
    MemoryMap *memp;
    Vvortex *dut_vortexp;
    VerilatedFstC *tracep;
};

struct TBCfg config;

void print_config() {
    std::cout << "Configuration: " << std::endl;
    std::cout << "\tTrace: " << ((config.trace_en) ? "Enabled" : "Disabled") << std::endl;
    std::cout << "\tCycle Limit: " << config.cycle_limit << std::endl;
    std::cout << "\tBinary file: " << config.fname << std::endl;

    if(config.trace_en && config.cycle_limit > 10 * MILLION) {
        std::cout << "WARNING: Enabling trace leads to extreme slowdown in simulation! Are you sure you want to run for >10M cycles with trace enabled?";
    }
}

void print_help_exit() {
    std::cerr << "/-------------\\" << std::endl;
    std::cerr << "| AFTx06 Sim  |" << std::endl;
    std::cerr << "\\-------------/" << std::endl;
    std::cerr << "Usage: ./Vaftx07 [filename] [flags...]" << std::endl;
    std::cerr << "\tfilename: path to binary for simulation" << std::endl;
    std::cerr << "\t--trace-en: Enable FST wave tracing" << std::endl;
    std::cerr << "\t--cycle-limit n: Set cycle count limit to n" << std::endl;
    std::cerr << "\t--help: Print this" << std::endl;
    exit(1);
}

void parse_cli(int argc, char **argv) {
    static char DEFAULT_FNAME[] = "meminit.bin";
    const char *TRACE_FLAG = "--trace-en";
    const char *CYCLE_LIMIT = "--cycle-limit";
    const char *HELP = "--help";

    config.trace_en = false;
    config.cycle_limit = UINT_MAX;
    config.fname = DEFAULT_FNAME;
    
    for(int i = 1; i < argc; i++) {
        if(!strncmp(TRACE_FLAG, argv[i], strlen(TRACE_FLAG))) {
            config.trace_en = true;
        } else if(!strncmp(CYCLE_LIMIT, argv[i], strlen(CYCLE_LIMIT))) {
            unsigned int cycle_limit;
            if(argc <= i + 1) {
                std::cerr << "Flag --cycle-limit requires an integer argument!" << std::endl;
                print_help_exit();
            }

            config.cycle_limit = atol(argv[i+1]);

            i++;
        } else if(!strncmp(HELP, argv[i], strlen(HELP))) {
            print_help_exit();
        } else if(i == 1) {
            config.fname = argv[i];
        } else {
            std::cerr << "Unrecognized argument: " << argv[i] << std::endl;
            print_help_exit();
        }
    }
}

class MemoryMap {
private:

    const uint32_t c_default_value = 0xBAD1BAD1;
    const char *dumpfile = "memsim.dump";
    std::map<uint32_t, uint32_t> mmap;

protected:
    inline uint32_t expand_mask(uint8_t mask) {
        uint32_t acc = 0;
        for(int i = 0; i < 4; i++) {
            auto bit = ((mask & (1 << i)) != 0);
            if(bit) {
                acc |= (0xFF << (i * 8));
            }
        }

        return acc;
    }

public:

    MemoryMap(const char *fname) {
        uint32_t address = 0x8400;
        std::ifstream myFile(fname, std::ios::in | std::ios::binary);
        if(!myFile) {
            std::ostringstream ss;
            ss << "Couldn't open " << fname << std::endl;
            std::cout << ss.str();
            throw ss.str();
        }

        while(!myFile.eof()) {
            uint32_t data;
            myFile.read((char *)&data, sizeof(data));

            mmap.insert(std::make_pair(address, data));

            address += 4;
        }
    }

    uint32_t read(uint32_t addr) {
        //std::cout << "Read [" << addr << "]" << std::endl;
        auto it = mmap.find(addr);
        if(it != mmap.end()) {
            return __builtin_bswap32(it->second);
        } else {
            return c_default_value;
        }
    }

    void write(uint32_t addr, uint32_t value, uint8_t mask) {
        #ifdef DEBUG_MODE
        std::cout << "Write [" << std::hex << addr << "] = " << __builtin_bswap32(value) << "(Mask " << (uint32_t)mask << ")" << std::dec << std::endl;
        #endif
        // NOTE: For now, assuming that all memory is legally acessible.
        if(addr == 0x20000) {
            uint32_t swapped = __builtin_bswap32(value);
            switch(mask) {
                // 1-byte
                case 0x1: std::cout << (char)((swapped >> 24)& 0xFF);
                    break;
                case 0x2: std::cout << (char)((swapped >> 16) & 0xFF);
                    break;
                case 0x4: std::cout << (char)((swapped >> 8) & 0xFF);
                    break;
                case 0x8: std::cout << (char)((swapped >> 0) & 0xFF);
                    break;
                // 2-byte
                case 0x3: std::cout << std::hex << ((uint16_t)(swapped >> 16) & 0xFFFF) << std::dec << std::endl;
                    break;
                case 0xC: std::cout << std::hex << ((uint16_t)swapped & 0xFFFF) << std::dec << std::endl;
                    break;
                case 0xF: std::cout << std::hex << ((uint32_t)swapped) << std::dec << std::endl;
            }
            //std::cout << (char)(__builtin_bswap32(value) & 0xFF);
            //putchar((char)(value & expand_mask(mask)));
        } else {
            // TODO: This masking doesn't seem right
            auto it = mmap.find(addr);
            if(it != mmap.end()) {
                auto mask_exp = expand_mask(mask);
                it->second = __builtin_bswap32(value & mask_exp) | __builtin_bswap32(__builtin_bswap32(it->second) & ~mask_exp);
            } else {
                mmap.insert(std::make_pair(addr, __builtin_bswap32(value)));
            }
        }
    }

    void dump() {
        std::ofstream outfile;
        outfile.open(dumpfile);
        if(!outfile) {
            std::ostringstream ss;
            ss << "Couldn't open " << dumpfile << std::endl;
            throw ss.str();
        }

        for(auto p : mmap) {
            //if(p.second != 0) {
                char buf[80];
                snprintf(buf, 80, "%08x : %02x%02x%02x%02x", p.first, 
                        (p.second & 0xFF000000) >> 24, 
                        (p.second & 0x00FF0000) >> 16, 
                        (p.second & 0x0000FF00) >> 8, 
                        p.second & 0x000000FF);
                outfile << buf << std::endl;
            //}
        }
    }
};

void signalHandler(int signum) {
    std::cout << "Got signal " << signum << std::endl;
    std::cout << "Calling SystemVerilog 'final' block & exiting!" << std::endl;

    config.dutp->final();
    config.memp->dump();

    if(config.trace_en) {
        config.tracep->close();
    }

    exit(signum);
}

void tick(Vaftx07& dut, VVortex& dut_vortex, VerilatedFstC& trace) {
    dut.CLK = 0;
    dut_vortex.clk = 0;
    dut.eval();
    dut_vortex.eval();
    if(config.trace_en) trace.dump(sim_time);
    sim_time++;
    dut.CLK = 1;
    dut_vortex.clk = 1;
    dut.eval();
    dut_vortex.eval();
    if(config.trace_en) trace.dump(sim_time);
    sim_time++;
}

void reset(Vaftx07& dut, VVortex& dut_vortex, VerilatedFstC& trace) {
    dut.CLK = 0;
    dut.nRST = 0;
    dut_vortex.clk = 0;
    dut_vortex.nrst = 0;
    tick(dut, dut_vortex, trace);
    dut.nRST = 0;
    dut_vortex.nrst = 0;
    tick(dut, dut_vortex, trace);
    dut.nRST = 1;
    dut_vortex.nrst = 1;
    tick(dut, dut_vortex, trace);
}


int main(int argc, char **argv) {

    signal(SIGINT, signalHandler);
    parse_cli(argc, argv);
    print_config();
    
    std::cout << "Constructing DUT model" << std::endl;
    Vaftx07 dut;
    VVortex dut_vortex;
    
    VerilatedFstC m_trace;
    //MemoryMap memory(config.fname);

    config.dutp = &dut;
    //config.memp = &memory;
    conif.dut_vortexp = &dut_vortex;
    config.tracep = &m_trace;

    if(config.trace_en) {
        Verilated::traceEverOn(true);
        dut.trace(&m_trace, 5);
        m_trace.open("waveform.fst");
    }

    std::cout << "------------------" << std::endl;
    std::cout << " Simulation Begin" << std::endl;
    std::cout << "------------------" << std::endl;

    auto count = 500;

    auto tstart = std::chrono::high_resolution_clock::now();

    reset(dut, dut_vortex, m_trace);

    // Main loop
    /*while(!Verilated::gotFinish() && sim_time < config.cycle_limit) {
        if(sim_time % 1000000 == 0) {
            std::cout << "Cycle " << sim_time << std::endl;
        }
        // Write enable
        if((~dut.offchip_sramif_nWE_out & 0xF) != 0) {
            uint8_t write_mask = ~dut.offchip_sramif_nWE_out & 0xF;
            memory.write((dut.offchip_sramif_external_addr << 2), 
                            dut.offchip_sramif_external_bidir_out,
                            write_mask);
        // Read enable
        } else if(dut.offchip_sramif_nOE == 0) {
            uint32_t value = memory.read(dut.offchip_sramif_external_addr << 2);
            dut.offchip_sramif_external_bidir_in = value;
        }
        tick(dut, m_trace);
    }*/

    while(!Verilated::gotFinish() && sim_time < config.cycle_limit) {
        tick(dut, dut_vortex, m_trace);
        count -= 1;
        if(count == 1) {
            dut.gpio_in = 0xFF;
        } else if(count == 0) {
            dut.gpio_in = 0;
            count = 500;
        }
    }

    auto tend = std::chrono::high_resolution_clock::now();

    auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(tend - tstart);

    std::cout << "Simulated " << sim_time << " cycles in " << ms.count() << "ms" << ", rate of " << (float)sim_time / ((float)ms.count() / 1000.0) << " cycles per second." << std::endl;

    if(config.trace_en) {
        m_trace.close();
    }
    //memory.dump();
    dut.final();
    dut_vortex.final();
    return 0;
}
