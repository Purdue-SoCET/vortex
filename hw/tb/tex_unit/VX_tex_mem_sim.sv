//Author: Raghul Prakash, SoCET Vortex GPU Team
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

    //texture ram block
    reg [31:0] tex_ram [SIZE:0];
    always_ff @ (posedge clk, negedge reset) begin
	if (reset) begin
		tex_ram <= 0;
	end
	else begin
		tex_ram <= 0xdeadbeef;
	end
    end
  
   reg [31:0] treq_tmask;
   reg [31:0] treq_filter;
   reg [31:0] treq_lgstride;
   reg [31:0] treq_baseaddr;
   reg [31:0] treq_addr;
   reg [31:0] treq_info;
   //combinational logic to get reqeuest about address and stride
   always_comb begin
    	if (req_valid) begin
		treq_tmask = req_tmask
		treq_req_filter = req_filter;
		treq_lgstride = req_lgstride;
		treq_baseaddr = req_baseaddr;
		treq_addr = req_addr;
		treq_info = req_info;
    	end 
	req_valid = 1;

   end
   
   wire data;
   
   assign data = tex_ram[treq_addr]
  // response based on ready of data
   rsp_data = rsp_ready ? data : 0xffff;


endmodule
