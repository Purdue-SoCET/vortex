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
	
	reg [7:0] tex_ram [SIZE:0]; //bytes
	reg [7:0] data; //data read
	integer i;
	initial begin
		$readmemh("texture.hex", tex_ram);
	end
	
	assign req_ready = req_valid;
	
	//get texel from ram and assert ready when received
	reg [7:0] data;
	reg texel_ready;
	always @ (*) begin
		data = '0;
		texel_ready = 0;
		if (req_valid && req_ready) begin
			//32 bit texel value
			data = {tex_ram[req_baseaddr[0] + req_addr[0][0]], tex_ram[req_baseaddr[0] + req_addr[0][1]], tex_ram[req_baseaddr[0] + req_addr[0][2]], tex_ram[req_baseaddr[0] + req_addr[0][3]]};
			texel_ready = 1;
		end
	end
	//rsp_valid tells that the memory unit can give the texel
	assign rsp_valid = 1'b1 && texel_ready;
	assign rsp_data = data;
	
	// full address calculation
	    wire [NUM_REQS-1:0][3:0][31:0] full_addr;    
	    for (genvar i = 0; i < NUM_REQS; ++i) begin
		for (genvar j = 0; j < 4; ++j) begin
		    assign full_addr[i][j] = req_baseaddr[i] + req_addr[i][j];
		end
	    end

  


endmodule
