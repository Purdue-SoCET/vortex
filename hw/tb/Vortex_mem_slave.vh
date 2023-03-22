`ifndef VORTEX_MEM_SLAVE_DEFINE
`define VORTEX_MEM_SLAVE_DEFINE

// size of register file (128 Kb -> 16 KB -> 16*2^10 B -> 2^14 B -> 0x4000 B worth of byte address space)
`define REG_FILE_BYTE_WIDTH 14
`define REG_FILE_BYTE_SIZE 2**REG_FILE_BYTE_WIDTH

`define WORD_SIZE 32

//////////////////////////////////
// Generic Bus Interface (AHB): //
//////////////////////////////////

// typedef logic [WORD_SIZE-1:0] word_t;
typedef logic [32-1:0] word_t;

interface generic_bus_if ();
    // import rv32i_types_pkg::*;

    // logic [RAM_ADDR_SIZE-1:0] addr;
    logic [32-1:0] addr;                // RAM_ADDR_SIZE = 32
    word_t wdata;
    word_t rdata;
    logic ren,wen;
    logic busy;
    logic [3:0] byte_en;

    modport generic_bus (
        input addr, ren, wen, wdata, byte_en,
        output rdata, busy
    );

    modport cpu (
        input rdata, busy,
        output addr, ren, wen, wdata, byte_en
    );

endinterface

`endif //GENERIC_BUS_IF_VH