/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    module for integrating on-chip SRAM/AHB subordinate, AHB manager, and control/status register
    logic to serve as interface between AFTx07 and Vortex

    assumptions:
        AHB only references word addresses
        it is safe to use reset as start/stop for Vortex
        it is safe to feed PC reset value into Vortex
*/

// temporary include to have defined vals
`include "Vortex_mem_slave.vh"

// include for Vortex widths
`include "../include/VX_define.vh"

module Vortex_wrapper_no_Vortex #(
)(
    /////////////////
    // Sequential: //
    /////////////////
    input clk, reset,

    //////////////////////////////
    // Vortex Memory Interface: //
    //////////////////////////////

    // Memory Request:
    // vortex outputs
    input logic                             Vortex_mem_req_valid,
    input logic                             Vortex_mem_req_rw,
    input logic [`VX_MEM_BYTEEN_WIDTH-1:0]  Vortex_mem_req_byteen, // 64 (512 / 8)
    input logic [`VX_MEM_ADDR_WIDTH-1:0]    Vortex_mem_req_addr,   // 26
    input logic [`VX_MEM_DATA_WIDTH-1:0]    Vortex_mem_req_data,   // 512
    input logic [`VX_MEM_TAG_WIDTH-1:0]     Vortex_mem_req_tag,    // 56 (55 for SM disabled)
    // vortex inputs
    output logic                            Vortex_mem_req_ready,

    // Memory response:
    // vortex inputs
    output logic                            Vortex_mem_rsp_valid,        
    output logic [`VX_MEM_DATA_WIDTH-1:0]   Vortex_mem_rsp_data,   // 512
    output logic [`VX_MEM_TAG_WIDTH-1:0]    Vortex_mem_rsp_tag,    // 56 (55 for SM disabled)
    // vortex outputs
    input logic                             Vortex_mem_rsp_ready,

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if.peripheral_vital        mem_slave_bpif,
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

    bus_protocol_if.peripheral_vital        ctrl_status_bpif,
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

    // FILL IN

    /////////////////////////////////
    // CTRL/STATUS to/from Vortex: //
    /////////////////////////////////

    input logic Vortex_busy,
    output logic ctrl_status_reset,
    output logic ctrl_status_PC_reset_val
);

    parameter MEM_SLAVE_ADDR_SPACE_BITS = 14

    ////////////////
    // constants: //
    ////////////////

    // default mem req
    localparam DEF_MEM_REQ_VALID = 1'b0;
    localparam DEF_MEM_REQ_RW = 1'b0;
    localparam DEF_MEM_REQ_BYTEEN = 64'h0;
    localparam DEF_MEM_REQ_ADDR = 26'h0;
    localparam DEF_MEM_REQ_DATA = 512'h0;
    localparam DEF_MEM_REQ_TAG = 56'h0;
    localparam DEF_MEM_RSP_READY = 1'b1;

    ///////////////////////
    // internal signals: //
    ///////////////////////

    // req/rsp to/from mem slave

    // Memory Request:
    logic                               mem_slave_mem_req_valid;
    logic                               mem_slave_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    mem_slave_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]      mem_slave_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_slave_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_slave_mem_req_tag;    // 56 (55 for SM disabled)
    logic                               mem_slave_mem_req_ready;
    // Memory response:
    logic                               mem_slave_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_slave_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_slave_mem_rsp_tag;    // 56 (55 for SM disabled)
    logic                               mem_slave_mem_rsp_ready;

    // req/rsp to/from ahb manager

    // Memory Request:
    logic                               ahb_manager_mem_req_valid;
    logic                               ahb_manager_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    ahb_manager_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]      ahb_manager_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]      ahb_manager_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       ahb_manager_mem_req_tag;    // 56 (55 for SM disabled)
    logic                               ahb_manager_mem_req_ready;
    // Memory response:
    logic                               ahb_manager_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      ahb_manager_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       ahb_manager_mem_rsp_tag;    // 56 (55 for SM disabled)
    logic                               ahb_manager_mem_rsp_ready;

    // req arbiter

    // rsp buffer

    // ctrl/status reg
    logic ctrl_status_busy, next_ctrl_status_busy;  // busy reg
    logic ctrl_status_start_triggered;              // detector for start write, will allow FSM transition
    logic next_ctrl_status_PC_reset_val;            // PC reset val reg

endmodule