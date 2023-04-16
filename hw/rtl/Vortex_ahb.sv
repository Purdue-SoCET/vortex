`include "VX_define.vh"

module Vortex_ahb #(
    parameter AXI_DATA_WIDTH   = `VX_MEM_DATA_WIDTH, 
    parameter AXI_ADDR_WIDTH   = 32,
    parameter AXI_TID_WIDTH    = `VX_MEM_TAG_WIDTH,    
    parameter AXI_STROBE_WIDTH = (`VX_MEM_DATA_WIDTH / 8)
)(
    // Clock
    input  logic                         clk,
    input  logic                         reset,
    // Status
    output logic                         busy,

    input logic HREADY, HRESP,
    input logic [31:0] HRDATA,
    output logic HWRITE,
    output logic [1:0] HTRANS,
    output logic [2:0] HBURST,
    output logic [2:0] HSIZE,
    output logic [31:0] HADDR,
    output logic [31:0] HWDATA,
    output logic [3:0] HWSTRB,
    output logic HSEL
);
    logic                            mem_req_valid;
    logic                            mem_req_rw; 
    logic [`VX_MEM_BYTEEN_WIDTH-1:0] mem_req_byteen;
    logic [`VX_MEM_ADDR_WIDTH-1:0]   mem_req_addr;
    logic [`VX_MEM_DATA_WIDTH-1:0]   mem_req_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]    mem_req_tag;
    logic                            mem_req_ready;

    logic                            mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]   mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]    mem_rsp_tag;
    logic                            mem_rsp_ready;
    
    VX_ahb_adapter ahb_adapter (
        .clk            (clk),
        .reset          (reset),

        .mem_req_valid  (mem_req_valid),
        .mem_req_rw     (mem_req_rw),
        .mem_req_byteen (mem_req_byteen),
        .mem_req_addr   (mem_req_addr),
        .mem_req_data   (mem_req_data),
        .mem_req_tag    (mem_req_tag),
        .mem_req_ready  (mem_req_ready),

        .mem_rsp_valid  (mem_rsp_valid),
        .mem_rsp_data   (mem_rsp_data),
        .mem_rsp_tag    (mem_rsp_tag),
        .mem_rsp_ready  (mem_rsp_ready),

        .HSEL (HSEL),
        .HWRITE (HWRITE),
        .HTRANS (HTRANS),
        .HADDR (HADDR),
        .HSIZE (HSIZE),
        .HWDATA (HWDATA),
        .HWSTRB (HWSTRB),
        .HBURST (HBURST),

        .HREADY (HREADY),
        .HRESP (HRESP),
        .HRDATA (HRDATA)
    );

    Vortex DUT (
        .clk            (clk),
        .reset          (reset),

        .mem_req_valid  (mem_req_valid),
        .mem_req_rw     (mem_req_rw),
        .mem_req_byteen (mem_req_byteen),
        .mem_req_addr   (mem_req_addr),
        .mem_req_data   (mem_req_data),
        .mem_req_tag    (mem_req_tag),
        .mem_req_ready  (mem_req_ready),

        .mem_rsp_valid  (mem_rsp_valid),
        .mem_rsp_data   (mem_rsp_data),
        .mem_rsp_tag    (mem_rsp_tag),
        .mem_rsp_ready  (mem_rsp_ready),

        .busy           (busy)
    );

endmodule