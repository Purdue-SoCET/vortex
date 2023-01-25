module VX_tex_mem_sim #(
    parameter CORE_ID   = 0,
    parameter REQ_INFOW = 1,
    parameter NUM_REQS  = 1
) (
    input wire clk,
    input wire reset,

   // memory interface
    VX_dcache_req_if.master dcache_req_if,
    VX_dcache_rsp_if.slave  dcache_rsp_if,

    // inputs
    input wire                          req_valid,
    input wire [NUM_REQS-1:0]           req_tmask,
    input wire [`TEX_FILTER_BITS-1:0]   req_filter,
    input wire [`TEX_LGSTRIDE_BITS-1:0] req_lgstride,
    input wire [NUM_REQS-1:0][31:0]     req_baseaddr,
    input wire [NUM_REQS-1:0][3:0][31:0] req_addr,
    input wire [REQ_INFOW-1:0]          req_info,
    output wire                         req_ready,

    // outputs
    output wire                         rsp_valid,
    output wire [NUM_REQS-1:0]          rsp_tmask,
    output wire [NUM_REQS-1:0][3:0][31:0] rsp_data,
    output wire [REQ_INFOW-1:0]         rsp_info,
    input wire                          rsp_ready
);






endmodule
