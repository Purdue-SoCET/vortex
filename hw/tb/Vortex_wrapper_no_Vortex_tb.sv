/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    testbench for Vortex_mem_slave, simulating memory interface and AHB generic bus interface
*/

// temporary include to have defined vals
`include "Vortex_mem_slave.vh"

// include for Vortex widths
`include "../include/VX_define.vh"

`timescale 1 ns / 1 ns

module Vortex_wrapper_no_Vortex_tb ();

    logic clk, nRST;

    logic                             Vortex_mem_req_valid;
    logic                             Vortex_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]  Vortex_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]    Vortex_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]    Vortex_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]     Vortex_mem_req_tag;    // 56 (55 for SM disabled)
    // vortex inputs
    logic                            Vortex_mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                            Vortex_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]   Vortex_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]    Vortex_mem_rsp_tag;    // 56 (55 for SM disabled)
    // vortex outputs
    logic                             Vortex_mem_rsp_ready;

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if        mem_slave_bpif();
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

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if        ctrl_status_bpif();
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

    //////////////////////////////////
    // AHB Manager for Vortex_... : //
    //////////////////////////////////

    ahb_if #(
        // .DATA_WIDTH(AHB_DATA_WIDTH),
        .DATA_WIDTH(32),
        // .ADDR_WIDTH(AHB_ADDR_WIDTH)
        .ADDR_WIDTH(32)
    ) ahb_manager_ahbif (.HCLK(clk), .HRESETn(nRST));
        // logic HSEL;
        // logic HREADY;
        // logic HREADYOUT;
        // logic HWRITE;
        // logic HMASTLOCK;
        // logic HRESP;
        // logic [1:0] HTRANS;
        // logic [2:0] HBURST;
        // logic [2:0] HSIZE;
        // logic [ADDR_WIDTH - 1:0] HADDR;
        // logic [DATA_WIDTH - 1:0] HWDATA;
        // logic [DATA_WIDTH - 1:0] HRDATA;
        // logic [(DATA_WIDTH/8) - 1:0] HWSTRB;

        // assign HREADY = HREADYOUT;

        // modport manager(
        //     input HCLK, HRESETn,
        //     input HREADY, HRESP, HRDATA,
        //     output HWRITE, HMASTLOCK, HTRANS,
        //     HBURST, HSIZE, HADDR, HWDATA, HWSTRB, HSEL
        // );

    /////////////////////////////////
    // CTRL/STATUS to/from Vortex: //
    /////////////////////////////////

    logic Vortex_busy;
    logic Vortex_reset;
    logic Vortex_PC_reset_val;

    Vortex_wrapper_no_Vortex DUT (.*);

    // testbench signal declarations
    string test_case;
    string sub_test_case;
    localparam PERIOD = 20;

    // clkgen
    always #(PERIOD/2) clk++;

    initial begin

        /* --------------------------------------------------------------------------------------------- */
        // RESET TESTING

        // all wrapper inputs default:

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b0;
        Vortex_mem_req_rw = 1'b0;
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'hF000_0000;
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h0;

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b0;
        mem_slave_bpif.ren = 1'b0;
        mem_slave_bpif.addr = 32'h0;
        mem_slave_bpif.wdata = 32'h0;
        mem_slave_bpif.strobe = 4'b0;

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0;
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        // VX_ahb_manager ahbif inputs
        // ahb_manager_ahbif.HREADY = 1'b1;
        ahb_manager_ahbif.HRESP = 1'b0;
        ahb_manager_ahbif.HRDATA = 32'h0;

        // Vortex inputs
        Vortex_busy = 1'b0;

        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD);

        /* --------------------------------------------------------------------------------------------- */
        // FSM, mem-mapped reg testing

        $finish();
    end

endmodule
