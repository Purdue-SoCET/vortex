/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    module for on-chip RAM fake register file with AFTx07 AHB slave interface (at generic bus interface) 
    and Vortex memory interface 

    assumptions:
        AHB only references word addresses
*/

// temporary include to have defined vals
`include "Vortex_mem_slave.vh"

// include for Vortex widths
`include "../include/VX_define.vh"

module Vortex_mem_slave #(
    /////////////////
    // parameters: //
    /////////////////

    // parameter VORTEX_START_PC_ADDR = 32'h80000000,
    parameter VORTEX_MEM_SLAVE_AHB_BASE_ADDR = 32'hF000_0000,
    // parameter LOCAL_MEM_SIZE = 12
	parameter LOCAL_MEM_SIZE = 14
)(
    /////////////////
    // Sequential: //
    /////////////////
    input clk, nRST,

    ///////////////////////
    // Memory Interface: //
    ///////////////////////

    // Memory Request:
    // vortex outputs
    input logic                             mem_req_valid,
    input logic                             mem_req_rw,
    input logic [`VX_MEM_BYTEEN_WIDTH-1:0]  mem_req_byteen, // 64 (512 / 8)
    input logic [`VX_MEM_ADDR_WIDTH-1:0]    mem_req_addr,   // 26
    input logic [`VX_MEM_DATA_WIDTH-1:0]    mem_req_data,   // 512
    input logic [`VX_MEM_TAG_WIDTH-1:0]     mem_req_tag,    // 56 (55 for SM disabled)
    // vortex inputs
    output logic                            mem_req_ready,

    // Memory response:
    // vortex inputs
    output logic                            mem_rsp_valid,        
    output logic [`VX_MEM_DATA_WIDTH-1:0]   mem_rsp_data,   // 512
    output logic [`VX_MEM_TAG_WIDTH-1:0]    mem_rsp_tag,    // 56 (55 for SM disabled)
    // vortex outputs
    input logic                             mem_rsp_ready,

    // Status:
    // vortex outputs
    input logic                             busy,

    //////////////////////////////////
    // Generic Bus Interface (AHB): //
    //////////////////////////////////

    bus_protocol_if.peripheral_vital        bpif
        // // Vital signals
        // logic wen; // request is a data write
        // logic ren; // request is a data read
        // logic request_stall; // High when protocol should insert wait states in transaction
        // logic [ADDR_WIDTH-1 : 0] addr; // *offset* address of request TODO: Is this good for general use?
        // logic error; // Indicate error condition to bus
        // logic [(DATA_WIDTH/8)-1 : 0] strobe; // byte enable for writes
        // logic [DATA_WIDTH-1 : 0] wdata, rdata; // data lines -- from perspective of bus master. rdata should be data read from peripheral.

        // modport peripheral_vital (
        //     input wen, ren, addr, wdata, strobe,
        //     output rdata, error, request_stall
        // );
);

    ///////////////////////
    // internal signals: //
    ///////////////////////

    // bad address signals
    logic Vortex_bad_address;
    // logic AHB_bad_address;

    // buffered Vortex memory interface signals
    logic                           next_mem_rsp_valid;
    logic [`VX_MEM_DATA_WIDTH-1:0]  next_mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]   next_mem_rsp_tag;

    // reg file signals (bytewise, packed)
    // logic [2**14-1:0][7:0] reg_file;
    // logic [2**14-1:0][7:0] next_reg_file;
    logic [2**LOCAL_MEM_SIZE-1:0][7:0] reg_file;
    logic [2**LOCAL_MEM_SIZE-1:0][7:0] next_reg_file;

    ////////////////
    // registers: //
    ////////////////

    // output buffer registers
    always_ff @ (posedge clk, negedge nRST) begin : VORTEX_MEM_INTERFACE_OUTPUT_BUFFER_FF_LOGIC
        if (~nRST)
        begin
            mem_rsp_valid <= 1'b0;
            mem_rsp_data <= 512'd0;
            mem_rsp_tag <= 26'd0;
        end
        else
        begin
            mem_rsp_valid <= next_mem_rsp_valid;
            mem_rsp_data <= next_mem_rsp_data;
            mem_rsp_tag <= next_mem_rsp_tag;
        end
    end

    // reg file instance
    always_ff @ (posedge clk, negedge nRST) begin : REG_FILE_FF_LOGIC
        if (~nRST)
        begin
            // LOAD_ZEROS
            reg_file <= '0;
        end
        else
        begin
            reg_file <= next_reg_file;
        end
    end

    // combinational logic for memory interface
    always_comb begin : OTHER_MEM_COMB_LOGIC

        //////////////////////
        // default outputs: //
        //////////////////////

        // hold mem
        next_reg_file = reg_file;

        // Vortex outputs
        // mem_rsp_data = 512'd0;   // updated for buffer
        next_mem_rsp_data = 512'd0;

        // AHB outputs
        bpif.error = 1'b0;
        bpif.request_stall = 1'b0;

        //////////////////
        // bad address: //
        //////////////////

        // Vortex bad address
        // if (mem_req_addr[25:8] != 18'b100000000000000000)
        if (mem_req_addr[32-6-1:LOCAL_MEM_SIZE-6] != VORTEX_MEM_SLAVE_AHB_BASE_ADDR[32-1:LOCAL_MEM_SIZE])
        begin
            Vortex_bad_address = 1'b1;
        end
        else
        begin
            Vortex_bad_address = 1'b0;
        end

        // AHB bad address
        // if (gbif.addr[31:14] != 18'b101100000000000000)
        // if (bpif.addr[32-1:LOCAL_MEM_SIZE] != VORTEX_LOCAL_MEM_AHB_BASE_ADDR[32-1:LOCAL_MEM_SIZE])
        // begin
        //     AHB_bad_address = 1'b1;
        //     bpif.error = 1'b1;
        // end
        // else
        // begin
        //     AHB_bad_address = 1'b0;
        //     bpif.error = 1'b0;
        // end

        /////////////////
        // read logic: //
        /////////////////

        // Vortex read logic (this part is automated by load_Vortex_mem_slave.py)
        next_mem_rsp_data[7:0] = reg_file[{mem_req_addr[7:0], 6'd0}];
        next_mem_rsp_data[15:8] = reg_file[{mem_req_addr[7:0], 6'd1}];
        next_mem_rsp_data[23:16] = reg_file[{mem_req_addr[7:0], 6'd2}];
        next_mem_rsp_data[31:24] = reg_file[{mem_req_addr[7:0], 6'd3}];
        next_mem_rsp_data[39:32] = reg_file[{mem_req_addr[7:0], 6'd4}];
        next_mem_rsp_data[47:40] = reg_file[{mem_req_addr[7:0], 6'd5}];
        next_mem_rsp_data[55:48] = reg_file[{mem_req_addr[7:0], 6'd6}];
        next_mem_rsp_data[63:56] = reg_file[{mem_req_addr[7:0], 6'd7}];
        next_mem_rsp_data[71:64] = reg_file[{mem_req_addr[7:0], 6'd8}];
        next_mem_rsp_data[79:72] = reg_file[{mem_req_addr[7:0], 6'd9}];
        next_mem_rsp_data[87:80] = reg_file[{mem_req_addr[7:0], 6'd10}];
        next_mem_rsp_data[95:88] = reg_file[{mem_req_addr[7:0], 6'd11}];
        next_mem_rsp_data[103:96] = reg_file[{mem_req_addr[7:0], 6'd12}];
        next_mem_rsp_data[111:104] = reg_file[{mem_req_addr[7:0], 6'd13}];
        next_mem_rsp_data[119:112] = reg_file[{mem_req_addr[7:0], 6'd14}];
        next_mem_rsp_data[127:120] = reg_file[{mem_req_addr[7:0], 6'd15}];
        next_mem_rsp_data[135:128] = reg_file[{mem_req_addr[7:0], 6'd16}];
        next_mem_rsp_data[143:136] = reg_file[{mem_req_addr[7:0], 6'd17}];
        next_mem_rsp_data[151:144] = reg_file[{mem_req_addr[7:0], 6'd18}];
        next_mem_rsp_data[159:152] = reg_file[{mem_req_addr[7:0], 6'd19}];
        next_mem_rsp_data[167:160] = reg_file[{mem_req_addr[7:0], 6'd20}];
        next_mem_rsp_data[175:168] = reg_file[{mem_req_addr[7:0], 6'd21}];
        next_mem_rsp_data[183:176] = reg_file[{mem_req_addr[7:0], 6'd22}];
        next_mem_rsp_data[191:184] = reg_file[{mem_req_addr[7:0], 6'd23}];
        next_mem_rsp_data[199:192] = reg_file[{mem_req_addr[7:0], 6'd24}];
        next_mem_rsp_data[207:200] = reg_file[{mem_req_addr[7:0], 6'd25}];
        next_mem_rsp_data[215:208] = reg_file[{mem_req_addr[7:0], 6'd26}];
        next_mem_rsp_data[223:216] = reg_file[{mem_req_addr[7:0], 6'd27}];
        next_mem_rsp_data[231:224] = reg_file[{mem_req_addr[7:0], 6'd28}];
        next_mem_rsp_data[239:232] = reg_file[{mem_req_addr[7:0], 6'd29}];
        next_mem_rsp_data[247:240] = reg_file[{mem_req_addr[7:0], 6'd30}];
        next_mem_rsp_data[255:248] = reg_file[{mem_req_addr[7:0], 6'd31}];
        next_mem_rsp_data[263:256] = reg_file[{mem_req_addr[7:0], 6'd32}];
        next_mem_rsp_data[271:264] = reg_file[{mem_req_addr[7:0], 6'd33}];
        next_mem_rsp_data[279:272] = reg_file[{mem_req_addr[7:0], 6'd34}];
        next_mem_rsp_data[287:280] = reg_file[{mem_req_addr[7:0], 6'd35}];
        next_mem_rsp_data[295:288] = reg_file[{mem_req_addr[7:0], 6'd36}];
        next_mem_rsp_data[303:296] = reg_file[{mem_req_addr[7:0], 6'd37}];
        next_mem_rsp_data[311:304] = reg_file[{mem_req_addr[7:0], 6'd38}];
        next_mem_rsp_data[319:312] = reg_file[{mem_req_addr[7:0], 6'd39}];
        next_mem_rsp_data[327:320] = reg_file[{mem_req_addr[7:0], 6'd40}];
        next_mem_rsp_data[335:328] = reg_file[{mem_req_addr[7:0], 6'd41}];
        next_mem_rsp_data[343:336] = reg_file[{mem_req_addr[7:0], 6'd42}];
        next_mem_rsp_data[351:344] = reg_file[{mem_req_addr[7:0], 6'd43}];
        next_mem_rsp_data[359:352] = reg_file[{mem_req_addr[7:0], 6'd44}];
        next_mem_rsp_data[367:360] = reg_file[{mem_req_addr[7:0], 6'd45}];
        next_mem_rsp_data[375:368] = reg_file[{mem_req_addr[7:0], 6'd46}];
        next_mem_rsp_data[383:376] = reg_file[{mem_req_addr[7:0], 6'd47}];
        next_mem_rsp_data[391:384] = reg_file[{mem_req_addr[7:0], 6'd48}];
        next_mem_rsp_data[399:392] = reg_file[{mem_req_addr[7:0], 6'd49}];
        next_mem_rsp_data[407:400] = reg_file[{mem_req_addr[7:0], 6'd50}];
        next_mem_rsp_data[415:408] = reg_file[{mem_req_addr[7:0], 6'd51}];
        next_mem_rsp_data[423:416] = reg_file[{mem_req_addr[7:0], 6'd52}];
        next_mem_rsp_data[431:424] = reg_file[{mem_req_addr[7:0], 6'd53}];
        next_mem_rsp_data[439:432] = reg_file[{mem_req_addr[7:0], 6'd54}];
        next_mem_rsp_data[447:440] = reg_file[{mem_req_addr[7:0], 6'd55}];
        next_mem_rsp_data[455:448] = reg_file[{mem_req_addr[7:0], 6'd56}];
        next_mem_rsp_data[463:456] = reg_file[{mem_req_addr[7:0], 6'd57}];
        next_mem_rsp_data[471:464] = reg_file[{mem_req_addr[7:0], 6'd58}];
        next_mem_rsp_data[479:472] = reg_file[{mem_req_addr[7:0], 6'd59}];
        next_mem_rsp_data[487:480] = reg_file[{mem_req_addr[7:0], 6'd60}];
        next_mem_rsp_data[495:488] = reg_file[{mem_req_addr[7:0], 6'd61}];
        next_mem_rsp_data[503:496] = reg_file[{mem_req_addr[7:0], 6'd62}];
        next_mem_rsp_data[511:504] = reg_file[{mem_req_addr[7:0], 6'd63}];

        // AHB read logic
        bpif.rdata[7:0] = reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd0}];
        bpif.rdata[15:8] = reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd1}];
        bpif.rdata[23:16] = reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd2}];
        bpif.rdata[31:24] = reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd3}];

        //////////////////////////////////////////
        // Vortex write logic (first priority): //
        //////////////////////////////////////////

        // check for valid, write, and address in range
        // if (mem_req_valid & mem_req_rw & ~Vortex_bad_address)
        if (mem_req_valid & mem_req_rw)
        begin
            // this part is automated by load_Vortex_mem_slave.py:
            if (mem_req_byteen[0]) next_reg_file[{mem_req_addr[7:0], 6'd0}] = mem_req_data[7:0];
            if (mem_req_byteen[1]) next_reg_file[{mem_req_addr[7:0], 6'd1}] = mem_req_data[15:8];
            if (mem_req_byteen[2]) next_reg_file[{mem_req_addr[7:0], 6'd2}] = mem_req_data[23:16];
            if (mem_req_byteen[3]) next_reg_file[{mem_req_addr[7:0], 6'd3}] = mem_req_data[31:24];
            if (mem_req_byteen[4]) next_reg_file[{mem_req_addr[7:0], 6'd4}] = mem_req_data[39:32];
            if (mem_req_byteen[5]) next_reg_file[{mem_req_addr[7:0], 6'd5}] = mem_req_data[47:40];
            if (mem_req_byteen[6]) next_reg_file[{mem_req_addr[7:0], 6'd6}] = mem_req_data[55:48];
            if (mem_req_byteen[7]) next_reg_file[{mem_req_addr[7:0], 6'd7}] = mem_req_data[63:56];
            if (mem_req_byteen[8]) next_reg_file[{mem_req_addr[7:0], 6'd8}] = mem_req_data[71:64];
            if (mem_req_byteen[9]) next_reg_file[{mem_req_addr[7:0], 6'd9}] = mem_req_data[79:72];
            if (mem_req_byteen[10]) next_reg_file[{mem_req_addr[7:0], 6'd10}] = mem_req_data[87:80];
            if (mem_req_byteen[11]) next_reg_file[{mem_req_addr[7:0], 6'd11}] = mem_req_data[95:88];
            if (mem_req_byteen[12]) next_reg_file[{mem_req_addr[7:0], 6'd12}] = mem_req_data[103:96];
            if (mem_req_byteen[13]) next_reg_file[{mem_req_addr[7:0], 6'd13}] = mem_req_data[111:104];
            if (mem_req_byteen[14]) next_reg_file[{mem_req_addr[7:0], 6'd14}] = mem_req_data[119:112];
            if (mem_req_byteen[15]) next_reg_file[{mem_req_addr[7:0], 6'd15}] = mem_req_data[127:120];
            if (mem_req_byteen[16]) next_reg_file[{mem_req_addr[7:0], 6'd16}] = mem_req_data[135:128];
            if (mem_req_byteen[17]) next_reg_file[{mem_req_addr[7:0], 6'd17}] = mem_req_data[143:136];
            if (mem_req_byteen[18]) next_reg_file[{mem_req_addr[7:0], 6'd18}] = mem_req_data[151:144];
            if (mem_req_byteen[19]) next_reg_file[{mem_req_addr[7:0], 6'd19}] = mem_req_data[159:152];
            if (mem_req_byteen[20]) next_reg_file[{mem_req_addr[7:0], 6'd20}] = mem_req_data[167:160];
            if (mem_req_byteen[21]) next_reg_file[{mem_req_addr[7:0], 6'd21}] = mem_req_data[175:168];
            if (mem_req_byteen[22]) next_reg_file[{mem_req_addr[7:0], 6'd22}] = mem_req_data[183:176];
            if (mem_req_byteen[23]) next_reg_file[{mem_req_addr[7:0], 6'd23}] = mem_req_data[191:184];
            if (mem_req_byteen[24]) next_reg_file[{mem_req_addr[7:0], 6'd24}] = mem_req_data[199:192];
            if (mem_req_byteen[25]) next_reg_file[{mem_req_addr[7:0], 6'd25}] = mem_req_data[207:200];
            if (mem_req_byteen[26]) next_reg_file[{mem_req_addr[7:0], 6'd26}] = mem_req_data[215:208];
            if (mem_req_byteen[27]) next_reg_file[{mem_req_addr[7:0], 6'd27}] = mem_req_data[223:216];
            if (mem_req_byteen[28]) next_reg_file[{mem_req_addr[7:0], 6'd28}] = mem_req_data[231:224];
            if (mem_req_byteen[29]) next_reg_file[{mem_req_addr[7:0], 6'd29}] = mem_req_data[239:232];
            if (mem_req_byteen[30]) next_reg_file[{mem_req_addr[7:0], 6'd30}] = mem_req_data[247:240];
            if (mem_req_byteen[31]) next_reg_file[{mem_req_addr[7:0], 6'd31}] = mem_req_data[255:248];
            if (mem_req_byteen[32]) next_reg_file[{mem_req_addr[7:0], 6'd32}] = mem_req_data[263:256];
            if (mem_req_byteen[33]) next_reg_file[{mem_req_addr[7:0], 6'd33}] = mem_req_data[271:264];
            if (mem_req_byteen[34]) next_reg_file[{mem_req_addr[7:0], 6'd34}] = mem_req_data[279:272];
            if (mem_req_byteen[35]) next_reg_file[{mem_req_addr[7:0], 6'd35}] = mem_req_data[287:280];
            if (mem_req_byteen[36]) next_reg_file[{mem_req_addr[7:0], 6'd36}] = mem_req_data[295:288];
            if (mem_req_byteen[37]) next_reg_file[{mem_req_addr[7:0], 6'd37}] = mem_req_data[303:296];
            if (mem_req_byteen[38]) next_reg_file[{mem_req_addr[7:0], 6'd38}] = mem_req_data[311:304];
            if (mem_req_byteen[39]) next_reg_file[{mem_req_addr[7:0], 6'd39}] = mem_req_data[319:312];
            if (mem_req_byteen[40]) next_reg_file[{mem_req_addr[7:0], 6'd40}] = mem_req_data[327:320];
            if (mem_req_byteen[41]) next_reg_file[{mem_req_addr[7:0], 6'd41}] = mem_req_data[335:328];
            if (mem_req_byteen[42]) next_reg_file[{mem_req_addr[7:0], 6'd42}] = mem_req_data[343:336];
            if (mem_req_byteen[43]) next_reg_file[{mem_req_addr[7:0], 6'd43}] = mem_req_data[351:344];
            if (mem_req_byteen[44]) next_reg_file[{mem_req_addr[7:0], 6'd44}] = mem_req_data[359:352];
            if (mem_req_byteen[45]) next_reg_file[{mem_req_addr[7:0], 6'd45}] = mem_req_data[367:360];
            if (mem_req_byteen[46]) next_reg_file[{mem_req_addr[7:0], 6'd46}] = mem_req_data[375:368];
            if (mem_req_byteen[47]) next_reg_file[{mem_req_addr[7:0], 6'd47}] = mem_req_data[383:376];
            if (mem_req_byteen[48]) next_reg_file[{mem_req_addr[7:0], 6'd48}] = mem_req_data[391:384];
            if (mem_req_byteen[49]) next_reg_file[{mem_req_addr[7:0], 6'd49}] = mem_req_data[399:392];
            if (mem_req_byteen[50]) next_reg_file[{mem_req_addr[7:0], 6'd50}] = mem_req_data[407:400];
            if (mem_req_byteen[51]) next_reg_file[{mem_req_addr[7:0], 6'd51}] = mem_req_data[415:408];
            if (mem_req_byteen[52]) next_reg_file[{mem_req_addr[7:0], 6'd52}] = mem_req_data[423:416];
            if (mem_req_byteen[53]) next_reg_file[{mem_req_addr[7:0], 6'd53}] = mem_req_data[431:424];
            if (mem_req_byteen[54]) next_reg_file[{mem_req_addr[7:0], 6'd54}] = mem_req_data[439:432];
            if (mem_req_byteen[55]) next_reg_file[{mem_req_addr[7:0], 6'd55}] = mem_req_data[447:440];
            if (mem_req_byteen[56]) next_reg_file[{mem_req_addr[7:0], 6'd56}] = mem_req_data[455:448];
            if (mem_req_byteen[57]) next_reg_file[{mem_req_addr[7:0], 6'd57}] = mem_req_data[463:456];
            if (mem_req_byteen[58]) next_reg_file[{mem_req_addr[7:0], 6'd58}] = mem_req_data[471:464];
            if (mem_req_byteen[59]) next_reg_file[{mem_req_addr[7:0], 6'd59}] = mem_req_data[479:472];
            if (mem_req_byteen[60]) next_reg_file[{mem_req_addr[7:0], 6'd60}] = mem_req_data[487:480];
            if (mem_req_byteen[61]) next_reg_file[{mem_req_addr[7:0], 6'd61}] = mem_req_data[495:488];
            if (mem_req_byteen[62]) next_reg_file[{mem_req_addr[7:0], 6'd62}] = mem_req_data[503:496];
            if (mem_req_byteen[63]) next_reg_file[{mem_req_addr[7:0], 6'd63}] = mem_req_data[511:504];

            // ahb busy
            bpif.request_stall = 1'b1;
        end

        ////////////////////////////////////////
        // AHB write logic (second priority): //
        ////////////////////////////////////////

        // if Vortex not writing, check for write and address in range
        // else if (bpif.wen & ~AHB_bad_address)
        else if (bpif.wen)
        begin
            // assumption: follow word address
            if (bpif.strobe[0]) next_reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd0}] = bpif.wdata[7:0];
            if (bpif.strobe[1]) next_reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd1}] = bpif.wdata[15:8];
            if (bpif.strobe[2]) next_reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd2}] = bpif.wdata[23:16];
            if (bpif.strobe[3]) next_reg_file[{bpif.addr[LOCAL_MEM_SIZE-1:2], 2'd3}] = bpif.wdata[31:24];
        end

        ////////////////////////////////
        // other combinational logic: //
        ////////////////////////////////

        // always ready for request
        mem_req_ready = 1'b1;           

        // read ready immediately
        // mem_rsp_valid = mem_req_valid;   // updated for buffer
        next_mem_rsp_valid = mem_req_valid & ~mem_req_rw;   // only need to respond for reads

        // match req immediately
        // mem_rsp_tag = mem_req_tag;       // updated for buffer
        next_mem_rsp_tag = mem_req_tag;
    end

    // only status registers use Vortex busy

endmodule

