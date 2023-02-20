// removed package "fpu_types"
// removed package "gpu_types"
module VX_muldiv (
	clk,
	reset,
	alu_op,
	uuid_in,
	wid_in,
	tmask_in,
	PC_in,
	rd_in,
	wb_in,
	alu_in1,
	alu_in2,
	uuid_out,
	wid_out,
	tmask_out,
	PC_out,
	rd_out,
	wb_out,
	data_out,
	valid_in,
	ready_in,
	valid_out,
	ready_out
);
	// Trace: ../../rtl/VX_muldiv.sv:4:5
	input wire clk;
	// Trace: ../../rtl/VX_muldiv.sv:5:5
	input wire reset;
	// Trace: ../../rtl/VX_muldiv.sv:8:5
	input wire [2:0] alu_op;
	// Trace: ../../rtl/VX_muldiv.sv:9:5
	input wire [43:0] uuid_in;
	// Trace: ../../rtl/VX_muldiv.sv:10:5
	input wire [0:0] wid_in;
	// Trace: ../../rtl/VX_muldiv.sv:11:5
	input wire [1:0] tmask_in;
	// Trace: ../../rtl/VX_muldiv.sv:12:5
	input wire [31:0] PC_in;
	// Trace: ../../rtl/VX_muldiv.sv:13:5
	input wire [4:0] rd_in;
	// Trace: ../../rtl/VX_muldiv.sv:14:5
	input wire wb_in;
	// Trace: ../../rtl/VX_muldiv.sv:15:5
	input wire [63:0] alu_in1;
	// Trace: ../../rtl/VX_muldiv.sv:16:5
	input wire [63:0] alu_in2;
	// Trace: ../../rtl/VX_muldiv.sv:19:5
	output wire [43:0] uuid_out;
	// Trace: ../../rtl/VX_muldiv.sv:20:5
	output wire [0:0] wid_out;
	// Trace: ../../rtl/VX_muldiv.sv:21:5
	output wire [1:0] tmask_out;
	// Trace: ../../rtl/VX_muldiv.sv:22:5
	output wire [31:0] PC_out;
	// Trace: ../../rtl/VX_muldiv.sv:23:5
	output wire [4:0] rd_out;
	// Trace: ../../rtl/VX_muldiv.sv:24:5
	output wire wb_out;
	// Trace: ../../rtl/VX_muldiv.sv:25:5
	output wire [63:0] data_out;
	// Trace: ../../rtl/VX_muldiv.sv:28:5
	input wire valid_in;
	// Trace: ../../rtl/VX_muldiv.sv:29:5
	output wire ready_in;
	// Trace: ../../rtl/VX_muldiv.sv:30:5
	output wire valid_out;
	// Trace: ../../rtl/VX_muldiv.sv:31:5
	input wire ready_out;
	// Trace: ../../rtl/VX_muldiv.sv:34:5
	wire is_div_op = alu_op[2];
	// Trace: ../../rtl/VX_muldiv.sv:36:5
	wire [63:0] mul_result;
	// Trace: ../../rtl/VX_muldiv.sv:37:5
	wire [43:0] mul_uuid_out;
	// Trace: ../../rtl/VX_muldiv.sv:38:5
	wire [0:0] mul_wid_out;
	// Trace: ../../rtl/VX_muldiv.sv:39:5
	wire [1:0] mul_tmask_out;
	// Trace: ../../rtl/VX_muldiv.sv:40:5
	wire [31:0] mul_PC_out;
	// Trace: ../../rtl/VX_muldiv.sv:41:5
	wire [4:0] mul_rd_out;
	// Trace: ../../rtl/VX_muldiv.sv:42:5
	wire mul_wb_out;
	// Trace: ../../rtl/VX_muldiv.sv:44:5
	wire stall_out;
	// Trace: ../../rtl/VX_muldiv.sv:46:5
	wire mul_valid_out;
	// Trace: ../../rtl/VX_muldiv.sv:47:5
	wire mul_valid_in = valid_in && !is_div_op;
	// Trace: ../../rtl/VX_muldiv.sv:48:5
	wire mul_ready_in = ~stall_out || ~mul_valid_out;
	// Trace: ../../rtl/VX_muldiv.sv:50:5
	wire is_mulh_in = alu_op != 3'h0;
	// Trace: ../../rtl/VX_muldiv.sv:51:5
	wire is_signed_mul_a = alu_op != 3'h3;
	// Trace: ../../rtl/VX_muldiv.sv:52:5
	wire is_signed_mul_b = (alu_op != 3'h3) && (alu_op != 3'h2);
	// Trace: ../../rtl/VX_muldiv.sv:82:5
	wire is_mulh_out;
	// Trace: ../../rtl/VX_muldiv.sv:84:5
	genvar i;
	generate
		for (i = 0; i < 2; i = i + 1) begin : genblk1
			// Trace: ../../rtl/VX_muldiv.sv:85:9
			wire [32:0] mul_in1 = {is_signed_mul_a & alu_in1[(i * 32) + 31], alu_in1[i * 32+:32]};
			// Trace: ../../rtl/VX_muldiv.sv:86:9
			wire [32:0] mul_in2 = {is_signed_mul_b & alu_in2[(i * 32) + 31], alu_in2[i * 32+:32]};
			// Trace: ../../rtl/VX_muldiv.sv:88:9
			wire [65:0] mul_result_tmp;
			// Trace: ../../rtl/VX_muldiv.sv:91:9
			VX_multiplier #(
				.WIDTHA(33),
				.WIDTHB(33),
				.WIDTHP(66),
				.SIGNED(1),
				.LATENCY(3)
			) multiplier(
				.clk(clk),
				.enable(mul_ready_in),
				.dataa(mul_in1),
				.datab(mul_in2),
				.result(mul_result_tmp)
			);
			// Trace: ../../rtl/VX_muldiv.sv:105:9
			assign mul_result[i * 32+:32] = (is_mulh_out ? mul_result_tmp[63:32] : mul_result_tmp[31:0]);
		end
	endgenerate
	// Trace: ../../rtl/VX_muldiv.sv:108:5
	VX_shift_register #(
		.DATAW(87),
		.DEPTH(3),
		.RESETW(1)
	) mul_shift_reg(
		.clk(clk),
		.reset(reset),
		.enable(mul_ready_in),
		.data_in({mul_valid_in, uuid_in, wid_in, tmask_in, PC_in, rd_in, wb_in, is_mulh_in}),
		.data_out({mul_valid_out, mul_uuid_out, mul_wid_out, mul_tmask_out, mul_PC_out, mul_rd_out, mul_wb_out, is_mulh_out})
	);
	// Trace: ../../rtl/VX_muldiv.sv:124:5
	wire [63:0] div_result;
	// Trace: ../../rtl/VX_muldiv.sv:125:5
	wire [43:0] div_uuid_out;
	// Trace: ../../rtl/VX_muldiv.sv:126:5
	wire [0:0] div_wid_out;
	// Trace: ../../rtl/VX_muldiv.sv:127:5
	wire [1:0] div_tmask_out;
	// Trace: ../../rtl/VX_muldiv.sv:128:5
	wire [31:0] div_PC_out;
	// Trace: ../../rtl/VX_muldiv.sv:129:5
	wire [4:0] div_rd_out;
	// Trace: ../../rtl/VX_muldiv.sv:130:5
	wire div_wb_out;
	// Trace: ../../rtl/VX_muldiv.sv:132:5
	wire is_rem_op_in = (alu_op == 3'h6) || (alu_op == 3'h7);
	// Trace: ../../rtl/VX_muldiv.sv:133:5
	wire is_signed_div = (alu_op == 3'h4) || (alu_op == 3'h6);
	// Trace: ../../rtl/VX_muldiv.sv:134:5
	wire div_valid_in = valid_in && is_div_op;
	// Trace: ../../rtl/VX_muldiv.sv:135:5
	wire div_ready_out = ~stall_out && ~mul_valid_out;
	// Trace: ../../rtl/VX_muldiv.sv:136:5
	wire div_ready_in;
	// Trace: ../../rtl/VX_muldiv.sv:137:5
	wire div_valid_out;
	// Trace: ../../rtl/VX_muldiv.sv:169:5
	wire [63:0] div_result_tmp;
	wire [63:0] rem_result_tmp;
	// Trace: ../../rtl/VX_muldiv.sv:170:5
	wire is_rem_op_out;
	// Trace: ../../rtl/VX_muldiv.sv:172:5
	VX_serial_div #(
		.WIDTHN(32),
		.WIDTHD(32),
		.WIDTHQ(32),
		.WIDTHR(32),
		.LANES(2),
		.TAGW(106)
	) divide(
		.clk(clk),
		.reset(reset),
		.valid_in(div_valid_in),
		.ready_in(div_ready_in),
		.signed_mode(is_signed_div),
		.tag_in({uuid_in, wid_in, tmask_in, PC_in, rd_in, wb_in, is_rem_op_in}),
		.numer(alu_in1),
		.denom(alu_in2),
		.quotient(div_result_tmp),
		.remainder(rem_result_tmp),
		.ready_out(div_ready_out),
		.valid_out(div_valid_out),
		.tag_out({div_uuid_out, div_wid_out, div_tmask_out, div_PC_out, div_rd_out, div_wb_out, is_rem_op_out})
	);
	// Trace: ../../rtl/VX_muldiv.sv:195:5
	assign div_result = (is_rem_op_out ? rem_result_tmp : div_result_tmp);
	// Trace: ../../rtl/VX_muldiv.sv:201:5
	wire rsp_valid = mul_valid_out || div_valid_out;
	// Trace: ../../rtl/VX_muldiv.sv:202:5
	wire [43:0] rsp_uuid = (mul_valid_out ? mul_uuid_out : div_uuid_out);
	// Trace: ../../rtl/VX_muldiv.sv:203:5
	wire [0:0] rsp_wid = (mul_valid_out ? mul_wid_out : div_wid_out);
	// Trace: ../../rtl/VX_muldiv.sv:204:5
	wire [1:0] rsp_tmask = (mul_valid_out ? mul_tmask_out : div_tmask_out);
	// Trace: ../../rtl/VX_muldiv.sv:205:5
	wire [31:0] rsp_PC = (mul_valid_out ? mul_PC_out : div_PC_out);
	// Trace: ../../rtl/VX_muldiv.sv:206:5
	wire [4:0] rsp_rd = (mul_valid_out ? mul_rd_out : div_rd_out);
	// Trace: ../../rtl/VX_muldiv.sv:207:5
	wire rsp_wb = (mul_valid_out ? mul_wb_out : div_wb_out);
	// Trace: ../../rtl/VX_muldiv.sv:208:5
	wire [63:0] rsp_data = (mul_valid_out ? mul_result : div_result);
	// Trace: ../../rtl/VX_muldiv.sv:210:5
	assign stall_out = ~ready_out && valid_out;
	// Trace: ../../rtl/VX_muldiv.sv:212:5
	VX_pipe_register #(
		.DATAW(150),
		.RESETW(1)
	) pipe_reg(
		.clk(clk),
		.reset(reset),
		.enable(~stall_out),
		.data_in({rsp_valid, rsp_uuid, rsp_wid, rsp_tmask, rsp_PC, rsp_rd, rsp_wb, rsp_data}),
		.data_out({valid_out, uuid_out, wid_out, tmask_out, PC_out, rd_out, wb_out, data_out})
	);
	// Trace: ../../rtl/VX_muldiv.sv:224:5
	assign ready_in = (is_div_op ? div_ready_in : mul_ready_in);
endmodule
// removed module with interface ports: VX_fetch
// removed module with interface ports: VX_gpu_unit
module Vortex_axi (
	clk,
	reset,
	m_axi_awid,
	m_axi_awaddr,
	m_axi_awlen,
	m_axi_awsize,
	m_axi_awburst,
	m_axi_awlock,
	m_axi_awcache,
	m_axi_awprot,
	m_axi_awqos,
	m_axi_awvalid,
	m_axi_awready,
	m_axi_wdata,
	m_axi_wstrb,
	m_axi_wlast,
	m_axi_wvalid,
	m_axi_wready,
	m_axi_bid,
	m_axi_bresp,
	m_axi_bvalid,
	m_axi_bready,
	m_axi_arid,
	m_axi_araddr,
	m_axi_arlen,
	m_axi_arsize,
	m_axi_arburst,
	m_axi_arlock,
	m_axi_arcache,
	m_axi_arprot,
	m_axi_arqos,
	m_axi_arvalid,
	m_axi_arready,
	m_axi_rid,
	m_axi_rdata,
	m_axi_rresp,
	m_axi_rlast,
	m_axi_rvalid,
	m_axi_rready,
	busy
);
	// Trace: ../../rtl/Vortex_axi.sv:4:15
	parameter AXI_DATA_WIDTH = (0 || 0 ? 16 : 64) * 8;
	// Trace: ../../rtl/Vortex_axi.sv:5:15
	parameter AXI_ADDR_WIDTH = 32;
	// Trace: ../../rtl/Vortex_axi.sv:6:15
	parameter AXI_TID_WIDTH = (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1;
	// Trace: ../../rtl/Vortex_axi.sv:7:15
	parameter AXI_STROBE_WIDTH = ((0 || 0 ? 16 : 64) * 8) / 8;
	// Trace: ../../rtl/Vortex_axi.sv:10:5
	input wire clk;
	// Trace: ../../rtl/Vortex_axi.sv:11:5
	input wire reset;
	// Trace: ../../rtl/Vortex_axi.sv:14:5
	output wire [AXI_TID_WIDTH - 1:0] m_axi_awid;
	// Trace: ../../rtl/Vortex_axi.sv:15:5
	output wire [AXI_ADDR_WIDTH - 1:0] m_axi_awaddr;
	// Trace: ../../rtl/Vortex_axi.sv:16:5
	output wire [7:0] m_axi_awlen;
	// Trace: ../../rtl/Vortex_axi.sv:17:5
	output wire [2:0] m_axi_awsize;
	// Trace: ../../rtl/Vortex_axi.sv:18:5
	output wire [1:0] m_axi_awburst;
	// Trace: ../../rtl/Vortex_axi.sv:19:5
	output wire m_axi_awlock;
	// Trace: ../../rtl/Vortex_axi.sv:20:5
	output wire [3:0] m_axi_awcache;
	// Trace: ../../rtl/Vortex_axi.sv:21:5
	output wire [2:0] m_axi_awprot;
	// Trace: ../../rtl/Vortex_axi.sv:22:5
	output wire [3:0] m_axi_awqos;
	// Trace: ../../rtl/Vortex_axi.sv:23:5
	output wire m_axi_awvalid;
	// Trace: ../../rtl/Vortex_axi.sv:24:5
	input wire m_axi_awready;
	// Trace: ../../rtl/Vortex_axi.sv:27:5
	output wire [AXI_DATA_WIDTH - 1:0] m_axi_wdata;
	// Trace: ../../rtl/Vortex_axi.sv:28:5
	output wire [AXI_STROBE_WIDTH - 1:0] m_axi_wstrb;
	// Trace: ../../rtl/Vortex_axi.sv:29:5
	output wire m_axi_wlast;
	// Trace: ../../rtl/Vortex_axi.sv:30:5
	output wire m_axi_wvalid;
	// Trace: ../../rtl/Vortex_axi.sv:31:5
	input wire m_axi_wready;
	// Trace: ../../rtl/Vortex_axi.sv:34:5
	input wire [AXI_TID_WIDTH - 1:0] m_axi_bid;
	// Trace: ../../rtl/Vortex_axi.sv:35:5
	input wire [1:0] m_axi_bresp;
	// Trace: ../../rtl/Vortex_axi.sv:36:5
	input wire m_axi_bvalid;
	// Trace: ../../rtl/Vortex_axi.sv:37:5
	output wire m_axi_bready;
	// Trace: ../../rtl/Vortex_axi.sv:40:5
	output wire [AXI_TID_WIDTH - 1:0] m_axi_arid;
	// Trace: ../../rtl/Vortex_axi.sv:41:5
	output wire [AXI_ADDR_WIDTH - 1:0] m_axi_araddr;
	// Trace: ../../rtl/Vortex_axi.sv:42:5
	output wire [7:0] m_axi_arlen;
	// Trace: ../../rtl/Vortex_axi.sv:43:5
	output wire [2:0] m_axi_arsize;
	// Trace: ../../rtl/Vortex_axi.sv:44:5
	output wire [1:0] m_axi_arburst;
	// Trace: ../../rtl/Vortex_axi.sv:45:5
	output wire m_axi_arlock;
	// Trace: ../../rtl/Vortex_axi.sv:46:5
	output wire [3:0] m_axi_arcache;
	// Trace: ../../rtl/Vortex_axi.sv:47:5
	output wire [2:0] m_axi_arprot;
	// Trace: ../../rtl/Vortex_axi.sv:48:5
	output wire [3:0] m_axi_arqos;
	// Trace: ../../rtl/Vortex_axi.sv:49:5
	output wire m_axi_arvalid;
	// Trace: ../../rtl/Vortex_axi.sv:50:5
	input wire m_axi_arready;
	// Trace: ../../rtl/Vortex_axi.sv:53:5
	input wire [AXI_TID_WIDTH - 1:0] m_axi_rid;
	// Trace: ../../rtl/Vortex_axi.sv:54:5
	input wire [AXI_DATA_WIDTH - 1:0] m_axi_rdata;
	// Trace: ../../rtl/Vortex_axi.sv:55:5
	input wire [1:0] m_axi_rresp;
	// Trace: ../../rtl/Vortex_axi.sv:56:5
	input wire m_axi_rlast;
	// Trace: ../../rtl/Vortex_axi.sv:57:5
	input wire m_axi_rvalid;
	// Trace: ../../rtl/Vortex_axi.sv:58:5
	output wire m_axi_rready;
	// Trace: ../../rtl/Vortex_axi.sv:61:5
	output wire busy;
	// Trace: ../../rtl/Vortex_axi.sv:63:5
	wire mem_req_valid;
	// Trace: ../../rtl/Vortex_axi.sv:64:5
	wire mem_req_rw;
	// Trace: ../../rtl/Vortex_axi.sv:65:5
	wire [(0 || 0 ? 16 : 64) - 1:0] mem_req_byteen;
	// Trace: ../../rtl/Vortex_axi.sv:66:5
	wire [(32 - $clog2((0 || 0 ? 16 : 64))) - 1:0] mem_req_addr;
	// Trace: ../../rtl/Vortex_axi.sv:67:5
	wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_req_data;
	// Trace: ../../rtl/Vortex_axi.sv:68:5
	wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_req_tag;
	// Trace: ../../rtl/Vortex_axi.sv:69:5
	wire mem_req_ready;
	// Trace: ../../rtl/Vortex_axi.sv:71:5
	wire mem_rsp_valid;
	// Trace: ../../rtl/Vortex_axi.sv:72:5
	wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_rsp_data;
	// Trace: ../../rtl/Vortex_axi.sv:73:5
	wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_rsp_tag;
	// Trace: ../../rtl/Vortex_axi.sv:74:5
	wire mem_rsp_ready;
	// Trace: ../../rtl/Vortex_axi.sv:76:5
	VX_axi_adapter #(
		.VX_DATA_WIDTH((0 || 0 ? 16 : 64) * 8),
		.VX_ADDR_WIDTH(32 - $clog2((0 || 0 ? 16 : 64))),
		.VX_TAG_WIDTH((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1),
		.VX_BYTEEN_WIDTH(AXI_STROBE_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_TID_WIDTH(AXI_TID_WIDTH),
		.AXI_STROBE_WIDTH(AXI_STROBE_WIDTH)
	) axi_adapter(
		.clk(clk),
		.reset(reset),
		.mem_req_valid(mem_req_valid),
		.mem_req_rw(mem_req_rw),
		.mem_req_byteen(mem_req_byteen),
		.mem_req_addr(mem_req_addr),
		.mem_req_data(mem_req_data),
		.mem_req_tag(mem_req_tag),
		.mem_req_ready(mem_req_ready),
		.mem_rsp_valid(mem_rsp_valid),
		.mem_rsp_data(mem_rsp_data),
		.mem_rsp_tag(mem_rsp_tag),
		.mem_rsp_ready(mem_rsp_ready),
		.m_axi_awid(m_axi_awid),
		.m_axi_awaddr(m_axi_awaddr),
		.m_axi_awlen(m_axi_awlen),
		.m_axi_awsize(m_axi_awsize),
		.m_axi_awburst(m_axi_awburst),
		.m_axi_awlock(m_axi_awlock),
		.m_axi_awcache(m_axi_awcache),
		.m_axi_awprot(m_axi_awprot),
		.m_axi_awqos(m_axi_awqos),
		.m_axi_awvalid(m_axi_awvalid),
		.m_axi_awready(m_axi_awready),
		.m_axi_wdata(m_axi_wdata),
		.m_axi_wstrb(m_axi_wstrb),
		.m_axi_wlast(m_axi_wlast),
		.m_axi_wvalid(m_axi_wvalid),
		.m_axi_wready(m_axi_wready),
		.m_axi_bid(m_axi_bid),
		.m_axi_bresp(m_axi_bresp),
		.m_axi_bvalid(m_axi_bvalid),
		.m_axi_bready(m_axi_bready),
		.m_axi_arid(m_axi_arid),
		.m_axi_araddr(m_axi_araddr),
		.m_axi_arlen(m_axi_arlen),
		.m_axi_arsize(m_axi_arsize),
		.m_axi_arburst(m_axi_arburst),
		.m_axi_arlock(m_axi_arlock),
		.m_axi_arcache(m_axi_arcache),
		.m_axi_arprot(m_axi_arprot),
		.m_axi_arqos(m_axi_arqos),
		.m_axi_arvalid(m_axi_arvalid),
		.m_axi_arready(m_axi_arready),
		.m_axi_rid(m_axi_rid),
		.m_axi_rdata(m_axi_rdata),
		.m_axi_rresp(m_axi_rresp),
		.m_axi_rlast(m_axi_rlast),
		.m_axi_rvalid(m_axi_rvalid),
		.m_axi_rready(m_axi_rready)
	);
	// Trace: ../../rtl/Vortex_axi.sv:145:5
	Vortex vortex(
		.clk(clk),
		.reset(reset),
		.mem_req_valid(mem_req_valid),
		.mem_req_rw(mem_req_rw),
		.mem_req_byteen(mem_req_byteen),
		.mem_req_addr(mem_req_addr),
		.mem_req_data(mem_req_data),
		.mem_req_tag(mem_req_tag),
		.mem_req_ready(mem_req_ready),
		.mem_rsp_valid(mem_rsp_valid),
		.mem_rsp_data(mem_rsp_data),
		.mem_rsp_tag(mem_rsp_tag),
		.mem_rsp_ready(mem_rsp_ready),
		.busy(busy)
	);
endmodule
module VX_ipdom_stack (
	clk,
	reset,
	pair,
	q1,
	q2,
	d,
	push,
	pop,
	index,
	empty,
	full
);
	// Trace: ../../rtl/VX_ipdom_stack.sv:4:15
	parameter WIDTH = 1;
	// Trace: ../../rtl/VX_ipdom_stack.sv:5:15
	parameter DEPTH = 1;
	// Trace: ../../rtl/VX_ipdom_stack.sv:7:5
	input wire clk;
	// Trace: ../../rtl/VX_ipdom_stack.sv:8:5
	input wire reset;
	// Trace: ../../rtl/VX_ipdom_stack.sv:9:5
	input wire pair;
	// Trace: ../../rtl/VX_ipdom_stack.sv:10:5
	input wire [WIDTH - 1:0] q1;
	// Trace: ../../rtl/VX_ipdom_stack.sv:11:5
	input wire [WIDTH - 1:0] q2;
	// Trace: ../../rtl/VX_ipdom_stack.sv:12:5
	output wire [WIDTH - 1:0] d;
	// Trace: ../../rtl/VX_ipdom_stack.sv:13:5
	input wire push;
	// Trace: ../../rtl/VX_ipdom_stack.sv:14:5
	input wire pop;
	// Trace: ../../rtl/VX_ipdom_stack.sv:15:5
	output wire index;
	// Trace: ../../rtl/VX_ipdom_stack.sv:16:5
	output wire empty;
	// Trace: ../../rtl/VX_ipdom_stack.sv:17:5
	output wire full;
	// Trace: ../../rtl/VX_ipdom_stack.sv:19:5
	localparam ADDRW = $clog2(DEPTH);
	// Trace: ../../rtl/VX_ipdom_stack.sv:21:5
	reg is_part [DEPTH - 1:0];
	// Trace: ../../rtl/VX_ipdom_stack.sv:23:5
	reg [ADDRW - 1:0] rd_ptr;
	reg [ADDRW - 1:0] wr_ptr;
	// Trace: ../../rtl/VX_ipdom_stack.sv:25:5
	wire [WIDTH - 1:0] d1;
	wire [WIDTH - 1:0] d2;
	// Trace: ../../rtl/VX_ipdom_stack.sv:27:5
	function automatic signed [ADDRW - 1:0] sv2v_cast_8BB5D_signed;
		input reg signed [ADDRW - 1:0] inp;
		sv2v_cast_8BB5D_signed = inp;
	endfunction
	function automatic [ADDRW - 1:0] sv2v_cast_8BB5D;
		input reg [ADDRW - 1:0] inp;
		sv2v_cast_8BB5D = inp;
	endfunction
	always @(posedge clk)
		// Trace: ../../rtl/VX_ipdom_stack.sv:28:9
		if (reset) begin
			// Trace: ../../rtl/VX_ipdom_stack.sv:29:13
			rd_ptr <= 0;
			// Trace: ../../rtl/VX_ipdom_stack.sv:30:13
			wr_ptr <= 0;
		end
		else
			// Trace: ../../rtl/VX_ipdom_stack.sv:32:13
			if (push) begin
				// Trace: ../../rtl/VX_ipdom_stack.sv:33:17
				rd_ptr <= wr_ptr;
				// Trace: ../../rtl/VX_ipdom_stack.sv:34:17
				wr_ptr <= wr_ptr + sv2v_cast_8BB5D_signed(1);
			end
			else if (pop) begin
				// Trace: ../../rtl/VX_ipdom_stack.sv:36:17
				wr_ptr <= wr_ptr - sv2v_cast_8BB5D(is_part[rd_ptr]);
				// Trace: ../../rtl/VX_ipdom_stack.sv:37:17
				rd_ptr <= rd_ptr - sv2v_cast_8BB5D(is_part[rd_ptr]);
			end
	// Trace: ../../rtl/VX_ipdom_stack.sv:42:5
	VX_dp_ram #(
		.DATAW(WIDTH * 2),
		.SIZE(DEPTH),
		.LUTRAM(1)
	) store(
		.clk(clk),
		.wren(push),
		.waddr(wr_ptr),
		.wdata({q2, q1}),
		.raddr(rd_ptr),
		.rdata({d2, d1})
	);
	// Trace: ../../rtl/VX_ipdom_stack.sv:55:5
	always @(posedge clk)
		// Trace: ../../rtl/VX_ipdom_stack.sv:56:9
		if (push)
			// Trace: ../../rtl/VX_ipdom_stack.sv:57:13
			is_part[wr_ptr] <= ~pair;
		else if (pop)
			// Trace: ../../rtl/VX_ipdom_stack.sv:59:13
			is_part[rd_ptr] <= 1;
	// Trace: ../../rtl/VX_ipdom_stack.sv:63:5
	assign index = is_part[rd_ptr];
	// Trace: ../../rtl/VX_ipdom_stack.sv:64:5
	assign d = (index ? d1 : d2);
	// Trace: ../../rtl/VX_ipdom_stack.sv:65:5
	assign empty = sv2v_cast_8BB5D_signed(0) == wr_ptr;
	// Trace: ../../rtl/VX_ipdom_stack.sv:66:5
	assign full = sv2v_cast_8BB5D_signed(DEPTH - 1) == wr_ptr;
endmodule
// removed module with interface ports: VX_icache_stage
// removed module with interface ports: VX_alu_unit
module VX_smem_arb (
	clk,
	reset,
	req_valid_in,
	req_rw_in,
	req_byteen_in,
	req_addr_in,
	req_data_in,
	req_tag_in,
	req_ready_in,
	req_valid_out,
	req_rw_out,
	req_byteen_out,
	req_addr_out,
	req_data_out,
	req_tag_out,
	req_ready_out,
	rsp_valid_in,
	rsp_tmask_in,
	rsp_data_in,
	rsp_tag_in,
	rsp_ready_in,
	rsp_valid_out,
	rsp_tmask_out,
	rsp_data_out,
	rsp_tag_out,
	rsp_ready_out
);
	// Trace: ../../rtl/VX_smem_arb.sv:4:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/VX_smem_arb.sv:5:15
	parameter LANES = 1;
	// Trace: ../../rtl/VX_smem_arb.sv:6:15
	parameter DATA_SIZE = 1;
	// Trace: ../../rtl/VX_smem_arb.sv:7:15
	parameter TAG_IN_WIDTH = 1;
	// Trace: ../../rtl/VX_smem_arb.sv:8:15
	parameter TAG_SEL_IDX = 0;
	// Trace: ../../rtl/VX_smem_arb.sv:9:15
	parameter BUFFERED_REQ = 0;
	// Trace: ../../rtl/VX_smem_arb.sv:10:15
	parameter BUFFERED_RSP = 0;
	// Trace: ../../rtl/VX_smem_arb.sv:11:15
	parameter TYPE = "P";
	// Trace: ../../rtl/VX_smem_arb.sv:13:15
	parameter ADDR_WIDTH = 32 - $clog2(DATA_SIZE);
	// Trace: ../../rtl/VX_smem_arb.sv:14:15
	parameter DATA_WIDTH = 8 * DATA_SIZE;
	// Trace: ../../rtl/VX_smem_arb.sv:15:15
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/VX_smem_arb.sv:16:15
	parameter TAG_OUT_WIDTH = TAG_IN_WIDTH - LOG_NUM_REQS;
	// Trace: ../../rtl/VX_smem_arb.sv:18:5
	input wire clk;
	// Trace: ../../rtl/VX_smem_arb.sv:19:5
	input wire reset;
	// Trace: ../../rtl/VX_smem_arb.sv:22:5
	input wire [LANES - 1:0] req_valid_in;
	// Trace: ../../rtl/VX_smem_arb.sv:23:5
	input wire [LANES - 1:0] req_rw_in;
	// Trace: ../../rtl/VX_smem_arb.sv:24:5
	input wire [(LANES * DATA_SIZE) - 1:0] req_byteen_in;
	// Trace: ../../rtl/VX_smem_arb.sv:25:5
	input wire [(LANES * ADDR_WIDTH) - 1:0] req_addr_in;
	// Trace: ../../rtl/VX_smem_arb.sv:26:5
	input wire [(LANES * DATA_WIDTH) - 1:0] req_data_in;
	// Trace: ../../rtl/VX_smem_arb.sv:27:5
	input wire [(LANES * TAG_IN_WIDTH) - 1:0] req_tag_in;
	// Trace: ../../rtl/VX_smem_arb.sv:28:5
	output wire [LANES - 1:0] req_ready_in;
	// Trace: ../../rtl/VX_smem_arb.sv:31:5
	output wire [(NUM_REQS * LANES) - 1:0] req_valid_out;
	// Trace: ../../rtl/VX_smem_arb.sv:32:5
	output wire [(NUM_REQS * LANES) - 1:0] req_rw_out;
	// Trace: ../../rtl/VX_smem_arb.sv:33:5
	output wire [((NUM_REQS * LANES) * DATA_SIZE) - 1:0] req_byteen_out;
	// Trace: ../../rtl/VX_smem_arb.sv:34:5
	output wire [((NUM_REQS * LANES) * ADDR_WIDTH) - 1:0] req_addr_out;
	// Trace: ../../rtl/VX_smem_arb.sv:35:5
	output wire [((NUM_REQS * LANES) * DATA_WIDTH) - 1:0] req_data_out;
	// Trace: ../../rtl/VX_smem_arb.sv:36:5
	output wire [((NUM_REQS * LANES) * TAG_OUT_WIDTH) - 1:0] req_tag_out;
	// Trace: ../../rtl/VX_smem_arb.sv:37:5
	input wire [(NUM_REQS * LANES) - 1:0] req_ready_out;
	// Trace: ../../rtl/VX_smem_arb.sv:40:5
	input wire [NUM_REQS - 1:0] rsp_valid_in;
	// Trace: ../../rtl/VX_smem_arb.sv:41:5
	input wire [(NUM_REQS * LANES) - 1:0] rsp_tmask_in;
	// Trace: ../../rtl/VX_smem_arb.sv:42:5
	input wire [((NUM_REQS * LANES) * DATA_WIDTH) - 1:0] rsp_data_in;
	// Trace: ../../rtl/VX_smem_arb.sv:43:5
	input wire [(NUM_REQS * TAG_OUT_WIDTH) - 1:0] rsp_tag_in;
	// Trace: ../../rtl/VX_smem_arb.sv:44:5
	output wire [NUM_REQS - 1:0] rsp_ready_in;
	// Trace: ../../rtl/VX_smem_arb.sv:47:5
	output wire rsp_valid_out;
	// Trace: ../../rtl/VX_smem_arb.sv:48:5
	output wire [LANES - 1:0] rsp_tmask_out;
	// Trace: ../../rtl/VX_smem_arb.sv:49:5
	output wire [(LANES * DATA_WIDTH) - 1:0] rsp_data_out;
	// Trace: ../../rtl/VX_smem_arb.sv:50:5
	output wire [TAG_IN_WIDTH - 1:0] rsp_tag_out;
	// Trace: ../../rtl/VX_smem_arb.sv:51:5
	input wire rsp_ready_out;
	// Trace: ../../rtl/VX_smem_arb.sv:53:5
	localparam REQ_DATAW = (((TAG_OUT_WIDTH + ADDR_WIDTH) + 1) + DATA_SIZE) + DATA_WIDTH;
	// Trace: ../../rtl/VX_smem_arb.sv:54:5
	localparam RSP_DATAW = (LANES * (1 + DATA_WIDTH)) + TAG_IN_WIDTH;
	// Trace: ../../rtl/VX_smem_arb.sv:56:5
	function automatic signed [LOG_NUM_REQS - 1:0] sv2v_cast_76B5F_signed;
		input reg signed [LOG_NUM_REQS - 1:0] inp;
		sv2v_cast_76B5F_signed = inp;
	endfunction
	generate
		if (NUM_REQS > 1) begin : genblk1
			// Trace: ../../rtl/VX_smem_arb.sv:58:9
			wire [(LANES * REQ_DATAW) - 1:0] req_data_in_merged;
			// Trace: ../../rtl/VX_smem_arb.sv:59:9
			wire [((NUM_REQS * LANES) * REQ_DATAW) - 1:0] req_data_out_merged;
			// Trace: ../../rtl/VX_smem_arb.sv:61:9
			wire [(LANES * LOG_NUM_REQS) - 1:0] req_sel;
			// Trace: ../../rtl/VX_smem_arb.sv:62:9
			wire [(LANES * TAG_OUT_WIDTH) - 1:0] req_tag_in_w;
			genvar i;
			for (i = 0; i < LANES; i = i + 1) begin : genblk1
				// Trace: ../../rtl/VX_smem_arb.sv:65:13
				assign req_sel[i * LOG_NUM_REQS+:LOG_NUM_REQS] = req_tag_in[(i * TAG_IN_WIDTH) + TAG_SEL_IDX+:LOG_NUM_REQS];
				// Trace: ../../rtl/VX_smem_arb.sv:67:13
				VX_bits_remove #(
					.N(TAG_IN_WIDTH),
					.S(LOG_NUM_REQS),
					.POS(TAG_SEL_IDX)
				) bits_remove(
					.data_in(req_tag_in[i * TAG_IN_WIDTH+:TAG_IN_WIDTH]),
					.data_out(req_tag_in_w[i * TAG_OUT_WIDTH+:TAG_OUT_WIDTH])
				);
				// Trace: ../../rtl/VX_smem_arb.sv:76:13
				assign req_data_in_merged[i * REQ_DATAW+:REQ_DATAW] = {req_tag_in_w[i * TAG_OUT_WIDTH+:TAG_OUT_WIDTH], req_addr_in[i * ADDR_WIDTH+:ADDR_WIDTH], req_rw_in[i], req_byteen_in[i * DATA_SIZE+:DATA_SIZE], req_data_in[i * DATA_WIDTH+:DATA_WIDTH]};
			end
			// Trace: ../../rtl/VX_smem_arb.sv:79:9
			VX_stream_demux #(
				.NUM_REQS(NUM_REQS),
				.LANES(LANES),
				.DATAW(REQ_DATAW),
				.BUFFERED(BUFFERED_REQ)
			) req_demux(
				.clk(clk),
				.reset(reset),
				.sel_in(req_sel),
				.valid_in(req_valid_in),
				.data_in(req_data_in_merged),
				.ready_in(req_ready_in),
				.valid_out(req_valid_out),
				.data_out(req_data_out_merged),
				.ready_out(req_ready_out)
			);
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk2
				genvar j;
				for (j = 0; j < LANES; j = j + 1) begin : genblk1
					// Trace: ../../rtl/VX_smem_arb.sv:98:17
					assign {req_tag_out[((i * LANES) + j) * TAG_OUT_WIDTH+:TAG_OUT_WIDTH], req_addr_out[((i * LANES) + j) * ADDR_WIDTH+:ADDR_WIDTH], req_rw_out[(i * LANES) + j], req_byteen_out[((i * LANES) + j) * DATA_SIZE+:DATA_SIZE], req_data_out[((i * LANES) + j) * DATA_WIDTH+:DATA_WIDTH]} = req_data_out_merged[((i * LANES) + j) * REQ_DATAW+:REQ_DATAW];
				end
			end
			// Trace: ../../rtl/VX_smem_arb.sv:104:9
			wire [(NUM_REQS * RSP_DATAW) - 1:0] rsp_data_in_merged;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk3
				// Trace: ../../rtl/VX_smem_arb.sv:107:13
				wire [TAG_IN_WIDTH - 1:0] rsp_tag_in_w;
				// Trace: ../../rtl/VX_smem_arb.sv:109:13
				VX_bits_insert #(
					.N(TAG_OUT_WIDTH),
					.S(LOG_NUM_REQS),
					.POS(TAG_SEL_IDX)
				) bits_insert(
					.data_in(rsp_tag_in[i * TAG_OUT_WIDTH+:TAG_OUT_WIDTH]),
					.sel_in(sv2v_cast_76B5F_signed(i)),
					.data_out(rsp_tag_in_w)
				);
				// Trace: ../../rtl/VX_smem_arb.sv:119:13
				assign rsp_data_in_merged[i * RSP_DATAW+:RSP_DATAW] = {rsp_tag_in_w, rsp_tmask_in[i * LANES+:LANES], rsp_data_in[DATA_WIDTH * (i * LANES)+:DATA_WIDTH * LANES]};
			end
			// Trace: ../../rtl/VX_smem_arb.sv:122:9
			VX_stream_arbiter #(
				.NUM_REQS(NUM_REQS),
				.LANES(1),
				.DATAW(RSP_DATAW),
				.BUFFERED(BUFFERED_RSP),
				.TYPE(TYPE)
			) rsp_arb(
				.clk(clk),
				.reset(reset),
				.valid_in(rsp_valid_in),
				.data_in(rsp_data_in_merged),
				.ready_in(rsp_ready_in),
				.valid_out(rsp_valid_out),
				.data_out({rsp_tag_out, rsp_tmask_out, rsp_data_out}),
				.ready_out(rsp_ready_out)
			);
		end
		else begin : genblk1
			// Trace: ../../rtl/VX_smem_arb.sv:144:9
			assign req_valid_out = req_valid_in;
			// Trace: ../../rtl/VX_smem_arb.sv:145:9
			assign req_tag_out = req_tag_in;
			// Trace: ../../rtl/VX_smem_arb.sv:146:9
			assign req_addr_out = req_addr_in;
			// Trace: ../../rtl/VX_smem_arb.sv:147:9
			assign req_rw_out = req_rw_in;
			// Trace: ../../rtl/VX_smem_arb.sv:148:9
			assign req_byteen_out = req_byteen_in;
			// Trace: ../../rtl/VX_smem_arb.sv:149:9
			assign req_data_out = req_data_in;
			// Trace: ../../rtl/VX_smem_arb.sv:150:9
			assign req_ready_in = req_ready_out;
			// Trace: ../../rtl/VX_smem_arb.sv:152:9
			assign rsp_valid_out = rsp_valid_in;
			// Trace: ../../rtl/VX_smem_arb.sv:153:9
			assign rsp_tmask_out = rsp_tmask_in;
			// Trace: ../../rtl/VX_smem_arb.sv:154:9
			assign rsp_tag_out = rsp_tag_in;
			// Trace: ../../rtl/VX_smem_arb.sv:155:9
			assign rsp_data_out = rsp_data_in;
			// Trace: ../../rtl/VX_smem_arb.sv:156:9
			assign rsp_ready_in = rsp_ready_out;
		end
	endgenerate
endmodule
// removed package "ahb_pkg"
// removed interface: ahb_if
// removed module with interface ports: Vortex_ahb
// removed package "ahb_pkg"
// removed module with interface ports: ahb_manager
module VX_mem_arb (
	clk,
	reset,
	req_valid_in,
	req_tag_in,
	req_addr_in,
	req_rw_in,
	req_byteen_in,
	req_data_in,
	req_ready_in,
	req_valid_out,
	req_tag_out,
	req_addr_out,
	req_rw_out,
	req_byteen_out,
	req_data_out,
	req_ready_out,
	rsp_valid_in,
	rsp_tag_in,
	rsp_data_in,
	rsp_ready_in,
	rsp_valid_out,
	rsp_tag_out,
	rsp_data_out,
	rsp_ready_out
);
	// Trace: ../../rtl/VX_mem_arb.sv:4:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/VX_mem_arb.sv:5:15
	parameter DATA_WIDTH = 1;
	// Trace: ../../rtl/VX_mem_arb.sv:6:15
	parameter ADDR_WIDTH = 1;
	// Trace: ../../rtl/VX_mem_arb.sv:7:15
	parameter TAG_IN_WIDTH = 1;
	// Trace: ../../rtl/VX_mem_arb.sv:8:15
	parameter TAG_SEL_IDX = 0;
	// Trace: ../../rtl/VX_mem_arb.sv:9:15
	parameter BUFFERED_REQ = 0;
	// Trace: ../../rtl/VX_mem_arb.sv:10:15
	parameter BUFFERED_RSP = 0;
	// Trace: ../../rtl/VX_mem_arb.sv:11:15
	parameter TYPE = "P";
	// Trace: ../../rtl/VX_mem_arb.sv:13:15
	parameter DATA_SIZE = DATA_WIDTH / 8;
	// Trace: ../../rtl/VX_mem_arb.sv:14:15
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/VX_mem_arb.sv:15:15
	parameter TAG_OUT_WIDTH = TAG_IN_WIDTH + LOG_NUM_REQS;
	// Trace: ../../rtl/VX_mem_arb.sv:17:5
	input wire clk;
	// Trace: ../../rtl/VX_mem_arb.sv:18:5
	input wire reset;
	// Trace: ../../rtl/VX_mem_arb.sv:21:5
	input wire [NUM_REQS - 1:0] req_valid_in;
	// Trace: ../../rtl/VX_mem_arb.sv:22:5
	input wire [(NUM_REQS * TAG_IN_WIDTH) - 1:0] req_tag_in;
	// Trace: ../../rtl/VX_mem_arb.sv:23:5
	input wire [(NUM_REQS * ADDR_WIDTH) - 1:0] req_addr_in;
	// Trace: ../../rtl/VX_mem_arb.sv:24:5
	input wire [NUM_REQS - 1:0] req_rw_in;
	// Trace: ../../rtl/VX_mem_arb.sv:25:5
	input wire [(NUM_REQS * DATA_SIZE) - 1:0] req_byteen_in;
	// Trace: ../../rtl/VX_mem_arb.sv:26:5
	input wire [(NUM_REQS * DATA_WIDTH) - 1:0] req_data_in;
	// Trace: ../../rtl/VX_mem_arb.sv:27:5
	output wire [NUM_REQS - 1:0] req_ready_in;
	// Trace: ../../rtl/VX_mem_arb.sv:30:5
	output wire req_valid_out;
	// Trace: ../../rtl/VX_mem_arb.sv:31:5
	output wire [TAG_OUT_WIDTH - 1:0] req_tag_out;
	// Trace: ../../rtl/VX_mem_arb.sv:32:5
	output wire [ADDR_WIDTH - 1:0] req_addr_out;
	// Trace: ../../rtl/VX_mem_arb.sv:33:5
	output wire req_rw_out;
	// Trace: ../../rtl/VX_mem_arb.sv:34:5
	output wire [DATA_SIZE - 1:0] req_byteen_out;
	// Trace: ../../rtl/VX_mem_arb.sv:35:5
	output wire [DATA_WIDTH - 1:0] req_data_out;
	// Trace: ../../rtl/VX_mem_arb.sv:36:5
	input wire req_ready_out;
	// Trace: ../../rtl/VX_mem_arb.sv:39:5
	input wire rsp_valid_in;
	// Trace: ../../rtl/VX_mem_arb.sv:40:5
	input wire [TAG_OUT_WIDTH - 1:0] rsp_tag_in;
	// Trace: ../../rtl/VX_mem_arb.sv:41:5
	input wire [DATA_WIDTH - 1:0] rsp_data_in;
	// Trace: ../../rtl/VX_mem_arb.sv:42:5
	output wire rsp_ready_in;
	// Trace: ../../rtl/VX_mem_arb.sv:45:5
	output wire [NUM_REQS - 1:0] rsp_valid_out;
	// Trace: ../../rtl/VX_mem_arb.sv:46:5
	output wire [(NUM_REQS * TAG_IN_WIDTH) - 1:0] rsp_tag_out;
	// Trace: ../../rtl/VX_mem_arb.sv:47:5
	output wire [(NUM_REQS * DATA_WIDTH) - 1:0] rsp_data_out;
	// Trace: ../../rtl/VX_mem_arb.sv:48:5
	input wire [NUM_REQS - 1:0] rsp_ready_out;
	// Trace: ../../rtl/VX_mem_arb.sv:50:5
	localparam REQ_DATAW = (((TAG_OUT_WIDTH + ADDR_WIDTH) + 1) + DATA_SIZE) + DATA_WIDTH;
	// Trace: ../../rtl/VX_mem_arb.sv:51:5
	localparam RSP_DATAW = TAG_IN_WIDTH + DATA_WIDTH;
	// Trace: ../../rtl/VX_mem_arb.sv:53:5
	function automatic signed [LOG_NUM_REQS - 1:0] sv2v_cast_76B5F_signed;
		input reg signed [LOG_NUM_REQS - 1:0] inp;
		sv2v_cast_76B5F_signed = inp;
	endfunction
	generate
		if (NUM_REQS > 1) begin : genblk1
			// Trace: ../../rtl/VX_mem_arb.sv:55:9
			wire [(NUM_REQS * REQ_DATAW) - 1:0] req_data_in_merged;
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
				// Trace: ../../rtl/VX_mem_arb.sv:58:13
				wire [TAG_OUT_WIDTH - 1:0] req_tag_in_w;
				// Trace: ../../rtl/VX_mem_arb.sv:60:13
				VX_bits_insert #(
					.N(TAG_IN_WIDTH),
					.S(LOG_NUM_REQS),
					.POS(TAG_SEL_IDX)
				) bits_insert(
					.data_in(req_tag_in[i * TAG_IN_WIDTH+:TAG_IN_WIDTH]),
					.sel_in(sv2v_cast_76B5F_signed(i)),
					.data_out(req_tag_in_w)
				);
				// Trace: ../../rtl/VX_mem_arb.sv:70:13
				assign req_data_in_merged[i * REQ_DATAW+:REQ_DATAW] = {req_tag_in_w, req_addr_in[i * ADDR_WIDTH+:ADDR_WIDTH], req_rw_in[i], req_byteen_in[i * DATA_SIZE+:DATA_SIZE], req_data_in[i * DATA_WIDTH+:DATA_WIDTH]};
			end
			// Trace: ../../rtl/VX_mem_arb.sv:73:9
			VX_stream_arbiter #(
				.NUM_REQS(NUM_REQS),
				.DATAW(REQ_DATAW),
				.BUFFERED(BUFFERED_REQ),
				.TYPE(TYPE)
			) req_arb(
				.clk(clk),
				.reset(reset),
				.valid_in(req_valid_in),
				.data_in(req_data_in_merged),
				.ready_in(req_ready_in),
				.valid_out(req_valid_out),
				.data_out({req_tag_out, req_addr_out, req_rw_out, req_byteen_out, req_data_out}),
				.ready_out(req_ready_out)
			);
			// Trace: ../../rtl/VX_mem_arb.sv:91:9
			wire [(NUM_REQS * RSP_DATAW) - 1:0] rsp_data_out_merged;
			// Trace: ../../rtl/VX_mem_arb.sv:93:9
			wire [LOG_NUM_REQS - 1:0] rsp_sel = rsp_tag_in[TAG_SEL_IDX+:LOG_NUM_REQS];
			// Trace: ../../rtl/VX_mem_arb.sv:95:9
			wire [TAG_IN_WIDTH - 1:0] rsp_tag_in_w;
			// Trace: ../../rtl/VX_mem_arb.sv:97:9
			VX_bits_remove #(
				.N(TAG_OUT_WIDTH),
				.S(LOG_NUM_REQS),
				.POS(TAG_SEL_IDX)
			) bits_remove(
				.data_in(rsp_tag_in),
				.data_out(rsp_tag_in_w)
			);
			// Trace: ../../rtl/VX_mem_arb.sv:106:9
			VX_stream_demux #(
				.NUM_REQS(NUM_REQS),
				.DATAW(RSP_DATAW),
				.BUFFERED(BUFFERED_RSP)
			) rsp_demux(
				.clk(clk),
				.reset(reset),
				.sel_in(rsp_sel),
				.valid_in(rsp_valid_in),
				.data_in({rsp_tag_in_w, rsp_data_in}),
				.ready_in(rsp_ready_in),
				.valid_out(rsp_valid_out),
				.data_out(rsp_data_out_merged),
				.ready_out(rsp_ready_out)
			);
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk2
				// Trace: ../../rtl/VX_mem_arb.sv:123:13
				assign {rsp_tag_out[i * TAG_IN_WIDTH+:TAG_IN_WIDTH], rsp_data_out[i * DATA_WIDTH+:DATA_WIDTH]} = rsp_data_out_merged[i * RSP_DATAW+:RSP_DATAW];
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/VX_mem_arb.sv:131:9
			assign req_valid_out = req_valid_in;
			// Trace: ../../rtl/VX_mem_arb.sv:132:9
			assign req_tag_out = req_tag_in;
			// Trace: ../../rtl/VX_mem_arb.sv:133:9
			assign req_addr_out = req_addr_in;
			// Trace: ../../rtl/VX_mem_arb.sv:134:9
			assign req_rw_out = req_rw_in;
			// Trace: ../../rtl/VX_mem_arb.sv:135:9
			assign req_byteen_out = req_byteen_in;
			// Trace: ../../rtl/VX_mem_arb.sv:136:9
			assign req_data_out = req_data_in;
			// Trace: ../../rtl/VX_mem_arb.sv:137:9
			assign req_ready_in = req_ready_out;
			// Trace: ../../rtl/VX_mem_arb.sv:139:9
			assign rsp_valid_out = rsp_valid_in;
			// Trace: ../../rtl/VX_mem_arb.sv:140:9
			assign rsp_tag_out = rsp_tag_in;
			// Trace: ../../rtl/VX_mem_arb.sv:141:9
			assign rsp_data_out = rsp_data_in;
			// Trace: ../../rtl/VX_mem_arb.sv:142:9
			assign rsp_ready_in = rsp_ready_out;
		end
	endgenerate
endmodule
// removed module with interface ports: VX_ibuffer
module Vortex (
	clk,
	reset,
	mem_req_valid,
	mem_req_rw,
	mem_req_byteen,
	mem_req_addr,
	mem_req_data,
	mem_req_tag,
	mem_req_ready,
	mem_rsp_valid,
	mem_rsp_data,
	mem_rsp_tag,
	mem_rsp_ready,
	busy
);
	// Trace: ../../rtl/Vortex.sv:7:5
	input wire clk;
	// Trace: ../../rtl/Vortex.sv:8:5
	input wire reset;
	// Trace: ../../rtl/Vortex.sv:11:5
	output wire mem_req_valid;
	// Trace: ../../rtl/Vortex.sv:12:5
	output wire mem_req_rw;
	// Trace: ../../rtl/Vortex.sv:13:5
	output wire [(0 || 0 ? 16 : 64) - 1:0] mem_req_byteen;
	// Trace: ../../rtl/Vortex.sv:14:5
	output wire [(32 - $clog2((0 || 0 ? 16 : 64))) - 1:0] mem_req_addr;
	// Trace: ../../rtl/Vortex.sv:15:5
	output wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_req_data;
	// Trace: ../../rtl/Vortex.sv:16:5
	output wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_req_tag;
	// Trace: ../../rtl/Vortex.sv:17:5
	input wire mem_req_ready;
	// Trace: ../../rtl/Vortex.sv:20:5
	input wire mem_rsp_valid;
	// Trace: ../../rtl/Vortex.sv:21:5
	input wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_rsp_data;
	// Trace: ../../rtl/Vortex.sv:22:5
	input wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_rsp_tag;
	// Trace: ../../rtl/Vortex.sv:23:5
	output wire mem_rsp_ready;
	// Trace: ../../rtl/Vortex.sv:26:5
	output wire busy;
	// Trace: ../../rtl/Vortex.sv:30:5
	wire [0:0] per_cluster_mem_req_valid;
	// Trace: ../../rtl/Vortex.sv:31:5
	wire [0:0] per_cluster_mem_req_rw;
	// Trace: ../../rtl/Vortex.sv:32:5
	wire [(0 || 0 ? 16 : 64) - 1:0] per_cluster_mem_req_byteen;
	// Trace: ../../rtl/Vortex.sv:33:5
	wire [(32 - $clog2((0 || 0 ? 16 : 64))) - 1:0] per_cluster_mem_req_addr;
	// Trace: ../../rtl/Vortex.sv:34:5
	wire [((0 || 0 ? 16 : 64) * 8) - 1:0] per_cluster_mem_req_data;
	// Trace: ../../rtl/Vortex.sv:35:5
	wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] per_cluster_mem_req_tag;
	// Trace: ../../rtl/Vortex.sv:36:5
	wire [0:0] per_cluster_mem_req_ready;
	// Trace: ../../rtl/Vortex.sv:38:5
	wire [0:0] per_cluster_mem_rsp_valid;
	// Trace: ../../rtl/Vortex.sv:39:5
	wire [((0 || 0 ? 16 : 64) * 8) - 1:0] per_cluster_mem_rsp_data;
	// Trace: ../../rtl/Vortex.sv:40:5
	wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] per_cluster_mem_rsp_tag;
	// Trace: ../../rtl/Vortex.sv:41:5
	wire [0:0] per_cluster_mem_rsp_ready;
	// Trace: ../../rtl/Vortex.sv:43:5
	wire [0:0] per_cluster_busy;
	// Trace: ../../rtl/Vortex.sv:45:5
	genvar i;
	generate
		for (i = 0; i < 1; i = i + 1) begin : genblk1
			// Trace: macro expansion of RESET_RELAY at ../../rtl/Vortex.sv:47:30
			wire cluster_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/Vortex.sv:47:63
			VX_reset_relay __cluster_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(cluster_reset)
			);
			// Trace: ../../rtl/Vortex.sv:49:9
			VX_cluster #(.CLUSTER_ID(i)) cluster(
				.clk(clk),
				.reset(cluster_reset),
				.mem_req_valid(per_cluster_mem_req_valid[i]),
				.mem_req_rw(per_cluster_mem_req_rw[i]),
				.mem_req_byteen(per_cluster_mem_req_byteen[i * (0 || 0 ? 16 : 64)+:(0 || 0 ? 16 : 64)]),
				.mem_req_addr(per_cluster_mem_req_addr[i * (32 - $clog2((0 || 0 ? 16 : 64)))+:32 - $clog2((0 || 0 ? 16 : 64))]),
				.mem_req_data(per_cluster_mem_req_data[i * ((0 || 0 ? 16 : 64) * 8)+:(0 || 0 ? 16 : 64) * 8]),
				.mem_req_tag(per_cluster_mem_req_tag[i * ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1)+:(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1]),
				.mem_req_ready(per_cluster_mem_req_ready[i]),
				.mem_rsp_valid(per_cluster_mem_rsp_valid[i]),
				.mem_rsp_data(per_cluster_mem_rsp_data[i * ((0 || 0 ? 16 : 64) * 8)+:(0 || 0 ? 16 : 64) * 8]),
				.mem_rsp_tag(per_cluster_mem_rsp_tag[i * ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1)+:(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1]),
				.mem_rsp_ready(per_cluster_mem_rsp_ready[i]),
				.busy(per_cluster_busy[i])
			);
		end
	endgenerate
	// Trace: ../../rtl/Vortex.sv:74:5
	assign busy = |per_cluster_busy;
	// Trace: ../../rtl/Vortex.sv:76:5
	generate
		if (1) begin : genblk2
			// Trace: macro expansion of RESET_RELAY at ../../rtl/Vortex.sv:145:30
			wire mem_arb_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/Vortex.sv:145:63
			VX_reset_relay __mem_arb_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(mem_arb_reset)
			);
			// Trace: ../../rtl/Vortex.sv:147:9
			VX_mem_arb #(
				.NUM_REQS(1),
				.DATA_WIDTH((0 || 0 ? 16 : 64) * 8),
				.ADDR_WIDTH(32 - $clog2((0 || 0 ? 16 : 64))),
				.TAG_IN_WIDTH((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1),
				.TYPE("R"),
				.BUFFERED_REQ(1),
				.BUFFERED_RSP(1)
			) mem_arb(
				.clk(clk),
				.reset(mem_arb_reset),
				.req_valid_in(per_cluster_mem_req_valid),
				.req_rw_in(per_cluster_mem_req_rw),
				.req_byteen_in(per_cluster_mem_req_byteen),
				.req_addr_in(per_cluster_mem_req_addr),
				.req_data_in(per_cluster_mem_req_data),
				.req_tag_in(per_cluster_mem_req_tag),
				.req_ready_in(per_cluster_mem_req_ready),
				.req_valid_out(mem_req_valid),
				.req_rw_out(mem_req_rw),
				.req_byteen_out(mem_req_byteen),
				.req_addr_out(mem_req_addr),
				.req_data_out(mem_req_data),
				.req_tag_out(mem_req_tag),
				.req_ready_out(mem_req_ready),
				.rsp_valid_out(per_cluster_mem_rsp_valid),
				.rsp_data_out(per_cluster_mem_rsp_data),
				.rsp_tag_out(per_cluster_mem_rsp_tag),
				.rsp_ready_out(per_cluster_mem_rsp_ready),
				.rsp_valid_in(mem_rsp_valid),
				.rsp_tag_in(mem_rsp_tag),
				.rsp_data_in(mem_rsp_data),
				.rsp_ready_in(mem_rsp_ready)
			);
		end
	endgenerate
endmodule
// removed module with interface ports: VX_mem_unit
// removed module with interface ports: VX_writeback
// removed module with interface ports: VX_commit
// removed module with interface ports: VX_issue
module VX_core (
	clk,
	reset,
	mem_req_valid,
	mem_req_rw,
	mem_req_byteen,
	mem_req_addr,
	mem_req_data,
	mem_req_tag,
	mem_req_ready,
	mem_rsp_valid,
	mem_rsp_data,
	mem_rsp_tag,
	mem_rsp_ready,
	busy
);
	// Trace: ../../rtl/VX_core.sv:4:15
	parameter CORE_ID = 0;
	// Trace: ../../rtl/VX_core.sv:9:5
	input wire clk;
	// Trace: ../../rtl/VX_core.sv:10:5
	input wire reset;
	// Trace: ../../rtl/VX_core.sv:13:5
	output wire mem_req_valid;
	// Trace: ../../rtl/VX_core.sv:14:5
	output wire mem_req_rw;
	// Trace: ../../rtl/VX_core.sv:15:5
	output wire [(0 || 0 ? 16 : 64) - 1:0] mem_req_byteen;
	// Trace: ../../rtl/VX_core.sv:16:5
	output wire [(32 - $clog2((0 || 0 ? 16 : 64))) - 1:0] mem_req_addr;
	// Trace: ../../rtl/VX_core.sv:17:5
	output wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_req_data;
	// Trace: ../../rtl/VX_core.sv:18:5
	output wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_req_tag;
	// Trace: ../../rtl/VX_core.sv:19:5
	input wire mem_req_ready;
	// Trace: ../../rtl/VX_core.sv:22:5
	input wire mem_rsp_valid;
	// Trace: ../../rtl/VX_core.sv:23:5
	input wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_rsp_data;
	// Trace: ../../rtl/VX_core.sv:24:5
	input wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_rsp_tag;
	// Trace: ../../rtl/VX_core.sv:25:5
	output wire mem_rsp_ready;
	// Trace: ../../rtl/VX_core.sv:28:5
	output wire busy;
	// Trace: ../../rtl/VX_core.sv:34:5
	// expanded interface instance: mem_req_if
	localparam _param_ABED4_DATA_WIDTH = (0 || 0 ? 16 : 64) * 8;
	localparam _param_ABED4_ADDR_WIDTH = 32 - $clog2((0 || 0 ? 16 : 64));
	localparam _param_ABED4_TAG_WIDTH = (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1;
	generate
		if (1) begin : mem_req_if
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:7:15
			localparam DATA_WIDTH = _param_ABED4_DATA_WIDTH;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:8:15
			localparam ADDR_WIDTH = _param_ABED4_ADDR_WIDTH;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:9:15
			localparam TAG_WIDTH = _param_ABED4_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:10:15
			localparam DATA_SIZE = DATA_WIDTH / 8;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:13:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:14:5
			wire rw;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:15:5
			wire [DATA_SIZE - 1:0] byteen;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:16:5
			wire [ADDR_WIDTH - 1:0] addr;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:17:5
			wire [DATA_WIDTH - 1:0] data;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:18:5
			wire [TAG_WIDTH - 1:0] tag;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:19:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:21:5
			// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:31:5
		end
	endgenerate
	// Trace: ../../rtl/VX_core.sv:40:5
	// expanded interface instance: mem_rsp_if
	localparam _param_F9E76_DATA_WIDTH = (0 || 0 ? 16 : 64) * 8;
	localparam _param_F9E76_TAG_WIDTH = (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1;
	generate
		if (1) begin : mem_rsp_if
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:7:15
			localparam DATA_WIDTH = _param_F9E76_DATA_WIDTH;
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:8:15
			localparam TAG_WIDTH = _param_F9E76_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:11:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:12:5
			wire [DATA_WIDTH - 1:0] data;
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:13:5
			wire [TAG_WIDTH - 1:0] tag;
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:14:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:16:5
			// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:23:5
		end
	endgenerate
	// Trace: ../../rtl/VX_core.sv:45:5
	assign mem_req_valid = mem_req_if.valid;
	// Trace: ../../rtl/VX_core.sv:46:5
	assign mem_req_rw = mem_req_if.rw;
	// Trace: ../../rtl/VX_core.sv:47:5
	assign mem_req_byteen = mem_req_if.byteen;
	// Trace: ../../rtl/VX_core.sv:48:5
	assign mem_req_addr = mem_req_if.addr;
	// Trace: ../../rtl/VX_core.sv:49:5
	assign mem_req_data = mem_req_if.data;
	// Trace: ../../rtl/VX_core.sv:50:5
	assign mem_req_tag = mem_req_if.tag;
	// Trace: ../../rtl/VX_core.sv:51:5
	assign mem_req_if.ready = mem_req_ready;
	// Trace: ../../rtl/VX_core.sv:53:5
	assign mem_rsp_if.valid = mem_rsp_valid;
	// Trace: ../../rtl/VX_core.sv:54:5
	assign mem_rsp_if.data = mem_rsp_data;
	// Trace: ../../rtl/VX_core.sv:55:5
	assign mem_rsp_if.tag = mem_rsp_tag;
	// Trace: ../../rtl/VX_core.sv:56:5
	assign mem_rsp_ready = mem_rsp_if.ready;
	// Trace: ../../rtl/VX_core.sv:60:5
	// expanded interface instance: dcache_req_if
	localparam _param_BD702_NUM_REQS = 2;
	localparam _param_BD702_WORD_SIZE = 4;
	localparam _param_BD702_TAG_WIDTH = 48;
	generate
		if (1) begin : dcache_req_if
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:7:15
			localparam NUM_REQS = _param_BD702_NUM_REQS;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:8:15
			localparam WORD_SIZE = _param_BD702_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:9:15
			localparam TAG_WIDTH = _param_BD702_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:12:5
			wire [1:0] valid;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:13:5
			wire [1:0] rw;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:14:5
			wire [7:0] byteen;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:15:5
			wire [59:0] addr;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:16:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:17:5
			wire [95:0] tag;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:18:5
			wire [1:0] ready;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:20:5
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:30:5
		end
	endgenerate
	// Trace: ../../rtl/VX_core.sv:66:5
	// expanded interface instance: dcache_rsp_if
	localparam _param_2395E_NUM_REQS = 2;
	localparam _param_2395E_WORD_SIZE = 4;
	localparam _param_2395E_TAG_WIDTH = 48;
	generate
		if (1) begin : dcache_rsp_if
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:7:15
			localparam NUM_REQS = _param_2395E_NUM_REQS;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:8:15
			localparam WORD_SIZE = _param_2395E_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:9:15
			localparam TAG_WIDTH = _param_2395E_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:12:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:13:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:14:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:15:5
			wire [47:0] tag;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:16:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:18:5
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:26:5
		end
	endgenerate
	// Trace: ../../rtl/VX_core.sv:72:5
	// expanded interface instance: icache_req_if
	localparam _param_1F99A_WORD_SIZE = 4;
	localparam _param_1F99A_TAG_WIDTH = 45;
	generate
		if (1) begin : icache_req_if
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:7:15
			localparam WORD_SIZE = _param_1F99A_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:8:15
			localparam TAG_WIDTH = _param_1F99A_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:11:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:12:5
			wire [29:0] addr;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:13:5
			wire [44:0] tag;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:14:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:16:5
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:23:5
		end
	endgenerate
	// Trace: ../../rtl/VX_core.sv:77:5
	// expanded interface instance: icache_rsp_if
	localparam _param_396BA_WORD_SIZE = 4;
	localparam _param_396BA_TAG_WIDTH = 45;
	generate
		if (1) begin : icache_rsp_if
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:7:15
			localparam WORD_SIZE = _param_396BA_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:8:15
			localparam TAG_WIDTH = _param_396BA_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:11:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:12:5
			wire [31:0] data;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:13:5
			wire [44:0] tag;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:14:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:16:5
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:23:5
		end
	endgenerate
	// Trace: ../../rtl/VX_core.sv:82:5
	VX_pipeline #(.CORE_ID(CORE_ID)) pipeline(
		.clk(clk),
		.reset(reset),
		.dcache_req_valid(dcache_req_if.valid),
		.dcache_req_rw(dcache_req_if.rw),
		.dcache_req_byteen(dcache_req_if.byteen),
		.dcache_req_addr(dcache_req_if.addr),
		.dcache_req_data(dcache_req_if.data),
		.dcache_req_tag(dcache_req_if.tag),
		.dcache_req_ready(dcache_req_if.ready),
		.dcache_rsp_valid(dcache_rsp_if.valid),
		.dcache_rsp_tmask(dcache_rsp_if.tmask),
		.dcache_rsp_data(dcache_rsp_if.data),
		.dcache_rsp_tag(dcache_rsp_if.tag),
		.dcache_rsp_ready(dcache_rsp_if.ready),
		.icache_req_valid(icache_req_if.valid),
		.icache_req_addr(icache_req_if.addr),
		.icache_req_tag(icache_req_if.tag),
		.icache_req_ready(icache_req_if.ready),
		.icache_rsp_valid(icache_rsp_if.valid),
		.icache_rsp_data(icache_rsp_if.data),
		.icache_rsp_tag(icache_rsp_if.tag),
		.icache_rsp_ready(icache_rsp_if.ready),
		.busy(busy)
	);
	// Trace: ../../rtl/VX_core.sv:127:5
	// expanded module instance: mem_unit
	localparam _param_A06D0_CORE_ID = CORE_ID;
	function automatic [(4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) - 1:0] sv2v_cast_7CD18;
		input reg [(4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) - 1:0] inp;
		sv2v_cast_7CD18 = inp;
	endfunction
	generate
		if (1) begin : mem_unit
			// Trace: ../../rtl/VX_mem_unit.sv:4:15
			localparam CORE_ID = _param_A06D0_CORE_ID;
			// Trace: ../../rtl/VX_mem_unit.sv:8:5
			wire clk;
			// Trace: ../../rtl/VX_mem_unit.sv:9:5
			wire reset;
			// Trace: ../../rtl/VX_mem_unit.sv:16:5
			// removed modport instance dcache_req_if
			// Trace: ../../rtl/VX_mem_unit.sv:17:5
			// removed modport instance dcache_rsp_if
			// Trace: ../../rtl/VX_mem_unit.sv:20:5
			// removed modport instance icache_req_if
			// Trace: ../../rtl/VX_mem_unit.sv:21:5
			// removed modport instance icache_rsp_if
			// Trace: ../../rtl/VX_mem_unit.sv:24:5
			// removed modport instance mem_req_if
			// Trace: ../../rtl/VX_mem_unit.sv:25:5
			// removed modport instance mem_rsp_if
			// Trace: ../../rtl/VX_mem_unit.sv:32:5
			// expanded interface instance: icache_mem_req_if
			localparam _param_03929_DATA_WIDTH = (0 || 0 ? 16 : 64) * 8;
			localparam _param_03929_ADDR_WIDTH = 32 - $clog2((0 || 0 ? 16 : 64));
			localparam _param_03929_TAG_WIDTH = 1;
			if (1) begin : icache_mem_req_if
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:7:15
				localparam DATA_WIDTH = _param_03929_DATA_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:8:15
				localparam ADDR_WIDTH = _param_03929_ADDR_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:9:15
				localparam TAG_WIDTH = _param_03929_TAG_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:10:15
				localparam DATA_SIZE = DATA_WIDTH / 8;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:13:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:14:5
				wire rw;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:15:5
				wire [DATA_SIZE - 1:0] byteen;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:16:5
				wire [ADDR_WIDTH - 1:0] addr;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:17:5
				wire [DATA_WIDTH - 1:0] data;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:18:5
				wire [0:0] tag;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:19:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:21:5
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:31:5
			end
			// Trace: ../../rtl/VX_mem_unit.sv:38:5
			// expanded interface instance: icache_mem_rsp_if
			localparam _param_8D4A5_DATA_WIDTH = (0 || 0 ? 16 : 64) * 8;
			localparam _param_8D4A5_TAG_WIDTH = 1;
			if (1) begin : icache_mem_rsp_if
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:7:15
				localparam DATA_WIDTH = _param_8D4A5_DATA_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:8:15
				localparam TAG_WIDTH = _param_8D4A5_TAG_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:11:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:12:5
				wire [DATA_WIDTH - 1:0] data;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:13:5
				wire [0:0] tag;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:14:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:16:5
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:23:5
			end
			// Trace: ../../rtl/VX_mem_unit.sv:43:5
			// expanded interface instance: dcache_mem_req_if
			localparam _param_B57C2_DATA_WIDTH = (0 || 0 ? 16 : 64) * 8;
			localparam _param_B57C2_ADDR_WIDTH = 32 - $clog2((0 || 0 ? 16 : 64));
			localparam _param_B57C2_TAG_WIDTH = (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48);
			if (1) begin : dcache_mem_req_if
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:7:15
				localparam DATA_WIDTH = _param_B57C2_DATA_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:8:15
				localparam ADDR_WIDTH = _param_B57C2_ADDR_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:9:15
				localparam TAG_WIDTH = _param_B57C2_TAG_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:10:15
				localparam DATA_SIZE = DATA_WIDTH / 8;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:13:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:14:5
				wire rw;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:15:5
				wire [DATA_SIZE - 1:0] byteen;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:16:5
				wire [ADDR_WIDTH - 1:0] addr;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:17:5
				wire [DATA_WIDTH - 1:0] data;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:18:5
				wire [TAG_WIDTH - 1:0] tag;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:19:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:21:5
				// Trace: ../../rtl/interfaces/VX_mem_req_if.sv:31:5
			end
			// Trace: ../../rtl/VX_mem_unit.sv:49:5
			// expanded interface instance: dcache_mem_rsp_if
			localparam _param_79532_DATA_WIDTH = (0 || 0 ? 16 : 64) * 8;
			localparam _param_79532_TAG_WIDTH = (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48);
			if (1) begin : dcache_mem_rsp_if
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:7:15
				localparam DATA_WIDTH = _param_79532_DATA_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:8:15
				localparam TAG_WIDTH = _param_79532_TAG_WIDTH;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:11:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:12:5
				wire [DATA_WIDTH - 1:0] data;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:13:5
				wire [TAG_WIDTH - 1:0] tag;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:14:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:16:5
				// Trace: ../../rtl/interfaces/VX_mem_rsp_if.sv:23:5
			end
			// Trace: ../../rtl/VX_mem_unit.sv:54:5
			// expanded interface instance: dcache_req_tmp_if
			localparam _param_79CA8_NUM_REQS = 2;
			localparam _param_79CA8_WORD_SIZE = 4;
			localparam _param_79CA8_TAG_WIDTH = 47;
			if (1) begin : dcache_req_tmp_if
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:7:15
				localparam NUM_REQS = _param_79CA8_NUM_REQS;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:8:15
				localparam WORD_SIZE = _param_79CA8_WORD_SIZE;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:9:15
				localparam TAG_WIDTH = _param_79CA8_TAG_WIDTH;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:12:5
				wire [1:0] valid;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:13:5
				wire [1:0] rw;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:14:5
				wire [7:0] byteen;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:15:5
				wire [59:0] addr;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:16:5
				wire [63:0] data;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:17:5
				wire [93:0] tag;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:18:5
				wire [1:0] ready;
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:20:5
				// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:30:5
			end
			// Trace: ../../rtl/VX_mem_unit.sv:60:5
			// expanded interface instance: dcache_rsp_tmp_if
			localparam _param_E25F4_NUM_REQS = 2;
			localparam _param_E25F4_WORD_SIZE = 4;
			localparam _param_E25F4_TAG_WIDTH = 47;
			if (1) begin : dcache_rsp_tmp_if
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:7:15
				localparam NUM_REQS = _param_E25F4_NUM_REQS;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:8:15
				localparam WORD_SIZE = _param_E25F4_WORD_SIZE;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:9:15
				localparam TAG_WIDTH = _param_E25F4_TAG_WIDTH;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:12:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:13:5
				wire [1:0] tmask;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:14:5
				wire [63:0] data;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:15:5
				wire [46:0] tag;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:16:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:18:5
				// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:26:5
			end
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:66:25
			wire icache_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:66:58
			VX_reset_relay __icache_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(icache_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:67:25
			wire dcache_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:67:58
			VX_reset_relay __dcache_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(dcache_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:68:26
			wire mem_arb_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:68:59
			VX_reset_relay __mem_arb_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(mem_arb_reset)
			);
			// Trace: ../../rtl/VX_mem_unit.sv:70:5
			localparam sv2v_uu_icache_NUM_REQS = 1;
			localparam sv2v_uu_icache_WORD_SIZE = 4;
			// removed localparam type sv2v_uu_icache_core_req_data
			localparam [31:0] sv2v_uu_icache_ext_core_req_data_x = 1'sbx;
			VX_cache #(
				.CACHE_ID((0 + (CORE_ID * 3)) + 0),
				.CACHE_SIZE(16384),
				.CACHE_LINE_SIZE((0 || 0 ? 16 : 64)),
				.NUM_BANKS(1),
				.WORD_SIZE(4),
				.NUM_REQS(1),
				.CREQ_SIZE(0),
				.CRSQ_SIZE(2),
				.MSHR_SIZE(2),
				.MRSQ_SIZE(0),
				.MREQ_SIZE(4),
				.WRITE_ENABLE(0),
				.CORE_TAG_WIDTH(45),
				.CORE_TAG_ID_BITS(1),
				.MEM_TAG_WIDTH(1)
			) icache(
				.clk(clk),
				.reset(icache_reset),
				.core_req_valid(VX_core.icache_req_if.valid),
				.core_req_rw(1'b0),
				.core_req_byteen('b0),
				.core_req_addr(VX_core.icache_req_if.addr),
				.core_req_data(sv2v_uu_icache_ext_core_req_data_x),
				.core_req_tag(VX_core.icache_req_if.tag),
				.core_req_ready(VX_core.icache_req_if.ready),
				.core_rsp_valid(VX_core.icache_rsp_if.valid),
				.core_rsp_data(VX_core.icache_rsp_if.data),
				.core_rsp_tag(VX_core.icache_rsp_if.tag),
				.core_rsp_ready(VX_core.icache_rsp_if.ready),
				.mem_req_valid(icache_mem_req_if.valid),
				.mem_req_rw(icache_mem_req_if.rw),
				.mem_req_byteen(icache_mem_req_if.byteen),
				.mem_req_addr(icache_mem_req_if.addr),
				.mem_req_data(icache_mem_req_if.data),
				.mem_req_tag(icache_mem_req_if.tag),
				.mem_req_ready(icache_mem_req_if.ready),
				.mem_rsp_valid(icache_mem_rsp_if.valid),
				.mem_rsp_data(icache_mem_rsp_if.data),
				.mem_rsp_tag(icache_mem_rsp_if.tag),
				.mem_rsp_ready(icache_mem_rsp_if.ready)
			);
			// Trace: ../../rtl/VX_mem_unit.sv:128:5
			VX_cache #(
				.CACHE_ID((0 + (CORE_ID * 3)) + 1),
				.CACHE_SIZE(16384),
				.CACHE_LINE_SIZE((0 || 0 ? 16 : 64)),
				.NUM_BANKS(2),
				.NUM_PORTS(1),
				.WORD_SIZE(4),
				.NUM_REQS(2),
				.CREQ_SIZE(0),
				.CRSQ_SIZE(2),
				.MSHR_SIZE(4),
				.MRSQ_SIZE(0),
				.MREQ_SIZE(4),
				.WRITE_ENABLE(1),
				.CORE_TAG_WIDTH(47),
				.CORE_TAG_ID_BITS(3),
				.MEM_TAG_WIDTH((4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)),
				.NC_ENABLE(1)
			) dcache(
				.clk(clk),
				.reset(dcache_reset),
				.core_req_valid(dcache_req_tmp_if.valid),
				.core_req_rw(dcache_req_tmp_if.rw),
				.core_req_byteen(dcache_req_tmp_if.byteen),
				.core_req_addr(dcache_req_tmp_if.addr),
				.core_req_data(dcache_req_tmp_if.data),
				.core_req_tag(dcache_req_tmp_if.tag),
				.core_req_ready(dcache_req_tmp_if.ready),
				.core_rsp_valid(dcache_rsp_tmp_if.valid),
				.core_rsp_tmask(dcache_rsp_tmp_if.tmask),
				.core_rsp_data(dcache_rsp_tmp_if.data),
				.core_rsp_tag(dcache_rsp_tmp_if.tag),
				.core_rsp_ready(dcache_rsp_tmp_if.ready),
				.mem_req_valid(dcache_mem_req_if.valid),
				.mem_req_rw(dcache_mem_req_if.rw),
				.mem_req_byteen(dcache_mem_req_if.byteen),
				.mem_req_addr(dcache_mem_req_if.addr),
				.mem_req_data(dcache_mem_req_if.data),
				.mem_req_tag(dcache_mem_req_if.tag),
				.mem_req_ready(dcache_mem_req_if.ready),
				.mem_rsp_valid(dcache_mem_rsp_if.valid),
				.mem_rsp_data(dcache_mem_rsp_if.data),
				.mem_rsp_tag(dcache_mem_rsp_if.tag),
				.mem_rsp_ready(dcache_mem_rsp_if.ready)
			);
			// Trace: ../../rtl/VX_mem_unit.sv:188:5
			if (1) begin : genblk1
				// Trace: ../../rtl/VX_mem_unit.sv:189:9
				// expanded interface instance: smem_req_if
				localparam _param_C3EC4_NUM_REQS = 2;
				localparam _param_C3EC4_WORD_SIZE = 4;
				localparam _param_C3EC4_TAG_WIDTH = 47;
				if (1) begin : smem_req_if
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:7:15
					localparam NUM_REQS = _param_C3EC4_NUM_REQS;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:8:15
					localparam WORD_SIZE = _param_C3EC4_WORD_SIZE;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:9:15
					localparam TAG_WIDTH = _param_C3EC4_TAG_WIDTH;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:12:5
					wire [1:0] valid;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:13:5
					wire [1:0] rw;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:14:5
					wire [7:0] byteen;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:15:5
					wire [59:0] addr;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:16:5
					wire [63:0] data;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:17:5
					wire [93:0] tag;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:18:5
					wire [1:0] ready;
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:20:5
					// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:30:5
				end
				// Trace: ../../rtl/VX_mem_unit.sv:195:9
				// expanded interface instance: smem_rsp_if
				localparam _param_541C4_NUM_REQS = 2;
				localparam _param_541C4_WORD_SIZE = 4;
				localparam _param_541C4_TAG_WIDTH = 47;
				if (1) begin : smem_rsp_if
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:7:15
					localparam NUM_REQS = _param_541C4_NUM_REQS;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:8:15
					localparam WORD_SIZE = _param_541C4_WORD_SIZE;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:9:15
					localparam TAG_WIDTH = _param_541C4_TAG_WIDTH;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:12:5
					wire valid;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:13:5
					wire [1:0] tmask;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:14:5
					wire [63:0] data;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:15:5
					wire [46:0] tag;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:16:5
					wire ready;
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:18:5
					// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:26:5
				end
				// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:201:31
				wire smem_arb_reset;
				// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:201:64
				VX_reset_relay __smem_arb_reset(
					.clk(clk),
					.reset(reset),
					.reset_o(smem_arb_reset)
				);
				// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:202:27
				wire smem_reset;
				// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_mem_unit.sv:202:60
				VX_reset_relay __smem_reset(
					.clk(clk),
					.reset(reset),
					.reset_o(smem_reset)
				);
				// Trace: ../../rtl/VX_mem_unit.sv:204:9
				VX_smem_arb #(
					.NUM_REQS(2),
					.LANES(2),
					.DATA_SIZE(4),
					.TAG_IN_WIDTH(48),
					.TAG_SEL_IDX(0),
					.TYPE("P"),
					.BUFFERED_REQ(2),
					.BUFFERED_RSP(1)
				) smem_arb(
					.clk(clk),
					.reset(smem_arb_reset),
					.req_valid_in(VX_core.dcache_req_if.valid),
					.req_rw_in(VX_core.dcache_req_if.rw),
					.req_byteen_in(VX_core.dcache_req_if.byteen),
					.req_addr_in(VX_core.dcache_req_if.addr),
					.req_data_in(VX_core.dcache_req_if.data),
					.req_tag_in(VX_core.dcache_req_if.tag),
					.req_ready_in(VX_core.dcache_req_if.ready),
					.req_valid_out({smem_req_if.valid, dcache_req_tmp_if.valid}),
					.req_rw_out({smem_req_if.rw, dcache_req_tmp_if.rw}),
					.req_byteen_out({smem_req_if.byteen, dcache_req_tmp_if.byteen}),
					.req_addr_out({smem_req_if.addr, dcache_req_tmp_if.addr}),
					.req_data_out({smem_req_if.data, dcache_req_tmp_if.data}),
					.req_tag_out({smem_req_if.tag, dcache_req_tmp_if.tag}),
					.req_ready_out({smem_req_if.ready, dcache_req_tmp_if.ready}),
					.rsp_valid_in({smem_rsp_if.valid, dcache_rsp_tmp_if.valid}),
					.rsp_tmask_in({smem_rsp_if.tmask, dcache_rsp_tmp_if.tmask}),
					.rsp_data_in({smem_rsp_if.data, dcache_rsp_tmp_if.data}),
					.rsp_tag_in({smem_rsp_if.tag, dcache_rsp_tmp_if.tag}),
					.rsp_ready_in({smem_rsp_if.ready, dcache_rsp_tmp_if.ready}),
					.rsp_valid_out(VX_core.dcache_rsp_if.valid),
					.rsp_tmask_out(VX_core.dcache_rsp_if.tmask),
					.rsp_tag_out(VX_core.dcache_rsp_if.tag),
					.rsp_data_out(VX_core.dcache_rsp_if.data),
					.rsp_ready_out(VX_core.dcache_rsp_if.ready)
				);
				// Trace: ../../rtl/VX_mem_unit.sv:250:9
				VX_shared_mem #(
					.CACHE_ID((0 + (CORE_ID * 3)) + 2),
					.CACHE_SIZE(4096),
					.NUM_BANKS(2),
					.WORD_SIZE(4),
					.NUM_REQS(2),
					.CREQ_SIZE(2),
					.CRSQ_SIZE(2),
					.CORE_TAG_WIDTH(47),
					.CORE_TAG_ID_BITS(3),
					.BANK_ADDR_OFFSET(8)
				) smem(
					.clk(clk),
					.reset(smem_reset),
					.core_req_valid(smem_req_if.valid),
					.core_req_rw(smem_req_if.rw),
					.core_req_byteen(smem_req_if.byteen),
					.core_req_addr(smem_req_if.addr),
					.core_req_data(smem_req_if.data),
					.core_req_tag(smem_req_if.tag),
					.core_req_ready(smem_req_if.ready),
					.core_rsp_valid(smem_rsp_if.valid),
					.core_rsp_tmask(smem_rsp_if.tmask),
					.core_rsp_data(smem_rsp_if.data),
					.core_rsp_tag(smem_rsp_if.tag),
					.core_rsp_ready(smem_rsp_if.ready)
				);
			end
			// Trace: ../../rtl/VX_mem_unit.sv:310:5
			wire [(4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) - 1:0] icache_mem_req_tag = sv2v_cast_7CD18(icache_mem_req_if.tag);
			// Trace: ../../rtl/VX_mem_unit.sv:311:5
			wire [(4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) - 1:0] icache_mem_rsp_tag;
			// Trace: ../../rtl/VX_mem_unit.sv:312:5
			assign icache_mem_rsp_if.tag = icache_mem_rsp_tag[0:0];
			// Trace: ../../rtl/VX_mem_unit.sv:315:5
			VX_mem_arb #(
				.NUM_REQS(2),
				.DATA_WIDTH((0 || 0 ? 16 : 64) * 8),
				.ADDR_WIDTH(32 - $clog2((0 || 0 ? 16 : 64))),
				.TAG_IN_WIDTH((4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)),
				.TYPE("R"),
				.TAG_SEL_IDX(1),
				.BUFFERED_REQ(1),
				.BUFFERED_RSP(2)
			) mem_arb(
				.clk(clk),
				.reset(mem_arb_reset),
				.req_valid_in({dcache_mem_req_if.valid, icache_mem_req_if.valid}),
				.req_rw_in({dcache_mem_req_if.rw, icache_mem_req_if.rw}),
				.req_byteen_in({dcache_mem_req_if.byteen, icache_mem_req_if.byteen}),
				.req_addr_in({dcache_mem_req_if.addr, icache_mem_req_if.addr}),
				.req_data_in({dcache_mem_req_if.data, icache_mem_req_if.data}),
				.req_tag_in({dcache_mem_req_if.tag, icache_mem_req_tag}),
				.req_ready_in({dcache_mem_req_if.ready, icache_mem_req_if.ready}),
				.req_valid_out(VX_core.mem_req_if.valid),
				.req_rw_out(VX_core.mem_req_if.rw),
				.req_byteen_out(VX_core.mem_req_if.byteen),
				.req_addr_out(VX_core.mem_req_if.addr),
				.req_data_out(VX_core.mem_req_if.data),
				.req_tag_out(VX_core.mem_req_if.tag),
				.req_ready_out(VX_core.mem_req_if.ready),
				.rsp_valid_out({dcache_mem_rsp_if.valid, icache_mem_rsp_if.valid}),
				.rsp_data_out({dcache_mem_rsp_if.data, icache_mem_rsp_if.data}),
				.rsp_tag_out({dcache_mem_rsp_if.tag, icache_mem_rsp_tag}),
				.rsp_ready_out({dcache_mem_rsp_if.ready, icache_mem_rsp_if.ready}),
				.rsp_valid_in(VX_core.mem_rsp_if.valid),
				.rsp_tag_in(VX_core.mem_rsp_if.tag),
				.rsp_data_in(VX_core.mem_rsp_if.data),
				.rsp_ready_in(VX_core.mem_rsp_if.ready)
			);
		end
	endgenerate
	assign mem_unit.clk = clk;
	assign mem_unit.reset = reset;
endmodule
// removed module with interface ports: VX_csr_data
// removed module with interface ports: VX_scoreboard
// removed module with interface ports: VX_lsu_unit
// removed module with interface ports: VX_decode
// removed module with interface ports: VX_gpr_stage
module VX_cache_arb (
	clk,
	reset,
	req_valid_in,
	req_rw_in,
	req_byteen_in,
	req_addr_in,
	req_data_in,
	req_tag_in,
	req_ready_in,
	req_valid_out,
	req_rw_out,
	req_byteen_out,
	req_addr_out,
	req_data_out,
	req_tag_out,
	req_ready_out,
	rsp_valid_in,
	rsp_tmask_in,
	rsp_data_in,
	rsp_tag_in,
	rsp_ready_in,
	rsp_valid_out,
	rsp_tmask_out,
	rsp_data_out,
	rsp_tag_out,
	rsp_ready_out
);
	// Trace: ../../rtl/VX_cache_arb.sv:4:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/VX_cache_arb.sv:5:15
	parameter LANES = 1;
	// Trace: ../../rtl/VX_cache_arb.sv:6:15
	parameter DATA_SIZE = 1;
	// Trace: ../../rtl/VX_cache_arb.sv:7:15
	parameter TAG_IN_WIDTH = 1;
	// Trace: ../../rtl/VX_cache_arb.sv:8:15
	parameter TAG_SEL_IDX = 0;
	// Trace: ../../rtl/VX_cache_arb.sv:9:15
	parameter BUFFERED_REQ = 0;
	// Trace: ../../rtl/VX_cache_arb.sv:10:15
	parameter BUFFERED_RSP = 0;
	// Trace: ../../rtl/VX_cache_arb.sv:11:15
	parameter TYPE = "R";
	// Trace: ../../rtl/VX_cache_arb.sv:13:16
	localparam ADDR_WIDTH = 32 - $clog2(DATA_SIZE);
	// Trace: ../../rtl/VX_cache_arb.sv:14:16
	localparam DATA_WIDTH = 8 * DATA_SIZE;
	// Trace: ../../rtl/VX_cache_arb.sv:15:16
	localparam LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/VX_cache_arb.sv:16:16
	localparam TAG_OUT_WIDTH = TAG_IN_WIDTH + LOG_NUM_REQS;
	// Trace: ../../rtl/VX_cache_arb.sv:18:5
	input wire clk;
	// Trace: ../../rtl/VX_cache_arb.sv:19:5
	input wire reset;
	// Trace: ../../rtl/VX_cache_arb.sv:22:5
	input wire [(NUM_REQS * LANES) - 1:0] req_valid_in;
	// Trace: ../../rtl/VX_cache_arb.sv:23:5
	input wire [(NUM_REQS * LANES) - 1:0] req_rw_in;
	// Trace: ../../rtl/VX_cache_arb.sv:24:5
	input wire [((NUM_REQS * LANES) * DATA_SIZE) - 1:0] req_byteen_in;
	// Trace: ../../rtl/VX_cache_arb.sv:25:5
	input wire [((NUM_REQS * LANES) * ADDR_WIDTH) - 1:0] req_addr_in;
	// Trace: ../../rtl/VX_cache_arb.sv:26:5
	input wire [((NUM_REQS * LANES) * DATA_WIDTH) - 1:0] req_data_in;
	// Trace: ../../rtl/VX_cache_arb.sv:27:5
	input wire [((NUM_REQS * LANES) * TAG_IN_WIDTH) - 1:0] req_tag_in;
	// Trace: ../../rtl/VX_cache_arb.sv:28:5
	output wire [(NUM_REQS * LANES) - 1:0] req_ready_in;
	// Trace: ../../rtl/VX_cache_arb.sv:31:5
	output wire [LANES - 1:0] req_valid_out;
	// Trace: ../../rtl/VX_cache_arb.sv:32:5
	output wire [LANES - 1:0] req_rw_out;
	// Trace: ../../rtl/VX_cache_arb.sv:33:5
	output wire [(LANES * DATA_SIZE) - 1:0] req_byteen_out;
	// Trace: ../../rtl/VX_cache_arb.sv:34:5
	output wire [(LANES * ADDR_WIDTH) - 1:0] req_addr_out;
	// Trace: ../../rtl/VX_cache_arb.sv:35:5
	output wire [(LANES * DATA_WIDTH) - 1:0] req_data_out;
	// Trace: ../../rtl/VX_cache_arb.sv:36:5
	output wire [(LANES * TAG_OUT_WIDTH) - 1:0] req_tag_out;
	// Trace: ../../rtl/VX_cache_arb.sv:37:5
	input wire [LANES - 1:0] req_ready_out;
	// Trace: ../../rtl/VX_cache_arb.sv:40:5
	input wire rsp_valid_in;
	// Trace: ../../rtl/VX_cache_arb.sv:41:5
	input wire [LANES - 1:0] rsp_tmask_in;
	// Trace: ../../rtl/VX_cache_arb.sv:42:5
	input wire [(LANES * DATA_WIDTH) - 1:0] rsp_data_in;
	// Trace: ../../rtl/VX_cache_arb.sv:43:5
	input wire [TAG_OUT_WIDTH - 1:0] rsp_tag_in;
	// Trace: ../../rtl/VX_cache_arb.sv:44:5
	output wire rsp_ready_in;
	// Trace: ../../rtl/VX_cache_arb.sv:47:5
	output wire [NUM_REQS - 1:0] rsp_valid_out;
	// Trace: ../../rtl/VX_cache_arb.sv:48:5
	output wire [(NUM_REQS * LANES) - 1:0] rsp_tmask_out;
	// Trace: ../../rtl/VX_cache_arb.sv:49:5
	output wire [((NUM_REQS * LANES) * DATA_WIDTH) - 1:0] rsp_data_out;
	// Trace: ../../rtl/VX_cache_arb.sv:50:5
	output wire [(NUM_REQS * TAG_IN_WIDTH) - 1:0] rsp_tag_out;
	// Trace: ../../rtl/VX_cache_arb.sv:51:5
	input wire [NUM_REQS - 1:0] rsp_ready_out;
	// Trace: ../../rtl/VX_cache_arb.sv:53:5
	localparam REQ_DATAW = (((TAG_OUT_WIDTH + ADDR_WIDTH) + 1) + DATA_SIZE) + DATA_WIDTH;
	// Trace: ../../rtl/VX_cache_arb.sv:54:5
	localparam RSP_DATAW = (LANES * (1 + DATA_WIDTH)) + TAG_IN_WIDTH;
	// Trace: ../../rtl/VX_cache_arb.sv:56:5
	function automatic signed [LOG_NUM_REQS - 1:0] sv2v_cast_76B5F_signed;
		input reg signed [LOG_NUM_REQS - 1:0] inp;
		sv2v_cast_76B5F_signed = inp;
	endfunction
	generate
		if (NUM_REQS > 1) begin : genblk1
			// Trace: ../../rtl/VX_cache_arb.sv:58:9
			wire [((NUM_REQS * LANES) * REQ_DATAW) - 1:0] req_data_in_merged;
			// Trace: ../../rtl/VX_cache_arb.sv:59:9
			wire [(LANES * REQ_DATAW) - 1:0] req_data_out_merged;
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
				genvar j;
				for (j = 0; j < LANES; j = j + 1) begin : genblk1
					// Trace: ../../rtl/VX_cache_arb.sv:63:17
					wire [TAG_OUT_WIDTH - 1:0] req_tag_in_w;
					// Trace: ../../rtl/VX_cache_arb.sv:65:17
					VX_bits_insert #(
						.N(TAG_IN_WIDTH),
						.S(LOG_NUM_REQS),
						.POS(TAG_SEL_IDX)
					) bits_insert(
						.data_in(req_tag_in[((i * LANES) + j) * TAG_IN_WIDTH+:TAG_IN_WIDTH]),
						.sel_in(sv2v_cast_76B5F_signed(i)),
						.data_out(req_tag_in_w)
					);
					// Trace: ../../rtl/VX_cache_arb.sv:75:17
					assign req_data_in_merged[((i * LANES) + j) * REQ_DATAW+:REQ_DATAW] = {req_tag_in_w, req_addr_in[((i * LANES) + j) * ADDR_WIDTH+:ADDR_WIDTH], req_rw_in[(i * LANES) + j], req_byteen_in[((i * LANES) + j) * DATA_SIZE+:DATA_SIZE], req_data_in[((i * LANES) + j) * DATA_WIDTH+:DATA_WIDTH]};
				end
			end
			// Trace: ../../rtl/VX_cache_arb.sv:79:9
			VX_stream_arbiter #(
				.NUM_REQS(NUM_REQS),
				.LANES(LANES),
				.DATAW(REQ_DATAW),
				.BUFFERED(BUFFERED_REQ),
				.TYPE(TYPE)
			) req_arb(
				.clk(clk),
				.reset(reset),
				.valid_in(req_valid_in),
				.data_in(req_data_in_merged),
				.ready_in(req_ready_in),
				.valid_out(req_valid_out),
				.data_out(req_data_out_merged),
				.ready_out(req_ready_out)
			);
			for (i = 0; i < LANES; i = i + 1) begin : genblk2
				// Trace: ../../rtl/VX_cache_arb.sv:97:13
				assign {req_tag_out[i * TAG_OUT_WIDTH+:TAG_OUT_WIDTH], req_addr_out[i * ADDR_WIDTH+:ADDR_WIDTH], req_rw_out[i], req_byteen_out[i * DATA_SIZE+:DATA_SIZE], req_data_out[i * DATA_WIDTH+:DATA_WIDTH]} = req_data_out_merged[i * REQ_DATAW+:REQ_DATAW];
			end
			// Trace: ../../rtl/VX_cache_arb.sv:102:9
			wire [(NUM_REQS * RSP_DATAW) - 1:0] rsp_data_out_merged;
			// Trace: ../../rtl/VX_cache_arb.sv:104:9
			wire [LOG_NUM_REQS - 1:0] rsp_sel = rsp_tag_in[TAG_SEL_IDX+:LOG_NUM_REQS];
			// Trace: ../../rtl/VX_cache_arb.sv:106:9
			wire [TAG_IN_WIDTH - 1:0] rsp_tag_in_w;
			// Trace: ../../rtl/VX_cache_arb.sv:108:9
			VX_bits_remove #(
				.N(TAG_OUT_WIDTH),
				.S(LOG_NUM_REQS),
				.POS(TAG_SEL_IDX)
			) bits_remove(
				.data_in(rsp_tag_in),
				.data_out(rsp_tag_in_w)
			);
			// Trace: ../../rtl/VX_cache_arb.sv:117:9
			VX_stream_demux #(
				.NUM_REQS(NUM_REQS),
				.LANES(1),
				.DATAW(RSP_DATAW),
				.BUFFERED(BUFFERED_RSP)
			) rsp_demux(
				.clk(clk),
				.reset(reset),
				.sel_in(rsp_sel),
				.valid_in(rsp_valid_in),
				.data_in({rsp_tmask_in, rsp_tag_in_w, rsp_data_in}),
				.ready_in(rsp_ready_in),
				.valid_out(rsp_valid_out),
				.data_out(rsp_data_out_merged),
				.ready_out(rsp_ready_out)
			);
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk3
				// Trace: ../../rtl/VX_cache_arb.sv:135:13
				assign {rsp_tmask_out[i * LANES+:LANES], rsp_tag_out[i * TAG_IN_WIDTH+:TAG_IN_WIDTH], rsp_data_out[DATA_WIDTH * (i * LANES)+:DATA_WIDTH * LANES]} = rsp_data_out_merged[i * RSP_DATAW+:RSP_DATAW];
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/VX_cache_arb.sv:143:9
			assign req_valid_out = req_valid_in;
			// Trace: ../../rtl/VX_cache_arb.sv:144:9
			assign req_tag_out = req_tag_in;
			// Trace: ../../rtl/VX_cache_arb.sv:145:9
			assign req_addr_out = req_addr_in;
			// Trace: ../../rtl/VX_cache_arb.sv:146:9
			assign req_rw_out = req_rw_in;
			// Trace: ../../rtl/VX_cache_arb.sv:147:9
			assign req_byteen_out = req_byteen_in;
			// Trace: ../../rtl/VX_cache_arb.sv:148:9
			assign req_data_out = req_data_in;
			// Trace: ../../rtl/VX_cache_arb.sv:149:9
			assign req_ready_in = req_ready_out;
			// Trace: ../../rtl/VX_cache_arb.sv:151:9
			assign rsp_valid_out = rsp_valid_in;
			// Trace: ../../rtl/VX_cache_arb.sv:152:9
			assign rsp_tmask_out = rsp_tmask_in;
			// Trace: ../../rtl/VX_cache_arb.sv:153:9
			assign rsp_tag_out = rsp_tag_in;
			// Trace: ../../rtl/VX_cache_arb.sv:154:9
			assign rsp_data_out = rsp_data_in;
			// Trace: ../../rtl/VX_cache_arb.sv:155:9
			assign rsp_ready_in = rsp_ready_out;
		end
	endgenerate
endmodule
// removed module with interface ports: VX_execute
// removed module with interface ports: VX_warp_sched
// removed module with interface ports: VX_csr_unit
module VX_cluster (
	clk,
	reset,
	mem_req_valid,
	mem_req_rw,
	mem_req_byteen,
	mem_req_addr,
	mem_req_data,
	mem_req_tag,
	mem_req_ready,
	mem_rsp_valid,
	mem_rsp_data,
	mem_rsp_tag,
	mem_rsp_ready,
	busy
);
	// Trace: ../../rtl/VX_cluster.sv:4:15
	parameter CLUSTER_ID = 0;
	// Trace: ../../rtl/VX_cluster.sv:9:5
	input wire clk;
	// Trace: ../../rtl/VX_cluster.sv:10:5
	input wire reset;
	// Trace: ../../rtl/VX_cluster.sv:13:5
	output wire mem_req_valid;
	// Trace: ../../rtl/VX_cluster.sv:14:5
	output wire mem_req_rw;
	// Trace: ../../rtl/VX_cluster.sv:15:5
	output wire [(0 || 0 ? 16 : 64) - 1:0] mem_req_byteen;
	// Trace: ../../rtl/VX_cluster.sv:16:5
	output wire [(32 - $clog2((0 || 0 ? 16 : 64))) - 1:0] mem_req_addr;
	// Trace: ../../rtl/VX_cluster.sv:17:5
	output wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_req_data;
	// Trace: ../../rtl/VX_cluster.sv:18:5
	output wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_req_tag;
	// Trace: ../../rtl/VX_cluster.sv:19:5
	input wire mem_req_ready;
	// Trace: ../../rtl/VX_cluster.sv:22:5
	input wire mem_rsp_valid;
	// Trace: ../../rtl/VX_cluster.sv:23:5
	input wire [((0 || 0 ? 16 : 64) * 8) - 1:0] mem_rsp_data;
	// Trace: ../../rtl/VX_cluster.sv:24:5
	input wire [(1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0:0] mem_rsp_tag;
	// Trace: ../../rtl/VX_cluster.sv:25:5
	output wire mem_rsp_ready;
	// Trace: ../../rtl/VX_cluster.sv:28:5
	output wire busy;
	// Trace: ../../rtl/VX_cluster.sv:32:5
	wire [0:0] per_core_mem_req_valid;
	// Trace: ../../rtl/VX_cluster.sv:33:5
	wire [0:0] per_core_mem_req_rw;
	// Trace: ../../rtl/VX_cluster.sv:34:5
	wire [(0 || 0 ? 16 : 64) - 1:0] per_core_mem_req_byteen;
	// Trace: ../../rtl/VX_cluster.sv:35:5
	wire [(32 - $clog2((0 || 0 ? 16 : 64))) - 1:0] per_core_mem_req_addr;
	// Trace: ../../rtl/VX_cluster.sv:36:5
	wire [((0 || 0 ? 16 : 64) * 8) - 1:0] per_core_mem_req_data;
	// Trace: ../../rtl/VX_cluster.sv:37:5
	wire [(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0 : (1 - ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0)) + ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) - 1)):(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? 0 : (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0)] per_core_mem_req_tag;
	// Trace: ../../rtl/VX_cluster.sv:38:5
	wire [0:0] per_core_mem_req_ready;
	// Trace: ../../rtl/VX_cluster.sv:40:5
	wire [0:0] per_core_mem_rsp_valid;
	// Trace: ../../rtl/VX_cluster.sv:41:5
	wire [((0 || 0 ? 16 : 64) * 8) - 1:0] per_core_mem_rsp_data;
	// Trace: ../../rtl/VX_cluster.sv:42:5
	wire [(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0 : (1 - ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0)) + ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) - 1)):(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? 0 : (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0)] per_core_mem_rsp_tag;
	// Trace: ../../rtl/VX_cluster.sv:43:5
	wire [0:0] per_core_mem_rsp_ready;
	// Trace: ../../rtl/VX_cluster.sv:45:5
	wire [0:0] per_core_busy;
	// Trace: ../../rtl/VX_cluster.sv:47:5
	genvar i;
	generate
		for (i = 0; i < 1; i = i + 1) begin : genblk1
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_cluster.sv:49:27
			wire core_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_cluster.sv:49:60
			VX_reset_relay __core_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(core_reset)
			);
			// Trace: ../../rtl/VX_cluster.sv:51:9
			VX_core #(.CORE_ID(i + (CLUSTER_ID * 1))) core(
				.clk(clk),
				.reset(core_reset),
				.mem_req_valid(per_core_mem_req_valid[i]),
				.mem_req_rw(per_core_mem_req_rw[i]),
				.mem_req_byteen(per_core_mem_req_byteen[i * (0 || 0 ? 16 : 64)+:(0 || 0 ? 16 : 64)]),
				.mem_req_addr(per_core_mem_req_addr[i * (32 - $clog2((0 || 0 ? 16 : 64)))+:32 - $clog2((0 || 0 ? 16 : 64))]),
				.mem_req_data(per_core_mem_req_data[i * ((0 || 0 ? 16 : 64) * 8)+:(0 || 0 ? 16 : 64) * 8]),
				.mem_req_tag(per_core_mem_req_tag[(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? 0 : (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) + (i * (((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1 : 1 - ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0)))+:(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1 : 1 - ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0))]),
				.mem_req_ready(per_core_mem_req_ready[i]),
				.mem_rsp_valid(per_core_mem_rsp_valid[i]),
				.mem_rsp_data(per_core_mem_rsp_data[i * ((0 || 0 ? 16 : 64) * 8)+:(0 || 0 ? 16 : 64) * 8]),
				.mem_rsp_tag(per_core_mem_rsp_tag[(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? 0 : (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) + (i * (((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1 : 1 - ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0)))+:(((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0) >= 0 ? (1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1 : 1 - ((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 0))]),
				.mem_rsp_ready(per_core_mem_rsp_ready[i]),
				.busy(per_core_busy[i])
			);
		end
	endgenerate
	// Trace: ../../rtl/VX_cluster.sv:76:5
	assign busy = |per_core_busy;
	// Trace: ../../rtl/VX_cluster.sv:78:5
	generate
		if (1) begin : genblk2
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_cluster.sv:147:30
			wire mem_arb_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_cluster.sv:147:63
			VX_reset_relay __mem_arb_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(mem_arb_reset)
			);
			// Trace: ../../rtl/VX_cluster.sv:149:9
			VX_mem_arb #(
				.NUM_REQS(1),
				.DATA_WIDTH((0 || 0 ? 16 : 64) * 8),
				.ADDR_WIDTH(32 - $clog2((0 || 0 ? 16 : 64))),
				.TAG_IN_WIDTH((1 > (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 1 : (4 > ((1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48) ? 4 : (1 + $clog2((0 || 0 ? 16 : 64) / 4)) + 48)) + 1),
				.TYPE("R"),
				.TAG_SEL_IDX(1),
				.BUFFERED_REQ(1),
				.BUFFERED_RSP(1)
			) mem_arb(
				.clk(clk),
				.reset(mem_arb_reset),
				.req_valid_in(per_core_mem_req_valid),
				.req_rw_in(per_core_mem_req_rw),
				.req_byteen_in(per_core_mem_req_byteen),
				.req_addr_in(per_core_mem_req_addr),
				.req_data_in(per_core_mem_req_data),
				.req_tag_in(per_core_mem_req_tag),
				.req_ready_in(per_core_mem_req_ready),
				.req_valid_out(mem_req_valid),
				.req_rw_out(mem_req_rw),
				.req_byteen_out(mem_req_byteen),
				.req_addr_out(mem_req_addr),
				.req_data_out(mem_req_data),
				.req_tag_out(mem_req_tag),
				.req_ready_out(mem_req_ready),
				.rsp_valid_out(per_core_mem_rsp_valid),
				.rsp_data_out(per_core_mem_rsp_data),
				.rsp_tag_out(per_core_mem_rsp_tag),
				.rsp_ready_out(per_core_mem_rsp_ready),
				.rsp_valid_in(mem_rsp_valid),
				.rsp_tag_in(mem_rsp_tag),
				.rsp_data_in(mem_rsp_data),
				.rsp_ready_in(mem_rsp_ready)
			);
		end
	endgenerate
endmodule
// removed package "ahb_pkg"
// removed module with interface ports: VX_fpu_unit
// removed module with interface ports: VX_dispatch
module VX_pipeline (
	clk,
	reset,
	dcache_req_valid,
	dcache_req_rw,
	dcache_req_byteen,
	dcache_req_addr,
	dcache_req_data,
	dcache_req_tag,
	dcache_req_ready,
	dcache_rsp_valid,
	dcache_rsp_tmask,
	dcache_rsp_data,
	dcache_rsp_tag,
	dcache_rsp_ready,
	icache_req_valid,
	icache_req_addr,
	icache_req_tag,
	icache_req_ready,
	icache_rsp_valid,
	icache_rsp_data,
	icache_rsp_tag,
	icache_rsp_ready,
	busy
);
	// Trace: ../../rtl/VX_pipeline.sv:4:15
	parameter CORE_ID = 0;
	// Trace: ../../rtl/VX_pipeline.sv:9:5
	input wire clk;
	// Trace: ../../rtl/VX_pipeline.sv:10:5
	input wire reset;
	// Trace: ../../rtl/VX_pipeline.sv:13:5
	output wire [1:0] dcache_req_valid;
	// Trace: ../../rtl/VX_pipeline.sv:14:5
	output wire [1:0] dcache_req_rw;
	// Trace: ../../rtl/VX_pipeline.sv:15:5
	output wire [7:0] dcache_req_byteen;
	// Trace: ../../rtl/VX_pipeline.sv:16:5
	output wire [59:0] dcache_req_addr;
	// Trace: ../../rtl/VX_pipeline.sv:17:5
	output wire [63:0] dcache_req_data;
	// Trace: ../../rtl/VX_pipeline.sv:18:5
	output wire [95:0] dcache_req_tag;
	// Trace: ../../rtl/VX_pipeline.sv:19:5
	input wire [1:0] dcache_req_ready;
	// Trace: ../../rtl/VX_pipeline.sv:22:5
	input wire dcache_rsp_valid;
	// Trace: ../../rtl/VX_pipeline.sv:23:5
	input wire [1:0] dcache_rsp_tmask;
	// Trace: ../../rtl/VX_pipeline.sv:24:5
	input wire [63:0] dcache_rsp_data;
	// Trace: ../../rtl/VX_pipeline.sv:25:5
	input wire [47:0] dcache_rsp_tag;
	// Trace: ../../rtl/VX_pipeline.sv:26:5
	output wire dcache_rsp_ready;
	// Trace: ../../rtl/VX_pipeline.sv:29:5
	output wire icache_req_valid;
	// Trace: ../../rtl/VX_pipeline.sv:30:5
	output wire [29:0] icache_req_addr;
	// Trace: ../../rtl/VX_pipeline.sv:31:5
	output wire [44:0] icache_req_tag;
	// Trace: ../../rtl/VX_pipeline.sv:32:5
	input wire icache_req_ready;
	// Trace: ../../rtl/VX_pipeline.sv:35:5
	input wire icache_rsp_valid;
	// Trace: ../../rtl/VX_pipeline.sv:36:5
	input wire [31:0] icache_rsp_data;
	// Trace: ../../rtl/VX_pipeline.sv:37:5
	input wire [44:0] icache_rsp_tag;
	// Trace: ../../rtl/VX_pipeline.sv:38:5
	output wire icache_rsp_ready;
	// Trace: ../../rtl/VX_pipeline.sv:45:5
	output wire busy;
	// Trace: ../../rtl/VX_pipeline.sv:51:5
	// expanded interface instance: dcache_req_if
	localparam _param_BD702_NUM_REQS = 2;
	localparam _param_BD702_WORD_SIZE = 4;
	localparam _param_BD702_TAG_WIDTH = 48;
	generate
		if (1) begin : dcache_req_if
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:7:15
			localparam NUM_REQS = _param_BD702_NUM_REQS;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:8:15
			localparam WORD_SIZE = _param_BD702_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:9:15
			localparam TAG_WIDTH = _param_BD702_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:12:5
			wire [1:0] valid;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:13:5
			wire [1:0] rw;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:14:5
			wire [7:0] byteen;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:15:5
			wire [59:0] addr;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:16:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:17:5
			wire [95:0] tag;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:18:5
			wire [1:0] ready;
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:20:5
			// Trace: ../../rtl/interfaces/VX_dcache_req_if.sv:30:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:57:5
	assign dcache_req_valid = dcache_req_if.valid;
	// Trace: ../../rtl/VX_pipeline.sv:58:5
	assign dcache_req_rw = dcache_req_if.rw;
	// Trace: ../../rtl/VX_pipeline.sv:59:5
	assign dcache_req_byteen = dcache_req_if.byteen;
	// Trace: ../../rtl/VX_pipeline.sv:60:5
	assign dcache_req_addr = dcache_req_if.addr;
	// Trace: ../../rtl/VX_pipeline.sv:61:5
	assign dcache_req_data = dcache_req_if.data;
	// Trace: ../../rtl/VX_pipeline.sv:62:5
	assign dcache_req_tag = dcache_req_if.tag;
	// Trace: ../../rtl/VX_pipeline.sv:63:5
	assign dcache_req_if.ready = dcache_req_ready;
	// Trace: ../../rtl/VX_pipeline.sv:69:5
	// expanded interface instance: dcache_rsp_if
	localparam _param_2395E_NUM_REQS = 2;
	localparam _param_2395E_WORD_SIZE = 4;
	localparam _param_2395E_TAG_WIDTH = 48;
	generate
		if (1) begin : dcache_rsp_if
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:7:15
			localparam NUM_REQS = _param_2395E_NUM_REQS;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:8:15
			localparam WORD_SIZE = _param_2395E_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:9:15
			localparam TAG_WIDTH = _param_2395E_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:12:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:13:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:14:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:15:5
			wire [47:0] tag;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:16:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:18:5
			// Trace: ../../rtl/interfaces/VX_dcache_rsp_if.sv:26:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:75:5
	assign dcache_rsp_if.valid = dcache_rsp_valid;
	// Trace: ../../rtl/VX_pipeline.sv:76:5
	assign dcache_rsp_if.tmask = dcache_rsp_tmask;
	// Trace: ../../rtl/VX_pipeline.sv:77:5
	assign dcache_rsp_if.data = dcache_rsp_data;
	// Trace: ../../rtl/VX_pipeline.sv:78:5
	assign dcache_rsp_if.tag = dcache_rsp_tag;
	// Trace: ../../rtl/VX_pipeline.sv:79:5
	assign dcache_rsp_ready = dcache_rsp_if.ready;
	// Trace: ../../rtl/VX_pipeline.sv:85:5
	// expanded interface instance: icache_req_if
	localparam _param_1F99A_WORD_SIZE = 4;
	localparam _param_1F99A_TAG_WIDTH = 45;
	generate
		if (1) begin : icache_req_if
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:7:15
			localparam WORD_SIZE = _param_1F99A_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:8:15
			localparam TAG_WIDTH = _param_1F99A_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:11:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:12:5
			wire [29:0] addr;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:13:5
			wire [44:0] tag;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:14:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:16:5
			// Trace: ../../rtl/interfaces/VX_icache_req_if.sv:23:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:90:5
	assign icache_req_valid = icache_req_if.valid;
	// Trace: ../../rtl/VX_pipeline.sv:91:5
	assign icache_req_addr = icache_req_if.addr;
	// Trace: ../../rtl/VX_pipeline.sv:92:5
	assign icache_req_tag = icache_req_if.tag;
	// Trace: ../../rtl/VX_pipeline.sv:93:5
	assign icache_req_if.ready = icache_req_ready;
	// Trace: ../../rtl/VX_pipeline.sv:99:5
	// expanded interface instance: icache_rsp_if
	localparam _param_396BA_WORD_SIZE = 4;
	localparam _param_396BA_TAG_WIDTH = 45;
	generate
		if (1) begin : icache_rsp_if
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:7:15
			localparam WORD_SIZE = _param_396BA_WORD_SIZE;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:8:15
			localparam TAG_WIDTH = _param_396BA_TAG_WIDTH;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:11:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:12:5
			wire [31:0] data;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:13:5
			wire [44:0] tag;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:14:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:16:5
			// Trace: ../../rtl/interfaces/VX_icache_rsp_if.sv:23:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:104:5
	assign icache_rsp_if.valid = icache_rsp_valid;
	// Trace: ../../rtl/VX_pipeline.sv:105:5
	assign icache_rsp_if.data = icache_rsp_data;
	// Trace: ../../rtl/VX_pipeline.sv:106:5
	assign icache_rsp_if.tag = icache_rsp_tag;
	// Trace: ../../rtl/VX_pipeline.sv:107:5
	assign icache_rsp_ready = icache_rsp_if.ready;
	// Trace: ../../rtl/VX_pipeline.sv:111:5
	// expanded interface instance: fetch_to_csr_if
	generate
		if (1) begin : fetch_to_csr_if
			// Trace: ../../rtl/interfaces/VX_fetch_to_csr_if.sv:8:5
			wire [3:0] thread_masks;
			// Trace: ../../rtl/interfaces/VX_fetch_to_csr_if.sv:10:5
			// Trace: ../../rtl/interfaces/VX_fetch_to_csr_if.sv:14:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:112:5
	// expanded interface instance: cmt_to_csr_if
	generate
		if (1) begin : cmt_to_csr_if
			// Trace: ../../rtl/interfaces/VX_cmt_to_csr_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_cmt_to_csr_if.sv:12:5
			wire [3:0] commit_size;
			// Trace: ../../rtl/interfaces/VX_cmt_to_csr_if.sv:14:5
			// Trace: ../../rtl/interfaces/VX_cmt_to_csr_if.sv:19:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:113:5
	// expanded interface instance: decode_if
	generate
		if (1) begin : decode_if
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:13:5
			wire [2:0] ex_type;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:14:5
			wire [3:0] op_type;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:15:5
			wire [2:0] op_mod;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:16:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:17:5
			wire use_PC;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:18:5
			wire use_imm;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:19:5
			wire [31:0] imm;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:20:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:21:5
			wire [4:0] rs1;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:22:5
			wire [4:0] rs2;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:23:5
			wire [4:0] rs3;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:24:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:26:5
			// Trace: ../../rtl/interfaces/VX_decode_if.sv:46:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:114:5
	// expanded interface instance: branch_ctl_if
	generate
		if (1) begin : branch_ctl_if
			// Trace: ../../rtl/interfaces/VX_branch_ctl_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_branch_ctl_if.sv:9:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_branch_ctl_if.sv:10:5
			wire taken;
			// Trace: ../../rtl/interfaces/VX_branch_ctl_if.sv:11:5
			wire [31:0] dest;
			// Trace: ../../rtl/interfaces/VX_branch_ctl_if.sv:13:5
			// Trace: ../../rtl/interfaces/VX_branch_ctl_if.sv:20:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:115:5
	// expanded interface instance: warp_ctl_if
	generate
		if (1) begin : warp_ctl_if
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:9:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:10:5
			// removed localparam type gpu_types_gpu_tmc_t
			wire [2:0] tmc;
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:11:5
			// removed localparam type gpu_types_gpu_wspawn_t
			wire [34:0] wspawn;
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:12:5
			// removed localparam type gpu_types_gpu_barrier_t
			wire [3:0] barrier;
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:13:5
			// removed localparam type gpu_types_gpu_split_t
			wire [37:0] split;
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:15:5
			// Trace: ../../rtl/interfaces/VX_warp_ctl_if.sv:24:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:116:5
	// expanded interface instance: ifetch_rsp_if
	generate
		if (1) begin : ifetch_rsp_if
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:10:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:11:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:13:5
			wire [31:0] data;
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:14:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:16:5
			// Trace: ../../rtl/interfaces/VX_ifetch_rsp_if.sv:26:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:117:5
	// expanded interface instance: alu_req_if
	generate
		if (1) begin : alu_req_if
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:13:5
			wire [31:0] next_PC;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:14:5
			wire [3:0] op_type;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:15:5
			wire [2:0] op_mod;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:16:5
			wire use_PC;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:17:5
			wire use_imm;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:18:5
			wire [31:0] imm;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:19:5
			wire [0:0] tid;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:20:5
			wire [63:0] rs1_data;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:21:5
			wire [63:0] rs2_data;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:22:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:23:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:24:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:26:5
			// Trace: ../../rtl/interfaces/VX_alu_req_if.sv:46:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:118:5
	// expanded interface instance: lsu_req_if
	generate
		if (1) begin : lsu_req_if
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:13:5
			wire [3:0] op_type;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:14:5
			wire is_fence;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:15:5
			wire [63:0] store_data;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:16:5
			wire [63:0] base_addr;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:17:5
			wire [31:0] offset;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:18:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:19:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:20:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:21:5
			wire is_prefetch;
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:23:5
			// Trace: ../../rtl/interfaces/VX_lsu_req_if.sv:40:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:119:5
	// expanded interface instance: csr_req_if
	generate
		if (1) begin : csr_req_if
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:13:5
			wire [1:0] op_type;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:14:5
			wire [11:0] addr;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:15:5
			wire [31:0] rs1_data;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:16:5
			wire use_imm;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:17:5
			wire [4:0] imm;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:18:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:19:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:20:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:22:5
			// Trace: ../../rtl/interfaces/VX_csr_req_if.sv:38:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:123:5
	// expanded interface instance: gpu_req_if
	generate
		if (1) begin : gpu_req_if
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:13:5
			wire [31:0] next_PC;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:14:5
			wire [3:0] op_type;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:15:5
			wire [2:0] op_mod;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:16:5
			wire [0:0] tid;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:17:5
			wire [63:0] rs1_data;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:18:5
			wire [63:0] rs2_data;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:19:5
			wire [63:0] rs3_data;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:20:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:21:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:22:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:24:5
			// Trace: ../../rtl/interfaces/VX_gpu_req_if.sv:42:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:124:5
	// expanded interface instance: writeback_if
	generate
		if (1) begin : writeback_if
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:10:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:11:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:13:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:14:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:15:5
			wire eop;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:16:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:18:5
			// Trace: ../../rtl/interfaces/VX_writeback_if.sv:30:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:125:5
	// expanded interface instance: wstall_if
	generate
		if (1) begin : wstall_if
			// Trace: ../../rtl/interfaces/VX_wstall_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_wstall_if.sv:9:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_wstall_if.sv:10:5
			wire stalled;
			// Trace: ../../rtl/interfaces/VX_wstall_if.sv:12:5
			// Trace: ../../rtl/interfaces/VX_wstall_if.sv:18:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:126:5
	// expanded interface instance: join_if
	generate
		if (1) begin : join_if
			// Trace: ../../rtl/interfaces/VX_join_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_join_if.sv:9:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_join_if.sv:11:5
			// Trace: ../../rtl/interfaces/VX_join_if.sv:16:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:127:5
	// expanded interface instance: alu_commit_if
	generate
		if (1) begin : alu_commit_if
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:13:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:14:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:15:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:16:5
			wire eop;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:17:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:19:5
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:32:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:128:5
	// expanded interface instance: ld_commit_if
	generate
		if (1) begin : ld_commit_if
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:13:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:14:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:15:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:16:5
			wire eop;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:17:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:19:5
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:32:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:129:5
	// expanded interface instance: st_commit_if
	generate
		if (1) begin : st_commit_if
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:13:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:14:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:15:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:16:5
			wire eop;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:17:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:19:5
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:32:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:130:5
	// expanded interface instance: csr_commit_if
	generate
		if (1) begin : csr_commit_if
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:13:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:14:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:15:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:16:5
			wire eop;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:17:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:19:5
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:32:5
		end
	endgenerate
	// Trace: ../../rtl/VX_pipeline.sv:134:5
	// expanded interface instance: gpu_commit_if
	generate
		if (1) begin : gpu_commit_if
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:8:5
			wire valid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:9:5
			wire [43:0] uuid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:10:5
			wire [0:0] wid;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:11:5
			wire [1:0] tmask;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:12:5
			wire [31:0] PC;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:13:5
			wire [63:0] data;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:14:5
			wire [4:0] rd;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:15:5
			wire wb;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:16:5
			wire eop;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:17:5
			wire ready;
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:19:5
			// Trace: ../../rtl/interfaces/VX_commit_if.sv:32:5
		end
	endgenerate
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:140:24
	wire fetch_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:140:57
	VX_reset_relay __fetch_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(fetch_reset)
	);
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:141:25
	wire decode_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:141:58
	VX_reset_relay __decode_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(decode_reset)
	);
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:142:24
	wire issue_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:142:57
	VX_reset_relay __issue_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(issue_reset)
	);
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:143:26
	wire execute_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:143:59
	VX_reset_relay __execute_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(execute_reset)
	);
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:144:25
	wire commit_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_pipeline.sv:144:58
	VX_reset_relay __commit_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(commit_reset)
	);
	// Trace: ../../rtl/VX_pipeline.sv:146:5
	// expanded module instance: fetch
	localparam _param_852F6_CORE_ID = CORE_ID;
	function automatic signed [43:0] sv2v_cast_44_signed;
		input reg signed [43:0] inp;
		sv2v_cast_44_signed = inp;
	endfunction
	generate
		if (1) begin : fetch
			// Trace: ../../rtl/VX_fetch.sv:4:15
			localparam CORE_ID = _param_852F6_CORE_ID;
			// Trace: ../../rtl/VX_fetch.sv:8:5
			wire clk;
			// Trace: ../../rtl/VX_fetch.sv:9:5
			wire reset;
			// Trace: ../../rtl/VX_fetch.sv:12:5
			// removed modport instance icache_req_if
			// Trace: ../../rtl/VX_fetch.sv:13:5
			// removed modport instance icache_rsp_if
			// Trace: ../../rtl/VX_fetch.sv:16:5
			// removed modport instance wstall_if
			// Trace: ../../rtl/VX_fetch.sv:17:5
			// removed modport instance join_if
			// Trace: ../../rtl/VX_fetch.sv:18:5
			// removed modport instance branch_ctl_if
			// Trace: ../../rtl/VX_fetch.sv:19:5
			// removed modport instance warp_ctl_if
			// Trace: ../../rtl/VX_fetch.sv:22:5
			// removed modport instance ifetch_rsp_if
			// Trace: ../../rtl/VX_fetch.sv:25:5
			// removed modport instance fetch_to_csr_if
			// Trace: ../../rtl/VX_fetch.sv:28:5
			wire busy;
			// Trace: ../../rtl/VX_fetch.sv:31:5
			// expanded interface instance: ifetch_req_if
			if (1) begin : ifetch_req_if
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:8:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:9:5
				wire [43:0] uuid;
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:10:5
				wire [1:0] tmask;
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:11:5
				wire [0:0] wid;
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:12:5
				wire [31:0] PC;
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:13:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:15:5
				// Trace: ../../rtl/interfaces/VX_ifetch_req_if.sv:24:5
			end
			// Trace: ../../rtl/VX_fetch.sv:33:5
			// expanded module instance: warp_sched
			localparam _param_4F3BC_CORE_ID = CORE_ID;
			if (1) begin : warp_sched
				// Trace: ../../rtl/VX_warp_sched.sv:4:15
				localparam CORE_ID = _param_4F3BC_CORE_ID;
				// Trace: ../../rtl/VX_warp_sched.sv:8:5
				wire clk;
				// Trace: ../../rtl/VX_warp_sched.sv:9:5
				wire reset;
				// Trace: ../../rtl/VX_warp_sched.sv:11:5
				// removed modport instance warp_ctl_if
				// Trace: ../../rtl/VX_warp_sched.sv:12:5
				// removed modport instance wstall_if
				// Trace: ../../rtl/VX_warp_sched.sv:13:5
				// removed modport instance join_if
				// Trace: ../../rtl/VX_warp_sched.sv:14:5
				// removed modport instance branch_ctl_if
				// Trace: ../../rtl/VX_warp_sched.sv:16:5
				// removed modport instance ifetch_req_if
				// Trace: ../../rtl/VX_warp_sched.sv:18:5
				// removed modport instance fetch_to_csr_if
				// Trace: ../../rtl/VX_warp_sched.sv:20:5
				wire busy;
				// Trace: ../../rtl/VX_warp_sched.sv:25:5
				wire join_else;
				// Trace: ../../rtl/VX_warp_sched.sv:26:5
				wire [31:0] join_pc;
				// Trace: ../../rtl/VX_warp_sched.sv:27:5
				wire [1:0] join_tmask;
				// Trace: ../../rtl/VX_warp_sched.sv:29:5
				reg [1:0] active_warps;
				reg [1:0] active_warps_n;
				// Trace: ../../rtl/VX_warp_sched.sv:30:5
				reg [1:0] stalled_warps;
				// Trace: ../../rtl/VX_warp_sched.sv:32:5
				reg [3:0] thread_masks;
				// Trace: ../../rtl/VX_warp_sched.sv:33:5
				reg [63:0] warp_pcs;
				// Trace: ../../rtl/VX_warp_sched.sv:36:5
				reg [7:0] barrier_masks;
				// Trace: ../../rtl/VX_warp_sched.sv:37:5
				wire reached_barrier_limit;
				// Trace: ../../rtl/VX_warp_sched.sv:40:5
				reg [31:0] wspawn_pc;
				// Trace: ../../rtl/VX_warp_sched.sv:41:5
				reg [1:0] use_wspawn;
				// Trace: ../../rtl/VX_warp_sched.sv:43:5
				wire [0:0] schedule_wid;
				// Trace: ../../rtl/VX_warp_sched.sv:44:5
				wire [1:0] schedule_tmask;
				// Trace: ../../rtl/VX_warp_sched.sv:45:5
				wire [31:0] schedule_pc;
				// Trace: ../../rtl/VX_warp_sched.sv:46:5
				wire schedule_valid;
				// Trace: ../../rtl/VX_warp_sched.sv:47:5
				wire warp_scheduled;
				// Trace: ../../rtl/VX_warp_sched.sv:49:5
				reg [43:0] issued_instrs;
				// Trace: ../../rtl/VX_warp_sched.sv:51:5
				wire ifetch_req_fire = VX_pipeline.fetch.ifetch_req_if.valid && VX_pipeline.fetch.ifetch_req_if.ready;
				// Trace: ../../rtl/VX_warp_sched.sv:53:5
				wire tmc_active = VX_pipeline.warp_ctl_if.tmc[1-:2] != 0;
				// Trace: ../../rtl/VX_warp_sched.sv:55:5
				always @(*) begin
					// Trace: ../../rtl/VX_warp_sched.sv:56:9
					active_warps_n = active_warps;
					// Trace: ../../rtl/VX_warp_sched.sv:57:9
					if (VX_pipeline.warp_ctl_if.valid && VX_pipeline.warp_ctl_if.wspawn[34])
						// Trace: ../../rtl/VX_warp_sched.sv:58:13
						active_warps_n = VX_pipeline.warp_ctl_if.wspawn[33-:2];
					if (VX_pipeline.warp_ctl_if.valid && VX_pipeline.warp_ctl_if.tmc[2])
						// Trace: ../../rtl/VX_warp_sched.sv:61:13
						active_warps_n[VX_pipeline.warp_ctl_if.wid] = tmc_active;
				end
				// Trace: ../../rtl/VX_warp_sched.sv:65:5
				always @(posedge clk)
					// Trace: ../../rtl/VX_warp_sched.sv:66:9
					if (reset) begin
						// Trace: ../../rtl/VX_warp_sched.sv:67:13
						barrier_masks <= 1'sb0;
						// Trace: ../../rtl/VX_warp_sched.sv:68:13
						use_wspawn <= 1'sb0;
						// Trace: ../../rtl/VX_warp_sched.sv:69:13
						stalled_warps <= 1'sb0;
						// Trace: ../../rtl/VX_warp_sched.sv:70:13
						warp_pcs <= 1'sb0;
						// Trace: ../../rtl/VX_warp_sched.sv:71:13
						active_warps <= 1'sb0;
						// Trace: ../../rtl/VX_warp_sched.sv:72:13
						thread_masks <= 1'sb0;
						// Trace: ../../rtl/VX_warp_sched.sv:73:13
						issued_instrs <= 1'sb0;
						// Trace: ../../rtl/VX_warp_sched.sv:76:13
						warp_pcs[0+:32] <= 32'h80000000;
						// Trace: ../../rtl/VX_warp_sched.sv:77:13
						active_warps[0] <= 1;
						// Trace: ../../rtl/VX_warp_sched.sv:78:13
						thread_masks[0+:2] <= 1;
					end
					else begin
						// Trace: ../../rtl/VX_warp_sched.sv:80:13
						if (VX_pipeline.warp_ctl_if.valid && VX_pipeline.warp_ctl_if.wspawn[34]) begin
							// Trace: ../../rtl/VX_warp_sched.sv:81:17
							use_wspawn <= VX_pipeline.warp_ctl_if.wspawn[33-:2] & ~2'sd1;
							// Trace: ../../rtl/VX_warp_sched.sv:82:17
							wspawn_pc <= VX_pipeline.warp_ctl_if.wspawn[31-:32];
						end
						if (VX_pipeline.warp_ctl_if.valid && VX_pipeline.warp_ctl_if.barrier[3]) begin
							// Trace: ../../rtl/VX_warp_sched.sv:86:17
							stalled_warps[VX_pipeline.warp_ctl_if.wid] <= 0;
							// Trace: ../../rtl/VX_warp_sched.sv:87:17
							if (reached_barrier_limit)
								// Trace: ../../rtl/VX_warp_sched.sv:88:21
								barrier_masks[VX_pipeline.warp_ctl_if.barrier[2-:2] * 2+:2] <= 0;
							else
								// Trace: ../../rtl/VX_warp_sched.sv:90:21
								barrier_masks[(VX_pipeline.warp_ctl_if.barrier[2-:2] * 2) + VX_pipeline.warp_ctl_if.wid] <= 1;
						end
						if (VX_pipeline.warp_ctl_if.valid && VX_pipeline.warp_ctl_if.tmc[2]) begin
							// Trace: ../../rtl/VX_warp_sched.sv:95:17
							thread_masks[VX_pipeline.warp_ctl_if.wid * 2+:2] <= VX_pipeline.warp_ctl_if.tmc[1-:2];
							// Trace: ../../rtl/VX_warp_sched.sv:96:17
							stalled_warps[VX_pipeline.warp_ctl_if.wid] <= 0;
						end
						if (VX_pipeline.warp_ctl_if.valid && VX_pipeline.warp_ctl_if.split[37]) begin
							// Trace: ../../rtl/VX_warp_sched.sv:100:17
							stalled_warps[VX_pipeline.warp_ctl_if.wid] <= 0;
							// Trace: ../../rtl/VX_warp_sched.sv:101:17
							if (VX_pipeline.warp_ctl_if.split[36])
								// Trace: ../../rtl/VX_warp_sched.sv:102:21
								thread_masks[VX_pipeline.warp_ctl_if.wid * 2+:2] <= VX_pipeline.warp_ctl_if.split[35-:2];
						end
						if (VX_pipeline.branch_ctl_if.valid) begin
							// Trace: ../../rtl/VX_warp_sched.sv:108:17
							if (VX_pipeline.branch_ctl_if.taken)
								// Trace: ../../rtl/VX_warp_sched.sv:109:21
								warp_pcs[VX_pipeline.branch_ctl_if.wid * 32+:32] <= VX_pipeline.branch_ctl_if.dest;
							// Trace: ../../rtl/VX_warp_sched.sv:111:17
							stalled_warps[VX_pipeline.branch_ctl_if.wid] <= 0;
						end
						if (warp_scheduled) begin
							// Trace: ../../rtl/VX_warp_sched.sv:116:17
							stalled_warps[schedule_wid] <= 1;
							// Trace: ../../rtl/VX_warp_sched.sv:119:17
							use_wspawn[schedule_wid] <= 0;
							// Trace: ../../rtl/VX_warp_sched.sv:120:17
							if (use_wspawn[schedule_wid])
								// Trace: ../../rtl/VX_warp_sched.sv:121:21
								thread_masks[schedule_wid * 2+:2] <= 1;
							// Trace: ../../rtl/VX_warp_sched.sv:124:17
							issued_instrs <= issued_instrs + 1;
						end
						if (ifetch_req_fire)
							// Trace: ../../rtl/VX_warp_sched.sv:128:17
							warp_pcs[VX_pipeline.fetch.ifetch_req_if.wid * 32+:32] <= VX_pipeline.fetch.ifetch_req_if.PC + 4;
						if (VX_pipeline.wstall_if.valid)
							// Trace: ../../rtl/VX_warp_sched.sv:132:17
							stalled_warps[VX_pipeline.wstall_if.wid] <= VX_pipeline.wstall_if.stalled;
						if (VX_pipeline.join_if.valid) begin
							// Trace: ../../rtl/VX_warp_sched.sv:137:17
							if (join_else)
								// Trace: ../../rtl/VX_warp_sched.sv:138:21
								warp_pcs[VX_pipeline.join_if.wid * 32+:32] <= join_pc;
							// Trace: ../../rtl/VX_warp_sched.sv:140:17
							thread_masks[VX_pipeline.join_if.wid * 2+:2] <= join_tmask;
						end
						// Trace: ../../rtl/VX_warp_sched.sv:143:13
						active_warps <= active_warps_n;
					end
				// Trace: ../../rtl/VX_warp_sched.sv:148:5
				assign VX_pipeline.fetch_to_csr_if.thread_masks = thread_masks;
				// Trace: ../../rtl/VX_warp_sched.sv:153:5
				wire [1:0] active_barrier_count;
				// Trace: ../../rtl/VX_warp_sched.sv:155:5
				wire [1:0] barrier_mask = barrier_masks[VX_pipeline.warp_ctl_if.barrier[2-:2] * 2+:2];
				// Trace: macro expansion of POP_COUNT at ../../rtl/VX_warp_sched.sv:156:46
				VX_popcount #(.N(2)) __active_barrier_count(
					.in_i(barrier_mask),
					.cnt_o(active_barrier_count)
				);
				// Trace: ../../rtl/VX_warp_sched.sv:158:5
				assign reached_barrier_limit = active_barrier_count[0:0] == VX_pipeline.warp_ctl_if.barrier[0-:1];
				// Trace: ../../rtl/VX_warp_sched.sv:160:5
				reg [1:0] barrier_stalls;
				// Trace: ../../rtl/VX_warp_sched.sv:161:5
				always @(*) begin
					// Trace: ../../rtl/VX_warp_sched.sv:162:9
					barrier_stalls = barrier_masks[0+:2];
					// Trace: ../../rtl/VX_warp_sched.sv:163:9
					begin : sv2v_autoblock_1
						// Trace: ../../rtl/VX_warp_sched.sv:163:14
						integer i;
						// Trace: ../../rtl/VX_warp_sched.sv:163:14
						for (i = 1; i < 4; i = i + 1)
							begin
								// Trace: ../../rtl/VX_warp_sched.sv:164:13
								barrier_stalls = barrier_stalls | barrier_masks[i * 2+:2];
							end
					end
				end
				// Trace: ../../rtl/VX_warp_sched.sv:170:5
				wire [33:0] ipdom_data [1:0];
				// Trace: ../../rtl/VX_warp_sched.sv:171:5
				wire ipdom_index [1:0];
				// Trace: ../../rtl/VX_warp_sched.sv:173:5
				genvar i;
				for (i = 0; i < 2; i = i + 1) begin : genblk1
					// Trace: ../../rtl/VX_warp_sched.sv:174:9
					wire push = (VX_pipeline.warp_ctl_if.valid && VX_pipeline.warp_ctl_if.split[37]) && (i == VX_pipeline.warp_ctl_if.wid);
					// Trace: ../../rtl/VX_warp_sched.sv:178:9
					wire pop = VX_pipeline.join_if.valid && (i == VX_pipeline.join_if.wid);
					// Trace: ../../rtl/VX_warp_sched.sv:180:9
					wire [1:0] else_tmask = VX_pipeline.warp_ctl_if.split[33-:2];
					// Trace: ../../rtl/VX_warp_sched.sv:181:9
					wire [1:0] orig_tmask = thread_masks[VX_pipeline.warp_ctl_if.wid * 2+:2];
					// Trace: ../../rtl/VX_warp_sched.sv:183:9
					wire [33:0] q_else = {VX_pipeline.warp_ctl_if.split[31-:32], else_tmask};
					// Trace: ../../rtl/VX_warp_sched.sv:184:9
					wire [33:0] q_end = {32'b00000000000000000000000000000000, orig_tmask};
					// Trace: ../../rtl/VX_warp_sched.sv:186:9
					VX_ipdom_stack #(
						.WIDTH(34),
						.DEPTH(4)
					) ipdom_stack(
						.clk(clk),
						.reset(reset),
						.push(push),
						.pop(pop),
						.pair(VX_pipeline.warp_ctl_if.split[36]),
						.q1(q_end),
						.q2(q_else),
						.d(ipdom_data[i]),
						.index(ipdom_index[i])
					);
				end
				// Trace: ../../rtl/VX_warp_sched.sv:204:5
				assign {join_pc, join_tmask} = ipdom_data[VX_pipeline.join_if.wid];
				// Trace: ../../rtl/VX_warp_sched.sv:205:5
				assign join_else = ~ipdom_index[VX_pipeline.join_if.wid];
				// Trace: ../../rtl/VX_warp_sched.sv:209:5
				wire [1:0] ready_warps = active_warps & ~(stalled_warps | barrier_stalls);
				// Trace: ../../rtl/VX_warp_sched.sv:211:5
				VX_lzc #(.N(2)) wid_select(
					.in_i(ready_warps),
					.cnt_o(schedule_wid),
					.valid_o(schedule_valid)
				);
				// Trace: ../../rtl/VX_warp_sched.sv:219:5
				wire [67:0] schedule_data;
				// Trace: ../../rtl/VX_warp_sched.sv:220:5
				for (i = 0; i < 2; i = i + 1) begin : genblk2
					// Trace: ../../rtl/VX_warp_sched.sv:221:9
					assign schedule_data[i * 34+:34] = {(use_wspawn[i] ? 2'sd1 : thread_masks[i * 2+:2]), (use_wspawn[i] ? wspawn_pc : warp_pcs[i * 32+:32])};
				end
				// Trace: ../../rtl/VX_warp_sched.sv:225:5
				assign {schedule_tmask, schedule_pc} = schedule_data[schedule_wid * 34+:34];
				// Trace: ../../rtl/VX_warp_sched.sv:227:5
				wire stall_out = ~VX_pipeline.fetch.ifetch_req_if.ready && VX_pipeline.fetch.ifetch_req_if.valid;
				// Trace: ../../rtl/VX_warp_sched.sv:229:5
				assign warp_scheduled = schedule_valid && ~stall_out;
				// Trace: ../../rtl/VX_warp_sched.sv:231:5
				wire [43:0] instr_uuid = ((issued_instrs * 1) * 1) + sv2v_cast_44_signed(CORE_ID);
				// Trace: ../../rtl/VX_warp_sched.sv:233:5
				VX_pipe_register #(
					.DATAW(80),
					.RESETW(1)
				) pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(!stall_out),
					.data_in({schedule_valid, instr_uuid, schedule_tmask, schedule_pc, schedule_wid}),
					.data_out({VX_pipeline.fetch.ifetch_req_if.valid, VX_pipeline.fetch.ifetch_req_if.uuid, VX_pipeline.fetch.ifetch_req_if.tmask, VX_pipeline.fetch.ifetch_req_if.PC, VX_pipeline.fetch.ifetch_req_if.wid})
				);
				// Trace: ../../rtl/VX_warp_sched.sv:244:5
				assign busy = active_warps != 0;
			end
			assign warp_sched.clk = clk;
			assign warp_sched.reset = reset;
			assign busy = warp_sched.busy;
			// Trace: ../../rtl/VX_fetch.sv:53:5
			// expanded module instance: icache_stage
			localparam _param_8CCB0_CORE_ID = CORE_ID;
			if (1) begin : icache_stage
				// Trace: ../../rtl/VX_icache_stage.sv:4:15
				localparam CORE_ID = _param_8CCB0_CORE_ID;
				// Trace: ../../rtl/VX_icache_stage.sv:8:5
				wire clk;
				// Trace: ../../rtl/VX_icache_stage.sv:9:5
				wire reset;
				// Trace: ../../rtl/VX_icache_stage.sv:12:5
				// removed modport instance icache_req_if
				// Trace: ../../rtl/VX_icache_stage.sv:13:5
				// removed modport instance icache_rsp_if
				// Trace: ../../rtl/VX_icache_stage.sv:16:5
				// removed modport instance ifetch_req_if
				// Trace: ../../rtl/VX_icache_stage.sv:19:5
				// removed modport instance ifetch_rsp_if
				// Trace: ../../rtl/VX_icache_stage.sv:25:5
				localparam OUT_REG = 0;
				// Trace: ../../rtl/VX_icache_stage.sv:27:5
				wire [0:0] req_tag;
				wire [0:0] rsp_tag;
				// Trace: ../../rtl/VX_icache_stage.sv:29:5
				wire icache_req_fire = VX_pipeline.icache_req_if.valid && VX_pipeline.icache_req_if.ready;
				// Trace: ../../rtl/VX_icache_stage.sv:31:5
				assign req_tag = VX_pipeline.fetch.ifetch_req_if.wid;
				// Trace: ../../rtl/VX_icache_stage.sv:32:5
				assign rsp_tag = VX_pipeline.icache_rsp_if.tag[0:0];
				// Trace: ../../rtl/VX_icache_stage.sv:34:5
				wire [43:0] rsp_uuid;
				// Trace: ../../rtl/VX_icache_stage.sv:35:5
				wire [31:0] rsp_PC;
				// Trace: ../../rtl/VX_icache_stage.sv:36:5
				wire [1:0] rsp_tmask;
				// Trace: ../../rtl/VX_icache_stage.sv:38:5
				VX_dp_ram #(
					.DATAW(78),
					.SIZE(2),
					.LUTRAM(1)
				) req_metadata(
					.clk(clk),
					.wren(icache_req_fire),
					.waddr(req_tag),
					.wdata({VX_pipeline.fetch.ifetch_req_if.PC, VX_pipeline.fetch.ifetch_req_if.tmask, VX_pipeline.fetch.ifetch_req_if.uuid}),
					.raddr(rsp_tag),
					.rdata({rsp_PC, rsp_tmask, rsp_uuid})
				);
				// Trace: ../../rtl/VX_icache_stage.sv:55:5
				assign VX_pipeline.icache_req_if.valid = VX_pipeline.fetch.ifetch_req_if.valid;
				// Trace: ../../rtl/VX_icache_stage.sv:56:5
				assign VX_pipeline.icache_req_if.addr = VX_pipeline.fetch.ifetch_req_if.PC[31:2];
				// Trace: ../../rtl/VX_icache_stage.sv:57:5
				assign VX_pipeline.icache_req_if.tag = {VX_pipeline.fetch.ifetch_req_if.uuid, req_tag};
				// Trace: ../../rtl/VX_icache_stage.sv:60:5
				assign VX_pipeline.fetch.ifetch_req_if.ready = VX_pipeline.icache_req_if.ready;
				// Trace: ../../rtl/VX_icache_stage.sv:62:5
				wire [0:0] rsp_wid = rsp_tag;
				// Trace: ../../rtl/VX_icache_stage.sv:64:5
				wire stall_out = ~VX_pipeline.ifetch_rsp_if.ready && (1'd1 && VX_pipeline.ifetch_rsp_if.valid);
				// Trace: ../../rtl/VX_icache_stage.sv:66:5
				VX_pipe_register #(
					.DATAW(112),
					.RESETW(1),
					.DEPTH(OUT_REG)
				) pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(!stall_out),
					.data_in({VX_pipeline.icache_rsp_if.valid, rsp_wid, rsp_tmask, rsp_PC, VX_pipeline.icache_rsp_if.data, rsp_uuid}),
					.data_out({VX_pipeline.ifetch_rsp_if.valid, VX_pipeline.ifetch_rsp_if.wid, VX_pipeline.ifetch_rsp_if.tmask, VX_pipeline.ifetch_rsp_if.PC, VX_pipeline.ifetch_rsp_if.data, VX_pipeline.ifetch_rsp_if.uuid})
				);
				// Trace: ../../rtl/VX_icache_stage.sv:79:5
				assign VX_pipeline.icache_rsp_if.ready = ~stall_out;
			end
			assign icache_stage.clk = clk;
			assign icache_stage.reset = reset;
		end
	endgenerate
	assign fetch.clk = clk;
	assign fetch.reset = fetch_reset;
	assign busy = fetch.busy;
	// Trace: ../../rtl/VX_pipeline.sv:163:5
	// expanded module instance: decode
	localparam _param_21B54_CORE_ID = CORE_ID;
	function automatic [3:0] sv2v_cast_4;
		input reg [3:0] inp;
		sv2v_cast_4 = inp;
	endfunction
	generate
		if (1) begin : decode
			// Trace: ../../rtl/VX_decode.sv:18:15
			localparam CORE_ID = _param_21B54_CORE_ID;
			// Trace: ../../rtl/VX_decode.sv:20:5
			wire clk;
			// Trace: ../../rtl/VX_decode.sv:21:5
			wire reset;
			// Trace: ../../rtl/VX_decode.sv:28:5
			// removed modport instance ifetch_rsp_if
			// Trace: ../../rtl/VX_decode.sv:31:5
			// removed modport instance decode_if
			// Trace: ../../rtl/VX_decode.sv:32:5
			// removed modport instance wstall_if
			// Trace: ../../rtl/VX_decode.sv:33:5
			// removed modport instance join_if
			// Trace: ../../rtl/VX_decode.sv:39:5
			reg [2:0] ex_type;
			// Trace: ../../rtl/VX_decode.sv:40:5
			reg [3:0] op_type;
			// Trace: ../../rtl/VX_decode.sv:41:5
			reg [2:0] op_mod;
			// Trace: ../../rtl/VX_decode.sv:42:5
			reg [4:0] rd_r;
			reg [4:0] rs1_r;
			reg [4:0] rs2_r;
			reg [4:0] rs3_r;
			// Trace: ../../rtl/VX_decode.sv:43:5
			reg [31:0] imm;
			// Trace: ../../rtl/VX_decode.sv:44:5
			reg use_rd;
			reg use_PC;
			reg use_imm;
			// Trace: ../../rtl/VX_decode.sv:45:5
			reg is_join;
			reg is_wstall;
			// Trace: ../../rtl/VX_decode.sv:47:5
			wire [31:0] instr = VX_pipeline.ifetch_rsp_if.data;
			// Trace: ../../rtl/VX_decode.sv:48:5
			wire [6:0] opcode = instr[6:0];
			// Trace: ../../rtl/VX_decode.sv:49:5
			wire [1:0] func2 = instr[26:25];
			// Trace: ../../rtl/VX_decode.sv:50:5
			wire [2:0] func3 = instr[14:12];
			// Trace: ../../rtl/VX_decode.sv:51:5
			wire [6:0] func7 = instr[31:25];
			// Trace: ../../rtl/VX_decode.sv:52:5
			wire [11:0] u_12 = instr[31:20];
			// Trace: ../../rtl/VX_decode.sv:54:5
			wire [4:0] rd = instr[11:7];
			// Trace: ../../rtl/VX_decode.sv:55:5
			wire [4:0] rs1 = instr[19:15];
			// Trace: ../../rtl/VX_decode.sv:56:5
			wire [4:0] rs2 = instr[24:20];
			// Trace: ../../rtl/VX_decode.sv:57:5
			wire [4:0] rs3 = instr[31:27];
			// Trace: ../../rtl/VX_decode.sv:59:5
			wire [19:0] upper_imm = {func7, rs2, rs1, func3};
			// Trace: ../../rtl/VX_decode.sv:60:5
			wire [11:0] alu_imm = (func3[0] && ~func3[1] ? {{7 {1'b0}}, rs2} : u_12);
			// Trace: ../../rtl/VX_decode.sv:61:5
			wire [11:0] s_imm = {func7, rd};
			// Trace: ../../rtl/VX_decode.sv:62:5
			wire [12:0] b_imm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
			// Trace: ../../rtl/VX_decode.sv:63:5
			wire [20:0] jal_imm = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
			// Trace: ../../rtl/VX_decode.sv:67:5
			always @(*) begin
				// Trace: ../../rtl/VX_decode.sv:69:9
				ex_type = 0;
				// Trace: ../../rtl/VX_decode.sv:70:9
				op_type = 1'sbx;
				// Trace: ../../rtl/VX_decode.sv:71:9
				op_mod = 0;
				// Trace: ../../rtl/VX_decode.sv:72:9
				rd_r = 0;
				// Trace: ../../rtl/VX_decode.sv:73:9
				rs1_r = 0;
				// Trace: ../../rtl/VX_decode.sv:74:9
				rs2_r = 0;
				// Trace: ../../rtl/VX_decode.sv:75:9
				rs3_r = 0;
				// Trace: ../../rtl/VX_decode.sv:76:9
				imm = 1'sbx;
				// Trace: ../../rtl/VX_decode.sv:77:9
				use_imm = 0;
				// Trace: ../../rtl/VX_decode.sv:78:9
				use_PC = 0;
				// Trace: ../../rtl/VX_decode.sv:79:9
				use_rd = 0;
				// Trace: ../../rtl/VX_decode.sv:80:9
				is_join = 0;
				// Trace: ../../rtl/VX_decode.sv:81:9
				is_wstall = 0;
				// Trace: ../../rtl/VX_decode.sv:83:9
				case (opcode)
					7'b0010011: begin
						// Trace: ../../rtl/VX_decode.sv:85:17
						ex_type = 3'h1;
						// Trace: ../../rtl/VX_decode.sv:86:17
						case (func3)
							3'h0:
								// Trace: ../../rtl/VX_decode.sv:87:27
								op_type = 4'b0000;
							3'h1:
								// Trace: ../../rtl/VX_decode.sv:88:27
								op_type = 4'b1111;
							3'h2:
								// Trace: ../../rtl/VX_decode.sv:89:27
								op_type = 4'b0101;
							3'h3:
								// Trace: ../../rtl/VX_decode.sv:90:27
								op_type = 4'b0100;
							3'h4:
								// Trace: ../../rtl/VX_decode.sv:91:27
								op_type = 4'b1110;
							3'h5:
								// Trace: ../../rtl/VX_decode.sv:92:27
								op_type = (func7[5] ? 4'b1001 : 4'b1000);
							3'h6:
								// Trace: ../../rtl/VX_decode.sv:93:27
								op_type = 4'b1101;
							3'h7:
								// Trace: ../../rtl/VX_decode.sv:94:27
								op_type = 4'b1100;
							default:
								;
						endcase
						// Trace: ../../rtl/VX_decode.sv:97:17
						use_rd = 1;
						// Trace: ../../rtl/VX_decode.sv:98:17
						use_imm = 1;
						// Trace: ../../rtl/VX_decode.sv:99:17
						imm = {{20 {alu_imm[11]}}, alu_imm};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:100:31
						rd_r = rd;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:101:32
						rs1_r = rs1;
					end
					7'b0110011: begin
						// Trace: ../../rtl/VX_decode.sv:104:17
						ex_type = 3'h1;
						// Trace: ../../rtl/VX_decode.sv:121:17
						// Trace: ../../rtl/VX_decode.sv:122:21
						case (func3)
							3'h0:
								// Trace: ../../rtl/VX_decode.sv:123:31
								op_type = (func7[5] ? 4'b1011 : 4'b0000);
							3'h1:
								// Trace: ../../rtl/VX_decode.sv:124:31
								op_type = 4'b1111;
							3'h2:
								// Trace: ../../rtl/VX_decode.sv:125:31
								op_type = 4'b0101;
							3'h3:
								// Trace: ../../rtl/VX_decode.sv:126:31
								op_type = 4'b0100;
							3'h4:
								// Trace: ../../rtl/VX_decode.sv:127:31
								op_type = 4'b1110;
							3'h5:
								// Trace: ../../rtl/VX_decode.sv:128:31
								op_type = (func7[5] ? 4'b1001 : 4'b1000);
							3'h6:
								// Trace: ../../rtl/VX_decode.sv:129:31
								op_type = 4'b1101;
							3'h7:
								// Trace: ../../rtl/VX_decode.sv:130:31
								op_type = 4'b1100;
							default:
								;
						endcase
						// Trace: ../../rtl/VX_decode.sv:134:17
						use_rd = 1;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:135:31
						rd_r = rd;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:136:32
						rs1_r = rs1;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:137:32
						rs2_r = rs2;
					end
					7'b0110111: begin
						// Trace: ../../rtl/VX_decode.sv:140:17
						ex_type = 3'h1;
						// Trace: ../../rtl/VX_decode.sv:141:17
						op_type = 4'b0010;
						// Trace: ../../rtl/VX_decode.sv:142:17
						use_rd = 1;
						// Trace: ../../rtl/VX_decode.sv:143:17
						use_imm = 1;
						// Trace: ../../rtl/VX_decode.sv:144:17
						imm = {upper_imm, 12'sd0};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:145:31
						rd_r = rd;
						// Trace: ../../rtl/VX_decode.sv:146:17
						rs1_r = 0;
					end
					7'b0010111: begin
						// Trace: ../../rtl/VX_decode.sv:149:17
						ex_type = 3'h1;
						// Trace: ../../rtl/VX_decode.sv:150:17
						op_type = 4'b0011;
						// Trace: ../../rtl/VX_decode.sv:151:17
						use_rd = 1;
						// Trace: ../../rtl/VX_decode.sv:152:17
						use_imm = 1;
						// Trace: ../../rtl/VX_decode.sv:153:17
						use_PC = 1;
						// Trace: ../../rtl/VX_decode.sv:154:17
						imm = {upper_imm, 12'sd0};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:155:31
						rd_r = rd;
					end
					7'b1101111: begin
						// Trace: ../../rtl/VX_decode.sv:158:17
						ex_type = 3'h1;
						// Trace: ../../rtl/VX_decode.sv:159:17
						op_type = 4'b1000;
						// Trace: ../../rtl/VX_decode.sv:160:17
						op_mod = 1;
						// Trace: ../../rtl/VX_decode.sv:161:17
						use_rd = 1;
						// Trace: ../../rtl/VX_decode.sv:162:17
						use_imm = 1;
						// Trace: ../../rtl/VX_decode.sv:163:17
						use_PC = 1;
						// Trace: ../../rtl/VX_decode.sv:164:17
						is_wstall = 1;
						// Trace: ../../rtl/VX_decode.sv:165:17
						imm = {{11 {jal_imm[20]}}, jal_imm};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:166:31
						rd_r = rd;
					end
					7'b1100111: begin
						// Trace: ../../rtl/VX_decode.sv:169:17
						ex_type = 3'h1;
						// Trace: ../../rtl/VX_decode.sv:170:17
						op_type = 4'b1001;
						// Trace: ../../rtl/VX_decode.sv:171:17
						op_mod = 1;
						// Trace: ../../rtl/VX_decode.sv:172:17
						use_rd = 1;
						// Trace: ../../rtl/VX_decode.sv:173:17
						use_imm = 1;
						// Trace: ../../rtl/VX_decode.sv:174:17
						is_wstall = 1;
						// Trace: ../../rtl/VX_decode.sv:175:17
						imm = {{20 {u_12[11]}}, u_12};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:176:31
						rd_r = rd;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:177:32
						rs1_r = rs1;
					end
					7'b1100011: begin
						// Trace: ../../rtl/VX_decode.sv:180:17
						ex_type = 3'h1;
						// Trace: ../../rtl/VX_decode.sv:181:17
						case (func3)
							3'h0:
								// Trace: ../../rtl/VX_decode.sv:182:27
								op_type = 4'b0000;
							3'h1:
								// Trace: ../../rtl/VX_decode.sv:183:27
								op_type = 4'b0010;
							3'h4:
								// Trace: ../../rtl/VX_decode.sv:184:27
								op_type = 4'b0101;
							3'h5:
								// Trace: ../../rtl/VX_decode.sv:185:27
								op_type = 4'b0111;
							3'h6:
								// Trace: ../../rtl/VX_decode.sv:186:27
								op_type = 4'b0100;
							3'h7:
								// Trace: ../../rtl/VX_decode.sv:187:27
								op_type = 4'b0110;
							default:
								;
						endcase
						// Trace: ../../rtl/VX_decode.sv:190:17
						op_mod = 1;
						// Trace: ../../rtl/VX_decode.sv:191:17
						use_imm = 1;
						// Trace: ../../rtl/VX_decode.sv:192:17
						use_PC = 1;
						// Trace: ../../rtl/VX_decode.sv:193:17
						is_wstall = 1;
						// Trace: ../../rtl/VX_decode.sv:194:17
						imm = {{19 {b_imm[12]}}, b_imm};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:195:32
						rs1_r = rs1;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:196:32
						rs2_r = rs2;
					end
					7'b0001111: begin
						// Trace: ../../rtl/VX_decode.sv:199:17
						ex_type = 3'h2;
						// Trace: ../../rtl/VX_decode.sv:200:17
						op_mod = 3'sd1;
					end
					7'b1110011:
						// Trace: ../../rtl/VX_decode.sv:203:17
						if (func3[1:0] != 0) begin
							// Trace: ../../rtl/VX_decode.sv:204:21
							ex_type = 3'h3;
							// Trace: ../../rtl/VX_decode.sv:205:21
							op_type = sv2v_cast_4(func3[1:0]);
							// Trace: ../../rtl/VX_decode.sv:206:21
							use_rd = 1;
							// Trace: ../../rtl/VX_decode.sv:207:21
							use_imm = func3[2];
							// Trace: ../../rtl/VX_decode.sv:208:21
							imm[11:0] = u_12;
							// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:209:35
							rd_r = rd;
							// Trace: ../../rtl/VX_decode.sv:210:21
							if (func3[2])
								// Trace: ../../rtl/VX_decode.sv:211:25
								imm[12+:5] = rs1;
							else
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:213:40
								rs1_r = rs1;
						end
						else begin
							// Trace: ../../rtl/VX_decode.sv:216:21
							ex_type = 3'h1;
							// Trace: ../../rtl/VX_decode.sv:217:21
							case (u_12)
								12'h000:
									// Trace: ../../rtl/VX_decode.sv:218:34
									op_type = 4'b1010;
								12'h001:
									// Trace: ../../rtl/VX_decode.sv:219:34
									op_type = 4'b1011;
								12'h002:
									// Trace: ../../rtl/VX_decode.sv:220:34
									op_type = 4'b1100;
								12'h102:
									// Trace: ../../rtl/VX_decode.sv:221:34
									op_type = 4'b1101;
								12'h302:
									// Trace: ../../rtl/VX_decode.sv:222:34
									op_type = 4'b1110;
								default:
									;
							endcase
							// Trace: ../../rtl/VX_decode.sv:225:21
							op_mod = 1;
							// Trace: ../../rtl/VX_decode.sv:226:21
							use_rd = 1;
							// Trace: ../../rtl/VX_decode.sv:227:21
							use_imm = 1;
							// Trace: ../../rtl/VX_decode.sv:228:21
							use_PC = 1;
							// Trace: ../../rtl/VX_decode.sv:229:21
							is_wstall = 1;
							// Trace: ../../rtl/VX_decode.sv:230:21
							imm = 32'd4;
							// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:231:35
							rd_r = rd;
						end
					7'b0000011: begin
						// Trace: ../../rtl/VX_decode.sv:238:17
						ex_type = 3'h2;
						// Trace: ../../rtl/VX_decode.sv:239:17
						op_type = sv2v_cast_4({1'b0, func3});
						// Trace: ../../rtl/VX_decode.sv:240:17
						use_rd = 1;
						// Trace: ../../rtl/VX_decode.sv:241:17
						imm = {{20 {u_12[11]}}, u_12};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:247:31
						rd_r = rd;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:248:32
						rs1_r = rs1;
					end
					7'b0100011: begin
						// Trace: ../../rtl/VX_decode.sv:254:17
						ex_type = 3'h2;
						// Trace: ../../rtl/VX_decode.sv:255:17
						op_type = sv2v_cast_4({1'b1, func3});
						// Trace: ../../rtl/VX_decode.sv:256:17
						imm = {{20 {s_imm[11]}}, s_imm};
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:257:32
						rs1_r = rs1;
						// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:263:32
						rs2_r = rs2;
					end
					7'b1101011: begin
						// Trace: ../../rtl/VX_decode.sv:354:17
						ex_type = 3'h5;
						// Trace: ../../rtl/VX_decode.sv:355:17
						case (func3)
							3'h0: begin
								// Trace: ../../rtl/VX_decode.sv:357:25
								op_type = (rs2[0] ? 4'h5 : 4'h0);
								// Trace: ../../rtl/VX_decode.sv:358:25
								is_wstall = 1;
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:359:40
								rs1_r = rs1;
							end
							3'h1: begin
								// Trace: ../../rtl/VX_decode.sv:362:25
								op_type = 4'h1;
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:363:40
								rs1_r = rs1;
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:364:40
								rs2_r = rs2;
							end
							3'h2: begin
								// Trace: ../../rtl/VX_decode.sv:367:25
								op_type = 4'h2;
								// Trace: ../../rtl/VX_decode.sv:368:25
								is_wstall = 1;
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:369:40
								rs1_r = rs1;
							end
							3'h3: begin
								// Trace: ../../rtl/VX_decode.sv:372:25
								op_type = 4'h3;
								// Trace: ../../rtl/VX_decode.sv:373:25
								is_join = 1;
							end
							3'h4: begin
								// Trace: ../../rtl/VX_decode.sv:376:25
								op_type = 4'h4;
								// Trace: ../../rtl/VX_decode.sv:377:25
								is_wstall = 1;
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:378:40
								rs1_r = rs1;
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:379:40
								rs2_r = rs2;
							end
							3'h5: begin
								// Trace: ../../rtl/VX_decode.sv:382:25
								ex_type = 3'h2;
								// Trace: ../../rtl/VX_decode.sv:383:25
								op_type = 4'b0010;
								// Trace: ../../rtl/VX_decode.sv:384:25
								op_mod = 3'sd2;
								// Trace: macro expansion of USED_IREG at ../../rtl/VX_decode.sv:385:40
								rs1_r = rs1;
							end
							default:
								;
						endcase
					end
					7'b1011011:
						// Trace: ../../rtl/VX_decode.sv:391:17
						case (func3)
							default:
								;
						endcase
					default:
						;
				endcase
			end
			// Trace: ../../rtl/VX_decode.sv:414:5
			wire wb = use_rd && |rd_r;
			// Trace: ../../rtl/VX_decode.sv:416:5
			assign VX_pipeline.decode_if.valid = VX_pipeline.ifetch_rsp_if.valid;
			// Trace: ../../rtl/VX_decode.sv:417:5
			assign VX_pipeline.decode_if.uuid = VX_pipeline.ifetch_rsp_if.uuid;
			// Trace: ../../rtl/VX_decode.sv:418:5
			assign VX_pipeline.decode_if.wid = VX_pipeline.ifetch_rsp_if.wid;
			// Trace: ../../rtl/VX_decode.sv:419:5
			assign VX_pipeline.decode_if.tmask = VX_pipeline.ifetch_rsp_if.tmask;
			// Trace: ../../rtl/VX_decode.sv:420:5
			assign VX_pipeline.decode_if.PC = VX_pipeline.ifetch_rsp_if.PC;
			// Trace: ../../rtl/VX_decode.sv:421:5
			assign VX_pipeline.decode_if.ex_type = ex_type;
			// Trace: ../../rtl/VX_decode.sv:422:5
			assign VX_pipeline.decode_if.op_type = op_type;
			// Trace: ../../rtl/VX_decode.sv:423:5
			assign VX_pipeline.decode_if.op_mod = op_mod;
			// Trace: ../../rtl/VX_decode.sv:424:5
			assign VX_pipeline.decode_if.wb = wb;
			// Trace: ../../rtl/VX_decode.sv:425:5
			assign VX_pipeline.decode_if.rd = rd_r;
			// Trace: ../../rtl/VX_decode.sv:426:5
			assign VX_pipeline.decode_if.rs1 = rs1_r;
			// Trace: ../../rtl/VX_decode.sv:427:5
			assign VX_pipeline.decode_if.rs2 = rs2_r;
			// Trace: ../../rtl/VX_decode.sv:428:5
			assign VX_pipeline.decode_if.rs3 = rs3_r;
			// Trace: ../../rtl/VX_decode.sv:429:5
			assign VX_pipeline.decode_if.imm = imm;
			// Trace: ../../rtl/VX_decode.sv:430:5
			assign VX_pipeline.decode_if.use_PC = use_PC;
			// Trace: ../../rtl/VX_decode.sv:431:5
			assign VX_pipeline.decode_if.use_imm = use_imm;
			// Trace: ../../rtl/VX_decode.sv:435:5
			wire ifetch_rsp_fire = VX_pipeline.ifetch_rsp_if.valid && VX_pipeline.ifetch_rsp_if.ready;
			// Trace: ../../rtl/VX_decode.sv:437:5
			assign VX_pipeline.join_if.valid = ifetch_rsp_fire && is_join;
			// Trace: ../../rtl/VX_decode.sv:438:5
			assign VX_pipeline.join_if.wid = VX_pipeline.ifetch_rsp_if.wid;
			// Trace: ../../rtl/VX_decode.sv:440:5
			assign VX_pipeline.wstall_if.valid = ifetch_rsp_fire;
			// Trace: ../../rtl/VX_decode.sv:441:5
			assign VX_pipeline.wstall_if.wid = VX_pipeline.ifetch_rsp_if.wid;
			// Trace: ../../rtl/VX_decode.sv:442:5
			assign VX_pipeline.wstall_if.stalled = is_wstall;
			// Trace: ../../rtl/VX_decode.sv:444:5
			assign VX_pipeline.ifetch_rsp_if.ready = VX_pipeline.decode_if.ready;
		end
	endgenerate
	assign decode.clk = clk;
	assign decode.reset = decode_reset;
	// Trace: ../../rtl/VX_pipeline.sv:177:5
	// expanded module instance: issue
	localparam _param_CF65A_CORE_ID = CORE_ID;
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	function automatic signed [1:0] sv2v_cast_2_signed;
		input reg signed [1:0] inp;
		sv2v_cast_2_signed = inp;
	endfunction
	generate
		if (1) begin : issue
			// Trace: ../../rtl/VX_issue.sv:4:15
			localparam CORE_ID = _param_CF65A_CORE_ID;
			// Trace: ../../rtl/VX_issue.sv:8:5
			wire clk;
			// Trace: ../../rtl/VX_issue.sv:9:5
			wire reset;
			// Trace: ../../rtl/VX_issue.sv:15:5
			// removed modport instance decode_if
			// Trace: ../../rtl/VX_issue.sv:16:5
			// removed modport instance writeback_if
			// Trace: ../../rtl/VX_issue.sv:18:5
			// removed modport instance alu_req_if
			// Trace: ../../rtl/VX_issue.sv:19:5
			// removed modport instance lsu_req_if
			// Trace: ../../rtl/VX_issue.sv:20:5
			// removed modport instance csr_req_if
			// Trace: ../../rtl/VX_issue.sv:24:5
			// removed modport instance gpu_req_if
			// Trace: ../../rtl/VX_issue.sv:26:5
			// expanded interface instance: ibuffer_if
			if (1) begin : ibuffer_if
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:8:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:9:5
				wire [43:0] uuid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:10:5
				wire [0:0] wid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:11:5
				wire [1:0] tmask;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:12:5
				wire [31:0] PC;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:13:5
				wire [2:0] ex_type;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:14:5
				wire [3:0] op_type;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:15:5
				wire [2:0] op_mod;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:16:5
				wire wb;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:17:5
				wire use_PC;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:18:5
				wire use_imm;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:19:5
				wire [31:0] imm;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:20:5
				wire [4:0] rd;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:21:5
				wire [4:0] rs1;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:22:5
				wire [4:0] rs2;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:23:5
				wire [4:0] rs3;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:25:5
				wire [4:0] rd_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:26:5
				wire [4:0] rs1_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:27:5
				wire [4:0] rs2_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:28:5
				wire [4:0] rs3_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:29:5
				wire [0:0] wid_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:31:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:33:5
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:58:5
			end
			// Trace: ../../rtl/VX_issue.sv:27:5
			// expanded interface instance: gpr_req_if
			if (1) begin : gpr_req_if
				// Trace: ../../rtl/interfaces/VX_gpr_req_if.sv:8:5
				wire [0:0] wid;
				// Trace: ../../rtl/interfaces/VX_gpr_req_if.sv:9:5
				wire [4:0] rs1;
				// Trace: ../../rtl/interfaces/VX_gpr_req_if.sv:10:5
				wire [4:0] rs2;
				// Trace: ../../rtl/interfaces/VX_gpr_req_if.sv:11:5
				wire [4:0] rs3;
				// Trace: ../../rtl/interfaces/VX_gpr_req_if.sv:13:5
				// Trace: ../../rtl/interfaces/VX_gpr_req_if.sv:20:5
			end
			// Trace: ../../rtl/VX_issue.sv:28:5
			// expanded interface instance: gpr_rsp_if
			if (1) begin : gpr_rsp_if
				// Trace: ../../rtl/interfaces/VX_gpr_rsp_if.sv:8:5
				wire [63:0] rs1_data;
				// Trace: ../../rtl/interfaces/VX_gpr_rsp_if.sv:9:5
				wire [63:0] rs2_data;
				// Trace: ../../rtl/interfaces/VX_gpr_rsp_if.sv:10:5
				wire [63:0] rs3_data;
				// Trace: ../../rtl/interfaces/VX_gpr_rsp_if.sv:12:5
				// Trace: ../../rtl/interfaces/VX_gpr_rsp_if.sv:18:5
			end
			// Trace: ../../rtl/VX_issue.sv:29:5
			// expanded interface instance: sboard_wb_if
			if (1) begin : sboard_wb_if
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:8:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:9:5
				wire [43:0] uuid;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:10:5
				wire [1:0] tmask;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:11:5
				wire [0:0] wid;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:12:5
				wire [31:0] PC;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:13:5
				wire [4:0] rd;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:14:5
				wire [63:0] data;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:15:5
				wire eop;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:16:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:18:5
				// Trace: ../../rtl/interfaces/VX_writeback_if.sv:30:5
			end
			// Trace: ../../rtl/VX_issue.sv:30:5
			// expanded interface instance: scoreboard_if
			if (1) begin : scoreboard_if
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:8:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:9:5
				wire [43:0] uuid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:10:5
				wire [0:0] wid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:11:5
				wire [1:0] tmask;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:12:5
				wire [31:0] PC;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:13:5
				wire [2:0] ex_type;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:14:5
				wire [3:0] op_type;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:15:5
				wire [2:0] op_mod;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:16:5
				wire wb;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:17:5
				wire use_PC;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:18:5
				wire use_imm;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:19:5
				wire [31:0] imm;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:20:5
				wire [4:0] rd;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:21:5
				wire [4:0] rs1;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:22:5
				wire [4:0] rs2;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:23:5
				wire [4:0] rs3;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:25:5
				wire [4:0] rd_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:26:5
				wire [4:0] rs1_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:27:5
				wire [4:0] rs2_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:28:5
				wire [4:0] rs3_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:29:5
				wire [0:0] wid_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:31:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:33:5
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:58:5
			end
			// Trace: ../../rtl/VX_issue.sv:31:5
			// expanded interface instance: dispatch_if
			if (1) begin : dispatch_if
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:8:5
				wire valid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:9:5
				wire [43:0] uuid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:10:5
				wire [0:0] wid;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:11:5
				wire [1:0] tmask;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:12:5
				wire [31:0] PC;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:13:5
				wire [2:0] ex_type;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:14:5
				wire [3:0] op_type;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:15:5
				wire [2:0] op_mod;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:16:5
				wire wb;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:17:5
				wire use_PC;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:18:5
				wire use_imm;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:19:5
				wire [31:0] imm;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:20:5
				wire [4:0] rd;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:21:5
				wire [4:0] rs1;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:22:5
				wire [4:0] rs2;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:23:5
				wire [4:0] rs3;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:25:5
				wire [4:0] rd_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:26:5
				wire [4:0] rs1_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:27:5
				wire [4:0] rs2_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:28:5
				wire [4:0] rs3_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:29:5
				wire [0:0] wid_n;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:31:5
				wire ready;
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:33:5
				// Trace: ../../rtl/interfaces/VX_ibuffer_if.sv:58:5
			end
			// Trace: ../../rtl/VX_issue.sv:34:5
			assign gpr_req_if.wid = ibuffer_if.wid;
			// Trace: ../../rtl/VX_issue.sv:35:5
			assign gpr_req_if.rs1 = ibuffer_if.rs1;
			// Trace: ../../rtl/VX_issue.sv:36:5
			assign gpr_req_if.rs2 = ibuffer_if.rs2;
			// Trace: ../../rtl/VX_issue.sv:37:5
			assign gpr_req_if.rs3 = ibuffer_if.rs3;
			// Trace: ../../rtl/VX_issue.sv:40:5
			assign sboard_wb_if.valid = VX_pipeline.writeback_if.valid;
			// Trace: ../../rtl/VX_issue.sv:41:5
			assign sboard_wb_if.uuid = VX_pipeline.writeback_if.uuid;
			// Trace: ../../rtl/VX_issue.sv:42:5
			assign sboard_wb_if.wid = VX_pipeline.writeback_if.wid;
			// Trace: ../../rtl/VX_issue.sv:43:5
			assign sboard_wb_if.PC = VX_pipeline.writeback_if.PC;
			// Trace: ../../rtl/VX_issue.sv:44:5
			assign sboard_wb_if.rd = VX_pipeline.writeback_if.rd;
			// Trace: ../../rtl/VX_issue.sv:45:5
			assign sboard_wb_if.eop = VX_pipeline.writeback_if.eop;
			// Trace: ../../rtl/VX_issue.sv:48:5
			assign scoreboard_if.valid = ibuffer_if.valid && dispatch_if.ready;
			// Trace: ../../rtl/VX_issue.sv:49:5
			assign scoreboard_if.uuid = ibuffer_if.uuid;
			// Trace: ../../rtl/VX_issue.sv:50:5
			assign scoreboard_if.wid = ibuffer_if.wid;
			// Trace: ../../rtl/VX_issue.sv:51:5
			assign scoreboard_if.PC = ibuffer_if.PC;
			// Trace: ../../rtl/VX_issue.sv:52:5
			assign scoreboard_if.wb = ibuffer_if.wb;
			// Trace: ../../rtl/VX_issue.sv:53:5
			assign scoreboard_if.rd = ibuffer_if.rd;
			// Trace: ../../rtl/VX_issue.sv:54:5
			assign scoreboard_if.rd_n = ibuffer_if.rd_n;
			// Trace: ../../rtl/VX_issue.sv:55:5
			assign scoreboard_if.rs1_n = ibuffer_if.rs1_n;
			// Trace: ../../rtl/VX_issue.sv:56:5
			assign scoreboard_if.rs2_n = ibuffer_if.rs2_n;
			// Trace: ../../rtl/VX_issue.sv:57:5
			assign scoreboard_if.rs3_n = ibuffer_if.rs3_n;
			// Trace: ../../rtl/VX_issue.sv:58:5
			assign scoreboard_if.wid_n = ibuffer_if.wid_n;
			// Trace: ../../rtl/VX_issue.sv:61:5
			assign dispatch_if.valid = ibuffer_if.valid && scoreboard_if.ready;
			// Trace: ../../rtl/VX_issue.sv:62:5
			assign dispatch_if.uuid = ibuffer_if.uuid;
			// Trace: ../../rtl/VX_issue.sv:63:5
			assign dispatch_if.wid = ibuffer_if.wid;
			// Trace: ../../rtl/VX_issue.sv:64:5
			assign dispatch_if.tmask = ibuffer_if.tmask;
			// Trace: ../../rtl/VX_issue.sv:65:5
			assign dispatch_if.PC = ibuffer_if.PC;
			// Trace: ../../rtl/VX_issue.sv:66:5
			assign dispatch_if.ex_type = ibuffer_if.ex_type;
			// Trace: ../../rtl/VX_issue.sv:67:5
			assign dispatch_if.op_type = ibuffer_if.op_type;
			// Trace: ../../rtl/VX_issue.sv:68:5
			assign dispatch_if.op_mod = ibuffer_if.op_mod;
			// Trace: ../../rtl/VX_issue.sv:69:5
			assign dispatch_if.wb = ibuffer_if.wb;
			// Trace: ../../rtl/VX_issue.sv:70:5
			assign dispatch_if.rd = ibuffer_if.rd;
			// Trace: ../../rtl/VX_issue.sv:71:5
			assign dispatch_if.rs1 = ibuffer_if.rs1;
			// Trace: ../../rtl/VX_issue.sv:72:5
			assign dispatch_if.imm = ibuffer_if.imm;
			// Trace: ../../rtl/VX_issue.sv:73:5
			assign dispatch_if.use_PC = ibuffer_if.use_PC;
			// Trace: ../../rtl/VX_issue.sv:74:5
			assign dispatch_if.use_imm = ibuffer_if.use_imm;
			// Trace: ../../rtl/VX_issue.sv:77:5
			assign ibuffer_if.ready = scoreboard_if.ready && dispatch_if.ready;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:79:23
			wire ibuf_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:79:56
			VX_reset_relay __ibuf_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(ibuf_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:80:29
			wire scoreboard_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:80:62
			VX_reset_relay __scoreboard_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(scoreboard_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:81:22
			wire gpr_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:81:55
			VX_reset_relay __gpr_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(gpr_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:82:27
			wire dispatch_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_issue.sv:82:60
			VX_reset_relay __dispatch_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(dispatch_reset)
			);
			// Trace: ../../rtl/VX_issue.sv:84:5
			// expanded module instance: ibuffer
			localparam _param_D579A_CORE_ID = CORE_ID;
			if (1) begin : ibuffer
				// Trace: ../../rtl/VX_ibuffer.sv:4:15
				localparam CORE_ID = _param_D579A_CORE_ID;
				// Trace: ../../rtl/VX_ibuffer.sv:6:5
				wire clk;
				// Trace: ../../rtl/VX_ibuffer.sv:7:5
				wire reset;
				// Trace: ../../rtl/VX_ibuffer.sv:10:5
				// removed modport instance decode_if
				// Trace: ../../rtl/VX_ibuffer.sv:13:5
				// removed modport instance ibuffer_if
				// Trace: ../../rtl/VX_ibuffer.sv:18:5
				localparam DATAW = 143;
				// Trace: ../../rtl/VX_ibuffer.sv:19:5
				localparam ADDRW = 2;
				// Trace: ../../rtl/VX_ibuffer.sv:20:5
				localparam NWARPSW = 2;
				// Trace: ../../rtl/VX_ibuffer.sv:22:5
				reg [3:0] used_r;
				// Trace: ../../rtl/VX_ibuffer.sv:23:5
				reg [1:0] full_r;
				reg [1:0] empty_r;
				reg [1:0] alm_empty_r;
				// Trace: ../../rtl/VX_ibuffer.sv:25:5
				wire [1:0] q_full;
				wire [1:0] q_empty;
				wire [1:0] q_alm_empty;
				// Trace: ../../rtl/VX_ibuffer.sv:26:5
				wire [142:0] q_data_in;
				// Trace: ../../rtl/VX_ibuffer.sv:27:5
				wire [285:0] q_data_prev;
				// Trace: ../../rtl/VX_ibuffer.sv:28:5
				reg [285:0] q_data_out;
				// Trace: ../../rtl/VX_ibuffer.sv:30:5
				wire enq_fire = VX_pipeline.decode_if.valid && VX_pipeline.decode_if.ready;
				// Trace: ../../rtl/VX_ibuffer.sv:31:5
				wire deq_fire = VX_pipeline.issue.ibuffer_if.valid && VX_pipeline.issue.ibuffer_if.ready;
				// Trace: ../../rtl/VX_ibuffer.sv:33:5
				genvar i;
				for (i = 0; i < 2; i = i + 1) begin : genblk1
					// Trace: ../../rtl/VX_ibuffer.sv:35:9
					wire writing = enq_fire && (i == VX_pipeline.decode_if.wid);
					// Trace: ../../rtl/VX_ibuffer.sv:36:9
					wire reading = deq_fire && (i == VX_pipeline.issue.ibuffer_if.wid);
					// Trace: ../../rtl/VX_ibuffer.sv:38:9
					wire going_empty = empty_r[i] || (alm_empty_r[i] && reading);
					// Trace: ../../rtl/VX_ibuffer.sv:40:9
					VX_elastic_buffer #(
						.DATAW(DATAW),
						.SIZE(2),
						.OUT_REG(1)
					) queue(
						.clk(clk),
						.reset(reset),
						.valid_in(writing && !going_empty),
						.data_in(q_data_in),
						.ready_out(reading),
						.data_out(q_data_prev[i * 143+:143])
					);
					// Trace: ../../rtl/VX_ibuffer.sv:55:9
					always @(posedge clk) begin
						// Trace: ../../rtl/VX_ibuffer.sv:56:13
						if (reset) begin
							// Trace: ../../rtl/VX_ibuffer.sv:57:17
							used_r[i * 2+:2] <= 0;
							// Trace: ../../rtl/VX_ibuffer.sv:58:17
							full_r[i] <= 0;
							// Trace: ../../rtl/VX_ibuffer.sv:59:17
							empty_r[i] <= 1;
							// Trace: ../../rtl/VX_ibuffer.sv:60:17
							alm_empty_r[i] <= 1;
						end
						else begin
							// Trace: ../../rtl/VX_ibuffer.sv:62:17
							if (writing) begin
								begin
									// Trace: ../../rtl/VX_ibuffer.sv:63:21
									if (!reading) begin
										// Trace: ../../rtl/VX_ibuffer.sv:64:25
										empty_r[i] <= 0;
										// Trace: ../../rtl/VX_ibuffer.sv:65:25
										if (used_r[i * 2+:2] == 1)
											// Trace: ../../rtl/VX_ibuffer.sv:66:29
											alm_empty_r[i] <= 0;
										if (used_r[i * 2+:2] == 2'sd2)
											// Trace: ../../rtl/VX_ibuffer.sv:68:29
											full_r[i] <= 1;
									end
								end
							end
							else if (reading) begin
								// Trace: ../../rtl/VX_ibuffer.sv:71:21
								full_r[i] <= 0;
								// Trace: ../../rtl/VX_ibuffer.sv:72:21
								if (used_r[i * 2+:2] == 2'sd1)
									// Trace: ../../rtl/VX_ibuffer.sv:73:25
									empty_r[i] <= 1;
								if (used_r[i * 2+:2] == 2'sd2)
									// Trace: ../../rtl/VX_ibuffer.sv:75:25
									alm_empty_r[i] <= 1;
							end
							// Trace: ../../rtl/VX_ibuffer.sv:77:17
							used_r[i * 2+:2] <= used_r[i * 2+:2] + sv2v_cast_2_signed($signed(sv2v_cast_2(writing) - sv2v_cast_2(reading)));
						end
						if (writing && going_empty)
							// Trace: ../../rtl/VX_ibuffer.sv:81:17
							q_data_out[i * 143+:143] <= q_data_in;
						else if (reading)
							// Trace: ../../rtl/VX_ibuffer.sv:83:17
							q_data_out[i * 143+:143] <= q_data_prev[i * 143+:143];
					end
					// Trace: ../../rtl/VX_ibuffer.sv:87:9
					assign q_full[i] = full_r[i];
					// Trace: ../../rtl/VX_ibuffer.sv:88:9
					assign q_empty[i] = empty_r[i];
					// Trace: ../../rtl/VX_ibuffer.sv:89:9
					assign q_alm_empty[i] = alm_empty_r[i];
				end
				// Trace: ../../rtl/VX_ibuffer.sv:94:5
				reg [1:0] valid_table;
				reg [1:0] valid_table_n;
				// Trace: ../../rtl/VX_ibuffer.sv:95:5
				reg [0:0] deq_wid;
				reg [0:0] deq_wid_n;
				// Trace: ../../rtl/VX_ibuffer.sv:96:5
				reg [0:0] deq_wid_rr;
				reg [0:0] deq_wid_rr_n;
				// Trace: ../../rtl/VX_ibuffer.sv:97:5
				reg deq_valid;
				reg deq_valid_n;
				// Trace: ../../rtl/VX_ibuffer.sv:98:5
				reg [142:0] deq_instr;
				reg [142:0] deq_instr_n;
				// Trace: ../../rtl/VX_ibuffer.sv:99:5
				reg [1:0] num_warps;
				// Trace: ../../rtl/VX_ibuffer.sv:104:5
				always @(*) begin
					// Trace: ../../rtl/VX_ibuffer.sv:105:9
					valid_table_n = valid_table;
					// Trace: ../../rtl/VX_ibuffer.sv:106:9
					if (deq_fire)
						// Trace: ../../rtl/VX_ibuffer.sv:107:13
						valid_table_n[deq_wid] = !q_alm_empty[deq_wid];
					if (enq_fire)
						// Trace: ../../rtl/VX_ibuffer.sv:110:13
						valid_table_n[VX_pipeline.decode_if.wid] = 1;
				end
				// Trace: ../../rtl/VX_ibuffer.sv:115:5
				// rewrote reg-to-output bindings
				wire [1:1] sv2v_tmp_rr_arbiter_grant_index;
				always @(*) deq_wid_rr_n = sv2v_tmp_rr_arbiter_grant_index;
				VX_rr_arbiter #(.NUM_REQS(2)) rr_arbiter(
					.clk(clk),
					.reset(reset),
					.requests(valid_table_n),
					.grant_index(sv2v_tmp_rr_arbiter_grant_index)
				);
				// Trace: ../../rtl/VX_ibuffer.sv:128:5
				always @(*)
					// Trace: ../../rtl/VX_ibuffer.sv:129:9
					if (num_warps > 1) begin
						// Trace: ../../rtl/VX_ibuffer.sv:130:13
						deq_valid_n = 1;
						// Trace: ../../rtl/VX_ibuffer.sv:131:13
						deq_wid_n = deq_wid_rr;
						// Trace: ../../rtl/VX_ibuffer.sv:132:13
						deq_instr_n = q_data_out[deq_wid_rr * 143+:143];
					end
					else if ((1 == num_warps) && !(deq_fire && q_alm_empty[deq_wid])) begin
						// Trace: ../../rtl/VX_ibuffer.sv:134:13
						deq_valid_n = 1;
						// Trace: ../../rtl/VX_ibuffer.sv:135:13
						deq_wid_n = deq_wid;
						// Trace: ../../rtl/VX_ibuffer.sv:136:13
						deq_instr_n = (deq_fire ? q_data_prev[deq_wid * 143+:143] : q_data_out[deq_wid * 143+:143]);
					end
					else begin
						// Trace: ../../rtl/VX_ibuffer.sv:138:13
						deq_valid_n = enq_fire;
						// Trace: ../../rtl/VX_ibuffer.sv:139:13
						deq_wid_n = VX_pipeline.decode_if.wid;
						// Trace: ../../rtl/VX_ibuffer.sv:140:13
						deq_instr_n = q_data_in;
					end
				// Trace: ../../rtl/VX_ibuffer.sv:144:5
				wire warp_added = enq_fire && q_empty[VX_pipeline.decode_if.wid];
				// Trace: ../../rtl/VX_ibuffer.sv:145:5
				wire warp_removed = (deq_fire && ~(enq_fire && (VX_pipeline.decode_if.wid == deq_wid))) && q_alm_empty[deq_wid];
				// Trace: ../../rtl/VX_ibuffer.sv:147:5
				always @(posedge clk) begin
					// Trace: ../../rtl/VX_ibuffer.sv:148:9
					if (reset) begin
						// Trace: ../../rtl/VX_ibuffer.sv:149:13
						valid_table <= 0;
						// Trace: ../../rtl/VX_ibuffer.sv:150:13
						deq_valid <= 0;
						// Trace: ../../rtl/VX_ibuffer.sv:151:13
						num_warps <= 0;
					end
					else begin
						// Trace: ../../rtl/VX_ibuffer.sv:153:13
						valid_table <= valid_table_n;
						// Trace: ../../rtl/VX_ibuffer.sv:154:13
						deq_valid <= deq_valid_n;
						// Trace: ../../rtl/VX_ibuffer.sv:157:13
						if (warp_added && !warp_removed)
							// Trace: ../../rtl/VX_ibuffer.sv:158:17
							num_warps <= num_warps + 2'sd1;
						else if (warp_removed && !warp_added)
							// Trace: ../../rtl/VX_ibuffer.sv:160:17
							num_warps <= num_warps - 2'sd1;
					end
					// Trace: ../../rtl/VX_ibuffer.sv:164:9
					deq_wid <= deq_wid_n;
					// Trace: ../../rtl/VX_ibuffer.sv:165:9
					deq_wid_rr <= deq_wid_rr_n;
					// Trace: ../../rtl/VX_ibuffer.sv:166:9
					deq_instr <= deq_instr_n;
				end
				// Trace: ../../rtl/VX_ibuffer.sv:169:5
				assign VX_pipeline.decode_if.ready = ~q_full[VX_pipeline.decode_if.wid];
				// Trace: ../../rtl/VX_ibuffer.sv:171:5
				assign q_data_in = {VX_pipeline.decode_if.uuid, VX_pipeline.decode_if.tmask, VX_pipeline.decode_if.PC, VX_pipeline.decode_if.ex_type, VX_pipeline.decode_if.op_type, VX_pipeline.decode_if.op_mod, VX_pipeline.decode_if.wb, VX_pipeline.decode_if.use_PC, VX_pipeline.decode_if.use_imm, VX_pipeline.decode_if.imm, VX_pipeline.decode_if.rd, VX_pipeline.decode_if.rs1, VX_pipeline.decode_if.rs2, VX_pipeline.decode_if.rs3};
				// Trace: ../../rtl/VX_ibuffer.sv:186:5
				assign VX_pipeline.issue.ibuffer_if.valid = deq_valid;
				// Trace: ../../rtl/VX_ibuffer.sv:187:5
				assign VX_pipeline.issue.ibuffer_if.wid = deq_wid;
				// Trace: ../../rtl/VX_ibuffer.sv:188:5
				assign {VX_pipeline.issue.ibuffer_if.uuid, VX_pipeline.issue.ibuffer_if.tmask, VX_pipeline.issue.ibuffer_if.PC, VX_pipeline.issue.ibuffer_if.ex_type, VX_pipeline.issue.ibuffer_if.op_type, VX_pipeline.issue.ibuffer_if.op_mod, VX_pipeline.issue.ibuffer_if.wb, VX_pipeline.issue.ibuffer_if.use_PC, VX_pipeline.issue.ibuffer_if.use_imm, VX_pipeline.issue.ibuffer_if.imm, VX_pipeline.issue.ibuffer_if.rd, VX_pipeline.issue.ibuffer_if.rs1, VX_pipeline.issue.ibuffer_if.rs2, VX_pipeline.issue.ibuffer_if.rs3} = deq_instr;
				// Trace: ../../rtl/VX_ibuffer.sv:204:5
				assign VX_pipeline.issue.ibuffer_if.wid_n = deq_wid_n;
				// Trace: ../../rtl/VX_ibuffer.sv:205:5
				assign VX_pipeline.issue.ibuffer_if.rd_n = deq_instr_n[15+:5];
				// Trace: ../../rtl/VX_ibuffer.sv:206:5
				assign VX_pipeline.issue.ibuffer_if.rs1_n = deq_instr_n[10+:5];
				// Trace: ../../rtl/VX_ibuffer.sv:207:5
				assign VX_pipeline.issue.ibuffer_if.rs2_n = deq_instr_n[5+:5];
				// Trace: ../../rtl/VX_ibuffer.sv:208:5
				assign VX_pipeline.issue.ibuffer_if.rs3_n = deq_instr_n[0+:5];
			end
			assign ibuffer.clk = clk;
			assign ibuffer.reset = ibuf_reset;
			// Trace: ../../rtl/VX_issue.sv:93:5
			// expanded module instance: scoreboard
			localparam _param_85D2C_CORE_ID = CORE_ID;
			if (1) begin : scoreboard
				// Trace: ../../rtl/VX_scoreboard.sv:4:15
				localparam CORE_ID = _param_85D2C_CORE_ID;
				// Trace: ../../rtl/VX_scoreboard.sv:6:5
				wire clk;
				// Trace: ../../rtl/VX_scoreboard.sv:7:5
				wire reset;
				// Trace: ../../rtl/VX_scoreboard.sv:9:5
				// removed modport instance ibuffer_if
				// Trace: ../../rtl/VX_scoreboard.sv:10:5
				// removed modport instance writeback_if
				// Trace: ../../rtl/VX_scoreboard.sv:12:5
				reg [63:0] inuse_regs;
				reg [63:0] inuse_regs_n;
				// Trace: ../../rtl/VX_scoreboard.sv:14:5
				wire reserve_reg = (VX_pipeline.issue.scoreboard_if.valid && VX_pipeline.issue.scoreboard_if.ready) && VX_pipeline.issue.scoreboard_if.wb;
				// Trace: ../../rtl/VX_scoreboard.sv:16:5
				wire release_reg = (VX_pipeline.issue.sboard_wb_if.valid && VX_pipeline.issue.sboard_wb_if.ready) && VX_pipeline.issue.sboard_wb_if.eop;
				// Trace: ../../rtl/VX_scoreboard.sv:18:5
				always @(*) begin
					// Trace: ../../rtl/VX_scoreboard.sv:19:9
					inuse_regs_n = inuse_regs;
					// Trace: ../../rtl/VX_scoreboard.sv:20:9
					if (reserve_reg)
						// Trace: ../../rtl/VX_scoreboard.sv:21:13
						inuse_regs_n[(VX_pipeline.issue.scoreboard_if.wid * 32) + VX_pipeline.issue.scoreboard_if.rd] = 1;
					if (release_reg)
						// Trace: ../../rtl/VX_scoreboard.sv:24:13
						inuse_regs_n[(VX_pipeline.issue.sboard_wb_if.wid * 32) + VX_pipeline.issue.sboard_wb_if.rd] = 0;
				end
				// Trace: ../../rtl/VX_scoreboard.sv:28:5
				always @(posedge clk)
					// Trace: ../../rtl/VX_scoreboard.sv:29:9
					if (reset)
						// Trace: ../../rtl/VX_scoreboard.sv:30:13
						inuse_regs <= 1'sb0;
					else
						// Trace: ../../rtl/VX_scoreboard.sv:32:13
						inuse_regs <= inuse_regs_n;
				// Trace: ../../rtl/VX_scoreboard.sv:36:5
				reg deq_inuse_rd;
				reg deq_inuse_rs1;
				reg deq_inuse_rs2;
				reg deq_inuse_rs3;
				// Trace: ../../rtl/VX_scoreboard.sv:38:5
				always @(posedge clk) begin
					// Trace: ../../rtl/VX_scoreboard.sv:39:9
					deq_inuse_rd <= inuse_regs_n[(VX_pipeline.issue.scoreboard_if.wid_n * 32) + VX_pipeline.issue.scoreboard_if.rd_n];
					// Trace: ../../rtl/VX_scoreboard.sv:40:9
					deq_inuse_rs1 <= inuse_regs_n[(VX_pipeline.issue.scoreboard_if.wid_n * 32) + VX_pipeline.issue.scoreboard_if.rs1_n];
					// Trace: ../../rtl/VX_scoreboard.sv:41:9
					deq_inuse_rs2 <= inuse_regs_n[(VX_pipeline.issue.scoreboard_if.wid_n * 32) + VX_pipeline.issue.scoreboard_if.rs2_n];
					// Trace: ../../rtl/VX_scoreboard.sv:42:9
					deq_inuse_rs3 <= inuse_regs_n[(VX_pipeline.issue.scoreboard_if.wid_n * 32) + VX_pipeline.issue.scoreboard_if.rs3_n];
				end
				// Trace: ../../rtl/VX_scoreboard.sv:45:5
				assign VX_pipeline.issue.sboard_wb_if.ready = 1'b1;
				// Trace: ../../rtl/VX_scoreboard.sv:47:5
				assign VX_pipeline.issue.scoreboard_if.ready = ~(((deq_inuse_rd | deq_inuse_rs1) | deq_inuse_rs2) | deq_inuse_rs3);
				// Trace: ../../rtl/VX_scoreboard.sv:54:5
				reg [31:0] deadlock_ctr;
				// Trace: ../../rtl/VX_scoreboard.sv:55:5
				wire [31:0] deadlock_timeout = 10000;
				// Trace: ../../rtl/VX_scoreboard.sv:57:5
				always @(posedge clk)
					// Trace: ../../rtl/VX_scoreboard.sv:58:9
					if (reset)
						// Trace: ../../rtl/VX_scoreboard.sv:59:13
						deadlock_ctr <= 0;
					else begin
						// Trace: ../../rtl/VX_scoreboard.sv:68:13
						if (release_reg)
							// Trace: macro expansion of ASSERT at ../../rtl/VX_scoreboard.sv:71:112
							if (inuse_regs[(VX_pipeline.issue.sboard_wb_if.wid * 32) + VX_pipeline.issue.sboard_wb_if.rd] != 0)
								;
						if (VX_pipeline.issue.scoreboard_if.valid && ~VX_pipeline.issue.scoreboard_if.ready) begin
							// Trace: ../../rtl/VX_scoreboard.sv:74:17
							deadlock_ctr <= deadlock_ctr + 1;
							// Trace: macro expansion of ASSERT at ../../rtl/VX_scoreboard.sv:78:94
							if (deadlock_ctr < deadlock_timeout)
								;
						end
						else if (VX_pipeline.issue.scoreboard_if.valid && VX_pipeline.issue.scoreboard_if.ready)
							// Trace: ../../rtl/VX_scoreboard.sv:80:17
							deadlock_ctr <= 0;
					end
			end
			assign scoreboard.clk = clk;
			assign scoreboard.reset = scoreboard_reset;
			// Trace: ../../rtl/VX_issue.sv:102:5
			// expanded module instance: gpr_stage
			localparam _param_E2C9E_CORE_ID = CORE_ID;
			if (1) begin : gpr_stage
				// Trace: ../../rtl/VX_gpr_stage.sv:4:15
				localparam CORE_ID = _param_E2C9E_CORE_ID;
				// Trace: ../../rtl/VX_gpr_stage.sv:6:5
				wire clk;
				// Trace: ../../rtl/VX_gpr_stage.sv:7:5
				wire reset;
				// Trace: ../../rtl/VX_gpr_stage.sv:10:5
				// removed modport instance writeback_if
				// Trace: ../../rtl/VX_gpr_stage.sv:11:5
				// removed modport instance gpr_req_if
				// Trace: ../../rtl/VX_gpr_stage.sv:14:5
				// removed modport instance gpr_rsp_if
				// Trace: ../../rtl/VX_gpr_stage.sv:20:5
				localparam RAM_SIZE = 64;
				// Trace: ../../rtl/VX_gpr_stage.sv:23:5
				wire write_enable = VX_pipeline.writeback_if.valid && (VX_pipeline.writeback_if.rd != 0);
				// Trace: ../../rtl/VX_gpr_stage.sv:25:5
				wire [1:0] wren;
				// Trace: ../../rtl/VX_gpr_stage.sv:26:5
				genvar i;
				for (i = 0; i < 2; i = i + 1) begin : genblk1
					// Trace: ../../rtl/VX_gpr_stage.sv:27:9
					assign wren[i] = write_enable && VX_pipeline.writeback_if.tmask[i];
				end
				// Trace: ../../rtl/VX_gpr_stage.sv:30:5
				wire [5:0] waddr;
				wire [5:0] raddr1;
				wire [5:0] raddr2;
				// Trace: ../../rtl/VX_gpr_stage.sv:31:5
				assign waddr = {VX_pipeline.writeback_if.wid, VX_pipeline.writeback_if.rd};
				// Trace: ../../rtl/VX_gpr_stage.sv:32:5
				assign raddr1 = {VX_pipeline.issue.gpr_req_if.wid, VX_pipeline.issue.gpr_req_if.rs1};
				// Trace: ../../rtl/VX_gpr_stage.sv:33:5
				assign raddr2 = {VX_pipeline.issue.gpr_req_if.wid, VX_pipeline.issue.gpr_req_if.rs2};
				// Trace: ../../rtl/VX_gpr_stage.sv:35:5
				for (i = 0; i < 2; i = i + 1) begin : genblk2
					// Trace: ../../rtl/VX_gpr_stage.sv:36:9
					VX_dp_ram #(
						.DATAW(32),
						.SIZE(RAM_SIZE),
						.INIT_ENABLE(1),
						.INIT_VALUE(0)
					) dp_ram1(
						.clk(clk),
						.wren(wren[i]),
						.waddr(waddr),
						.wdata(VX_pipeline.writeback_if.data[i * 32+:32]),
						.raddr(raddr1),
						.rdata(VX_pipeline.issue.gpr_rsp_if.rs1_data[i * 32+:32])
					);
					// Trace: ../../rtl/VX_gpr_stage.sv:50:9
					VX_dp_ram #(
						.DATAW(32),
						.SIZE(RAM_SIZE),
						.INIT_ENABLE(1),
						.INIT_VALUE(0)
					) dp_ram2(
						.clk(clk),
						.wren(wren[i]),
						.waddr(waddr),
						.wdata(VX_pipeline.writeback_if.data[i * 32+:32]),
						.raddr(raddr2),
						.rdata(VX_pipeline.issue.gpr_rsp_if.rs2_data[i * 32+:32])
					);
				end
				// Trace: ../../rtl/VX_gpr_stage.sv:86:5
				assign VX_pipeline.issue.gpr_rsp_if.rs3_data = 1'sbx;
				// Trace: ../../rtl/VX_gpr_stage.sv:89:5
				assign VX_pipeline.writeback_if.ready = 1'b1;
			end
			assign gpr_stage.clk = clk;
			assign gpr_stage.reset = gpr_reset;
			// Trace: ../../rtl/VX_issue.sv:112:5
			// expanded module instance: dispatch
			if (1) begin : dispatch
				// Trace: ../../rtl/VX_dispatch.sv:4:5
				wire clk;
				// Trace: ../../rtl/VX_dispatch.sv:5:5
				wire reset;
				// Trace: ../../rtl/VX_dispatch.sv:8:5
				// removed modport instance ibuffer_if
				// Trace: ../../rtl/VX_dispatch.sv:9:5
				// removed modport instance gpr_rsp_if
				// Trace: ../../rtl/VX_dispatch.sv:12:5
				// removed modport instance alu_req_if
				// Trace: ../../rtl/VX_dispatch.sv:13:5
				// removed modport instance lsu_req_if
				// Trace: ../../rtl/VX_dispatch.sv:14:5
				// removed modport instance csr_req_if
				// Trace: ../../rtl/VX_dispatch.sv:18:5
				// removed modport instance gpu_req_if
				// Trace: ../../rtl/VX_dispatch.sv:20:5
				wire [0:0] tid;
				// Trace: ../../rtl/VX_dispatch.sv:21:5
				wire alu_req_ready;
				// Trace: ../../rtl/VX_dispatch.sv:22:5
				wire lsu_req_ready;
				// Trace: ../../rtl/VX_dispatch.sv:23:5
				wire csr_req_ready;
				// Trace: ../../rtl/VX_dispatch.sv:27:5
				wire gpu_req_ready;
				// Trace: ../../rtl/VX_dispatch.sv:29:5
				VX_lzc #(.N(2)) tid_select(
					.in_i(VX_pipeline.issue.dispatch_if.tmask),
					.cnt_o(tid)
				);
				// Trace: ../../rtl/VX_dispatch.sv:37:5
				wire [31:0] next_PC = VX_pipeline.issue.dispatch_if.PC + 4;
				// Trace: ../../rtl/VX_dispatch.sv:41:5
				wire alu_req_valid = VX_pipeline.issue.dispatch_if.valid && (VX_pipeline.issue.dispatch_if.ex_type == 3'h1);
				// Trace: ../../rtl/VX_dispatch.sv:42:5
				wire [3:0] alu_op_type = VX_pipeline.issue.dispatch_if.op_type;
				// Trace: ../../rtl/VX_dispatch.sv:44:5
				VX_skid_buffer #(
					.DATAW(287),
					.OUT_REG(1)
				) alu_buffer(
					.clk(clk),
					.reset(reset),
					.valid_in(alu_req_valid),
					.ready_in(alu_req_ready),
					.data_in({VX_pipeline.issue.dispatch_if.uuid, VX_pipeline.issue.dispatch_if.wid, VX_pipeline.issue.dispatch_if.tmask, VX_pipeline.issue.dispatch_if.PC, next_PC, alu_op_type, VX_pipeline.issue.dispatch_if.op_mod, VX_pipeline.issue.dispatch_if.imm, VX_pipeline.issue.dispatch_if.use_PC, VX_pipeline.issue.dispatch_if.use_imm, VX_pipeline.issue.dispatch_if.rd, VX_pipeline.issue.dispatch_if.wb, tid, VX_pipeline.issue.gpr_rsp_if.rs1_data, VX_pipeline.issue.gpr_rsp_if.rs2_data}),
					.data_out({VX_pipeline.alu_req_if.uuid, VX_pipeline.alu_req_if.wid, VX_pipeline.alu_req_if.tmask, VX_pipeline.alu_req_if.PC, VX_pipeline.alu_req_if.next_PC, VX_pipeline.alu_req_if.op_type, VX_pipeline.alu_req_if.op_mod, VX_pipeline.alu_req_if.imm, VX_pipeline.alu_req_if.use_PC, VX_pipeline.alu_req_if.use_imm, VX_pipeline.alu_req_if.rd, VX_pipeline.alu_req_if.wb, VX_pipeline.alu_req_if.tid, VX_pipeline.alu_req_if.rs1_data, VX_pipeline.alu_req_if.rs2_data}),
					.valid_out(VX_pipeline.alu_req_if.valid),
					.ready_out(VX_pipeline.alu_req_if.ready)
				);
				// Trace: ../../rtl/VX_dispatch.sv:60:5
				wire lsu_req_valid = VX_pipeline.issue.dispatch_if.valid && (VX_pipeline.issue.dispatch_if.ex_type == 3'h2);
				// Trace: ../../rtl/VX_dispatch.sv:61:5
				wire [3:0] lsu_op_type = VX_pipeline.issue.dispatch_if.op_type;
				// Trace: ../../rtl/VX_dispatch.sv:62:5
				wire lsu_is_fence = 3'h1 == VX_pipeline.issue.dispatch_if.op_mod;
				// Trace: ../../rtl/VX_dispatch.sv:63:5
				wire lsu_is_prefetch = 3'h2 == VX_pipeline.issue.dispatch_if.op_mod;
				// Trace: ../../rtl/VX_dispatch.sv:65:5
				VX_skid_buffer #(
					.DATAW(251),
					.OUT_REG(1)
				) lsu_buffer(
					.clk(clk),
					.reset(reset),
					.valid_in(lsu_req_valid),
					.ready_in(lsu_req_ready),
					.data_in({VX_pipeline.issue.dispatch_if.uuid, VX_pipeline.issue.dispatch_if.wid, VX_pipeline.issue.dispatch_if.tmask, VX_pipeline.issue.dispatch_if.PC, lsu_op_type, lsu_is_fence, VX_pipeline.issue.dispatch_if.imm, VX_pipeline.issue.dispatch_if.rd, VX_pipeline.issue.dispatch_if.wb, VX_pipeline.issue.gpr_rsp_if.rs1_data, VX_pipeline.issue.gpr_rsp_if.rs2_data, lsu_is_prefetch}),
					.data_out({VX_pipeline.lsu_req_if.uuid, VX_pipeline.lsu_req_if.wid, VX_pipeline.lsu_req_if.tmask, VX_pipeline.lsu_req_if.PC, VX_pipeline.lsu_req_if.op_type, VX_pipeline.lsu_req_if.is_fence, VX_pipeline.lsu_req_if.offset, VX_pipeline.lsu_req_if.rd, VX_pipeline.lsu_req_if.wb, VX_pipeline.lsu_req_if.base_addr, VX_pipeline.lsu_req_if.store_data, VX_pipeline.lsu_req_if.is_prefetch}),
					.valid_out(VX_pipeline.lsu_req_if.valid),
					.ready_out(VX_pipeline.lsu_req_if.ready)
				);
				// Trace: ../../rtl/VX_dispatch.sv:81:5
				wire csr_req_valid = VX_pipeline.issue.dispatch_if.valid && (VX_pipeline.issue.dispatch_if.ex_type == 3'h3);
				// Trace: ../../rtl/VX_dispatch.sv:82:5
				wire [1:0] csr_op_type = sv2v_cast_2(VX_pipeline.issue.dispatch_if.op_type);
				// Trace: ../../rtl/VX_dispatch.sv:83:5
				wire [11:0] csr_addr = VX_pipeline.issue.dispatch_if.imm[11:0];
				// Trace: ../../rtl/VX_dispatch.sv:84:5
				wire [4:0] csr_imm = VX_pipeline.issue.dispatch_if.imm[12+:5];
				// Trace: ../../rtl/VX_dispatch.sv:85:5
				wire [31:0] csr_rs1_data = VX_pipeline.issue.gpr_rsp_if.rs1_data[tid * 32+:32];
				// Trace: ../../rtl/VX_dispatch.sv:87:5
				VX_skid_buffer #(
					.DATAW(137),
					.OUT_REG(1)
				) csr_buffer(
					.clk(clk),
					.reset(reset),
					.valid_in(csr_req_valid),
					.ready_in(csr_req_ready),
					.data_in({VX_pipeline.issue.dispatch_if.uuid, VX_pipeline.issue.dispatch_if.wid, VX_pipeline.issue.dispatch_if.tmask, VX_pipeline.issue.dispatch_if.PC, csr_op_type, csr_addr, VX_pipeline.issue.dispatch_if.rd, VX_pipeline.issue.dispatch_if.wb, VX_pipeline.issue.dispatch_if.use_imm, csr_imm, csr_rs1_data}),
					.data_out({VX_pipeline.csr_req_if.uuid, VX_pipeline.csr_req_if.wid, VX_pipeline.csr_req_if.tmask, VX_pipeline.csr_req_if.PC, VX_pipeline.csr_req_if.op_type, VX_pipeline.csr_req_if.addr, VX_pipeline.csr_req_if.rd, VX_pipeline.csr_req_if.wb, VX_pipeline.csr_req_if.use_imm, VX_pipeline.csr_req_if.imm, VX_pipeline.csr_req_if.rs1_data}),
					.valid_out(VX_pipeline.csr_req_if.valid),
					.ready_out(VX_pipeline.csr_req_if.ready)
				);
				// Trace: ../../rtl/VX_dispatch.sv:126:5
				wire gpu_req_valid = VX_pipeline.issue.dispatch_if.valid && (VX_pipeline.issue.dispatch_if.ex_type == 3'h5);
				// Trace: ../../rtl/VX_dispatch.sv:127:5
				wire [3:0] gpu_op_type = VX_pipeline.issue.dispatch_if.op_type;
				// Trace: ../../rtl/VX_dispatch.sv:129:5
				VX_skid_buffer #(
					.DATAW(317),
					.OUT_REG(1)
				) gpu_buffer(
					.clk(clk),
					.reset(reset),
					.valid_in(gpu_req_valid),
					.ready_in(gpu_req_ready),
					.data_in({VX_pipeline.issue.dispatch_if.uuid, VX_pipeline.issue.dispatch_if.wid, VX_pipeline.issue.dispatch_if.tmask, VX_pipeline.issue.dispatch_if.PC, next_PC, gpu_op_type, VX_pipeline.issue.dispatch_if.op_mod, VX_pipeline.issue.dispatch_if.rd, VX_pipeline.issue.dispatch_if.wb, tid, VX_pipeline.issue.gpr_rsp_if.rs1_data, VX_pipeline.issue.gpr_rsp_if.rs2_data, VX_pipeline.issue.gpr_rsp_if.rs3_data}),
					.data_out({VX_pipeline.gpu_req_if.uuid, VX_pipeline.gpu_req_if.wid, VX_pipeline.gpu_req_if.tmask, VX_pipeline.gpu_req_if.PC, VX_pipeline.gpu_req_if.next_PC, VX_pipeline.gpu_req_if.op_type, VX_pipeline.gpu_req_if.op_mod, VX_pipeline.gpu_req_if.rd, VX_pipeline.gpu_req_if.wb, VX_pipeline.gpu_req_if.tid, VX_pipeline.gpu_req_if.rs1_data, VX_pipeline.gpu_req_if.rs2_data, VX_pipeline.gpu_req_if.rs3_data}),
					.valid_out(VX_pipeline.gpu_req_if.valid),
					.ready_out(VX_pipeline.gpu_req_if.ready)
				);
				// Trace: ../../rtl/VX_dispatch.sv:144:5
				reg ready_r;
				// Trace: ../../rtl/VX_dispatch.sv:145:5
				always @(*)
					// Trace: ../../rtl/VX_dispatch.sv:146:9
					case (VX_pipeline.issue.dispatch_if.ex_type)
						3'h1:
							// Trace: ../../rtl/VX_dispatch.sv:147:18
							ready_r = alu_req_ready;
						3'h2:
							// Trace: ../../rtl/VX_dispatch.sv:148:18
							ready_r = lsu_req_ready;
						3'h3:
							// Trace: ../../rtl/VX_dispatch.sv:149:18
							ready_r = csr_req_ready;
						3'h5:
							// Trace: ../../rtl/VX_dispatch.sv:153:18
							ready_r = gpu_req_ready;
						default:
							// Trace: ../../rtl/VX_dispatch.sv:154:18
							ready_r = 1'b1;
					endcase
				// Trace: ../../rtl/VX_dispatch.sv:157:5
				assign VX_pipeline.issue.dispatch_if.ready = ready_r;
			end
			assign dispatch.clk = clk;
			assign dispatch.reset = dispatch_reset;
		end
	endgenerate
	assign issue.clk = clk;
	assign issue.reset = issue_reset;
	// Trace: ../../rtl/VX_pipeline.sv:201:5
	// expanded module instance: execute
	localparam _param_B78CA_CORE_ID = CORE_ID;
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	function automatic [2:0] sv2v_cast_3;
		input reg [2:0] inp;
		sv2v_cast_3 = inp;
	endfunction
	function automatic [25:0] sv2v_cast_26;
		input reg [25:0] inp;
		sv2v_cast_26 = inp;
	endfunction
	function automatic signed [25:0] sv2v_cast_26_signed;
		input reg signed [25:0] inp;
		sv2v_cast_26_signed = inp;
	endfunction
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	function automatic [63:0] sv2v_cast_64;
		input reg [63:0] inp;
		sv2v_cast_64 = inp;
	endfunction
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	generate
		if (1) begin : execute
			// Trace: ../../rtl/VX_execute.sv:4:15
			localparam CORE_ID = _param_B78CA_CORE_ID;
			// Trace: ../../rtl/VX_execute.sv:8:5
			wire clk;
			// Trace: ../../rtl/VX_execute.sv:9:5
			wire reset;
			// Trace: ../../rtl/VX_execute.sv:12:5
			// removed modport instance dcache_req_if
			// Trace: ../../rtl/VX_execute.sv:13:5
			// removed modport instance dcache_rsp_if
			// Trace: ../../rtl/VX_execute.sv:16:5
			// removed modport instance cmt_to_csr_if
			// Trace: ../../rtl/VX_execute.sv:19:5
			// removed modport instance fetch_to_csr_if
			// Trace: ../../rtl/VX_execute.sv:27:5
			// removed modport instance alu_req_if
			// Trace: ../../rtl/VX_execute.sv:28:5
			// removed modport instance lsu_req_if
			// Trace: ../../rtl/VX_execute.sv:29:5
			// removed modport instance csr_req_if
			// Trace: ../../rtl/VX_execute.sv:33:5
			// removed modport instance gpu_req_if
			// Trace: ../../rtl/VX_execute.sv:36:5
			// removed modport instance branch_ctl_if
			// Trace: ../../rtl/VX_execute.sv:37:5
			// removed modport instance warp_ctl_if
			// Trace: ../../rtl/VX_execute.sv:38:5
			// removed modport instance alu_commit_if
			// Trace: ../../rtl/VX_execute.sv:39:5
			// removed modport instance ld_commit_if
			// Trace: ../../rtl/VX_execute.sv:40:5
			// removed modport instance st_commit_if
			// Trace: ../../rtl/VX_execute.sv:41:5
			// removed modport instance csr_commit_if
			// Trace: ../../rtl/VX_execute.sv:45:5
			// removed modport instance gpu_commit_if
			// Trace: ../../rtl/VX_execute.sv:47:5
			wire busy;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:133:22
			wire alu_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:133:55
			VX_reset_relay __alu_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(alu_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:134:22
			wire lsu_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:134:55
			VX_reset_relay __lsu_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(lsu_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:135:22
			wire csr_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:135:55
			VX_reset_relay __csr_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(csr_reset)
			);
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:136:22
			wire gpu_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/VX_execute.sv:136:55
			VX_reset_relay __gpu_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(gpu_reset)
			);
			// Trace: ../../rtl/VX_execute.sv:138:5
			// expanded module instance: alu_unit
			localparam _param_4B10A_CORE_ID = CORE_ID;
			if (1) begin : alu_unit
				// Trace: ../../rtl/VX_alu_unit.sv:4:15
				localparam CORE_ID = _param_4B10A_CORE_ID;
				// Trace: ../../rtl/VX_alu_unit.sv:6:5
				wire clk;
				// Trace: ../../rtl/VX_alu_unit.sv:7:5
				wire reset;
				// Trace: ../../rtl/VX_alu_unit.sv:10:5
				// removed modport instance alu_req_if
				// Trace: ../../rtl/VX_alu_unit.sv:13:5
				// removed modport instance branch_ctl_if
				// Trace: ../../rtl/VX_alu_unit.sv:14:5
				// removed modport instance alu_commit_if
				// Trace: ../../rtl/VX_alu_unit.sv:19:5
				reg [63:0] alu_result;
				// Trace: ../../rtl/VX_alu_unit.sv:20:5
				wire [63:0] add_result;
				// Trace: ../../rtl/VX_alu_unit.sv:21:5
				wire [65:0] sub_result;
				// Trace: ../../rtl/VX_alu_unit.sv:22:5
				wire [63:0] shr_result;
				// Trace: ../../rtl/VX_alu_unit.sv:23:5
				reg [63:0] msc_result;
				// Trace: ../../rtl/VX_alu_unit.sv:25:5
				wire ready_in;
				// Trace: ../../rtl/VX_alu_unit.sv:28:5
				wire is_br_op = VX_pipeline.alu_req_if.op_mod[0];
				// Trace: ../../rtl/VX_alu_unit.sv:29:5
				wire [3:0] alu_op = VX_pipeline.alu_req_if.op_type;
				// Trace: ../../rtl/VX_alu_unit.sv:30:5
				wire [3:0] br_op = VX_pipeline.alu_req_if.op_type;
				// Trace: ../../rtl/VX_alu_unit.sv:31:5
				wire alu_signed = alu_op[0];
				// Trace: ../../rtl/VX_alu_unit.sv:32:5
				wire [1:0] alu_op_class = alu_op[3:2];
				// Trace: ../../rtl/VX_alu_unit.sv:33:5
				wire is_sub = alu_op == 4'b1011;
				// Trace: ../../rtl/VX_alu_unit.sv:35:5
				wire [63:0] alu_in1 = VX_pipeline.alu_req_if.rs1_data;
				// Trace: ../../rtl/VX_alu_unit.sv:36:5
				wire [63:0] alu_in2 = VX_pipeline.alu_req_if.rs2_data;
				// Trace: ../../rtl/VX_alu_unit.sv:38:5
				wire [63:0] alu_in1_PC = (VX_pipeline.alu_req_if.use_PC ? {2 {VX_pipeline.alu_req_if.PC}} : alu_in1);
				// Trace: ../../rtl/VX_alu_unit.sv:39:5
				wire [63:0] alu_in2_imm = (VX_pipeline.alu_req_if.use_imm ? {2 {VX_pipeline.alu_req_if.imm}} : alu_in2);
				// Trace: ../../rtl/VX_alu_unit.sv:40:5
				wire [63:0] alu_in2_less = (VX_pipeline.alu_req_if.use_imm && ~is_br_op ? {2 {VX_pipeline.alu_req_if.imm}} : alu_in2);
				// Trace: ../../rtl/VX_alu_unit.sv:42:5
				genvar i;
				for (i = 0; i < 2; i = i + 1) begin : genblk1
					// Trace: ../../rtl/VX_alu_unit.sv:43:9
					assign add_result[i * 32+:32] = alu_in1_PC[i * 32+:32] + alu_in2_imm[i * 32+:32];
				end
				// Trace: ../../rtl/VX_alu_unit.sv:46:5
				for (i = 0; i < 2; i = i + 1) begin : genblk2
					// Trace: ../../rtl/VX_alu_unit.sv:47:9
					wire [32:0] sub_in1 = {alu_signed & alu_in1[(i * 32) + 31], alu_in1[i * 32+:32]};
					// Trace: ../../rtl/VX_alu_unit.sv:48:9
					wire [32:0] sub_in2 = {alu_signed & alu_in2_less[(i * 32) + 31], alu_in2_less[i * 32+:32]};
					// Trace: ../../rtl/VX_alu_unit.sv:49:9
					assign sub_result[i * 33+:33] = sub_in1 - sub_in2;
				end
				// Trace: ../../rtl/VX_alu_unit.sv:52:5
				for (i = 0; i < 2; i = i + 1) begin : genblk3
					// Trace: ../../rtl/VX_alu_unit.sv:53:9
					wire [32:0] shr_in1 = {alu_signed & alu_in1[(i * 32) + 31], alu_in1[i * 32+:32]};
					// Trace: ../../rtl/VX_alu_unit.sv:54:9
					assign shr_result[i * 32+:32] = sv2v_cast_32_signed($signed(shr_in1) >>> alu_in2_imm[(i * 32) + 4-:5]);
				end
				// Trace: ../../rtl/VX_alu_unit.sv:57:5
				for (i = 0; i < 2; i = i + 1) begin : genblk4
					// Trace: ../../rtl/VX_alu_unit.sv:58:9
					always @(*)
						// Trace: ../../rtl/VX_alu_unit.sv:59:13
						case (alu_op)
							4'b1100:
								// Trace: ../../rtl/VX_alu_unit.sv:60:32
								msc_result[i * 32+:32] = alu_in1[i * 32+:32] & alu_in2_imm[i * 32+:32];
							4'b1101:
								// Trace: ../../rtl/VX_alu_unit.sv:61:32
								msc_result[i * 32+:32] = alu_in1[i * 32+:32] | alu_in2_imm[i * 32+:32];
							4'b1110:
								// Trace: ../../rtl/VX_alu_unit.sv:62:32
								msc_result[i * 32+:32] = alu_in1[i * 32+:32] ^ alu_in2_imm[i * 32+:32];
							default:
								// Trace: ../../rtl/VX_alu_unit.sv:64:27
								msc_result[i * 32+:32] = alu_in1[i * 32+:32] << alu_in2_imm[(i * 32) + 4-:5];
						endcase
				end
				// Trace: ../../rtl/VX_alu_unit.sv:69:5
				for (i = 0; i < 2; i = i + 1) begin : genblk5
					// Trace: ../../rtl/VX_alu_unit.sv:70:9
					always @(*)
						// Trace: ../../rtl/VX_alu_unit.sv:71:13
						case (alu_op_class)
							2'b00:
								// Trace: ../../rtl/VX_alu_unit.sv:72:24
								alu_result[i * 32+:32] = add_result[i * 32+:32];
							2'b01:
								// Trace: ../../rtl/VX_alu_unit.sv:73:24
								alu_result[i * 32+:32] = {31'b0000000000000000000000000000000, sub_result[(i * 33) + 32]};
							2'b10:
								// Trace: ../../rtl/VX_alu_unit.sv:74:24
								alu_result[i * 32+:32] = (is_sub ? sub_result[(i * 33) + 31-:32] : shr_result[i * 32+:32]);
							default:
								// Trace: ../../rtl/VX_alu_unit.sv:77:26
								alu_result[i * 32+:32] = msc_result[i * 32+:32];
						endcase
				end
				// Trace: ../../rtl/VX_alu_unit.sv:84:5
				wire is_jal = is_br_op && ((br_op == 4'b1000) || (br_op == 4'b1001));
				// Trace: ../../rtl/VX_alu_unit.sv:85:5
				wire [63:0] alu_jal_result = (is_jal ? {2 {VX_pipeline.alu_req_if.next_PC}} : alu_result);
				// Trace: ../../rtl/VX_alu_unit.sv:87:5
				wire [31:0] br_dest = add_result[VX_pipeline.alu_req_if.tid * 32+:32];
				// Trace: ../../rtl/VX_alu_unit.sv:88:5
				wire [32:0] cmp_result = sub_result[VX_pipeline.alu_req_if.tid * 33+:33];
				// Trace: ../../rtl/VX_alu_unit.sv:90:5
				wire is_less = cmp_result[32];
				// Trace: ../../rtl/VX_alu_unit.sv:91:5
				wire is_equal = ~(|cmp_result[31:0]);
				// Trace: ../../rtl/VX_alu_unit.sv:95:5
				wire alu_valid_in;
				// Trace: ../../rtl/VX_alu_unit.sv:96:5
				wire alu_ready_in;
				// Trace: ../../rtl/VX_alu_unit.sv:97:5
				wire alu_valid_out;
				// Trace: ../../rtl/VX_alu_unit.sv:98:5
				wire alu_ready_out;
				// Trace: ../../rtl/VX_alu_unit.sv:99:5
				wire [43:0] alu_uuid;
				// Trace: ../../rtl/VX_alu_unit.sv:100:5
				wire [0:0] alu_wid;
				// Trace: ../../rtl/VX_alu_unit.sv:101:5
				wire [1:0] alu_tmask;
				// Trace: ../../rtl/VX_alu_unit.sv:102:5
				wire [31:0] alu_PC;
				// Trace: ../../rtl/VX_alu_unit.sv:103:5
				wire [4:0] alu_rd;
				// Trace: ../../rtl/VX_alu_unit.sv:104:5
				wire alu_wb;
				// Trace: ../../rtl/VX_alu_unit.sv:105:5
				wire [63:0] alu_data;
				// Trace: ../../rtl/VX_alu_unit.sv:107:5
				wire [3:0] br_op_r;
				// Trace: ../../rtl/VX_alu_unit.sv:108:5
				wire [31:0] br_dest_r;
				// Trace: ../../rtl/VX_alu_unit.sv:109:5
				wire is_less_r;
				// Trace: ../../rtl/VX_alu_unit.sv:110:5
				wire is_equal_r;
				// Trace: ../../rtl/VX_alu_unit.sv:111:5
				wire is_br_op_r;
				// Trace: ../../rtl/VX_alu_unit.sv:113:5
				assign alu_ready_in = alu_ready_out || ~alu_valid_out;
				// Trace: ../../rtl/VX_alu_unit.sv:115:5
				VX_pipe_register #(
					.DATAW(189),
					.RESETW(1)
				) pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(alu_ready_in),
					.data_in({alu_valid_in, VX_pipeline.alu_req_if.uuid, VX_pipeline.alu_req_if.wid, VX_pipeline.alu_req_if.tmask, VX_pipeline.alu_req_if.PC, VX_pipeline.alu_req_if.rd, VX_pipeline.alu_req_if.wb, alu_jal_result, is_br_op, br_op, is_less, is_equal, br_dest}),
					.data_out({alu_valid_out, alu_uuid, alu_wid, alu_tmask, alu_PC, alu_rd, alu_wb, alu_data, is_br_op_r, br_op_r, is_less_r, is_equal_r, br_dest_r})
				);
				// Trace: ../../rtl/VX_alu_unit.sv:127:5
				wire br_neg = br_op_r[1];
				// Trace: ../../rtl/VX_alu_unit.sv:128:5
				wire br_less = br_op_r[2];
				// Trace: ../../rtl/VX_alu_unit.sv:129:5
				wire br_static = br_op_r[3];
				// Trace: ../../rtl/VX_alu_unit.sv:131:5
				assign VX_pipeline.branch_ctl_if.valid = (alu_valid_out && alu_ready_out) && is_br_op_r;
				// Trace: ../../rtl/VX_alu_unit.sv:132:5
				assign VX_pipeline.branch_ctl_if.taken = ((br_less ? is_less_r : is_equal_r) ^ br_neg) | br_static;
				// Trace: ../../rtl/VX_alu_unit.sv:133:5
				assign VX_pipeline.branch_ctl_if.wid = alu_wid;
				// Trace: ../../rtl/VX_alu_unit.sv:134:5
				assign VX_pipeline.branch_ctl_if.dest = br_dest_r;
				// Trace: ../../rtl/VX_alu_unit.sv:138:5
				wire mul_valid_in;
				// Trace: ../../rtl/VX_alu_unit.sv:139:5
				wire mul_ready_in;
				// Trace: ../../rtl/VX_alu_unit.sv:140:5
				wire mul_valid_out;
				// Trace: ../../rtl/VX_alu_unit.sv:141:5
				wire mul_ready_out;
				// Trace: ../../rtl/VX_alu_unit.sv:142:5
				wire [43:0] mul_uuid;
				// Trace: ../../rtl/VX_alu_unit.sv:143:5
				wire [0:0] mul_wid;
				// Trace: ../../rtl/VX_alu_unit.sv:144:5
				wire [1:0] mul_tmask;
				// Trace: ../../rtl/VX_alu_unit.sv:145:5
				wire [31:0] mul_PC;
				// Trace: ../../rtl/VX_alu_unit.sv:146:5
				wire [4:0] mul_rd;
				// Trace: ../../rtl/VX_alu_unit.sv:147:5
				wire mul_wb;
				// Trace: ../../rtl/VX_alu_unit.sv:148:5
				wire [63:0] mul_data;
				// Trace: ../../rtl/VX_alu_unit.sv:150:5
				wire [2:0] mul_op = sv2v_cast_3(VX_pipeline.alu_req_if.op_type);
				// Trace: ../../rtl/VX_alu_unit.sv:152:5
				VX_muldiv muldiv(
					.clk(clk),
					.reset(reset),
					.alu_op(mul_op),
					.uuid_in(VX_pipeline.alu_req_if.uuid),
					.wid_in(VX_pipeline.alu_req_if.wid),
					.tmask_in(VX_pipeline.alu_req_if.tmask),
					.PC_in(VX_pipeline.alu_req_if.PC),
					.rd_in(VX_pipeline.alu_req_if.rd),
					.wb_in(VX_pipeline.alu_req_if.wb),
					.alu_in1(VX_pipeline.alu_req_if.rs1_data),
					.alu_in2(VX_pipeline.alu_req_if.rs2_data),
					.wid_out(mul_wid),
					.uuid_out(mul_uuid),
					.tmask_out(mul_tmask),
					.PC_out(mul_PC),
					.rd_out(mul_rd),
					.wb_out(mul_wb),
					.data_out(mul_data),
					.valid_in(mul_valid_in),
					.ready_in(mul_ready_in),
					.valid_out(mul_valid_out),
					.ready_out(mul_ready_out)
				);
				// Trace: ../../rtl/VX_alu_unit.sv:183:5
				wire is_mul_op = VX_pipeline.alu_req_if.op_mod[1];
				// Trace: ../../rtl/VX_alu_unit.sv:185:5
				assign ready_in = (is_mul_op ? mul_ready_in : alu_ready_in);
				// Trace: ../../rtl/VX_alu_unit.sv:187:5
				assign alu_valid_in = VX_pipeline.alu_req_if.valid && ~is_mul_op;
				// Trace: ../../rtl/VX_alu_unit.sv:188:5
				assign mul_valid_in = VX_pipeline.alu_req_if.valid && is_mul_op;
				// Trace: ../../rtl/VX_alu_unit.sv:190:5
				assign VX_pipeline.alu_commit_if.valid = alu_valid_out || mul_valid_out;
				// Trace: ../../rtl/VX_alu_unit.sv:191:5
				assign VX_pipeline.alu_commit_if.uuid = (alu_valid_out ? alu_uuid : mul_uuid);
				// Trace: ../../rtl/VX_alu_unit.sv:192:5
				assign VX_pipeline.alu_commit_if.wid = (alu_valid_out ? alu_wid : mul_wid);
				// Trace: ../../rtl/VX_alu_unit.sv:193:5
				assign VX_pipeline.alu_commit_if.tmask = (alu_valid_out ? alu_tmask : mul_tmask);
				// Trace: ../../rtl/VX_alu_unit.sv:194:5
				assign VX_pipeline.alu_commit_if.PC = (alu_valid_out ? alu_PC : mul_PC);
				// Trace: ../../rtl/VX_alu_unit.sv:195:5
				assign VX_pipeline.alu_commit_if.rd = (alu_valid_out ? alu_rd : mul_rd);
				// Trace: ../../rtl/VX_alu_unit.sv:196:5
				assign VX_pipeline.alu_commit_if.wb = (alu_valid_out ? alu_wb : mul_wb);
				// Trace: ../../rtl/VX_alu_unit.sv:197:5
				assign VX_pipeline.alu_commit_if.data = (alu_valid_out ? alu_data : mul_data);
				// Trace: ../../rtl/VX_alu_unit.sv:199:5
				assign alu_ready_out = VX_pipeline.alu_commit_if.ready;
				// Trace: ../../rtl/VX_alu_unit.sv:200:5
				assign mul_ready_out = VX_pipeline.alu_commit_if.ready & ~alu_valid_out;
				// Trace: ../../rtl/VX_alu_unit.sv:221:5
				assign VX_pipeline.alu_commit_if.eop = 1'b1;
				// Trace: ../../rtl/VX_alu_unit.sv:224:5
				assign VX_pipeline.alu_req_if.ready = ready_in;
			end
			assign alu_unit.clk = clk;
			assign alu_unit.reset = alu_reset;
			// Trace: ../../rtl/VX_execute.sv:148:5
			// expanded module instance: lsu_unit
			localparam _param_54826_CORE_ID = CORE_ID;
			if (1) begin : lsu_unit
				// Trace: ../../rtl/VX_lsu_unit.sv:4:15
				localparam CORE_ID = _param_54826_CORE_ID;
				// Trace: ../../rtl/VX_lsu_unit.sv:8:5
				wire clk;
				// Trace: ../../rtl/VX_lsu_unit.sv:9:5
				wire reset;
				// Trace: ../../rtl/VX_lsu_unit.sv:12:5
				// removed modport instance dcache_req_if
				// Trace: ../../rtl/VX_lsu_unit.sv:13:5
				// removed modport instance dcache_rsp_if
				// Trace: ../../rtl/VX_lsu_unit.sv:16:5
				// removed modport instance lsu_req_if
				// Trace: ../../rtl/VX_lsu_unit.sv:19:5
				// removed modport instance ld_commit_if
				// Trace: ../../rtl/VX_lsu_unit.sv:20:5
				// removed modport instance st_commit_if
				// Trace: ../../rtl/VX_lsu_unit.sv:22:5
				localparam MEM_ASHIFT = 6;
				// Trace: ../../rtl/VX_lsu_unit.sv:23:5
				localparam MEM_ADDRW = 26;
				// Trace: ../../rtl/VX_lsu_unit.sv:24:5
				localparam REQ_ASHIFT = 2;
				// Trace: ../../rtl/VX_lsu_unit.sv:30:5
				wire req_valid;
				// Trace: ../../rtl/VX_lsu_unit.sv:31:5
				wire [43:0] req_uuid;
				// Trace: ../../rtl/VX_lsu_unit.sv:32:5
				wire [1:0] req_tmask;
				// Trace: ../../rtl/VX_lsu_unit.sv:33:5
				wire [63:0] req_addr;
				// Trace: ../../rtl/VX_lsu_unit.sv:34:5
				wire [3:0] req_type;
				// Trace: ../../rtl/VX_lsu_unit.sv:35:5
				wire [63:0] req_data;
				// Trace: ../../rtl/VX_lsu_unit.sv:36:5
				wire [4:0] req_rd;
				// Trace: ../../rtl/VX_lsu_unit.sv:37:5
				wire req_wb;
				// Trace: ../../rtl/VX_lsu_unit.sv:38:5
				wire [0:0] req_wid;
				// Trace: ../../rtl/VX_lsu_unit.sv:39:5
				wire [31:0] req_pc;
				// Trace: ../../rtl/VX_lsu_unit.sv:40:5
				wire req_is_dup;
				// Trace: ../../rtl/VX_lsu_unit.sv:41:5
				wire req_is_prefetch;
				// Trace: ../../rtl/VX_lsu_unit.sv:43:5
				wire mbuf_empty;
				// Trace: ../../rtl/VX_lsu_unit.sv:45:5
				wire [3:0] lsu_addr_type;
				wire [3:0] req_addr_type;
				// Trace: ../../rtl/VX_lsu_unit.sv:48:5
				wire [63:0] full_addr;
				// Trace: ../../rtl/VX_lsu_unit.sv:49:5
				genvar i;
				for (i = 0; i < 2; i = i + 1) begin : genblk1
					// Trace: ../../rtl/VX_lsu_unit.sv:50:9
					assign full_addr[i * 32+:32] = VX_pipeline.lsu_req_if.base_addr[i * 32+:32] + VX_pipeline.lsu_req_if.offset;
				end
				// Trace: ../../rtl/VX_lsu_unit.sv:54:5
				wire [0:0] addr_matches;
				// Trace: ../../rtl/VX_lsu_unit.sv:55:5
				for (i = 0; i < 1; i = i + 1) begin : genblk2
					// Trace: ../../rtl/VX_lsu_unit.sv:56:9
					assign addr_matches[i] = (VX_pipeline.lsu_req_if.base_addr[(i + 1) * 32+:32] == VX_pipeline.lsu_req_if.base_addr[0+:32]) || ~VX_pipeline.lsu_req_if.tmask[i + 1];
				end
				// Trace: ../../rtl/VX_lsu_unit.sv:59:5
				wire lsu_is_dup = VX_pipeline.lsu_req_if.tmask[0] && &addr_matches;
				// Trace: ../../rtl/VX_lsu_unit.sv:61:5
				for (i = 0; i < 2; i = i + 1) begin : genblk3
					// Trace: ../../rtl/VX_lsu_unit.sv:63:9
					wire is_addr_nc = full_addr[(i * 32) + MEM_ASHIFT+:MEM_ADDRW] >= sv2v_cast_26(32'hff000000 >> MEM_ASHIFT);
					if (1) begin : genblk1
						// Trace: ../../rtl/VX_lsu_unit.sv:66:13
						wire is_addr_sm = (full_addr[(i * 32) + MEM_ASHIFT+:MEM_ADDRW] >= sv2v_cast_26_signed(33'sd4278185984 >> MEM_ASHIFT)) & (full_addr[(i * 32) + MEM_ASHIFT+:MEM_ADDRW] < sv2v_cast_26(32'hff000000 >> MEM_ASHIFT));
						// Trace: ../../rtl/VX_lsu_unit.sv:68:13
						assign lsu_addr_type[i * 2+:2] = {is_addr_nc, is_addr_sm};
					end
				end
				// Trace: ../../rtl/VX_lsu_unit.sv:75:5
				wire fence_wait = VX_pipeline.lsu_req_if.is_fence && (req_valid || !mbuf_empty);
				// Trace: ../../rtl/VX_lsu_unit.sv:77:5
				wire ready_in;
				// Trace: ../../rtl/VX_lsu_unit.sv:78:5
				wire stall_in = ~ready_in && req_valid;
				// Trace: ../../rtl/VX_lsu_unit.sv:80:5
				wire lsu_valid = VX_pipeline.lsu_req_if.valid && ~fence_wait;
				// Trace: ../../rtl/VX_lsu_unit.sv:82:5
				wire lsu_wb = VX_pipeline.lsu_req_if.wb | VX_pipeline.lsu_req_if.is_prefetch;
				// Trace: ../../rtl/VX_lsu_unit.sv:84:5
				VX_pipe_register #(
					.DATAW(224),
					.RESETW(1)
				) req_pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(!stall_in),
					.data_in({lsu_valid, lsu_is_dup, VX_pipeline.lsu_req_if.is_prefetch, VX_pipeline.lsu_req_if.uuid, VX_pipeline.lsu_req_if.wid, VX_pipeline.lsu_req_if.tmask, VX_pipeline.lsu_req_if.PC, full_addr, lsu_addr_type, VX_pipeline.lsu_req_if.op_type, VX_pipeline.lsu_req_if.rd, lsu_wb, VX_pipeline.lsu_req_if.store_data}),
					.data_out({req_valid, req_is_dup, req_is_prefetch, req_uuid, req_wid, req_tmask, req_pc, req_addr, req_addr_type, req_type, req_rd, req_wb, req_data})
				);
				// Trace: ../../rtl/VX_lsu_unit.sv:96:5
				assign VX_pipeline.lsu_req_if.ready = ~stall_in && ~fence_wait;
				// Trace: ../../rtl/VX_lsu_unit.sv:98:5
				wire [43:0] rsp_uuid;
				// Trace: ../../rtl/VX_lsu_unit.sv:99:5
				wire [0:0] rsp_wid;
				// Trace: ../../rtl/VX_lsu_unit.sv:100:5
				wire [31:0] rsp_pc;
				// Trace: ../../rtl/VX_lsu_unit.sv:101:5
				wire [4:0] rsp_rd;
				// Trace: ../../rtl/VX_lsu_unit.sv:102:5
				wire rsp_wb;
				// Trace: ../../rtl/VX_lsu_unit.sv:103:5
				wire [3:0] rsp_type;
				// Trace: ../../rtl/VX_lsu_unit.sv:104:5
				wire rsp_is_dup;
				// Trace: ../../rtl/VX_lsu_unit.sv:105:5
				wire rsp_is_prefetch;
				// Trace: ../../rtl/VX_lsu_unit.sv:107:5
				reg [7:0] rsp_rem_mask;
				// Trace: ../../rtl/VX_lsu_unit.sv:108:5
				wire [1:0] rsp_rem_mask_n;
				// Trace: ../../rtl/VX_lsu_unit.sv:109:5
				wire [1:0] rsp_tmask;
				// Trace: ../../rtl/VX_lsu_unit.sv:111:5
				reg [1:0] req_sent_mask;
				// Trace: ../../rtl/VX_lsu_unit.sv:112:5
				reg is_req_start;
				// Trace: ../../rtl/VX_lsu_unit.sv:114:5
				wire [1:0] mbuf_waddr;
				wire [1:0] mbuf_raddr;
				// Trace: ../../rtl/VX_lsu_unit.sv:115:5
				wire mbuf_full;
				// Trace: ../../rtl/VX_lsu_unit.sv:120:5
				wire [3:0] req_offset;
				wire [3:0] rsp_offset;
				// Trace: ../../rtl/VX_lsu_unit.sv:121:5
				for (i = 0; i < 2; i = i + 1) begin : genblk4
					// Trace: ../../rtl/VX_lsu_unit.sv:122:9
					assign req_offset[i * 2+:2] = req_addr[(i * 32) + 1-:2];
				end
				// Trace: ../../rtl/VX_lsu_unit.sv:125:5
				wire [1:0] dcache_req_fire = VX_pipeline.dcache_req_if.valid & VX_pipeline.dcache_req_if.ready;
				// Trace: ../../rtl/VX_lsu_unit.sv:127:5
				wire dcache_rsp_fire = VX_pipeline.dcache_rsp_if.valid && VX_pipeline.dcache_rsp_if.ready;
				// Trace: ../../rtl/VX_lsu_unit.sv:129:5
				wire [1:0] req_tmask_dup = req_tmask & {~req_is_dup, 1'b1};
				// Trace: ../../rtl/VX_lsu_unit.sv:131:5
				wire mbuf_push = ((~mbuf_full && |(({2 {req_valid}} & req_tmask_dup) & VX_pipeline.dcache_req_if.ready)) && is_req_start) && req_wb;
				// Trace: ../../rtl/VX_lsu_unit.sv:136:5
				wire mbuf_pop = dcache_rsp_fire && (0 == rsp_rem_mask_n);
				// Trace: ../../rtl/VX_lsu_unit.sv:138:5
				assign mbuf_raddr = VX_pipeline.dcache_rsp_if.tag[2+:2];
				// Trace: ../../rtl/VX_lsu_unit.sv:142:5
				wire req_wb2 = req_wb && ~req_is_prefetch;
				// Trace: ../../rtl/VX_lsu_unit.sv:144:5
				VX_index_buffer #(
					.DATAW(95),
					.SIZE(4)
				) req_metadata(
					.clk(clk),
					.reset(reset),
					.write_addr(mbuf_waddr),
					.acquire_slot(mbuf_push),
					.read_addr(mbuf_raddr),
					.write_data({req_uuid, req_wid, req_pc, req_tmask, req_rd, req_wb2, req_type, req_offset, req_is_dup, req_is_prefetch}),
					.read_data({rsp_uuid, rsp_wid, rsp_pc, rsp_tmask, rsp_rd, rsp_wb, rsp_type, rsp_offset, rsp_is_dup, rsp_is_prefetch}),
					.release_addr(mbuf_raddr),
					.release_slot(mbuf_pop),
					.full(mbuf_full),
					.empty(mbuf_empty)
				);
				// Trace: ../../rtl/VX_lsu_unit.sv:161:5
				wire dcache_req_ready = &((VX_pipeline.dcache_req_if.ready | req_sent_mask) | ~req_tmask_dup);
				// Trace: ../../rtl/VX_lsu_unit.sv:163:5
				wire [1:0] req_sent_mask_n = req_sent_mask | dcache_req_fire;
				// Trace: ../../rtl/VX_lsu_unit.sv:165:5
				always @(posedge clk)
					// Trace: ../../rtl/VX_lsu_unit.sv:166:9
					if (reset) begin
						// Trace: ../../rtl/VX_lsu_unit.sv:167:13
						req_sent_mask <= 0;
						// Trace: ../../rtl/VX_lsu_unit.sv:168:13
						is_req_start <= 1;
					end
					else
						// Trace: ../../rtl/VX_lsu_unit.sv:170:13
						if (dcache_req_ready) begin
							// Trace: ../../rtl/VX_lsu_unit.sv:171:17
							req_sent_mask <= 0;
							// Trace: ../../rtl/VX_lsu_unit.sv:172:17
							is_req_start <= 1;
						end
						else begin
							// Trace: ../../rtl/VX_lsu_unit.sv:174:17
							req_sent_mask <= req_sent_mask_n;
							// Trace: ../../rtl/VX_lsu_unit.sv:175:17
							is_req_start <= 0 == req_sent_mask_n;
						end
				// Trace: ../../rtl/VX_lsu_unit.sv:181:5
				reg [1:0] req_tag_hold;
				// Trace: ../../rtl/VX_lsu_unit.sv:182:5
				wire [1:0] req_tag = (is_req_start ? mbuf_waddr : req_tag_hold);
				// Trace: ../../rtl/VX_lsu_unit.sv:183:5
				always @(posedge clk)
					// Trace: ../../rtl/VX_lsu_unit.sv:184:9
					if (mbuf_push)
						// Trace: ../../rtl/VX_lsu_unit.sv:185:13
						req_tag_hold <= mbuf_waddr;
				// Trace: ../../rtl/VX_lsu_unit.sv:189:5
				assign rsp_rem_mask_n = rsp_rem_mask[mbuf_raddr * 2+:2] & ~VX_pipeline.dcache_rsp_if.tmask;
				// Trace: ../../rtl/VX_lsu_unit.sv:191:5
				always @(posedge clk) begin
					// Trace: ../../rtl/VX_lsu_unit.sv:192:9
					if (mbuf_push)
						// Trace: ../../rtl/VX_lsu_unit.sv:193:13
						rsp_rem_mask[mbuf_waddr * 2+:2] <= req_tmask_dup;
					if (dcache_rsp_fire)
						// Trace: ../../rtl/VX_lsu_unit.sv:196:13
						rsp_rem_mask[mbuf_raddr * 2+:2] <= rsp_rem_mask_n;
				end
				// Trace: ../../rtl/VX_lsu_unit.sv:201:5
				wire req_dep_ready = (req_wb && ~(mbuf_full && is_req_start)) || (~req_wb && VX_pipeline.st_commit_if.ready);
				// Trace: ../../rtl/VX_lsu_unit.sv:206:5
				for (i = 0; i < 2; i = i + 1) begin : genblk5
					// Trace: ../../rtl/VX_lsu_unit.sv:208:9
					reg [3:0] mem_req_byteen;
					// Trace: ../../rtl/VX_lsu_unit.sv:209:9
					reg [31:0] mem_req_data;
					// Trace: ../../rtl/VX_lsu_unit.sv:211:9
					always @(*) begin
						// Trace: ../../rtl/VX_lsu_unit.sv:212:13
						mem_req_byteen = {4 {req_wb}};
						// Trace: ../../rtl/VX_lsu_unit.sv:213:13
						case (req_type[1:0])
							0:
								// Trace: ../../rtl/VX_lsu_unit.sv:214:20
								mem_req_byteen[req_offset[i * 2+:2]] = 1;
							1: begin
								// Trace: ../../rtl/VX_lsu_unit.sv:216:21
								mem_req_byteen[req_offset[i * 2+:2]] = 1;
								// Trace: ../../rtl/VX_lsu_unit.sv:217:21
								mem_req_byteen[{req_offset[(i * 2) + 1], 1'b1}] = 1;
							end
							default:
								// Trace: ../../rtl/VX_lsu_unit.sv:219:27
								mem_req_byteen = {4 {1'b1}};
						endcase
					end
					// Trace: ../../rtl/VX_lsu_unit.sv:223:9
					always @(*) begin
						// Trace: ../../rtl/VX_lsu_unit.sv:224:13
						mem_req_data = req_data[i * 32+:32];
						// Trace: ../../rtl/VX_lsu_unit.sv:225:13
						case (req_offset[i * 2+:2])
							1:
								// Trace: ../../rtl/VX_lsu_unit.sv:226:20
								mem_req_data[31:8] = req_data[(i * 32) + 23-:24];
							2:
								// Trace: ../../rtl/VX_lsu_unit.sv:227:20
								mem_req_data[31:16] = req_data[(i * 32) + 15-:16];
							3:
								// Trace: ../../rtl/VX_lsu_unit.sv:228:20
								mem_req_data[31:24] = req_data[(i * 32) + 7-:8];
							default:
								;
						endcase
					end
					// Trace: ../../rtl/VX_lsu_unit.sv:233:9
					assign VX_pipeline.dcache_req_if.valid[i] = ((req_valid && req_dep_ready) && req_tmask_dup[i]) && !req_sent_mask[i];
					// Trace: ../../rtl/VX_lsu_unit.sv:234:9
					assign VX_pipeline.dcache_req_if.rw[i] = ~req_wb;
					// Trace: ../../rtl/VX_lsu_unit.sv:235:9
					assign VX_pipeline.dcache_req_if.addr[i * 30+:30] = req_addr[(i * 32) + 31-:30];
					// Trace: ../../rtl/VX_lsu_unit.sv:236:9
					assign VX_pipeline.dcache_req_if.byteen[i * 4+:4] = mem_req_byteen;
					// Trace: ../../rtl/VX_lsu_unit.sv:237:9
					assign VX_pipeline.dcache_req_if.data[i * 32+:32] = mem_req_data;
					// Trace: ../../rtl/VX_lsu_unit.sv:238:9
					assign VX_pipeline.dcache_req_if.tag[i * 48+:48] = {req_uuid, req_tag, req_addr_type[i * 2+:2]};
				end
				// Trace: ../../rtl/VX_lsu_unit.sv:241:5
				assign ready_in = req_dep_ready && dcache_req_ready;
				// Trace: ../../rtl/VX_lsu_unit.sv:245:5
				wire is_store_rsp = (req_valid && ~req_wb) && dcache_req_ready;
				// Trace: ../../rtl/VX_lsu_unit.sv:247:5
				assign VX_pipeline.st_commit_if.valid = is_store_rsp;
				// Trace: ../../rtl/VX_lsu_unit.sv:248:5
				assign VX_pipeline.st_commit_if.uuid = req_uuid;
				// Trace: ../../rtl/VX_lsu_unit.sv:249:5
				assign VX_pipeline.st_commit_if.wid = req_wid;
				// Trace: ../../rtl/VX_lsu_unit.sv:250:5
				assign VX_pipeline.st_commit_if.tmask = req_tmask;
				// Trace: ../../rtl/VX_lsu_unit.sv:251:5
				assign VX_pipeline.st_commit_if.PC = req_pc;
				// Trace: ../../rtl/VX_lsu_unit.sv:252:5
				assign VX_pipeline.st_commit_if.rd = 0;
				// Trace: ../../rtl/VX_lsu_unit.sv:253:5
				assign VX_pipeline.st_commit_if.wb = 0;
				// Trace: ../../rtl/VX_lsu_unit.sv:254:5
				assign VX_pipeline.st_commit_if.eop = 1'b1;
				// Trace: ../../rtl/VX_lsu_unit.sv:255:5
				assign VX_pipeline.st_commit_if.data = 0;
				// Trace: ../../rtl/VX_lsu_unit.sv:259:5
				reg [63:0] rsp_data;
				// Trace: ../../rtl/VX_lsu_unit.sv:260:5
				wire [1:0] rsp_tmask_qual;
				// Trace: ../../rtl/VX_lsu_unit.sv:262:5
				for (i = 0; i < 2; i = i + 1) begin : genblk6
					// Trace: ../../rtl/VX_lsu_unit.sv:263:9
					wire [31:0] rsp_data32 = ((i == 0) || rsp_is_dup ? VX_pipeline.dcache_rsp_if.data[0+:32] : VX_pipeline.dcache_rsp_if.data[i * 32+:32]);
					// Trace: ../../rtl/VX_lsu_unit.sv:264:9
					wire [15:0] rsp_data16 = (rsp_offset[(i * 2) + 1] ? rsp_data32[31:16] : rsp_data32[15:0]);
					// Trace: ../../rtl/VX_lsu_unit.sv:265:9
					wire [7:0] rsp_data8 = (rsp_offset[i * 2] ? rsp_data16[15:8] : rsp_data16[7:0]);
					// Trace: ../../rtl/VX_lsu_unit.sv:267:9
					always @(*)
						// Trace: ../../rtl/VX_lsu_unit.sv:268:13
						case (rsp_type[2:0])
							3'b000:
								// Trace: ../../rtl/VX_lsu_unit.sv:269:27
								rsp_data[i * 32+:32] = sv2v_cast_32_signed($signed(rsp_data8));
							3'b001:
								// Trace: ../../rtl/VX_lsu_unit.sv:270:27
								rsp_data[i * 32+:32] = sv2v_cast_32_signed($signed(rsp_data16));
							3'b100:
								// Trace: ../../rtl/VX_lsu_unit.sv:271:27
								rsp_data[i * 32+:32] = sv2v_cast_32($unsigned(rsp_data8));
							3'b101:
								// Trace: ../../rtl/VX_lsu_unit.sv:272:27
								rsp_data[i * 32+:32] = sv2v_cast_32($unsigned(rsp_data16));
							default:
								// Trace: ../../rtl/VX_lsu_unit.sv:273:22
								rsp_data[i * 32+:32] = rsp_data32;
						endcase
				end
				// Trace: ../../rtl/VX_lsu_unit.sv:278:5
				assign rsp_tmask_qual = (rsp_is_dup ? rsp_tmask : VX_pipeline.dcache_rsp_if.tmask);
				// Trace: ../../rtl/VX_lsu_unit.sv:282:5
				wire load_rsp_stall = ~VX_pipeline.ld_commit_if.ready && VX_pipeline.ld_commit_if.valid;
				// Trace: ../../rtl/VX_lsu_unit.sv:284:5
				VX_pipe_register #(
					.DATAW(151),
					.RESETW(1)
				) rsp_pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(!load_rsp_stall),
					.data_in({VX_pipeline.dcache_rsp_if.valid, rsp_uuid, rsp_wid, rsp_tmask_qual, rsp_pc, rsp_rd, rsp_wb, rsp_data, mbuf_pop}),
					.data_out({VX_pipeline.ld_commit_if.valid, VX_pipeline.ld_commit_if.uuid, VX_pipeline.ld_commit_if.wid, VX_pipeline.ld_commit_if.tmask, VX_pipeline.ld_commit_if.PC, VX_pipeline.ld_commit_if.rd, VX_pipeline.ld_commit_if.wb, VX_pipeline.ld_commit_if.data, VX_pipeline.ld_commit_if.eop})
				);
				// Trace: ../../rtl/VX_lsu_unit.sv:296:5
				assign VX_pipeline.dcache_rsp_if.ready = ~load_rsp_stall;
			end
			assign lsu_unit.clk = clk;
			assign lsu_unit.reset = lsu_reset;
			// Trace: ../../rtl/VX_execute.sv:166:5
			// expanded module instance: csr_unit
			localparam _param_BED2E_CORE_ID = CORE_ID;
			if (1) begin : csr_unit
				// Trace: ../../rtl/VX_csr_unit.sv:4:15
				localparam CORE_ID = _param_BED2E_CORE_ID;
				// Trace: ../../rtl/VX_csr_unit.sv:6:5
				wire clk;
				// Trace: ../../rtl/VX_csr_unit.sv:7:5
				wire reset;
				// Trace: ../../rtl/VX_csr_unit.sv:17:5
				// removed modport instance cmt_to_csr_if
				// Trace: ../../rtl/VX_csr_unit.sv:18:5
				// removed modport instance fetch_to_csr_if
				// Trace: ../../rtl/VX_csr_unit.sv:19:5
				// removed modport instance csr_req_if
				// Trace: ../../rtl/VX_csr_unit.sv:20:5
				// removed modport instance csr_commit_if
				// Trace: ../../rtl/VX_csr_unit.sv:30:5
				wire [1:0] pending;
				// Trace: ../../rtl/VX_csr_unit.sv:31:5
				wire busy;
				// Trace: ../../rtl/VX_csr_unit.sv:33:5
				wire csr_we_s1;
				// Trace: ../../rtl/VX_csr_unit.sv:34:5
				wire [11:0] csr_addr_s1;
				// Trace: ../../rtl/VX_csr_unit.sv:35:5
				wire [31:0] csr_read_data;
				// Trace: ../../rtl/VX_csr_unit.sv:36:5
				wire [31:0] csr_read_data_s1;
				// Trace: ../../rtl/VX_csr_unit.sv:37:5
				wire [31:0] csr_updated_data_s1;
				// Trace: ../../rtl/VX_csr_unit.sv:39:5
				wire write_enable = VX_pipeline.csr_commit_if.valid && csr_we_s1;
				// Trace: ../../rtl/VX_csr_unit.sv:41:5
				wire [31:0] csr_req_data = (VX_pipeline.csr_req_if.use_imm ? sv2v_cast_32(VX_pipeline.csr_req_if.imm) : VX_pipeline.csr_req_if.rs1_data);
				// Trace: ../../rtl/VX_csr_unit.sv:43:5
				// expanded module instance: csr_data
				localparam _param_9D0B6_CORE_ID = CORE_ID;
				if (1) begin : csr_data
					// Trace: ../../rtl/VX_csr_data.sv:4:15
					localparam CORE_ID = _param_9D0B6_CORE_ID;
					// Trace: ../../rtl/VX_csr_data.sv:6:5
					wire clk;
					// Trace: ../../rtl/VX_csr_data.sv:7:5
					wire reset;
					// Trace: ../../rtl/VX_csr_data.sv:17:5
					// removed modport instance cmt_to_csr_if
					// Trace: ../../rtl/VX_csr_data.sv:18:5
					// removed modport instance fetch_to_csr_if
					// Trace: ../../rtl/VX_csr_data.sv:27:5
					wire read_enable;
					// Trace: ../../rtl/VX_csr_data.sv:28:5
					wire [43:0] read_uuid;
					// Trace: ../../rtl/VX_csr_data.sv:29:5
					wire [11:0] read_addr;
					// Trace: ../../rtl/VX_csr_data.sv:30:5
					wire [0:0] read_wid;
					// Trace: ../../rtl/VX_csr_data.sv:31:5
					wire [31:0] read_data;
					// Trace: ../../rtl/VX_csr_data.sv:33:5
					wire write_enable;
					// Trace: ../../rtl/VX_csr_data.sv:34:5
					wire [43:0] write_uuid;
					// Trace: ../../rtl/VX_csr_data.sv:35:5
					wire [11:0] write_addr;
					// Trace: ../../rtl/VX_csr_data.sv:36:5
					wire [0:0] write_wid;
					// Trace: ../../rtl/VX_csr_data.sv:37:5
					wire [31:0] write_data;
					// Trace: ../../rtl/VX_csr_data.sv:39:5
					wire busy;
					// Trace: ../../rtl/VX_csr_data.sv:41:5
					// removed import fpu_types::*;
					// Trace: ../../rtl/VX_csr_data.sv:43:5
					reg [11:0] csr_satp;
					// Trace: ../../rtl/VX_csr_data.sv:44:5
					reg [11:0] csr_mstatus;
					// Trace: ../../rtl/VX_csr_data.sv:45:5
					reg [11:0] csr_medeleg;
					// Trace: ../../rtl/VX_csr_data.sv:46:5
					reg [11:0] csr_mideleg;
					// Trace: ../../rtl/VX_csr_data.sv:47:5
					reg [11:0] csr_mie;
					// Trace: ../../rtl/VX_csr_data.sv:48:5
					reg [11:0] csr_mtvec;
					// Trace: ../../rtl/VX_csr_data.sv:49:5
					reg [11:0] csr_mepc;
					// Trace: ../../rtl/VX_csr_data.sv:50:5
					reg [11:0] csr_pmpcfg [0:0];
					// Trace: ../../rtl/VX_csr_data.sv:51:5
					reg [11:0] csr_pmpaddr [0:0];
					// Trace: ../../rtl/VX_csr_data.sv:52:5
					reg [63:0] csr_cycle;
					// Trace: ../../rtl/VX_csr_data.sv:53:5
					reg [63:0] csr_instret;
					// Trace: ../../rtl/VX_csr_data.sv:55:5
					// removed localparam type fpu_types_fflags_t
					reg [15:0] fcsr;
					// Trace: ../../rtl/VX_csr_data.sv:57:5
					always @(posedge clk)
						// Trace: ../../rtl/VX_csr_data.sv:58:9
						if (reset)
							// Trace: ../../rtl/VX_csr_data.sv:59:13
							fcsr <= 1'sb0;
						else
							// Trace: ../../rtl/VX_csr_data.sv:67:13
							if (write_enable)
								// Trace: ../../rtl/VX_csr_data.sv:68:17
								case (write_addr)
									12'h001:
										// Trace: ../../rtl/VX_csr_data.sv:69:36
										fcsr[(write_wid * 8) + 4-:5] <= write_data[4:0];
									12'h002:
										// Trace: ../../rtl/VX_csr_data.sv:70:36
										fcsr[(write_wid * 8) + 7-:3] <= write_data[2:0];
									12'h003:
										// Trace: ../../rtl/VX_csr_data.sv:71:36
										fcsr[write_wid * 8+:8] <= write_data[7:0];
									12'h180:
										// Trace: ../../rtl/VX_csr_data.sv:72:36
										csr_satp <= write_data[11:0];
									12'h300:
										// Trace: ../../rtl/VX_csr_data.sv:73:36
										csr_mstatus <= write_data[11:0];
									12'h302:
										// Trace: ../../rtl/VX_csr_data.sv:74:36
										csr_medeleg <= write_data[11:0];
									12'h303:
										// Trace: ../../rtl/VX_csr_data.sv:75:36
										csr_mideleg <= write_data[11:0];
									12'h304:
										// Trace: ../../rtl/VX_csr_data.sv:76:36
										csr_mie <= write_data[11:0];
									12'h305:
										// Trace: ../../rtl/VX_csr_data.sv:77:36
										csr_mtvec <= write_data[11:0];
									12'h341:
										// Trace: ../../rtl/VX_csr_data.sv:78:36
										csr_mepc <= write_data[11:0];
									12'h3a0:
										// Trace: ../../rtl/VX_csr_data.sv:79:36
										csr_pmpcfg[0] <= write_data[11:0];
									12'h3b0:
										// Trace: ../../rtl/VX_csr_data.sv:80:36
										csr_pmpaddr[0] <= write_data[11:0];
									default:
										// Trace: macro expansion of ASSERT at ../../rtl/VX_csr_data.sv:88:122
										if (~write_enable)
											;
								endcase
					// Trace: ../../rtl/VX_csr_data.sv:106:5
					always @(posedge clk)
						// Trace: ../../rtl/VX_csr_data.sv:107:8
						if (reset) begin
							// Trace: ../../rtl/VX_csr_data.sv:108:13
							csr_cycle <= 0;
							// Trace: ../../rtl/VX_csr_data.sv:109:13
							csr_instret <= 0;
						end
						else begin
							// Trace: ../../rtl/VX_csr_data.sv:111:13
							if (busy)
								// Trace: ../../rtl/VX_csr_data.sv:112:17
								csr_cycle <= csr_cycle + 1;
							if (VX_pipeline.cmt_to_csr_if.valid)
								// Trace: ../../rtl/VX_csr_data.sv:115:17
								csr_instret <= csr_instret + sv2v_cast_64(VX_pipeline.cmt_to_csr_if.commit_size);
						end
					// Trace: ../../rtl/VX_csr_data.sv:120:5
					reg [31:0] read_data_r;
					// Trace: ../../rtl/VX_csr_data.sv:121:5
					reg read_addr_valid_r;
					// Trace: ../../rtl/VX_csr_data.sv:123:5
					always @(*) begin
						// Trace: ../../rtl/VX_csr_data.sv:124:9
						read_data_r = 1'sbx;
						// Trace: ../../rtl/VX_csr_data.sv:125:9
						read_addr_valid_r = 1;
						// Trace: ../../rtl/VX_csr_data.sv:126:9
						case (read_addr)
							12'h001:
								// Trace: ../../rtl/VX_csr_data.sv:127:31
								read_data_r = sv2v_cast_32(fcsr[(read_wid * 8) + 4-:5]);
							12'h002:
								// Trace: ../../rtl/VX_csr_data.sv:128:31
								read_data_r = sv2v_cast_32(fcsr[(read_wid * 8) + 7-:3]);
							12'h003:
								// Trace: ../../rtl/VX_csr_data.sv:129:31
								read_data_r = sv2v_cast_32(fcsr[read_wid * 8+:8]);
							12'hcc0, 12'hcc1, 12'hcc3:
								// Trace: ../../rtl/VX_csr_data.sv:133:31
								read_data_r = sv2v_cast_32(read_wid);
							12'hcc2, 12'hf14:
								// Trace: ../../rtl/VX_csr_data.sv:136:31
								read_data_r = (CORE_ID * 2) + sv2v_cast_32(read_wid);
							12'hcc5:
								// Trace: ../../rtl/VX_csr_data.sv:137:31
								read_data_r = CORE_ID;
							12'hcc4:
								// Trace: ../../rtl/VX_csr_data.sv:139:31
								read_data_r = sv2v_cast_32(VX_pipeline.fetch_to_csr_if.thread_masks[read_wid * 2+:2]);
							12'hfc0:
								// Trace: ../../rtl/VX_csr_data.sv:141:31
								read_data_r = 2;
							12'hfc1:
								// Trace: ../../rtl/VX_csr_data.sv:142:31
								read_data_r = 2;
							12'hfc2:
								// Trace: ../../rtl/VX_csr_data.sv:143:31
								read_data_r = 1;
							12'hb00:
								// Trace: ../../rtl/VX_csr_data.sv:145:31
								read_data_r = csr_cycle[31:0];
							12'hb80:
								// Trace: ../../rtl/VX_csr_data.sv:146:31
								read_data_r = sv2v_cast_32(csr_cycle[43:32]);
							12'hb02:
								// Trace: ../../rtl/VX_csr_data.sv:147:31
								read_data_r = csr_instret[31:0];
							12'hb82:
								// Trace: ../../rtl/VX_csr_data.sv:148:31
								read_data_r = sv2v_cast_32(csr_instret[43:32]);
							12'h180:
								// Trace: ../../rtl/VX_csr_data.sv:222:30
								read_data_r = sv2v_cast_32(csr_satp);
							12'h300:
								// Trace: ../../rtl/VX_csr_data.sv:224:30
								read_data_r = sv2v_cast_32(csr_mstatus);
							12'h301:
								// Trace: ../../rtl/VX_csr_data.sv:225:30
								read_data_r = 9441536;
							12'h302:
								// Trace: ../../rtl/VX_csr_data.sv:226:30
								read_data_r = sv2v_cast_32(csr_medeleg);
							12'h303:
								// Trace: ../../rtl/VX_csr_data.sv:227:30
								read_data_r = sv2v_cast_32(csr_mideleg);
							12'h304:
								// Trace: ../../rtl/VX_csr_data.sv:228:30
								read_data_r = sv2v_cast_32(csr_mie);
							12'h305:
								// Trace: ../../rtl/VX_csr_data.sv:229:30
								read_data_r = sv2v_cast_32(csr_mtvec);
							12'h341:
								// Trace: ../../rtl/VX_csr_data.sv:231:30
								read_data_r = sv2v_cast_32(csr_mepc);
							12'h3a0:
								// Trace: ../../rtl/VX_csr_data.sv:233:30
								read_data_r = sv2v_cast_32(csr_pmpcfg[0]);
							12'h3b0:
								// Trace: ../../rtl/VX_csr_data.sv:234:30
								read_data_r = sv2v_cast_32(csr_pmpaddr[0]);
							12'hf11:
								// Trace: ../../rtl/VX_csr_data.sv:236:30
								read_data_r = 0;
							12'hf12:
								// Trace: ../../rtl/VX_csr_data.sv:237:30
								read_data_r = 0;
							12'hf13:
								// Trace: ../../rtl/VX_csr_data.sv:238:30
								read_data_r = 0;
							default:
								// Trace: ../../rtl/VX_csr_data.sv:241:17
								if (((read_addr >= 12'hb00) && (read_addr < 2848)) || ((read_addr >= 12'hb80) && (read_addr < 2976)))
									// Trace: ../../rtl/VX_csr_data.sv:243:22
									read_addr_valid_r = 1;
								else
									// Trace: ../../rtl/VX_csr_data.sv:252:21
									read_addr_valid_r = 0;
						endcase
					end
					// Trace: ../../rtl/VX_csr_data.sv:259:5
					assign read_data = read_data_r;
				end
				assign csr_data.clk = clk;
				assign csr_data.reset = reset;
				assign csr_data.read_enable = VX_pipeline.csr_req_if.valid;
				assign csr_data.read_uuid = VX_pipeline.csr_req_if.uuid;
				assign csr_data.read_addr = VX_pipeline.csr_req_if.addr;
				assign csr_data.read_wid = VX_pipeline.csr_req_if.wid;
				assign csr_read_data = csr_data.read_data;
				assign csr_data.write_enable = write_enable;
				assign csr_data.write_uuid = VX_pipeline.csr_commit_if.uuid;
				assign csr_data.write_addr = csr_addr_s1;
				assign csr_data.write_wid = VX_pipeline.csr_commit_if.wid;
				assign csr_data.write_data = csr_updated_data_s1;
				assign csr_data.busy = busy;
				// Trace: ../../rtl/VX_csr_unit.sv:76:5
				wire write_hazard = ((csr_addr_s1 == VX_pipeline.csr_req_if.addr) && (VX_pipeline.csr_commit_if.wid == VX_pipeline.csr_req_if.wid)) && VX_pipeline.csr_commit_if.valid;
				// Trace: ../../rtl/VX_csr_unit.sv:80:5
				wire [31:0] csr_read_data_qual = (write_hazard ? csr_updated_data_s1 : csr_read_data);
				// Trace: ../../rtl/VX_csr_unit.sv:82:5
				reg [31:0] csr_updated_data;
				// Trace: ../../rtl/VX_csr_unit.sv:83:5
				reg csr_we_s0_unqual;
				// Trace: ../../rtl/VX_csr_unit.sv:85:5
				always @(*) begin
					// Trace: ../../rtl/VX_csr_unit.sv:86:9
					csr_we_s0_unqual = csr_req_data != 0;
					// Trace: ../../rtl/VX_csr_unit.sv:87:9
					case (VX_pipeline.csr_req_if.op_type)
						2'h1: begin
							// Trace: ../../rtl/VX_csr_unit.sv:89:17
							csr_updated_data = csr_req_data;
							// Trace: ../../rtl/VX_csr_unit.sv:90:17
							csr_we_s0_unqual = 1;
						end
						2'h2:
							// Trace: ../../rtl/VX_csr_unit.sv:93:17
							csr_updated_data = csr_read_data_qual | csr_req_data;
						default:
							// Trace: ../../rtl/VX_csr_unit.sv:97:17
							csr_updated_data = csr_read_data_qual & ~csr_req_data;
					endcase
				end
				// Trace: ../../rtl/VX_csr_unit.sv:105:5
				wire stall_in = 0;
				// Trace: ../../rtl/VX_csr_unit.sv:108:5
				wire csr_req_valid = VX_pipeline.csr_req_if.valid && !stall_in;
				// Trace: ../../rtl/VX_csr_unit.sv:110:5
				wire stall_out = ~VX_pipeline.csr_commit_if.ready && VX_pipeline.csr_commit_if.valid;
				// Trace: ../../rtl/VX_csr_unit.sv:112:5
				VX_pipe_register #(
					.DATAW(163),
					.RESETW(1)
				) pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(!stall_out),
					.data_in({csr_req_valid, VX_pipeline.csr_req_if.uuid, VX_pipeline.csr_req_if.wid, VX_pipeline.csr_req_if.tmask, VX_pipeline.csr_req_if.PC, VX_pipeline.csr_req_if.rd, VX_pipeline.csr_req_if.wb, csr_we_s0_unqual, VX_pipeline.csr_req_if.addr, csr_read_data_qual, csr_updated_data}),
					.data_out({VX_pipeline.csr_commit_if.valid, VX_pipeline.csr_commit_if.uuid, VX_pipeline.csr_commit_if.wid, VX_pipeline.csr_commit_if.tmask, VX_pipeline.csr_commit_if.PC, VX_pipeline.csr_commit_if.rd, VX_pipeline.csr_commit_if.wb, csr_we_s1, csr_addr_s1, csr_read_data_s1, csr_updated_data_s1})
				);
				// Trace: ../../rtl/VX_csr_unit.sv:123:5
				genvar i;
				for (i = 0; i < 2; i = i + 1) begin : genblk1
					// Trace: ../../rtl/VX_csr_unit.sv:124:9
					assign VX_pipeline.csr_commit_if.data[i * 32+:32] = (csr_addr_s1 == 12'hcc0 ? i : ((csr_addr_s1 == 12'hcc1) || (csr_addr_s1 == 12'hcc2) ? (csr_read_data_s1 * 2) + i : csr_read_data_s1));
				end
				// Trace: ../../rtl/VX_csr_unit.sv:130:5
				assign VX_pipeline.csr_commit_if.eop = 1'b1;
				// Trace: ../../rtl/VX_csr_unit.sv:133:5
				assign VX_pipeline.csr_req_if.ready = ~(stall_out || stall_in);
				// Trace: ../../rtl/VX_csr_unit.sv:136:5
				reg [1:0] pending_r;
				// Trace: ../../rtl/VX_csr_unit.sv:137:5
				always @(posedge clk)
					// Trace: ../../rtl/VX_csr_unit.sv:138:9
					if (reset)
						// Trace: ../../rtl/VX_csr_unit.sv:139:13
						pending_r <= 0;
					else begin
						// Trace: ../../rtl/VX_csr_unit.sv:141:13
						if (VX_pipeline.csr_commit_if.valid && VX_pipeline.csr_commit_if.ready)
							// Trace: ../../rtl/VX_csr_unit.sv:142:18
							pending_r[VX_pipeline.csr_commit_if.wid] <= 0;
						if (VX_pipeline.csr_req_if.valid && VX_pipeline.csr_req_if.ready)
							// Trace: ../../rtl/VX_csr_unit.sv:145:18
							pending_r[VX_pipeline.csr_req_if.wid] <= 1;
					end
				// Trace: ../../rtl/VX_csr_unit.sv:149:5
				assign pending = pending_r;
			end
			assign csr_unit.clk = clk;
			assign csr_unit.reset = csr_reset;
			assign csr_unit.busy = busy;
			// Trace: ../../rtl/VX_execute.sv:211:5
			// expanded module instance: gpu_unit
			localparam _param_FC85A_CORE_ID = CORE_ID;
			if (1) begin : gpu_unit
				// Trace: ../../rtl/VX_gpu_unit.sv:4:15
				localparam CORE_ID = _param_FC85A_CORE_ID;
				// Trace: ../../rtl/VX_gpu_unit.sv:8:5
				wire clk;
				// Trace: ../../rtl/VX_gpu_unit.sv:9:5
				wire reset;
				// Trace: ../../rtl/VX_gpu_unit.sv:12:5
				// removed modport instance gpu_req_if
				// Trace: ../../rtl/VX_gpu_unit.sv:25:5
				// removed modport instance warp_ctl_if
				// Trace: ../../rtl/VX_gpu_unit.sv:26:5
				// removed modport instance gpu_commit_if
				// Trace: ../../rtl/VX_gpu_unit.sv:28:5
				// removed import gpu_types::*;
				// Trace: ../../rtl/VX_gpu_unit.sv:32:5
				// removed localparam type gpu_types_gpu_barrier_t
				// removed localparam type gpu_types_gpu_split_t
				// removed localparam type gpu_types_gpu_tmc_t
				// removed localparam type gpu_types_gpu_wspawn_t
				localparam WCTL_DATAW = 80;
				// Trace: ../../rtl/VX_gpu_unit.sv:33:5
				localparam RSP_DATAW = WCTL_DATAW;
				// Trace: ../../rtl/VX_gpu_unit.sv:35:5
				wire rsp_valid;
				// Trace: ../../rtl/VX_gpu_unit.sv:36:5
				wire [43:0] rsp_uuid;
				// Trace: ../../rtl/VX_gpu_unit.sv:37:5
				wire [0:0] rsp_wid;
				// Trace: ../../rtl/VX_gpu_unit.sv:38:5
				wire [1:0] rsp_tmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:39:5
				wire [31:0] rsp_PC;
				// Trace: ../../rtl/VX_gpu_unit.sv:40:5
				wire [4:0] rsp_rd;
				// Trace: ../../rtl/VX_gpu_unit.sv:41:5
				wire rsp_wb;
				// Trace: ../../rtl/VX_gpu_unit.sv:43:5
				wire [79:0] rsp_data;
				wire [79:0] rsp_data_r;
				// Trace: ../../rtl/VX_gpu_unit.sv:45:5
				wire [2:0] tmc;
				// Trace: ../../rtl/VX_gpu_unit.sv:46:5
				wire [34:0] wspawn;
				// Trace: ../../rtl/VX_gpu_unit.sv:47:5
				wire [3:0] barrier;
				// Trace: ../../rtl/VX_gpu_unit.sv:48:5
				wire [37:0] split;
				// Trace: ../../rtl/VX_gpu_unit.sv:50:5
				wire [79:0] warp_ctl_data;
				// Trace: ../../rtl/VX_gpu_unit.sv:51:5
				wire is_warp_ctl;
				// Trace: ../../rtl/VX_gpu_unit.sv:53:5
				wire stall_in;
				wire stall_out;
				// Trace: ../../rtl/VX_gpu_unit.sv:55:5
				wire is_wspawn = VX_pipeline.gpu_req_if.op_type == 4'h1;
				// Trace: ../../rtl/VX_gpu_unit.sv:56:5
				wire is_tmc = VX_pipeline.gpu_req_if.op_type == 4'h0;
				// Trace: ../../rtl/VX_gpu_unit.sv:57:5
				wire is_split = VX_pipeline.gpu_req_if.op_type == 4'h2;
				// Trace: ../../rtl/VX_gpu_unit.sv:58:5
				wire is_bar = VX_pipeline.gpu_req_if.op_type == 4'h4;
				// Trace: ../../rtl/VX_gpu_unit.sv:59:5
				wire is_pred = VX_pipeline.gpu_req_if.op_type == 4'h5;
				// Trace: ../../rtl/VX_gpu_unit.sv:61:5
				wire [31:0] rs1_data = VX_pipeline.gpu_req_if.rs1_data[VX_pipeline.gpu_req_if.tid * 32+:32];
				// Trace: ../../rtl/VX_gpu_unit.sv:62:5
				wire [31:0] rs2_data = VX_pipeline.gpu_req_if.rs2_data[VX_pipeline.gpu_req_if.tid * 32+:32];
				// Trace: ../../rtl/VX_gpu_unit.sv:64:5
				wire [1:0] taken_tmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:65:5
				wire [1:0] not_taken_tmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:67:5
				genvar i;
				for (i = 0; i < 2; i = i + 1) begin : genblk1
					// Trace: ../../rtl/VX_gpu_unit.sv:68:9
					wire taken = VX_pipeline.gpu_req_if.rs1_data[i * 32+:32] != 0;
					// Trace: ../../rtl/VX_gpu_unit.sv:69:9
					assign taken_tmask[i] = VX_pipeline.gpu_req_if.tmask[i] & taken;
					// Trace: ../../rtl/VX_gpu_unit.sv:70:9
					assign not_taken_tmask[i] = VX_pipeline.gpu_req_if.tmask[i] & ~taken;
				end
				// Trace: ../../rtl/VX_gpu_unit.sv:75:5
				wire [1:0] pred_mask = (taken_tmask != 0 ? taken_tmask : VX_pipeline.gpu_req_if.tmask);
				// Trace: ../../rtl/VX_gpu_unit.sv:77:5
				assign tmc[2] = is_tmc || is_pred;
				// Trace: ../../rtl/VX_gpu_unit.sv:78:5
				assign tmc[1-:2] = (is_pred ? pred_mask : rs1_data[1:0]);
				// Trace: ../../rtl/VX_gpu_unit.sv:82:5
				wire [31:0] wspawn_pc = rs2_data;
				// Trace: ../../rtl/VX_gpu_unit.sv:83:5
				wire [1:0] wspawn_wmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:84:5
				for (i = 0; i < 2; i = i + 1) begin : genblk2
					// Trace: ../../rtl/VX_gpu_unit.sv:85:9
					assign wspawn_wmask[i] = i < rs1_data;
				end
				// Trace: ../../rtl/VX_gpu_unit.sv:87:5
				assign wspawn[34] = is_wspawn;
				// Trace: ../../rtl/VX_gpu_unit.sv:88:5
				assign wspawn[33-:2] = wspawn_wmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:89:5
				assign wspawn[31-:32] = wspawn_pc;
				// Trace: ../../rtl/VX_gpu_unit.sv:93:5
				assign split[37] = is_split;
				// Trace: ../../rtl/VX_gpu_unit.sv:94:5
				assign split[36] = |taken_tmask && |not_taken_tmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:95:5
				assign split[35-:2] = taken_tmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:96:5
				assign split[33-:2] = not_taken_tmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:97:5
				assign split[31-:32] = VX_pipeline.gpu_req_if.next_PC;
				// Trace: ../../rtl/VX_gpu_unit.sv:101:5
				assign barrier[3] = is_bar;
				// Trace: ../../rtl/VX_gpu_unit.sv:102:5
				assign barrier[2-:2] = rs1_data[1:0];
				// Trace: ../../rtl/VX_gpu_unit.sv:103:5
				assign barrier[0-:1] = sv2v_cast_1(rs2_data - 1);
				// Trace: ../../rtl/VX_gpu_unit.sv:106:5
				assign warp_ctl_data = {tmc, wspawn, split, barrier};
				// Trace: ../../rtl/VX_gpu_unit.sv:170:5
				assign stall_in = stall_out;
				// Trace: ../../rtl/VX_gpu_unit.sv:171:5
				assign is_warp_ctl = 1;
				// Trace: ../../rtl/VX_gpu_unit.sv:173:5
				assign rsp_valid = VX_pipeline.gpu_req_if.valid;
				// Trace: ../../rtl/VX_gpu_unit.sv:174:5
				assign rsp_uuid = VX_pipeline.gpu_req_if.uuid;
				// Trace: ../../rtl/VX_gpu_unit.sv:175:5
				assign rsp_wid = VX_pipeline.gpu_req_if.wid;
				// Trace: ../../rtl/VX_gpu_unit.sv:176:5
				assign rsp_tmask = VX_pipeline.gpu_req_if.tmask;
				// Trace: ../../rtl/VX_gpu_unit.sv:177:5
				assign rsp_PC = VX_pipeline.gpu_req_if.PC;
				// Trace: ../../rtl/VX_gpu_unit.sv:178:5
				assign rsp_rd = 0;
				// Trace: ../../rtl/VX_gpu_unit.sv:179:5
				assign rsp_wb = 0;
				// Trace: ../../rtl/VX_gpu_unit.sv:180:5
				function automatic [79:0] sv2v_cast_790CE;
					input reg [79:0] inp;
					sv2v_cast_790CE = inp;
				endfunction
				assign rsp_data = sv2v_cast_790CE(warp_ctl_data);
				// Trace: ../../rtl/VX_gpu_unit.sv:184:5
				wire is_warp_ctl_r;
				// Trace: ../../rtl/VX_gpu_unit.sv:187:5
				assign stall_out = ~VX_pipeline.gpu_commit_if.ready && VX_pipeline.gpu_commit_if.valid;
				// Trace: ../../rtl/VX_gpu_unit.sv:189:5
				VX_pipe_register #(
					.DATAW(167),
					.RESETW(1)
				) pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(!stall_out),
					.data_in({rsp_valid, rsp_uuid, rsp_wid, rsp_tmask, rsp_PC, rsp_rd, rsp_wb, rsp_data, is_warp_ctl}),
					.data_out({VX_pipeline.gpu_commit_if.valid, VX_pipeline.gpu_commit_if.uuid, VX_pipeline.gpu_commit_if.wid, VX_pipeline.gpu_commit_if.tmask, VX_pipeline.gpu_commit_if.PC, VX_pipeline.gpu_commit_if.rd, VX_pipeline.gpu_commit_if.wb, rsp_data_r, is_warp_ctl_r})
				);
				// Trace: ../../rtl/VX_gpu_unit.sv:200:5
				assign VX_pipeline.gpu_commit_if.data = rsp_data_r[63:0];
				// Trace: ../../rtl/VX_gpu_unit.sv:201:5
				assign VX_pipeline.gpu_commit_if.eop = 1'b1;
				// Trace: ../../rtl/VX_gpu_unit.sv:205:5
				assign {VX_pipeline.warp_ctl_if.tmc, VX_pipeline.warp_ctl_if.wspawn, VX_pipeline.warp_ctl_if.split, VX_pipeline.warp_ctl_if.barrier} = rsp_data_r[79:0];
				// Trace: ../../rtl/VX_gpu_unit.sv:207:5
				assign VX_pipeline.warp_ctl_if.valid = (VX_pipeline.gpu_commit_if.valid && VX_pipeline.gpu_commit_if.ready) && is_warp_ctl_r;
				// Trace: ../../rtl/VX_gpu_unit.sv:208:5
				assign VX_pipeline.warp_ctl_if.wid = VX_pipeline.gpu_commit_if.wid;
				// Trace: ../../rtl/VX_gpu_unit.sv:211:5
				assign VX_pipeline.gpu_req_if.ready = ~stall_in;
			end
			assign gpu_unit.clk = clk;
			assign gpu_unit.reset = gpu_reset;
			// Trace: ../../rtl/VX_execute.sv:231:5
			wire ebreak;
			// Trace: ../../rtl/VX_execute.sv:232:5
			assign ebreak = ((VX_pipeline.alu_req_if.valid && VX_pipeline.alu_req_if.ready) && VX_pipeline.alu_req_if.op_mod[0]) && ((VX_pipeline.alu_req_if.op_type == 4'b1011) || (VX_pipeline.alu_req_if.op_type == 4'b1010));
		end
	endgenerate
	assign execute.clk = clk;
	assign execute.reset = execute_reset;
	assign execute.busy = busy;
	// Trace: ../../rtl/VX_pipeline.sv:242:5
	// expanded module instance: commit
	localparam _param_D837E_CORE_ID = CORE_ID;
	generate
		if (1) begin : commit
			// Trace: ../../rtl/VX_commit.sv:4:15
			localparam CORE_ID = _param_D837E_CORE_ID;
			// Trace: ../../rtl/VX_commit.sv:6:5
			wire clk;
			// Trace: ../../rtl/VX_commit.sv:7:5
			wire reset;
			// Trace: ../../rtl/VX_commit.sv:10:5
			// removed modport instance alu_commit_if
			// Trace: ../../rtl/VX_commit.sv:11:5
			// removed modport instance ld_commit_if
			// Trace: ../../rtl/VX_commit.sv:12:5
			// removed modport instance st_commit_if
			// Trace: ../../rtl/VX_commit.sv:13:5
			// removed modport instance csr_commit_if
			// Trace: ../../rtl/VX_commit.sv:17:5
			// removed modport instance gpu_commit_if
			// Trace: ../../rtl/VX_commit.sv:20:5
			// removed modport instance writeback_if
			// Trace: ../../rtl/VX_commit.sv:21:5
			// removed modport instance cmt_to_csr_if
			// Trace: ../../rtl/VX_commit.sv:25:5
			wire alu_commit_fire = VX_pipeline.alu_commit_if.valid && VX_pipeline.alu_commit_if.ready;
			// Trace: ../../rtl/VX_commit.sv:26:5
			wire ld_commit_fire = VX_pipeline.ld_commit_if.valid && VX_pipeline.ld_commit_if.ready;
			// Trace: ../../rtl/VX_commit.sv:27:5
			wire st_commit_fire = VX_pipeline.st_commit_if.valid && VX_pipeline.st_commit_if.ready;
			// Trace: ../../rtl/VX_commit.sv:28:5
			wire csr_commit_fire = VX_pipeline.csr_commit_if.valid && VX_pipeline.csr_commit_if.ready;
			// Trace: ../../rtl/VX_commit.sv:32:5
			wire gpu_commit_fire = VX_pipeline.gpu_commit_if.valid && VX_pipeline.gpu_commit_if.ready;
			// Trace: ../../rtl/VX_commit.sv:34:5
			wire commit_fire = (((alu_commit_fire || ld_commit_fire) || st_commit_fire) || csr_commit_fire) || gpu_commit_fire;
			// Trace: ../../rtl/VX_commit.sv:46:5
			wire [9:0] commit_tmask;
			// Trace: ../../rtl/VX_commit.sv:49:5
			wire [3:0] commit_size;
			// Trace: ../../rtl/VX_commit.sv:51:5
			assign commit_tmask = {{2 {alu_commit_fire}} & VX_pipeline.alu_commit_if.tmask, {2 {ld_commit_fire}} & VX_pipeline.ld_commit_if.tmask, {2 {st_commit_fire}} & VX_pipeline.st_commit_if.tmask, {2 {csr_commit_fire}} & VX_pipeline.csr_commit_if.tmask, {2 {gpu_commit_fire}} & VX_pipeline.gpu_commit_if.tmask};
			// Trace: macro expansion of POP_COUNT at ../../rtl/VX_commit.sv:62:37
			VX_popcount #(.N(10)) __commit_size(
				.in_i(commit_tmask),
				.cnt_o(commit_size)
			);
			// Trace: ../../rtl/VX_commit.sv:64:5
			VX_pipe_register #(
				.DATAW(5),
				.RESETW(1)
			) pipe_reg(
				.clk(clk),
				.reset(reset),
				.enable(1'b1),
				.data_in({commit_fire, commit_size}),
				.data_out({VX_pipeline.cmt_to_csr_if.valid, VX_pipeline.cmt_to_csr_if.commit_size})
			);
			// Trace: ../../rtl/VX_commit.sv:77:5
			// expanded module instance: writeback
			localparam _param_35426_CORE_ID = CORE_ID;
			if (1) begin : writeback
				// Trace: ../../rtl/VX_writeback.sv:4:15
				localparam CORE_ID = _param_35426_CORE_ID;
				// Trace: ../../rtl/VX_writeback.sv:6:5
				wire clk;
				// Trace: ../../rtl/VX_writeback.sv:7:5
				wire reset;
				// Trace: ../../rtl/VX_writeback.sv:10:5
				// removed modport instance alu_commit_if
				// Trace: ../../rtl/VX_writeback.sv:11:5
				// removed modport instance ld_commit_if
				// Trace: ../../rtl/VX_writeback.sv:12:5
				// removed modport instance csr_commit_if
				// Trace: ../../rtl/VX_writeback.sv:16:5
				// removed modport instance gpu_commit_if
				// Trace: ../../rtl/VX_writeback.sv:19:5
				// removed modport instance writeback_if
				// Trace: ../../rtl/VX_writeback.sv:24:5
				localparam DATAW = 105;
				// Trace: ../../rtl/VX_writeback.sv:28:5
				localparam NUM_RSPS = 4;
				// Trace: ../../rtl/VX_writeback.sv:31:5
				wire wb_valid;
				// Trace: ../../rtl/VX_writeback.sv:32:5
				wire [0:0] wb_wid;
				// Trace: ../../rtl/VX_writeback.sv:33:5
				wire [31:0] wb_PC;
				// Trace: ../../rtl/VX_writeback.sv:34:5
				wire [1:0] wb_tmask;
				// Trace: ../../rtl/VX_writeback.sv:35:5
				wire [4:0] wb_rd;
				// Trace: ../../rtl/VX_writeback.sv:36:5
				wire [63:0] wb_data;
				// Trace: ../../rtl/VX_writeback.sv:37:5
				wire wb_eop;
				// Trace: ../../rtl/VX_writeback.sv:39:5
				wire [3:0] rsp_valid;
				// Trace: ../../rtl/VX_writeback.sv:40:5
				wire [419:0] rsp_data;
				// Trace: ../../rtl/VX_writeback.sv:41:5
				wire [3:0] rsp_ready;
				// Trace: ../../rtl/VX_writeback.sv:42:5
				wire stall;
				// Trace: ../../rtl/VX_writeback.sv:44:5
				assign rsp_valid = {VX_pipeline.gpu_commit_if.valid && VX_pipeline.gpu_commit_if.wb, VX_pipeline.csr_commit_if.valid && VX_pipeline.csr_commit_if.wb, VX_pipeline.alu_commit_if.valid && VX_pipeline.alu_commit_if.wb, VX_pipeline.ld_commit_if.valid && VX_pipeline.ld_commit_if.wb};
				// Trace: ../../rtl/VX_writeback.sv:54:5
				assign rsp_data = {VX_pipeline.gpu_commit_if.wid, VX_pipeline.gpu_commit_if.PC, VX_pipeline.gpu_commit_if.tmask, VX_pipeline.gpu_commit_if.rd, VX_pipeline.gpu_commit_if.data, VX_pipeline.gpu_commit_if.eop, VX_pipeline.csr_commit_if.wid, VX_pipeline.csr_commit_if.PC, VX_pipeline.csr_commit_if.tmask, VX_pipeline.csr_commit_if.rd, VX_pipeline.csr_commit_if.data, VX_pipeline.csr_commit_if.eop, VX_pipeline.alu_commit_if.wid, VX_pipeline.alu_commit_if.PC, VX_pipeline.alu_commit_if.tmask, VX_pipeline.alu_commit_if.rd, VX_pipeline.alu_commit_if.data, VX_pipeline.alu_commit_if.eop, VX_pipeline.ld_commit_if.wid, VX_pipeline.ld_commit_if.PC, VX_pipeline.ld_commit_if.tmask, VX_pipeline.ld_commit_if.rd, VX_pipeline.ld_commit_if.data, VX_pipeline.ld_commit_if.eop};
				// Trace: ../../rtl/VX_writeback.sv:64:5
				VX_stream_arbiter #(
					.NUM_REQS(NUM_RSPS),
					.DATAW(DATAW),
					.BUFFERED(1),
					.TYPE("R")
				) rsp_arb(
					.clk(clk),
					.reset(reset),
					.valid_in(rsp_valid),
					.data_in(rsp_data),
					.ready_in(rsp_ready),
					.valid_out(wb_valid),
					.data_out({wb_wid, wb_PC, wb_tmask, wb_rd, wb_data, wb_eop}),
					.ready_out(~stall)
				);
				// Trace: ../../rtl/VX_writeback.sv:80:5
				assign VX_pipeline.ld_commit_if.ready = rsp_ready[0] || ~VX_pipeline.ld_commit_if.wb;
				// Trace: ../../rtl/VX_writeback.sv:87:5
				assign VX_pipeline.alu_commit_if.ready = rsp_ready[1] || ~VX_pipeline.alu_commit_if.wb;
				// Trace: ../../rtl/VX_writeback.sv:88:5
				assign VX_pipeline.csr_commit_if.ready = rsp_ready[2] || ~VX_pipeline.csr_commit_if.wb;
				// Trace: ../../rtl/VX_writeback.sv:89:5
				assign VX_pipeline.gpu_commit_if.ready = rsp_ready[3] || ~VX_pipeline.gpu_commit_if.wb;
				// Trace: ../../rtl/VX_writeback.sv:92:5
				assign stall = ~VX_pipeline.writeback_if.ready && VX_pipeline.writeback_if.valid;
				// Trace: ../../rtl/VX_writeback.sv:94:5
				VX_pipe_register #(
					.DATAW(106),
					.RESETW(1)
				) pipe_reg(
					.clk(clk),
					.reset(reset),
					.enable(~stall),
					.data_in({wb_valid, wb_wid, wb_PC, wb_tmask, wb_rd, wb_data, wb_eop}),
					.data_out({VX_pipeline.writeback_if.valid, VX_pipeline.writeback_if.wid, VX_pipeline.writeback_if.PC, VX_pipeline.writeback_if.tmask, VX_pipeline.writeback_if.rd, VX_pipeline.writeback_if.data, VX_pipeline.writeback_if.eop})
				);
				// Trace: ../../rtl/VX_writeback.sv:106:5
				reg [31:0] last_wb_value [31:0];
				// Trace: ../../rtl/VX_writeback.sv:107:5
				always @(posedge clk)
					// Trace: ../../rtl/VX_writeback.sv:108:9
					if (VX_pipeline.writeback_if.valid && VX_pipeline.writeback_if.ready)
						// Trace: ../../rtl/VX_writeback.sv:109:13
						last_wb_value[VX_pipeline.writeback_if.rd] <= VX_pipeline.writeback_if.data[0+:32];
			end
			assign writeback.clk = clk;
			assign writeback.reset = reset;
			// Trace: ../../rtl/VX_commit.sv:94:5
			assign VX_pipeline.st_commit_if.ready = 1'b1;
		end
	endgenerate
	assign commit.clk = clk;
	assign commit.reset = commit_reset;
endmodule
module VX_pipe_register (
	clk,
	reset,
	enable,
	data_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_pipe_register.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:6:15
	parameter RESETW = DATAW;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:7:15
	parameter DEPTH = 1;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:9:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:10:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:11:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:12:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:13:5
	output wire [DATAW - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_pipe_register.sv:16:5
	function automatic signed [RESETW - 1:0] sv2v_cast_5A382_signed;
		input reg signed [RESETW - 1:0] inp;
		sv2v_cast_5A382_signed = inp;
	endfunction
	generate
		if (DEPTH == 0) begin : genblk1
			// Trace: ../../rtl/libs/VX_pipe_register.sv:20:9
			assign data_out = data_in;
		end
		else if (DEPTH == 1) begin : genblk1
			if (RESETW == 0) begin : genblk1
				// Trace: ../../rtl/libs/VX_pipe_register.sv:24:13
				reg [DATAW - 1:0] value;
				// Trace: ../../rtl/libs/VX_pipe_register.sv:26:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_pipe_register.sv:27:17
					if (enable)
						// Trace: ../../rtl/libs/VX_pipe_register.sv:28:21
						value <= data_in;
				// Trace: ../../rtl/libs/VX_pipe_register.sv:31:13
				assign data_out = value;
			end
			else if (RESETW == DATAW) begin : genblk1
				// Trace: ../../rtl/libs/VX_pipe_register.sv:33:13
				reg [DATAW - 1:0] value;
				// Trace: ../../rtl/libs/VX_pipe_register.sv:35:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_pipe_register.sv:36:17
					if (reset)
						// Trace: ../../rtl/libs/VX_pipe_register.sv:37:21
						value <= sv2v_cast_5A382_signed(0);
					else if (enable)
						// Trace: ../../rtl/libs/VX_pipe_register.sv:39:21
						value <= data_in;
				// Trace: ../../rtl/libs/VX_pipe_register.sv:42:13
				assign data_out = value;
			end
			else begin : genblk1
				// Trace: ../../rtl/libs/VX_pipe_register.sv:44:13
				reg [(DATAW - RESETW) - 1:0] value_d;
				// Trace: ../../rtl/libs/VX_pipe_register.sv:45:13
				reg [RESETW - 1:0] value_r;
				// Trace: ../../rtl/libs/VX_pipe_register.sv:47:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_pipe_register.sv:48:17
					if (reset)
						// Trace: ../../rtl/libs/VX_pipe_register.sv:49:21
						value_r <= sv2v_cast_5A382_signed(0);
					else if (enable)
						// Trace: ../../rtl/libs/VX_pipe_register.sv:51:21
						value_r <= data_in[DATAW - 1:DATAW - RESETW];
				// Trace: ../../rtl/libs/VX_pipe_register.sv:55:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_pipe_register.sv:56:17
					if (enable)
						// Trace: ../../rtl/libs/VX_pipe_register.sv:57:21
						value_d <= data_in[(DATAW - RESETW) - 1:0];
				// Trace: ../../rtl/libs/VX_pipe_register.sv:60:13
				assign data_out = {value_r, value_d};
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_pipe_register.sv:63:9
			VX_shift_register #(
				.DATAW(DATAW),
				.RESETW(RESETW),
				.DEPTH(DEPTH)
			) shift_reg(
				.clk(clk),
				.reset(reset),
				.enable(enable),
				.data_in(data_in),
				.data_out(data_out)
			);
		end
	endgenerate
endmodule
module VX_fifo_queue (
	clk,
	reset,
	push,
	pop,
	data_in,
	data_out,
	empty,
	alm_empty,
	full,
	alm_full,
	size
);
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:6:15
	parameter SIZE = 2;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:7:15
	parameter ALM_FULL = SIZE - 1;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:8:15
	parameter ALM_EMPTY = 1;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:9:15
	parameter ADDRW = $clog2(SIZE);
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:10:15
	parameter SIZEW = $clog2(SIZE + 1);
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:11:15
	parameter OUT_REG = 0;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:12:15
	parameter LUTRAM = 1;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:14:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:15:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:16:5
	input wire push;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:17:5
	input wire pop;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:18:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:19:5
	output wire [DATAW - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:20:5
	output wire empty;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:21:5
	output wire alm_empty;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:22:5
	output wire full;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:23:5
	output wire alm_full;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:24:5
	output wire [SIZEW - 1:0] size;
	// Trace: ../../rtl/libs/VX_fifo_queue.sv:28:5
	function automatic signed [ADDRW - 1:0] sv2v_cast_8BB5D_signed;
		input reg signed [ADDRW - 1:0] inp;
		sv2v_cast_8BB5D_signed = inp;
	endfunction
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	function automatic [ADDRW - 1:0] sv2v_cast_8BB5D;
		input reg [ADDRW - 1:0] inp;
		sv2v_cast_8BB5D = inp;
	endfunction
	generate
		if (SIZE == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:30:9
			reg [DATAW - 1:0] head_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:31:9
			reg size_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:33:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_fifo_queue.sv:34:13
				if (reset) begin
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:35:17
					head_r <= 0;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:36:17
					size_r <= 0;
				end
				else begin
					// Trace: macro expansion of ASSERT at ../../rtl/libs/VX_fifo_queue.sv:38:52
					if (!push || !full)
						;
					if (!pop || !empty)
						;
					if (push) begin
						begin
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:41:21
							if (!pop)
								// Trace: ../../rtl/libs/VX_fifo_queue.sv:42:25
								size_r <= 1;
						end
					end
					else if (pop)
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:45:21
						size_r <= 0;
					if (push)
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:48:21
						head_r <= data_in;
				end
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:53:9
			assign data_out = head_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:54:9
			assign empty = size_r == 0;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:55:9
			assign alm_empty = 1'b1;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:56:9
			assign full = size_r != 0;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:57:9
			assign alm_full = 1'b1;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:58:9
			assign size = size_r;
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:62:9
			reg empty_r;
			reg alm_empty_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:63:9
			reg full_r;
			reg alm_full_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:64:9
			reg [ADDRW - 1:0] used_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:66:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_fifo_queue.sv:67:13
				if (reset) begin
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:68:17
					empty_r <= 1;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:69:17
					alm_empty_r <= 1;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:70:17
					full_r <= 0;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:71:17
					alm_full_r <= 0;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:72:17
					used_r <= 0;
				end
				else begin
					// Trace: macro expansion of ASSERT at ../../rtl/libs/VX_fifo_queue.sv:74:52
					if (!push || !full)
						;
					if (!pop || !empty)
						;
					if (push) begin
						begin
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:77:21
							if (!pop) begin
								// Trace: ../../rtl/libs/VX_fifo_queue.sv:78:25
								empty_r <= 0;
								// Trace: ../../rtl/libs/VX_fifo_queue.sv:79:25
								if (used_r == sv2v_cast_8BB5D_signed(ALM_EMPTY))
									// Trace: ../../rtl/libs/VX_fifo_queue.sv:80:29
									alm_empty_r <= 0;
								if (used_r == sv2v_cast_8BB5D_signed(SIZE - 1))
									// Trace: ../../rtl/libs/VX_fifo_queue.sv:82:29
									full_r <= 1;
								if (used_r == sv2v_cast_8BB5D_signed(ALM_FULL - 1))
									// Trace: ../../rtl/libs/VX_fifo_queue.sv:84:29
									alm_full_r <= 1;
							end
						end
					end
					else if (pop) begin
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:87:21
						full_r <= 0;
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:88:21
						if (used_r == sv2v_cast_8BB5D_signed(ALM_FULL))
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:89:25
							alm_full_r <= 0;
						if (used_r == sv2v_cast_8BB5D_signed(1))
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:91:25
							empty_r <= 1;
						if (used_r == sv2v_cast_8BB5D_signed(ALM_EMPTY + 1))
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:93:25
							alm_empty_r <= 1;
					end
					if (SIZE > 2)
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:96:21
						used_r <= used_r + sv2v_cast_8BB5D_signed($signed(sv2v_cast_2(push) - sv2v_cast_2(pop)));
					else
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:99:21
						used_r[0] <= used_r[0] ^ (push ^ pop);
				end
			if (SIZE == 2) begin : genblk1
				if (0 == OUT_REG) begin : genblk1
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:108:17
					reg [DATAW - 1:0] shift_reg [1:0];
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:110:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:111:21
						if (push) begin
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:112:25
							shift_reg[1] <= shift_reg[0];
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:113:25
							shift_reg[0] <= data_in;
						end
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:117:17
					assign data_out = shift_reg[!used_r[0]];
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:121:17
					reg [DATAW - 1:0] data_out_r;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:122:17
					reg [DATAW - 1:0] buffer;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:124:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:125:21
						if (push)
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:126:25
							buffer <= data_in;
						if (push && (empty_r || (used_r && pop)))
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:129:25
							data_out_r <= data_in;
						else if (pop)
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:131:25
							data_out_r <= buffer;
					end
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:135:17
					assign data_out = data_out_r;
				end
			end
			else begin : genblk1
				if (0 == OUT_REG) begin : genblk1
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:143:17
					reg [ADDRW - 1:0] rd_ptr_r;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:144:17
					reg [ADDRW - 1:0] wr_ptr_r;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:146:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:147:21
						if (reset) begin
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:148:25
							rd_ptr_r <= 0;
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:149:25
							wr_ptr_r <= 0;
						end
						else begin
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:151:25
							wr_ptr_r <= wr_ptr_r + sv2v_cast_8BB5D(push);
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:152:25
							rd_ptr_r <= rd_ptr_r + sv2v_cast_8BB5D(pop);
						end
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:156:17
					VX_dp_ram #(
						.DATAW(DATAW),
						.SIZE(SIZE),
						.OUT_REG(0),
						.LUTRAM(LUTRAM)
					) dp_ram(
						.clk(clk),
						.wren(push),
						.waddr(wr_ptr_r),
						.wdata(data_in),
						.raddr(rd_ptr_r),
						.rdata(data_out)
					);
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:172:17
					wire [DATAW - 1:0] dout;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:173:17
					reg [DATAW - 1:0] dout_r;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:174:17
					reg [ADDRW - 1:0] wr_ptr_r;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:175:17
					reg [ADDRW - 1:0] rd_ptr_r;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:176:17
					reg [ADDRW - 1:0] rd_ptr_n_r;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:178:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:179:21
						if (reset) begin
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:180:25
							wr_ptr_r <= 0;
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:181:25
							rd_ptr_r <= 0;
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:182:25
							rd_ptr_n_r <= 1;
						end
						else begin
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:184:25
							if (push)
								// Trace: ../../rtl/libs/VX_fifo_queue.sv:185:29
								wr_ptr_r <= wr_ptr_r + sv2v_cast_8BB5D_signed(1);
							if (pop) begin
								// Trace: ../../rtl/libs/VX_fifo_queue.sv:188:29
								rd_ptr_r <= rd_ptr_n_r;
								// Trace: ../../rtl/libs/VX_fifo_queue.sv:189:29
								if (SIZE > 2)
									// Trace: ../../rtl/libs/VX_fifo_queue.sv:190:33
									rd_ptr_n_r <= rd_ptr_r + sv2v_cast_8BB5D_signed(2);
								else
									// Trace: ../../rtl/libs/VX_fifo_queue.sv:192:33
									rd_ptr_n_r <= ~rd_ptr_n_r;
							end
						end
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:198:17
					VX_dp_ram #(
						.DATAW(DATAW),
						.SIZE(SIZE),
						.OUT_REG(0),
						.LUTRAM(LUTRAM)
					) dp_ram(
						.clk(clk),
						.wren(push),
						.waddr(wr_ptr_r),
						.wdata(data_in),
						.raddr(rd_ptr_n_r),
						.rdata(dout)
					);
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:212:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_fifo_queue.sv:213:21
						if (push && (empty_r || ((used_r == sv2v_cast_8BB5D_signed(1)) && pop)))
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:214:25
							dout_r <= data_in;
						else if (pop)
							// Trace: ../../rtl/libs/VX_fifo_queue.sv:216:25
							dout_r <= dout;
					// Trace: ../../rtl/libs/VX_fifo_queue.sv:220:17
					assign data_out = dout_r;
				end
			end
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:224:9
			assign empty = empty_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:225:9
			assign alm_empty = alm_empty_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:226:9
			assign full = full_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:227:9
			assign alm_full = alm_full_r;
			// Trace: ../../rtl/libs/VX_fifo_queue.sv:228:9
			assign size = {full_r, used_r};
		end
	endgenerate
endmodule
module VX_axi_adapter (
	clk,
	reset,
	mem_req_valid,
	mem_req_rw,
	mem_req_byteen,
	mem_req_addr,
	mem_req_data,
	mem_req_tag,
	mem_rsp_ready,
	mem_rsp_valid,
	mem_rsp_data,
	mem_rsp_tag,
	mem_req_ready,
	m_axi_awid,
	m_axi_awaddr,
	m_axi_awlen,
	m_axi_awsize,
	m_axi_awburst,
	m_axi_awlock,
	m_axi_awcache,
	m_axi_awprot,
	m_axi_awqos,
	m_axi_awvalid,
	m_axi_awready,
	m_axi_wdata,
	m_axi_wstrb,
	m_axi_wlast,
	m_axi_wvalid,
	m_axi_wready,
	m_axi_bid,
	m_axi_bresp,
	m_axi_bvalid,
	m_axi_bready,
	m_axi_arid,
	m_axi_araddr,
	m_axi_arlen,
	m_axi_arsize,
	m_axi_arburst,
	m_axi_arlock,
	m_axi_arcache,
	m_axi_arprot,
	m_axi_arqos,
	m_axi_arvalid,
	m_axi_arready,
	m_axi_rid,
	m_axi_rdata,
	m_axi_rresp,
	m_axi_rlast,
	m_axi_rvalid,
	m_axi_rready
);
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:4:15
	parameter VX_DATA_WIDTH = 512;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:5:15
	parameter VX_ADDR_WIDTH = 32 - $clog2(VX_DATA_WIDTH / 8);
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:6:15
	parameter VX_TAG_WIDTH = 8;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:7:15
	parameter AXI_DATA_WIDTH = VX_DATA_WIDTH;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:8:15
	parameter AXI_ADDR_WIDTH = 32;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:9:15
	parameter AXI_TID_WIDTH = VX_TAG_WIDTH;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:11:15
	parameter VX_BYTEEN_WIDTH = VX_DATA_WIDTH / 8;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:12:15
	parameter AXI_STROBE_WIDTH = AXI_DATA_WIDTH / 8;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:14:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:15:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:18:5
	input wire mem_req_valid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:19:5
	input wire mem_req_rw;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:20:5
	input wire [VX_BYTEEN_WIDTH - 1:0] mem_req_byteen;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:21:5
	input wire [VX_ADDR_WIDTH - 1:0] mem_req_addr;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:22:5
	input wire [VX_DATA_WIDTH - 1:0] mem_req_data;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:23:5
	input wire [VX_TAG_WIDTH - 1:0] mem_req_tag;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:26:5
	input wire mem_rsp_ready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:27:5
	output wire mem_rsp_valid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:28:5
	output wire [VX_DATA_WIDTH - 1:0] mem_rsp_data;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:29:5
	output wire [VX_TAG_WIDTH - 1:0] mem_rsp_tag;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:30:5
	output wire mem_req_ready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:33:5
	output wire [AXI_TID_WIDTH - 1:0] m_axi_awid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:34:5
	output wire [AXI_ADDR_WIDTH - 1:0] m_axi_awaddr;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:35:5
	output wire [7:0] m_axi_awlen;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:36:5
	output wire [2:0] m_axi_awsize;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:37:5
	output wire [1:0] m_axi_awburst;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:38:5
	output wire m_axi_awlock;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:39:5
	output wire [3:0] m_axi_awcache;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:40:5
	output wire [2:0] m_axi_awprot;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:41:5
	output wire [3:0] m_axi_awqos;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:42:5
	output wire m_axi_awvalid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:43:5
	input wire m_axi_awready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:46:5
	output wire [AXI_DATA_WIDTH - 1:0] m_axi_wdata;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:47:5
	output wire [AXI_STROBE_WIDTH - 1:0] m_axi_wstrb;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:48:5
	output wire m_axi_wlast;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:49:5
	output wire m_axi_wvalid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:50:5
	input wire m_axi_wready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:53:5
	input wire [AXI_TID_WIDTH - 1:0] m_axi_bid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:54:5
	input wire [1:0] m_axi_bresp;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:55:5
	input wire m_axi_bvalid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:56:5
	output wire m_axi_bready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:59:5
	output wire [AXI_TID_WIDTH - 1:0] m_axi_arid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:60:5
	output wire [AXI_ADDR_WIDTH - 1:0] m_axi_araddr;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:61:5
	output wire [7:0] m_axi_arlen;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:62:5
	output wire [2:0] m_axi_arsize;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:63:5
	output wire [1:0] m_axi_arburst;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:64:5
	output wire m_axi_arlock;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:65:5
	output wire [3:0] m_axi_arcache;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:66:5
	output wire [2:0] m_axi_arprot;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:67:5
	output wire [3:0] m_axi_arqos;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:68:5
	output wire m_axi_arvalid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:69:5
	input wire m_axi_arready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:72:5
	input wire [AXI_TID_WIDTH - 1:0] m_axi_rid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:73:5
	input wire [AXI_DATA_WIDTH - 1:0] m_axi_rdata;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:74:5
	input wire [1:0] m_axi_rresp;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:75:5
	input wire m_axi_rlast;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:76:5
	input wire m_axi_rvalid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:77:5
	output wire m_axi_rready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:79:5
	localparam AXSIZE = $clog2(VX_DATA_WIDTH / 8);
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:86:5
	reg awvalid_ack;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:87:5
	reg wvalid_ack;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:89:5
	wire mem_req_fire = mem_req_valid && mem_req_ready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:91:5
	always @(posedge clk)
		// Trace: ../../rtl/libs/VX_axi_adapter.sv:92:3
		if (reset) begin
			// Trace: ../../rtl/libs/VX_axi_adapter.sv:93:4
			awvalid_ack <= 0;
			// Trace: ../../rtl/libs/VX_axi_adapter.sv:94:13
			wvalid_ack <= 0;
		end
		else
			// Trace: ../../rtl/libs/VX_axi_adapter.sv:96:13
			if (mem_req_fire) begin
				// Trace: ../../rtl/libs/VX_axi_adapter.sv:97:17
				awvalid_ack <= 0;
				// Trace: ../../rtl/libs/VX_axi_adapter.sv:98:17
				wvalid_ack <= 0;
			end
			else begin
				// Trace: ../../rtl/libs/VX_axi_adapter.sv:100:17
				awvalid_ack <= m_axi_awvalid && m_axi_awready;
				// Trace: ../../rtl/libs/VX_axi_adapter.sv:101:17
				wvalid_ack <= m_axi_wvalid && m_axi_wready;
			end
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:106:5
	wire axi_write_ready = (m_axi_awready || awvalid_ack) && (m_axi_wready || wvalid_ack);
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:109:5
	assign m_axi_awvalid = (mem_req_valid && mem_req_rw) && !awvalid_ack;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:110:5
	assign m_axi_awid = mem_req_tag;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:111:5
	function automatic [AXI_ADDR_WIDTH - 1:0] sv2v_cast_DC0A3;
		input reg [AXI_ADDR_WIDTH - 1:0] inp;
		sv2v_cast_DC0A3 = inp;
	endfunction
	assign m_axi_awaddr = sv2v_cast_DC0A3(mem_req_addr) << AXSIZE;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:112:5
	assign m_axi_awlen = 8'b00000000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:113:5
	function automatic signed [2:0] sv2v_cast_3_signed;
		input reg signed [2:0] inp;
		sv2v_cast_3_signed = inp;
	endfunction
	assign m_axi_awsize = sv2v_cast_3_signed(AXSIZE);
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:114:5
	assign m_axi_awburst = 2'b00;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:115:5
	assign m_axi_awlock = 1'b0;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:116:5
	assign m_axi_awcache = 4'b0000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:117:5
	assign m_axi_awprot = 3'b000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:118:5
	assign m_axi_awqos = 4'b0000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:121:5
	assign m_axi_wvalid = (mem_req_valid && mem_req_rw) && !wvalid_ack;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:122:5
	assign m_axi_wdata = mem_req_data;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:123:5
	assign m_axi_wstrb = mem_req_byteen;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:124:5
	assign m_axi_wlast = 1'b1;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:129:5
	assign m_axi_bready = 1'b1;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:132:5
	assign m_axi_arvalid = mem_req_valid && !mem_req_rw;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:133:5
	assign m_axi_arid = mem_req_tag;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:134:5
	assign m_axi_araddr = sv2v_cast_DC0A3(mem_req_addr) << AXSIZE;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:135:5
	assign m_axi_arlen = 8'b00000000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:136:5
	assign m_axi_arsize = sv2v_cast_3_signed(AXSIZE);
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:137:5
	assign m_axi_arburst = 2'b00;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:138:5
	assign m_axi_arlock = 1'b0;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:139:5
	assign m_axi_arcache = 4'b0000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:140:5
	assign m_axi_arprot = 3'b000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:141:5
	assign m_axi_arqos = 4'b0000;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:144:5
	assign mem_rsp_valid = m_axi_rvalid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:145:5
	assign mem_rsp_tag = m_axi_rid;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:146:5
	assign mem_rsp_data = m_axi_rdata;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:149:5
	assign m_axi_rready = mem_rsp_ready;
	// Trace: ../../rtl/libs/VX_axi_adapter.sv:152:2
	assign mem_req_ready = (mem_req_rw ? axi_write_ready : m_axi_arready);
endmodule
module VX_matrix_arbiter (
	clk,
	reset,
	enable,
	requests,
	grant_index,
	grant_onehot,
	grant_valid
);
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:5:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:6:15
	parameter LOCK_ENABLE = 0;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:7:15
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:9:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:10:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:11:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:12:5
	input wire [NUM_REQS - 1:0] requests;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:13:5
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:14:5
	output wire [NUM_REQS - 1:0] grant_onehot;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:15:5
	output wire grant_valid;
	// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:18:5
	generate
		if (NUM_REQS == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:23:9
			assign grant_index = 0;
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:24:9
			assign grant_onehot = requests;
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:25:9
			assign grant_valid = requests[0];
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:29:9
			reg [NUM_REQS - 1:1] state [NUM_REQS - 1:0];
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:30:9
			wire [NUM_REQS - 1:0] pri [NUM_REQS - 1:0];
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:31:9
			wire [NUM_REQS - 1:0] grant_unqual;
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
				genvar j;
				for (j = 0; j < NUM_REQS; j = j + 1) begin : genblk1
					if (j > i) begin : genblk1
						// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:36:21
						assign pri[j][i] = requests[i] && state[i][j];
					end
					else if (j < i) begin : genblk1
						// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:39:21
						assign pri[j][i] = requests[i] && !state[j][i];
					end
					else begin : genblk1
						// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:42:21
						assign pri[j][i] = 0;
					end
				end
				// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:45:13
				assign grant_unqual[i] = requests[i] && !(|pri[i]);
			end
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk2
				genvar j;
				for (j = i + 1; j < NUM_REQS; j = j + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:50:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:51:21
						if (reset)
							// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:52:25
							state[i][j] <= 0;
						else
							// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:54:25
							state[i][j] <= (state[i][j] || grant_unqual[j]) && !grant_unqual[i];
				end
			end
			if (LOCK_ENABLE == 0) begin : genblk3
				// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:62:13
				assign grant_onehot = grant_unqual;
			end
			else begin : genblk3
				// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:64:13
				reg [NUM_REQS - 1:0] grant_unqual_prev;
				// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:65:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:66:17
					if (reset)
						// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:67:21
						grant_unqual_prev <= 0;
					else if (enable)
						// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:69:21
						grant_unqual_prev <= grant_unqual;
				// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:72:13
				assign grant_onehot = (enable ? grant_unqual : grant_unqual_prev);
			end
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:75:9
			VX_onehot_encoder #(.N(NUM_REQS)) encoder(
				.data_in(grant_unqual),
				.data_out(grant_index)
			);
			// Trace: ../../rtl/libs/VX_matrix_arbiter.sv:83:9
			assign grant_valid = |requests;
		end
	endgenerate
endmodule
module VX_index_buffer (
	clk,
	reset,
	write_addr,
	write_data,
	acquire_slot,
	read_addr,
	read_data,
	release_addr,
	release_slot,
	empty,
	full
);
	// Trace: ../../rtl/libs/VX_index_buffer.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:6:15
	parameter SIZE = 1;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:7:15
	parameter LUTRAM = 1;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:8:15
	parameter ADDRW = (SIZE > 1 ? $clog2(SIZE) : 1);
	// Trace: ../../rtl/libs/VX_index_buffer.sv:10:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:11:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:13:5
	output wire [ADDRW - 1:0] write_addr;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:14:5
	input wire [DATAW - 1:0] write_data;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:15:5
	input wire acquire_slot;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:17:5
	input wire [ADDRW - 1:0] read_addr;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:18:5
	output wire [DATAW - 1:0] read_data;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:19:5
	input wire [ADDRW - 1:0] release_addr;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:20:5
	input wire release_slot;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:22:5
	output wire empty;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:23:5
	output wire full;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:25:5
	reg [SIZE - 1:0] free_slots;
	reg [SIZE - 1:0] free_slots_n;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:26:5
	reg [ADDRW - 1:0] write_addr_r;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:27:5
	reg empty_r;
	reg full_r;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:29:5
	wire free_valid;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:30:5
	wire [ADDRW - 1:0] free_index;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:32:5
	VX_lzc #(.N(SIZE)) free_slots_sel(
		.in_i(free_slots_n),
		.cnt_o(free_index),
		.valid_o(free_valid)
	);
	// Trace: ../../rtl/libs/VX_index_buffer.sv:40:5
	always @(*) begin
		// Trace: ../../rtl/libs/VX_index_buffer.sv:41:9
		free_slots_n = free_slots;
		// Trace: ../../rtl/libs/VX_index_buffer.sv:42:9
		if (release_slot)
			// Trace: ../../rtl/libs/VX_index_buffer.sv:43:13
			free_slots_n[release_addr] = 1;
		if (acquire_slot)
			// Trace: ../../rtl/libs/VX_index_buffer.sv:46:13
			free_slots_n[write_addr_r] = 0;
	end
	// Trace: ../../rtl/libs/VX_index_buffer.sv:50:5
	function automatic [ADDRW - 1:0] sv2v_cast_8BB5D;
		input reg [ADDRW - 1:0] inp;
		sv2v_cast_8BB5D = inp;
	endfunction
	always @(posedge clk)
		// Trace: ../../rtl/libs/VX_index_buffer.sv:51:9
		if (reset) begin
			// Trace: ../../rtl/libs/VX_index_buffer.sv:52:13
			write_addr_r <= sv2v_cast_8BB5D(1'b0);
			// Trace: ../../rtl/libs/VX_index_buffer.sv:53:13
			free_slots <= {SIZE {1'b1}};
			// Trace: ../../rtl/libs/VX_index_buffer.sv:54:13
			empty_r <= 1'b1;
			// Trace: ../../rtl/libs/VX_index_buffer.sv:55:13
			full_r <= 1'b0;
		end
		else begin
			// Trace: ../../rtl/libs/VX_index_buffer.sv:57:13
			if (release_slot)
				// Trace: macro expansion of ASSERT at ../../rtl/libs/VX_index_buffer.sv:58:112
				if (0 == free_slots[release_addr])
					;
			if (acquire_slot)
				// Trace: macro expansion of ASSERT at ../../rtl/libs/VX_index_buffer.sv:61:105
				if (1 == free_slots[write_addr])
					;
			// Trace: ../../rtl/libs/VX_index_buffer.sv:63:13
			write_addr_r <= free_index;
			// Trace: ../../rtl/libs/VX_index_buffer.sv:64:13
			free_slots <= free_slots_n;
			// Trace: ../../rtl/libs/VX_index_buffer.sv:65:13
			empty_r <= &free_slots_n;
			// Trace: ../../rtl/libs/VX_index_buffer.sv:66:13
			full_r <= ~free_valid;
		end
	// Trace: ../../rtl/libs/VX_index_buffer.sv:70:5
	VX_dp_ram #(
		.DATAW(DATAW),
		.SIZE(SIZE),
		.LUTRAM(LUTRAM)
	) data_table(
		.clk(clk),
		.wren(acquire_slot),
		.waddr(write_addr_r),
		.wdata(write_data),
		.raddr(read_addr),
		.rdata(read_data)
	);
	// Trace: ../../rtl/libs/VX_index_buffer.sv:83:5
	assign write_addr = write_addr_r;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:84:5
	assign empty = empty_r;
	// Trace: ../../rtl/libs/VX_index_buffer.sv:85:5
	assign full = full_r;
endmodule
module VX_index_queue (
	clk,
	reset,
	write_data,
	write_addr,
	push,
	pop,
	full,
	empty,
	read_addr,
	read_data
);
	// Trace: ../../rtl/libs/VX_index_queue.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_index_queue.sv:6:15
	parameter SIZE = 1;
	// Trace: ../../rtl/libs/VX_index_queue.sv:8:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_index_queue.sv:9:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_index_queue.sv:10:5
	input wire [DATAW - 1:0] write_data;
	// Trace: ../../rtl/libs/VX_index_queue.sv:11:5
	output wire [(SIZE > 1 ? $clog2(SIZE) : 1) - 1:0] write_addr;
	// Trace: ../../rtl/libs/VX_index_queue.sv:12:5
	input wire push;
	// Trace: ../../rtl/libs/VX_index_queue.sv:13:5
	input wire pop;
	// Trace: ../../rtl/libs/VX_index_queue.sv:14:5
	output wire full;
	// Trace: ../../rtl/libs/VX_index_queue.sv:15:5
	output wire empty;
	// Trace: ../../rtl/libs/VX_index_queue.sv:16:5
	input wire [(SIZE > 1 ? $clog2(SIZE) : 1) - 1:0] read_addr;
	// Trace: ../../rtl/libs/VX_index_queue.sv:17:5
	output wire [DATAW - 1:0] read_data;
	// Trace: ../../rtl/libs/VX_index_queue.sv:19:5
	reg [DATAW - 1:0] entries [SIZE - 1:0];
	// Trace: ../../rtl/libs/VX_index_queue.sv:20:5
	reg [SIZE - 1:0] valid;
	// Trace: ../../rtl/libs/VX_index_queue.sv:21:5
	reg [(SIZE > 1 ? $clog2(SIZE) : 1):0] rd_ptr;
	reg [(SIZE > 1 ? $clog2(SIZE) : 1):0] wr_ptr;
	// Trace: ../../rtl/libs/VX_index_queue.sv:23:5
	wire [(SIZE > 1 ? $clog2(SIZE) : 1) - 1:0] rd_a;
	wire [(SIZE > 1 ? $clog2(SIZE) : 1) - 1:0] wr_a;
	// Trace: ../../rtl/libs/VX_index_queue.sv:24:5
	wire enqueue;
	wire dequeue;
	// Trace: ../../rtl/libs/VX_index_queue.sv:26:5
	assign rd_a = rd_ptr[(SIZE > 1 ? $clog2(SIZE) : 1) - 1:0];
	// Trace: ../../rtl/libs/VX_index_queue.sv:27:5
	assign wr_a = wr_ptr[(SIZE > 1 ? $clog2(SIZE) : 1) - 1:0];
	// Trace: ../../rtl/libs/VX_index_queue.sv:29:5
	assign empty = wr_ptr == rd_ptr;
	// Trace: ../../rtl/libs/VX_index_queue.sv:30:5
	assign full = (wr_a == rd_a) && (wr_ptr[(SIZE > 1 ? $clog2(SIZE) : 1)] != rd_ptr[(SIZE > 1 ? $clog2(SIZE) : 1)]);
	// Trace: ../../rtl/libs/VX_index_queue.sv:32:5
	assign enqueue = push;
	// Trace: ../../rtl/libs/VX_index_queue.sv:33:5
	assign dequeue = !empty && !valid[rd_a];
	// Trace: ../../rtl/libs/VX_index_queue.sv:37:5
	always @(posedge clk) begin
		// Trace: ../../rtl/libs/VX_index_queue.sv:38:9
		if (reset) begin
			// Trace: ../../rtl/libs/VX_index_queue.sv:39:13
			rd_ptr <= 0;
			// Trace: ../../rtl/libs/VX_index_queue.sv:40:13
			wr_ptr <= 0;
			// Trace: ../../rtl/libs/VX_index_queue.sv:41:13
			valid <= 0;
		end
		else begin
			// Trace: ../../rtl/libs/VX_index_queue.sv:43:13
			if (enqueue) begin
				// Trace: ../../rtl/libs/VX_index_queue.sv:44:17
				valid[wr_a] <= 1;
				// Trace: ../../rtl/libs/VX_index_queue.sv:45:17
				wr_ptr <= wr_ptr + 1;
			end
			if (dequeue)
				// Trace: ../../rtl/libs/VX_index_queue.sv:48:17
				rd_ptr <= rd_ptr + 1;
			if (pop)
				// Trace: ../../rtl/libs/VX_index_queue.sv:51:17
				valid[read_addr] <= 0;
		end
		if (enqueue)
			// Trace: ../../rtl/libs/VX_index_queue.sv:56:13
			entries[wr_a] <= write_data;
	end
	// Trace: ../../rtl/libs/VX_index_queue.sv:60:5
	assign write_addr = wr_a;
	// Trace: ../../rtl/libs/VX_index_queue.sv:61:5
	assign read_data = entries[read_addr];
endmodule
module VX_find_first (
	data_i,
	valid_i,
	data_o,
	valid_o
);
	// Trace: ../../rtl/libs/VX_find_first.sv:5:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_find_first.sv:6:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_find_first.sv:7:15
	parameter REVERSE = 0;
	// Trace: ../../rtl/libs/VX_find_first.sv:8:15
	parameter LOGN = $clog2(N);
	// Trace: ../../rtl/libs/VX_find_first.sv:10:5
	input wire [(N * DATAW) - 1:0] data_i;
	// Trace: ../../rtl/libs/VX_find_first.sv:11:5
	input wire [N - 1:0] valid_i;
	// Trace: ../../rtl/libs/VX_find_first.sv:12:5
	output wire [DATAW - 1:0] data_o;
	// Trace: ../../rtl/libs/VX_find_first.sv:13:5
	output wire valid_o;
	// Trace: ../../rtl/libs/VX_find_first.sv:15:5
	localparam TL = (1 << LOGN) - 1;
	// Trace: ../../rtl/libs/VX_find_first.sv:16:5
	localparam TN = (1 << (LOGN + 1)) - 1;
	// Trace: ../../rtl/libs/VX_find_first.sv:19:5
	wire [TN - 1:0] s_n;
	// Trace: ../../rtl/libs/VX_find_first.sv:20:5
	wire [(TN * DATAW) - 1:0] d_n;
	// Trace: ../../rtl/libs/VX_find_first.sv:23:5
	genvar i;
	generate
		for (i = 0; i < N; i = i + 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_find_first.sv:24:9
			assign s_n[TL + i] = (REVERSE ? valid_i[(N - 1) - i] : valid_i[i]);
			// Trace: ../../rtl/libs/VX_find_first.sv:25:9
			assign d_n[(TL + i) * DATAW+:DATAW] = (REVERSE ? data_i[((N - 1) - i) * DATAW+:DATAW] : data_i[i * DATAW+:DATAW]);
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_find_first.sv:28:5
	generate
		for (i = TL + N; i < TN; i = i + 1) begin : genblk2
			// Trace: ../../rtl/libs/VX_find_first.sv:29:9
			assign s_n[i] = 0;
			// Trace: ../../rtl/libs/VX_find_first.sv:30:9
			assign d_n[i * DATAW+:DATAW] = 1'sbx;
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_find_first.sv:33:5
	genvar j;
	generate
		for (j = 0; j < LOGN; j = j + 1) begin : genblk3
			genvar i;
			for (i = 0; i < (2 ** j); i = i + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_find_first.sv:35:13
				assign s_n[((2 ** j) - 1) + i] = s_n[((2 ** (j + 1)) - 1) + (i * 2)] | s_n[(((2 ** (j + 1)) - 1) + (i * 2)) + 1];
				// Trace: ../../rtl/libs/VX_find_first.sv:36:13
				assign d_n[(((2 ** j) - 1) + i) * DATAW+:DATAW] = (s_n[((2 ** (j + 1)) - 1) + (i * 2)] ? d_n[(((2 ** (j + 1)) - 1) + (i * 2)) * DATAW+:DATAW] : d_n[((((2 ** (j + 1)) - 1) + (i * 2)) + 1) * DATAW+:DATAW]);
			end
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_find_first.sv:40:5
	assign valid_o = s_n[0];
	// Trace: ../../rtl/libs/VX_find_first.sv:41:5
	assign data_o = d_n[0+:DATAW];
endmodule
module VX_bits_insert (
	data_in,
	sel_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_bits_insert.sv:4:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_bits_insert.sv:5:15
	parameter S = 1;
	// Trace: ../../rtl/libs/VX_bits_insert.sv:6:15
	parameter POS = 0;
	// Trace: ../../rtl/libs/VX_bits_insert.sv:8:5
	input wire [N - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_bits_insert.sv:9:5
	input wire [S - 1:0] sel_in;
	// Trace: ../../rtl/libs/VX_bits_insert.sv:10:5
	output wire [(N + S) - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_bits_insert.sv:12:5
	generate
		if (POS == 0) begin : genblk1
			// Trace: ../../rtl/libs/VX_bits_insert.sv:13:9
			assign data_out = {data_in, sel_in};
		end
		else if (POS == N) begin : genblk1
			// Trace: ../../rtl/libs/VX_bits_insert.sv:15:9
			assign data_out = {sel_in, data_in};
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_bits_insert.sv:17:9
			assign data_out = {data_in[N - 1:POS], sel_in, data_in[POS - 1:0]};
		end
	endgenerate
endmodule
module VX_stream_arbiter (
	clk,
	reset,
	valid_in,
	data_in,
	ready_in,
	valid_out,
	data_out,
	ready_out
);
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:4:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:5:15
	parameter LANES = 1;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:6:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:7:15
	parameter TYPE = "P";
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:8:15
	parameter LOCK_ENABLE = 1;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:9:15
	parameter BUFFERED = 0;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:11:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:12:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:14:5
	input wire [(NUM_REQS * LANES) - 1:0] valid_in;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:15:5
	input wire [((NUM_REQS * LANES) * DATAW) - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:16:5
	output wire [(NUM_REQS * LANES) - 1:0] ready_in;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:18:5
	output wire [LANES - 1:0] valid_out;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:19:5
	output wire [(LANES * DATAW) - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:20:5
	input wire [LANES - 1:0] ready_out;
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:22:5
	localparam LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/libs/VX_stream_arbiter.sv:24:5
	generate
		if (NUM_REQS > 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:25:9
			wire sel_valid;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:26:9
			wire sel_ready;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:27:9
			wire [LOG_NUM_REQS - 1:0] sel_index;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:28:9
			wire [NUM_REQS - 1:0] sel_onehot;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:30:9
			wire [NUM_REQS - 1:0] valid_in_any;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:31:9
			wire [LANES - 1:0] ready_in_sel;
			if (LANES > 1) begin : genblk1
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_stream_arbiter.sv:35:17
					assign valid_in_any[i] = |valid_in[i * LANES+:LANES];
				end
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:37:13
				assign sel_ready = |ready_in_sel;
			end
			else begin : genblk1
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_stream_arbiter.sv:40:17
					assign valid_in_any[i] = valid_in[i * LANES+:LANES];
				end
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:42:13
				assign sel_ready = ready_in_sel;
			end
			if (TYPE == "P") begin : genblk2
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:46:13
				VX_fixed_arbiter #(
					.NUM_REQS(NUM_REQS),
					.LOCK_ENABLE(LOCK_ENABLE)
				) sel_arb(
					.clk(clk),
					.reset(reset),
					.requests(valid_in_any),
					.enable(sel_ready),
					.grant_valid(sel_valid),
					.grant_index(sel_index),
					.grant_onehot(sel_onehot)
				);
			end
			else if (TYPE == "R") begin : genblk2
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:59:13
				VX_rr_arbiter #(
					.NUM_REQS(NUM_REQS),
					.LOCK_ENABLE(LOCK_ENABLE)
				) sel_arb(
					.clk(clk),
					.reset(reset),
					.requests(valid_in_any),
					.enable(sel_ready),
					.grant_valid(sel_valid),
					.grant_index(sel_index),
					.grant_onehot(sel_onehot)
				);
			end
			else if (TYPE == "F") begin : genblk2
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:72:13
				VX_fair_arbiter #(
					.NUM_REQS(NUM_REQS),
					.LOCK_ENABLE(LOCK_ENABLE)
				) sel_arb(
					.clk(clk),
					.reset(reset),
					.requests(valid_in_any),
					.enable(sel_ready),
					.grant_valid(sel_valid),
					.grant_index(sel_index),
					.grant_onehot(sel_onehot)
				);
			end
			else if (TYPE == "M") begin : genblk2
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:85:13
				VX_matrix_arbiter #(
					.NUM_REQS(NUM_REQS),
					.LOCK_ENABLE(LOCK_ENABLE)
				) sel_arb(
					.clk(clk),
					.reset(reset),
					.requests(valid_in_any),
					.enable(sel_ready),
					.grant_valid(sel_valid),
					.grant_index(sel_index),
					.grant_onehot(sel_onehot)
				);
			end
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:101:9
			wire [LANES - 1:0] valid_in_sel;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:102:9
			wire [(LANES * DATAW) - 1:0] data_in_sel;
			if (LANES > 1) begin : genblk3
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:105:13
				wire [(NUM_REQS * (LANES * (1 + DATAW))) - 1:0] valid_data_in;
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_stream_arbiter.sv:107:17
					assign valid_data_in[i * (LANES * (1 + DATAW))+:LANES * (1 + DATAW)] = {valid_in[i * LANES+:LANES], data_in[DATAW * (i * LANES)+:DATAW * LANES]};
				end
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:109:13
				assign {valid_in_sel, data_in_sel} = valid_data_in[sel_index * (LANES * (1 + DATAW))+:LANES * (1 + DATAW)];
			end
			else begin : genblk3
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:112:13
				assign data_in_sel = data_in[DATAW * (sel_index * LANES)+:DATAW * LANES];
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:113:13
				assign valid_in_sel = sel_valid;
			end
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk4
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:117:13
				assign ready_in[i * LANES+:LANES] = ready_in_sel & {LANES {sel_onehot[i]}};
			end
			for (i = 0; i < LANES; i = i + 1) begin : genblk5
				// Trace: ../../rtl/libs/VX_stream_arbiter.sv:121:13
				VX_skid_buffer #(
					.DATAW(DATAW),
					.PASSTHRU(0 == BUFFERED),
					.OUT_REG(2 == BUFFERED)
				) out_buffer(
					.clk(clk),
					.reset(reset),
					.valid_in(valid_in_sel[i]),
					.data_in(data_in_sel[i * DATAW+:DATAW]),
					.ready_in(ready_in_sel[i]),
					.valid_out(valid_out[i]),
					.data_out(data_out[i * DATAW+:DATAW]),
					.ready_out(ready_out[i])
				);
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:142:9
			assign valid_out = valid_in;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:143:9
			assign data_out = data_in;
			// Trace: ../../rtl/libs/VX_stream_arbiter.sv:144:9
			assign ready_in = ready_out;
		end
	endgenerate
endmodule
module VX_dp_ram (
	clk,
	wren,
	waddr,
	wdata,
	raddr,
	rdata
);
	// Trace: ../../rtl/libs/VX_dp_ram.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:6:15
	parameter SIZE = 1;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:7:15
	parameter BYTEENW = 1;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:8:15
	parameter OUT_REG = 0;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:9:15
	parameter NO_RWCHECK = 0;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:10:15
	parameter LUTRAM = 0;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:11:15
	parameter ADDRW = $clog2(SIZE);
	// Trace: ../../rtl/libs/VX_dp_ram.sv:12:15
	parameter INIT_ENABLE = 0;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:13:15
	parameter INIT_FILE = "";
	// Trace: ../../rtl/libs/VX_dp_ram.sv:14:15
	parameter [DATAW - 1:0] INIT_VALUE = 0;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:16:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:17:5
	input wire [BYTEENW - 1:0] wren;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:18:5
	input wire [ADDRW - 1:0] waddr;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:19:5
	input wire [DATAW - 1:0] wdata;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:20:5
	input wire [ADDRW - 1:0] raddr;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:21:5
	output wire [DATAW - 1:0] rdata;
	// Trace: ../../rtl/libs/VX_dp_ram.sv:38:5
	generate
		if (LUTRAM) begin : genblk1
			if (OUT_REG) begin : genblk1
				// Trace: ../../rtl/libs/VX_dp_ram.sv:40:13
				reg [DATAW - 1:0] rdata_r;
				if (BYTEENW > 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_dp_ram.sv:42:32
					reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:44:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:44:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:44:234
							initial begin : sv2v_autoblock_1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:44:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:44:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:44:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_dp_ram.sv:46:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_dp_ram.sv:47:21
						begin : sv2v_autoblock_2
							// Trace: ../../rtl/libs/VX_dp_ram.sv:47:26
							integer i;
							// Trace: ../../rtl/libs/VX_dp_ram.sv:47:26
							for (i = 0; i < BYTEENW; i = i + 1)
								begin
									// Trace: ../../rtl/libs/VX_dp_ram.sv:48:25
									if (wren[i])
										// Trace: ../../rtl/libs/VX_dp_ram.sv:49:29
										ram[waddr][i * 8+:8] <= wdata[i * 8+:8];
								end
						end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:51:21
						rdata_r <= ram[raddr];
					end
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_dp_ram.sv:54:32
					reg [DATAW - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:56:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:56:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:56:234
							initial begin : sv2v_autoblock_3
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:56:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:56:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:56:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_dp_ram.sv:58:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_dp_ram.sv:59:21
						if (wren)
							// Trace: ../../rtl/libs/VX_dp_ram.sv:60:25
							ram[waddr] <= wdata;
						// Trace: ../../rtl/libs/VX_dp_ram.sv:61:21
						rdata_r <= ram[raddr];
					end
				end
				// Trace: ../../rtl/libs/VX_dp_ram.sv:64:13
				assign rdata = rdata_r;
			end
			else begin : genblk1
				if (BYTEENW > 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_dp_ram.sv:67:32
					reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:69:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:69:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:69:234
							initial begin : sv2v_autoblock_4
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:69:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:69:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:69:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_dp_ram.sv:71:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_dp_ram.sv:72:21
						begin : sv2v_autoblock_5
							// Trace: ../../rtl/libs/VX_dp_ram.sv:72:26
							integer i;
							// Trace: ../../rtl/libs/VX_dp_ram.sv:72:26
							for (i = 0; i < BYTEENW; i = i + 1)
								begin
									// Trace: ../../rtl/libs/VX_dp_ram.sv:73:25
									if (wren[i])
										// Trace: ../../rtl/libs/VX_dp_ram.sv:74:29
										ram[waddr][i * 8+:8] <= wdata[i * 8+:8];
								end
						end
					// Trace: ../../rtl/libs/VX_dp_ram.sv:77:17
					assign rdata = ram[raddr];
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_dp_ram.sv:79:32
					reg [DATAW - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:81:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:81:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:81:234
							initial begin : sv2v_autoblock_6
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:81:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:81:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:81:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_dp_ram.sv:83:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_dp_ram.sv:84:21
						if (wren)
							// Trace: ../../rtl/libs/VX_dp_ram.sv:85:25
							ram[waddr] <= wdata;
					// Trace: ../../rtl/libs/VX_dp_ram.sv:87:17
					assign rdata = ram[raddr];
				end
			end
		end
		else begin : genblk1
			if (OUT_REG) begin : genblk1
				// Trace: ../../rtl/libs/VX_dp_ram.sv:92:13
				reg [DATAW - 1:0] rdata_r;
				if (BYTEENW > 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_dp_ram.sv:95:17
					reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:97:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:97:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:97:234
							initial begin : sv2v_autoblock_7
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:97:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:97:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:97:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_dp_ram.sv:99:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_dp_ram.sv:100:21
						begin : sv2v_autoblock_8
							// Trace: ../../rtl/libs/VX_dp_ram.sv:100:26
							integer i;
							// Trace: ../../rtl/libs/VX_dp_ram.sv:100:26
							for (i = 0; i < BYTEENW; i = i + 1)
								begin
									// Trace: ../../rtl/libs/VX_dp_ram.sv:101:25
									if (wren[i])
										// Trace: ../../rtl/libs/VX_dp_ram.sv:102:29
										ram[waddr][i * 8+:8] <= wdata[i * 8+:8];
								end
						end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:104:21
						rdata_r <= ram[raddr];
					end
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_dp_ram.sv:107:17
					reg [DATAW - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:109:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:109:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:109:234
							initial begin : sv2v_autoblock_9
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:109:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:109:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:109:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_dp_ram.sv:111:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_dp_ram.sv:112:21
						if (wren)
							// Trace: ../../rtl/libs/VX_dp_ram.sv:113:25
							ram[waddr] <= wdata;
						// Trace: ../../rtl/libs/VX_dp_ram.sv:114:21
						rdata_r <= ram[raddr];
					end
				end
				// Trace: ../../rtl/libs/VX_dp_ram.sv:117:13
				assign rdata = rdata_r;
			end
			else begin : genblk1
				if (NO_RWCHECK) begin : genblk1
					if (BYTEENW > 1) begin : genblk1
						// Trace: ../../rtl/libs/VX_dp_ram.sv:121:38
						reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:123:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:123:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:123:238
								initial begin : sv2v_autoblock_10
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:123:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:123:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:123:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:125:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_dp_ram.sv:126:25
							begin : sv2v_autoblock_11
								// Trace: ../../rtl/libs/VX_dp_ram.sv:126:30
								integer i;
								// Trace: ../../rtl/libs/VX_dp_ram.sv:126:30
								for (i = 0; i < BYTEENW; i = i + 1)
									begin
										// Trace: ../../rtl/libs/VX_dp_ram.sv:127:29
										if (wren[i])
											// Trace: ../../rtl/libs/VX_dp_ram.sv:128:33
											ram[waddr][i * 8+:8] <= wdata[i * 8+:8];
									end
							end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:131:21
						assign rdata = ram[raddr];
					end
					else begin : genblk1
						// Trace: ../../rtl/libs/VX_dp_ram.sv:133:38
						reg [DATAW - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:135:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:135:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:135:238
								initial begin : sv2v_autoblock_12
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:135:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:135:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:135:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:137:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_dp_ram.sv:138:25
							if (wren)
								// Trace: ../../rtl/libs/VX_dp_ram.sv:139:29
								ram[waddr] <= wdata;
						// Trace: ../../rtl/libs/VX_dp_ram.sv:141:21
						assign rdata = ram[raddr];
					end
				end
				else begin : genblk1
					if (BYTEENW > 1) begin : genblk1
						// Trace: ../../rtl/libs/VX_dp_ram.sv:145:21
						reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:147:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:147:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:147:238
								initial begin : sv2v_autoblock_13
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:147:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:147:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:147:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:149:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_dp_ram.sv:150:25
							begin : sv2v_autoblock_14
								// Trace: ../../rtl/libs/VX_dp_ram.sv:150:30
								integer i;
								// Trace: ../../rtl/libs/VX_dp_ram.sv:150:30
								for (i = 0; i < BYTEENW; i = i + 1)
									begin
										// Trace: ../../rtl/libs/VX_dp_ram.sv:151:29
										if (wren[i])
											// Trace: ../../rtl/libs/VX_dp_ram.sv:152:33
											ram[waddr][i * 8+:8] <= wdata[i * 8+:8];
									end
							end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:155:21
						assign rdata = ram[raddr];
					end
					else begin : genblk1
						// Trace: ../../rtl/libs/VX_dp_ram.sv:157:21
						reg [DATAW - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:159:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:159:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:159:238
								initial begin : sv2v_autoblock_15
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:159:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:159:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_dp_ram.sv:159:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_dp_ram.sv:161:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_dp_ram.sv:162:25
							if (wren)
								// Trace: ../../rtl/libs/VX_dp_ram.sv:163:29
								ram[waddr] <= wdata;
						// Trace: ../../rtl/libs/VX_dp_ram.sv:165:21
						assign rdata = ram[raddr];
					end
				end
			end
		end
	endgenerate
endmodule
module VX_scan (
	data_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_scan.sv:8:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_scan.sv:9:15
	parameter OP = 0;
	// Trace: ../../rtl/libs/VX_scan.sv:10:15
	parameter REVERSE = 0;
	// Trace: ../../rtl/libs/VX_scan.sv:12:5
	input wire [N - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_scan.sv:13:5
	output wire [N - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_scan.sv:17:5
	localparam LOGN = $clog2(N);
	// Trace: ../../rtl/libs/VX_scan.sv:19:5
	wire [(LOGN >= 0 ? ((LOGN + 1) * N) - 1 : ((1 - LOGN) * N) + ((LOGN * N) - 1)):(LOGN >= 0 ? 0 : LOGN * N)] t;
	// Trace: ../../rtl/libs/VX_scan.sv:22:5
	generate
		if (REVERSE) begin : genblk1
			// Trace: ../../rtl/libs/VX_scan.sv:23:9
			assign t[(LOGN >= 0 ? 0 : LOGN) * N+:N] = data_in;
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_scan.sv:25:9
			function automatic [N - 1:0] _sv2v_strm_F2A76;
				input reg [(0 + N) - 1:0] inp;
				reg [(0 + N) - 1:0] _sv2v_strm_55E18_inp;
				reg [(0 + N) - 1:0] _sv2v_strm_55E18_out;
				integer _sv2v_strm_55E18_idx;
				begin
					_sv2v_strm_55E18_inp = {inp};
					for (_sv2v_strm_55E18_idx = 0; _sv2v_strm_55E18_idx <= ((0 + N) - 1); _sv2v_strm_55E18_idx = _sv2v_strm_55E18_idx + 1)
						_sv2v_strm_55E18_out[((0 + N) - 1) - _sv2v_strm_55E18_idx-:1] = _sv2v_strm_55E18_inp[_sv2v_strm_55E18_idx+:1];
					_sv2v_strm_F2A76 = ((0 + N) <= N ? _sv2v_strm_55E18_out << (N - (0 + N)) : _sv2v_strm_55E18_out >> ((0 + N) - N));
				end
			endfunction
			assign t[(LOGN >= 0 ? 0 : LOGN) * N+:N] = _sv2v_strm_F2A76({data_in});
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_scan.sv:29:5
	function automatic [N - 1:0] sv2v_cast_AC047;
		input reg [N - 1:0] inp;
		sv2v_cast_AC047 = inp;
	endfunction
	generate
		if ((N == 2) && (OP == 1)) begin : genblk2
			// Trace: ../../rtl/libs/VX_scan.sv:30:6
			assign t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N] = {t[((LOGN >= 0 ? 0 : LOGN) * N) + 1], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 1-:2]};
		end
		else if ((N == 3) && (OP == 1)) begin : genblk2
			// Trace: ../../rtl/libs/VX_scan.sv:32:6
			assign t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N] = {t[((LOGN >= 0 ? 0 : LOGN) * N) + 2], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 2-:2], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 2-:3]};
		end
		else if ((N == 4) && (OP == 1)) begin : genblk2
			// Trace: ../../rtl/libs/VX_scan.sv:34:6
			assign t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N] = {t[((LOGN >= 0 ? 0 : LOGN) * N) + 3], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 3-:2], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 3-:3], &t[((LOGN >= 0 ? 0 : LOGN) * N) + 3-:4]};
		end
		else begin : genblk2
			// Trace: ../../rtl/libs/VX_scan.sv:37:9
			wire [N - 1:0] fill;
			genvar i;
			for (i = 0; i < LOGN; i = i + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_scan.sv:39:13
				wire [N - 1:0] shifted = sv2v_cast_AC047({fill, t[(LOGN >= 0 ? i : LOGN - i) * N+:N]} >> (1 << i));
				if (OP == 0) begin : genblk1
					// Trace: ../../rtl/libs/VX_scan.sv:41:11
					assign fill = {N {1'b0}};
					// Trace: ../../rtl/libs/VX_scan.sv:42:11
					assign t[(LOGN >= 0 ? i + 1 : LOGN - (i + 1)) * N+:N] = t[(LOGN >= 0 ? i : LOGN - i) * N+:N] ^ shifted;
				end
				else if (OP == 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_scan.sv:44:11
					assign fill = {N {1'b1}};
					// Trace: ../../rtl/libs/VX_scan.sv:45:11
					assign t[(LOGN >= 0 ? i + 1 : LOGN - (i + 1)) * N+:N] = t[(LOGN >= 0 ? i : LOGN - i) * N+:N] & shifted;
				end
				else if (OP == 2) begin : genblk1
					// Trace: ../../rtl/libs/VX_scan.sv:47:11
					assign fill = {N {1'b0}};
					// Trace: ../../rtl/libs/VX_scan.sv:48:11
					assign t[(LOGN >= 0 ? i + 1 : LOGN - (i + 1)) * N+:N] = t[(LOGN >= 0 ? i : LOGN - i) * N+:N] | shifted;
				end
			end
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_scan.sv:54:5
	generate
		if (REVERSE) begin : genblk3
			// Trace: ../../rtl/libs/VX_scan.sv:55:9
			assign data_out = t[(LOGN >= 0 ? LOGN : LOGN - LOGN) * N+:N];
		end
		else begin : genblk3
			genvar i;
			for (i = 0; i < N; i = i + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_scan.sv:58:13
				assign data_out[i] = t[((LOGN >= 0 ? LOGN : LOGN - LOGN) * N) + ((N - 1) - i)];
			end
		end
	endgenerate
endmodule
module VX_serial_div (
	clk,
	reset,
	valid_in,
	ready_in,
	numer,
	denom,
	signed_mode,
	tag_in,
	quotient,
	remainder,
	ready_out,
	valid_out,
	tag_out
);
	// Trace: ../../rtl/libs/VX_serial_div.sv:5:15
	parameter WIDTHN = 1;
	// Trace: ../../rtl/libs/VX_serial_div.sv:6:15
	parameter WIDTHD = 1;
	// Trace: ../../rtl/libs/VX_serial_div.sv:7:15
	parameter WIDTHQ = 1;
	// Trace: ../../rtl/libs/VX_serial_div.sv:8:15
	parameter WIDTHR = 1;
	// Trace: ../../rtl/libs/VX_serial_div.sv:9:15
	parameter LANES = 1;
	// Trace: ../../rtl/libs/VX_serial_div.sv:10:15
	parameter TAGW = 1;
	// Trace: ../../rtl/libs/VX_serial_div.sv:12:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_serial_div.sv:13:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_serial_div.sv:15:5
	input wire valid_in;
	// Trace: ../../rtl/libs/VX_serial_div.sv:16:5
	output wire ready_in;
	// Trace: ../../rtl/libs/VX_serial_div.sv:17:5
	input wire [(LANES * WIDTHN) - 1:0] numer;
	// Trace: ../../rtl/libs/VX_serial_div.sv:18:5
	input wire [(LANES * WIDTHD) - 1:0] denom;
	// Trace: ../../rtl/libs/VX_serial_div.sv:19:5
	input wire signed_mode;
	// Trace: ../../rtl/libs/VX_serial_div.sv:20:5
	input wire [TAGW - 1:0] tag_in;
	// Trace: ../../rtl/libs/VX_serial_div.sv:22:5
	output wire [(LANES * WIDTHQ) - 1:0] quotient;
	// Trace: ../../rtl/libs/VX_serial_div.sv:23:5
	output wire [(LANES * WIDTHR) - 1:0] remainder;
	// Trace: ../../rtl/libs/VX_serial_div.sv:24:5
	input wire ready_out;
	// Trace: ../../rtl/libs/VX_serial_div.sv:25:5
	output wire valid_out;
	// Trace: ../../rtl/libs/VX_serial_div.sv:26:5
	output wire [TAGW - 1:0] tag_out;
	// Trace: ../../rtl/libs/VX_serial_div.sv:28:5
	localparam MIN_ND = (WIDTHN < WIDTHD ? WIDTHN : WIDTHD);
	// Trace: ../../rtl/libs/VX_serial_div.sv:29:5
	localparam CNTRW = $clog2(WIDTHN + 1);
	// Trace: ../../rtl/libs/VX_serial_div.sv:31:5
	reg [((WIDTHN + MIN_ND) >= 0 ? (LANES * ((WIDTHN + MIN_ND) + 1)) - 1 : (LANES * (1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) - 1)):((WIDTHN + MIN_ND) >= 0 ? 0 : (WIDTHN + MIN_ND) + 0)] working;
	// Trace: ../../rtl/libs/VX_serial_div.sv:32:5
	reg [(LANES * WIDTHD) - 1:0] denom_r;
	// Trace: ../../rtl/libs/VX_serial_div.sv:34:5
	wire [(LANES * WIDTHN) - 1:0] numer_qual;
	// Trace: ../../rtl/libs/VX_serial_div.sv:35:5
	wire [(LANES * WIDTHD) - 1:0] denom_qual;
	// Trace: ../../rtl/libs/VX_serial_div.sv:36:5
	wire [(WIDTHD >= 0 ? (LANES * (WIDTHD + 1)) - 1 : (LANES * (1 - WIDTHD)) + (WIDTHD - 1)):(WIDTHD >= 0 ? 0 : WIDTHD + 0)] sub_result;
	// Trace: ../../rtl/libs/VX_serial_div.sv:38:5
	reg [LANES - 1:0] inv_quot;
	reg [LANES - 1:0] inv_rem;
	// Trace: ../../rtl/libs/VX_serial_div.sv:40:5
	reg [CNTRW - 1:0] cntr;
	// Trace: ../../rtl/libs/VX_serial_div.sv:41:5
	reg is_busy;
	// Trace: ../../rtl/libs/VX_serial_div.sv:43:5
	reg [TAGW - 1:0] tag_r;
	// Trace: ../../rtl/libs/VX_serial_div.sv:45:5
	wire done = ~(|cntr);
	// Trace: ../../rtl/libs/VX_serial_div.sv:47:5
	wire push = valid_in && ready_in;
	// Trace: ../../rtl/libs/VX_serial_div.sv:48:5
	wire pop = valid_out && ready_out;
	// Trace: ../../rtl/libs/VX_serial_div.sv:50:5
	genvar i;
	generate
		for (i = 0; i < LANES; i = i + 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_serial_div.sv:51:9
			wire negate_numer = signed_mode && numer[(i * WIDTHN) + (WIDTHN - 1)];
			// Trace: ../../rtl/libs/VX_serial_div.sv:52:9
			wire negate_denom = signed_mode && denom[(i * WIDTHD) + (WIDTHD - 1)];
			// Trace: ../../rtl/libs/VX_serial_div.sv:53:9
			assign numer_qual[i * WIDTHN+:WIDTHN] = (negate_numer ? -$signed(numer[i * WIDTHN+:WIDTHN]) : numer[i * WIDTHN+:WIDTHN]);
			// Trace: ../../rtl/libs/VX_serial_div.sv:54:9
			assign denom_qual[i * WIDTHD+:WIDTHD] = (negate_denom ? -$signed(denom[i * WIDTHD+:WIDTHD]) : denom[i * WIDTHD+:WIDTHD]);
			// Trace: ../../rtl/libs/VX_serial_div.sv:55:9
			assign sub_result[(WIDTHD >= 0 ? 0 : WIDTHD) + (i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD))+:(WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)] = working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) >= WIDTHN ? WIDTHN + MIN_ND : ((WIDTHN + MIN_ND) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1))) + ((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)) - 1)-:((WIDTHN + MIN_ND) >= WIDTHN ? ((WIDTHN + MIN_ND) - WIDTHN) + 1 : (WIDTHN - (WIDTHN + MIN_ND)) + 1)] - denom_r[i * WIDTHD+:WIDTHD];
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_serial_div.sv:58:5
	function automatic signed [CNTRW - 1:0] sv2v_cast_A86AD_signed;
		input reg signed [CNTRW - 1:0] inp;
		sv2v_cast_A86AD_signed = inp;
	endfunction
	always @(posedge clk) begin
		// Trace: ../../rtl/libs/VX_serial_div.sv:59:9
		if (reset) begin
			// Trace: ../../rtl/libs/VX_serial_div.sv:60:13
			cntr <= 0;
			// Trace: ../../rtl/libs/VX_serial_div.sv:61:13
			is_busy <= 0;
		end
		else begin
			// Trace: ../../rtl/libs/VX_serial_div.sv:63:13
			if (push) begin
				// Trace: ../../rtl/libs/VX_serial_div.sv:64:17
				cntr <= WIDTHN;
				// Trace: ../../rtl/libs/VX_serial_div.sv:65:17
				is_busy <= 1;
			end
			else if (!done)
				// Trace: ../../rtl/libs/VX_serial_div.sv:67:17
				cntr <= cntr - sv2v_cast_A86AD_signed(1);
			if (pop)
				// Trace: ../../rtl/libs/VX_serial_div.sv:70:17
				is_busy <= 0;
		end
		if (push) begin
			// Trace: ../../rtl/libs/VX_serial_div.sv:75:13
			begin : sv2v_autoblock_1
				// Trace: ../../rtl/libs/VX_serial_div.sv:75:18
				integer i;
				// Trace: ../../rtl/libs/VX_serial_div.sv:75:18
				for (i = 0; i < LANES; i = i + 1)
					begin
						// Trace: ../../rtl/libs/VX_serial_div.sv:76:17
						working[((WIDTHN + MIN_ND) >= 0 ? 0 : WIDTHN + MIN_ND) + (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND)))+:((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))] <= {{WIDTHD {1'b0}}, numer_qual[i * WIDTHN+:WIDTHN], 1'b0};
						// Trace: ../../rtl/libs/VX_serial_div.sv:77:17
						denom_r[i * WIDTHD+:WIDTHD] <= denom_qual[i * WIDTHD+:WIDTHD];
						// Trace: ../../rtl/libs/VX_serial_div.sv:78:17
						inv_quot[i] <= ((denom[i * WIDTHD+:WIDTHD] != 0) && signed_mode) && (numer[(i * WIDTHN) + 31] ^ denom[(i * WIDTHD) + 31]);
						// Trace: ../../rtl/libs/VX_serial_div.sv:79:17
						inv_rem[i] <= signed_mode && numer[(i * WIDTHN) + 31];
					end
			end
			// Trace: ../../rtl/libs/VX_serial_div.sv:81:13
			tag_r <= tag_in;
		end
		else if (!done)
			// Trace: ../../rtl/libs/VX_serial_div.sv:83:13
			begin : sv2v_autoblock_2
				// Trace: ../../rtl/libs/VX_serial_div.sv:83:18
				integer i;
				// Trace: ../../rtl/libs/VX_serial_div.sv:83:18
				for (i = 0; i < LANES; i = i + 1)
					begin
						// Trace: ../../rtl/libs/VX_serial_div.sv:84:17
						working[((WIDTHN + MIN_ND) >= 0 ? 0 : WIDTHN + MIN_ND) + (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND)))+:((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))] <= (sub_result[(i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)) + (WIDTHD >= 0 ? WIDTHD : WIDTHD - WIDTHD)] ? {working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) - 1 : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) - 1 : (WIDTHN + MIN_ND) - ((WIDTHN + MIN_ND) - 1))) + (WIDTHN + MIN_ND)) - 1)-:WIDTHN + MIN_ND], 1'b0} : {sub_result[(WIDTHD >= 0 ? (i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)) + (WIDTHD >= 0 ? WIDTHD - 1 : WIDTHD - (WIDTHD - 1)) : (((i * (WIDTHD >= 0 ? WIDTHD + 1 : 1 - WIDTHD)) + (WIDTHD >= 0 ? WIDTHD - 1 : WIDTHD - (WIDTHD - 1))) + WIDTHD) - 1)-:WIDTHD], working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHN - 1 : (WIDTHN + MIN_ND) - (WIDTHN - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHN - 1 : (WIDTHN + MIN_ND) - (WIDTHN - 1))) + WIDTHN) - 1)-:WIDTHN], 1'b1});
					end
			end
	end
	// Trace: ../../rtl/libs/VX_serial_div.sv:90:5
	generate
		for (i = 0; i < LANES; i = i + 1) begin : genblk2
			// Trace: ../../rtl/libs/VX_serial_div.sv:91:9
			wire [WIDTHQ - 1:0] q = working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHQ - 1 : (WIDTHN + MIN_ND) - (WIDTHQ - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? WIDTHQ - 1 : (WIDTHN + MIN_ND) - (WIDTHQ - 1))) + WIDTHQ) - 1)-:WIDTHQ];
			// Trace: ../../rtl/libs/VX_serial_div.sv:92:9
			wire [WIDTHR - 1:0] r = working[((WIDTHN + MIN_ND) >= 0 ? (i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1)) : (((i * ((WIDTHN + MIN_ND) >= 0 ? (WIDTHN + MIN_ND) + 1 : 1 - (WIDTHN + MIN_ND))) + ((WIDTHN + MIN_ND) >= 0 ? ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1) : (WIDTHN + MIN_ND) - ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? WIDTHN + WIDTHR : ((WIDTHN + WIDTHR) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1))) + ((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)) - 1)-:((WIDTHN + WIDTHR) >= (WIDTHN + 1) ? ((WIDTHN + WIDTHR) - (WIDTHN + 1)) + 1 : ((WIDTHN + 1) - (WIDTHN + WIDTHR)) + 1)];
			// Trace: ../../rtl/libs/VX_serial_div.sv:93:9
			assign quotient[i * WIDTHQ+:WIDTHQ] = (inv_quot[i] ? -$signed(q) : q);
			// Trace: ../../rtl/libs/VX_serial_div.sv:94:9
			assign remainder[i * WIDTHR+:WIDTHR] = (inv_rem[i] ? -$signed(r) : r);
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_serial_div.sv:97:5
	assign ready_in = !is_busy;
	// Trace: ../../rtl/libs/VX_serial_div.sv:98:5
	assign tag_out = tag_r;
	// Trace: ../../rtl/libs/VX_serial_div.sv:99:5
	assign valid_out = is_busy && done;
endmodule
module VX_elastic_buffer (
	clk,
	reset,
	valid_in,
	ready_in,
	data_in,
	data_out,
	ready_out,
	valid_out
);
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:6:15
	parameter SIZE = 2;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:7:15
	parameter OUT_REG = 0;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:8:15
	parameter LUTRAM = 0;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:10:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:11:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:13:5
	input wire valid_in;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:14:5
	output wire ready_in;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:15:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:17:5
	output wire [DATAW - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:18:5
	input wire ready_out;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:19:5
	output wire valid_out;
	// Trace: ../../rtl/libs/VX_elastic_buffer.sv:23:5
	generate
		if (SIZE == 0) begin : genblk1
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:28:9
			assign valid_out = valid_in;
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:29:9
			assign data_out = data_in;
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:30:9
			assign ready_in = ready_out;
		end
		else if (SIZE == 2) begin : genblk1
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:34:9
			VX_skid_buffer #(
				.DATAW(DATAW),
				.OUT_REG(OUT_REG)
			) queue(
				.clk(clk),
				.reset(reset),
				.valid_in(valid_in),
				.data_in(data_in),
				.ready_in(ready_in),
				.valid_out(valid_out),
				.data_out(data_out),
				.ready_out(ready_out)
			);
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:50:9
			wire empty;
			wire full;
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:52:9
			wire push = valid_in && ready_in;
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:53:9
			wire pop = valid_out && ready_out;
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:55:9
			VX_fifo_queue #(
				.DATAW(DATAW),
				.SIZE(SIZE),
				.OUT_REG(OUT_REG),
				.LUTRAM(LUTRAM)
			) queue(
				.clk(clk),
				.reset(reset),
				.push(push),
				.pop(pop),
				.data_in(data_in),
				.data_out(data_out),
				.empty(empty),
				.full(full)
			);
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:74:9
			assign ready_in = ~full;
			// Trace: ../../rtl/libs/VX_elastic_buffer.sv:75:9
			assign valid_out = ~empty;
		end
	endgenerate
endmodule
module VX_divider (
	clk,
	enable,
	numer,
	denom,
	quotient,
	remainder
);
	// Trace: ../../rtl/libs/VX_divider.sv:5:15
	parameter WIDTHN = 1;
	// Trace: ../../rtl/libs/VX_divider.sv:6:15
	parameter WIDTHD = 1;
	// Trace: ../../rtl/libs/VX_divider.sv:7:15
	parameter WIDTHQ = 1;
	// Trace: ../../rtl/libs/VX_divider.sv:8:15
	parameter WIDTHR = 1;
	// Trace: ../../rtl/libs/VX_divider.sv:9:15
	parameter NSIGNED = 0;
	// Trace: ../../rtl/libs/VX_divider.sv:10:15
	parameter DSIGNED = 0;
	// Trace: ../../rtl/libs/VX_divider.sv:11:15
	parameter LATENCY = 0;
	// Trace: ../../rtl/libs/VX_divider.sv:13:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_divider.sv:14:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_divider.sv:15:5
	input wire [WIDTHN - 1:0] numer;
	// Trace: ../../rtl/libs/VX_divider.sv:16:5
	input wire [WIDTHD - 1:0] denom;
	// Trace: ../../rtl/libs/VX_divider.sv:17:5
	output wire [WIDTHQ - 1:0] quotient;
	// Trace: ../../rtl/libs/VX_divider.sv:18:5
	output wire [WIDTHR - 1:0] remainder;
	// Trace: ../../rtl/libs/VX_divider.sv:49:5
	reg [WIDTHN - 1:0] quotient_unqual;
	// Trace: ../../rtl/libs/VX_divider.sv:50:5
	reg [WIDTHD - 1:0] remainder_unqual;
	// Trace: ../../rtl/libs/VX_divider.sv:52:5
	always @(*) begin
		// Trace: ../../rtl/libs/VX_divider.sv:53:9
		// Trace: ../../rtl/libs/VX_divider.sv:54:13
		if (NSIGNED && DSIGNED) begin
			// Trace: ../../rtl/libs/VX_divider.sv:55:17
			quotient_unqual = $signed(numer) / $signed(denom);
			// Trace: ../../rtl/libs/VX_divider.sv:56:17
			remainder_unqual = $signed(numer) % $signed(denom);
		end
		else if (NSIGNED && !DSIGNED) begin
			// Trace: ../../rtl/libs/VX_divider.sv:59:17
			quotient_unqual = $signed(numer) / denom;
			// Trace: ../../rtl/libs/VX_divider.sv:60:17
			remainder_unqual = $signed(numer) % denom;
		end
		else if (!NSIGNED && DSIGNED) begin
			// Trace: ../../rtl/libs/VX_divider.sv:63:17
			quotient_unqual = numer / $signed(denom);
			// Trace: ../../rtl/libs/VX_divider.sv:64:17
			remainder_unqual = numer % $signed(denom);
		end
		else begin
			// Trace: ../../rtl/libs/VX_divider.sv:67:17
			quotient_unqual = numer / denom;
			// Trace: ../../rtl/libs/VX_divider.sv:68:17
			remainder_unqual = numer % denom;
		end
	end
	// Trace: ../../rtl/libs/VX_divider.sv:73:5
	generate
		if (LATENCY == 0) begin : genblk1
			// Trace: ../../rtl/libs/VX_divider.sv:74:9
			assign quotient = quotient_unqual[WIDTHQ - 1:0];
			// Trace: ../../rtl/libs/VX_divider.sv:75:9
			assign remainder = remainder_unqual[WIDTHR - 1:0];
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_divider.sv:77:9
			reg [WIDTHN - 1:0] quotient_pipe [LATENCY - 1:0];
			// Trace: ../../rtl/libs/VX_divider.sv:78:9
			reg [WIDTHD - 1:0] remainder_pipe [LATENCY - 1:0];
			genvar i;
			for (i = 0; i < LATENCY; i = i + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_divider.sv:81:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_divider.sv:82:17
					if (enable) begin
						// Trace: ../../rtl/libs/VX_divider.sv:83:21
						quotient_pipe[i] <= (0 == i ? quotient_unqual : quotient_pipe[i - 1]);
						// Trace: ../../rtl/libs/VX_divider.sv:84:21
						remainder_pipe[i] <= (0 == i ? remainder_unqual : remainder_pipe[i - 1]);
					end
			end
			// Trace: ../../rtl/libs/VX_divider.sv:89:9
			assign quotient = quotient_pipe[LATENCY - 1][WIDTHQ - 1:0];
			// Trace: ../../rtl/libs/VX_divider.sv:90:9
			assign remainder = remainder_pipe[LATENCY - 1][WIDTHR - 1:0];
		end
	endgenerate
endmodule
module VX_popcount (
	in_i,
	cnt_o
);
	// Trace: ../../rtl/libs/VX_popcount.sv:5:15
	parameter MODEL = 1;
	// Trace: ../../rtl/libs/VX_popcount.sv:6:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_popcount.sv:7:15
	parameter M = $clog2(N + 1);
	// Trace: ../../rtl/libs/VX_popcount.sv:9:5
	input wire [N - 1:0] in_i;
	// Trace: ../../rtl/libs/VX_popcount.sv:10:5
	output wire [M - 1:0] cnt_o;
	// Trace: ../../rtl/libs/VX_popcount.sv:20:5
	generate
		if (N == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_popcount.sv:22:9
			assign cnt_o = in_i;
		end
		else if (MODEL == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_popcount.sv:26:9
			localparam PN = 1 << $clog2(N);
			// Trace: ../../rtl/libs/VX_popcount.sv:27:9
			localparam LOGPN = $clog2(PN);
			// Trace: ../../rtl/libs/VX_popcount.sv:29:9
			wire [M - 1:0] tmp [0:PN - 1][0:PN - 1];
			genvar i;
			for (i = 0; i < N; i = i + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_popcount.sv:32:13
				assign tmp[0][i] = in_i[i];
			end
			for (i = N; i < PN; i = i + 1) begin : genblk2
				// Trace: ../../rtl/libs/VX_popcount.sv:36:13
				assign tmp[0][i] = 1'sb0;
			end
			genvar j;
			for (j = 0; j < LOGPN; j = j + 1) begin : genblk3
				genvar i;
				for (i = 0; i < (1 << ((LOGPN - j) - 1)); i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_popcount.sv:41:17
					assign tmp[j + 1][i] = tmp[j][i * 2] + tmp[j][(i * 2) + 1];
				end
			end
			// Trace: ../../rtl/libs/VX_popcount.sv:45:9
			assign cnt_o = tmp[LOGPN][0];
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_popcount.sv:49:9
			reg [M - 1:0] cnt_r;
			// Trace: ../../rtl/libs/VX_popcount.sv:51:9
			always @(*) begin
				// Trace: ../../rtl/libs/VX_popcount.sv:52:13
				cnt_r = 1'sb0;
				// Trace: ../../rtl/libs/VX_popcount.sv:53:13
				begin : sv2v_autoblock_1
					// Trace: ../../rtl/libs/VX_popcount.sv:53:18
					integer i;
					// Trace: ../../rtl/libs/VX_popcount.sv:53:18
					for (i = 0; i < N; i = i + 1)
						begin
							// Trace: ../../rtl/libs/VX_popcount.sv:55:17
							cnt_r = cnt_r + in_i[i];
						end
				end
			end
			// Trace: ../../rtl/libs/VX_popcount.sv:60:9
			assign cnt_o = cnt_r;
		end
	endgenerate
endmodule
module VX_priority_encoder (
	data_in,
	onehot,
	index,
	valid_out
);
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:5:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:6:15
	parameter REVERSE = 0;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:7:15
	parameter MODEL = 1;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:8:15
	parameter LN = (N > 1 ? $clog2(N) : 1);
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:10:5
	input wire [N - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:11:5
	output wire [N - 1:0] onehot;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:12:5
	output wire [LN - 1:0] index;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:13:5
	output wire valid_out;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:15:5
	wire [N - 1:0] reversed;
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:17:5
	generate
		if (REVERSE) begin : genblk1
			genvar i;
			for (i = 0; i < N; i = i + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_priority_encoder.sv:19:13
				assign reversed[(N - i) - 1] = data_in[i];
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:22:9
			assign reversed = data_in;
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_priority_encoder.sv:25:5
	function automatic signed [LN - 1:0] sv2v_cast_83428_signed;
		input reg signed [LN - 1:0] inp;
		sv2v_cast_83428_signed = inp;
	endfunction
	generate
		if (N == 1) begin : genblk2
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:27:9
			assign onehot = reversed;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:28:9
			assign index = 0;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:29:9
			assign valid_out = reversed;
		end
		else if (N == 2) begin : genblk2
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:33:9
			assign onehot = {~reversed[0], reversed[0]};
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:34:9
			assign index = ~reversed[0];
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:35:9
			assign valid_out = |reversed;
		end
		else if (MODEL == 1) begin : genblk2
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:39:9
			wire [N - 1:0] scan_lo;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:41:9
			VX_scan #(
				.N(N),
				.OP(2)
			) scan(
				.data_in(reversed),
				.data_out(scan_lo)
			);
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:49:9
			VX_lzc #(.N(N)) lzc(
				.in_i(reversed),
				.cnt_o(index)
			);
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:57:9
			assign onehot = scan_lo & {~scan_lo[N - 2:0], 1'b1};
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:58:9
			assign valid_out = scan_lo[N - 1];
		end
		else if (MODEL == 2) begin : genblk2
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:63:9
			wire [N - 1:0] higher_pri_regs;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:65:9
			assign higher_pri_regs[N - 1:1] = higher_pri_regs[N - 2:0] | reversed[N - 2:0];
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:66:9
			assign higher_pri_regs[0] = 1'b0;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:67:9
			assign onehot[N - 1:0] = reversed[N - 1:0] & ~higher_pri_regs[N - 1:0];
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:69:9
			VX_lzc #(.N(N)) lzc(
				.in_i(reversed),
				.cnt_o(index),
				.valid_o(valid_out)
			);
		end
		else if (MODEL == 3) begin : genblk2
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:79:9
			assign onehot = reversed & ~(reversed - 1);
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:81:9
			VX_lzc #(.N(N)) lzc(
				.in_i(reversed),
				.cnt_o(index),
				.valid_o(valid_out)
			);
		end
		else begin : genblk2
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:91:9
			reg [LN - 1:0] index_r;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:92:9
			reg [N - 1:0] onehot_r;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:94:9
			always @(*) begin
				// Trace: ../../rtl/libs/VX_priority_encoder.sv:95:13
				index_r = 1'sbx;
				// Trace: ../../rtl/libs/VX_priority_encoder.sv:96:13
				onehot_r = 1'sbx;
				// Trace: ../../rtl/libs/VX_priority_encoder.sv:97:13
				begin : sv2v_autoblock_1
					// Trace: ../../rtl/libs/VX_priority_encoder.sv:97:18
					integer i;
					// Trace: ../../rtl/libs/VX_priority_encoder.sv:97:18
					for (i = N - 1; i >= 0; i = i - 1)
						begin
							// Trace: ../../rtl/libs/VX_priority_encoder.sv:98:17
							if (reversed[i]) begin
								// Trace: ../../rtl/libs/VX_priority_encoder.sv:99:21
								index_r = sv2v_cast_83428_signed(i);
								// Trace: ../../rtl/libs/VX_priority_encoder.sv:100:21
								onehot_r = 0;
								// Trace: ../../rtl/libs/VX_priority_encoder.sv:101:21
								onehot_r[i] = 1'b1;
							end
						end
				end
			end
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:106:9
			assign index = index_r;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:107:9
			assign onehot = onehot_r;
			// Trace: ../../rtl/libs/VX_priority_encoder.sv:108:9
			assign valid_out = |reversed;
		end
	endgenerate
endmodule
module VX_onehot_encoder (
	data_in,
	data_out,
	valid_out
);
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:8:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:9:15
	parameter REVERSE = 0;
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:10:15
	parameter MODEL = 1;
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:11:15
	parameter LN = (N > 1 ? $clog2(N) : 1);
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:13:5
	input wire [N - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:14:5
	output wire [LN - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:15:5
	output wire valid_out;
	// Trace: ../../rtl/libs/VX_onehot_encoder.sv:17:5
	function automatic signed [(N > 1 ? $clog2(N) : 1) - 1:0] sv2v_cast_374F3_signed;
		input reg signed [(N > 1 ? $clog2(N) : 1) - 1:0] inp;
		sv2v_cast_374F3_signed = inp;
	endfunction
	generate
		if (N == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:19:9
			assign data_out = data_in;
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:20:9
			assign valid_out = data_in;
		end
		else if (N == 2) begin : genblk1
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:24:9
			assign data_out = data_in[!REVERSE];
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:25:9
			assign valid_out = |data_in;
		end
		else if (MODEL == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:29:9
			localparam levels_lp = $clog2(N);
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:30:9
			localparam aligned_width_lp = 1 << $clog2(N);
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:32:9
			wire [(levels_lp >= 0 ? ((levels_lp + 1) * aligned_width_lp) - 1 : ((1 - levels_lp) * aligned_width_lp) + ((levels_lp * aligned_width_lp) - 1)):(levels_lp >= 0 ? 0 : levels_lp * aligned_width_lp)] addr;
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:33:9
			wire [(levels_lp >= 0 ? ((levels_lp + 1) * aligned_width_lp) - 1 : ((1 - levels_lp) * aligned_width_lp) + ((levels_lp * aligned_width_lp) - 1)):(levels_lp >= 0 ? 0 : levels_lp * aligned_width_lp)] v;
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:36:9
			function automatic [aligned_width_lp - 1:0] sv2v_cast_65C44;
				input reg [aligned_width_lp - 1:0] inp;
				sv2v_cast_65C44 = inp;
			endfunction
			assign v[(levels_lp >= 0 ? 0 : levels_lp) * aligned_width_lp+:aligned_width_lp] = (REVERSE ? data_in << (aligned_width_lp - N) : sv2v_cast_65C44(data_in));
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:37:9
			assign addr[(levels_lp >= 0 ? 0 : levels_lp) * aligned_width_lp+:aligned_width_lp] = 1'sbx;
			genvar level;
			for (level = 1; level < (levels_lp + 1); level = level + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_onehot_encoder.sv:40:13
				localparam segments_lp = 2 ** (levels_lp - level);
				// Trace: ../../rtl/libs/VX_onehot_encoder.sv:41:13
				localparam segment_slot_lp = aligned_width_lp / segments_lp;
				// Trace: ../../rtl/libs/VX_onehot_encoder.sv:42:13
				localparam segment_width_lp = level;
				genvar segment;
				for (segment = 0; segment < segments_lp; segment = segment + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_onehot_encoder.sv:45:17
					wire [1:0] vs = {v[((levels_lp >= 0 ? level - 1 : levels_lp - (level - 1)) * aligned_width_lp) + ((segment * segment_slot_lp) + (segment_slot_lp >> 1))], v[((levels_lp >= 0 ? level - 1 : levels_lp - (level - 1)) * aligned_width_lp) + (segment * segment_slot_lp)]};
					// Trace: ../../rtl/libs/VX_onehot_encoder.sv:50:17
					assign v[((levels_lp >= 0 ? level : levels_lp - level) * aligned_width_lp) + (segment * segment_slot_lp)] = |vs;
					if (level == 1) begin : genblk1
						// Trace: ../../rtl/libs/VX_onehot_encoder.sv:53:21
						assign addr[((levels_lp >= 0 ? level : levels_lp - level) * aligned_width_lp) + (segment * segment_slot_lp)+:segment_width_lp] = vs[!REVERSE];
					end
					else begin : genblk1
						// Trace: ../../rtl/libs/VX_onehot_encoder.sv:55:21
						assign addr[((levels_lp >= 0 ? level : levels_lp - level) * aligned_width_lp) + (segment * segment_slot_lp)+:segment_width_lp] = {vs[!REVERSE], addr[((levels_lp >= 0 ? level - 1 : levels_lp - (level - 1)) * aligned_width_lp) + (segment * segment_slot_lp)+:segment_width_lp - 1] | addr[((levels_lp >= 0 ? level - 1 : levels_lp - (level - 1)) * aligned_width_lp) + ((segment * segment_slot_lp) + (segment_slot_lp >> 1))+:segment_width_lp - 1]};
					end
				end
			end
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:63:9
			assign data_out = addr[((levels_lp >= 0 ? levels_lp : levels_lp - levels_lp) * aligned_width_lp) + ((N > 1 ? $clog2(N) : 1) - 1)-:(N > 1 ? $clog2(N) : 1)];
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:64:9
			assign valid_out = v[(levels_lp >= 0 ? levels_lp : levels_lp - levels_lp) * aligned_width_lp];
		end
		else if (MODEL == 2) begin : genblk1
			genvar j;
			for (j = 0; j < LN; j = j + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_onehot_encoder.sv:69:13
				wire [N - 1:0] mask;
				genvar i;
				for (i = 0; i < N; i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_onehot_encoder.sv:71:17
					assign mask[i] = i[j];
				end
				// Trace: ../../rtl/libs/VX_onehot_encoder.sv:73:13
				assign data_out[j] = |(mask & data_in);
			end
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:76:9
			assign valid_out = |data_in;
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:80:9
			reg [LN - 1:0] index_r;
			if (REVERSE) begin : genblk1
				// Trace: ../../rtl/libs/VX_onehot_encoder.sv:83:13
				always @(*) begin
					// Trace: ../../rtl/libs/VX_onehot_encoder.sv:84:17
					index_r = 1'sbx;
					// Trace: ../../rtl/libs/VX_onehot_encoder.sv:85:17
					begin : sv2v_autoblock_1
						// Trace: ../../rtl/libs/VX_onehot_encoder.sv:85:22
						integer i;
						// Trace: ../../rtl/libs/VX_onehot_encoder.sv:85:22
						for (i = N - 1; i >= 0; i = i - 1)
							begin
								// Trace: ../../rtl/libs/VX_onehot_encoder.sv:86:21
								if (data_in[i])
									// Trace: ../../rtl/libs/VX_onehot_encoder.sv:87:25
									index_r = sv2v_cast_374F3_signed(i);
							end
					end
				end
			end
			else begin : genblk1
				// Trace: ../../rtl/libs/VX_onehot_encoder.sv:92:13
				always @(*) begin
					// Trace: ../../rtl/libs/VX_onehot_encoder.sv:93:17
					index_r = 1'sbx;
					// Trace: ../../rtl/libs/VX_onehot_encoder.sv:94:17
					begin : sv2v_autoblock_2
						// Trace: ../../rtl/libs/VX_onehot_encoder.sv:94:22
						integer i;
						// Trace: ../../rtl/libs/VX_onehot_encoder.sv:94:22
						for (i = 0; i < N; i = i + 1)
							begin
								// Trace: ../../rtl/libs/VX_onehot_encoder.sv:95:21
								if (data_in[i])
									// Trace: ../../rtl/libs/VX_onehot_encoder.sv:96:25
									index_r = sv2v_cast_374F3_signed(i);
							end
					end
				end
			end
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:102:9
			assign data_out = index_r;
			// Trace: ../../rtl/libs/VX_onehot_encoder.sv:103:9
			assign valid_out = |data_in;
		end
	endgenerate
endmodule
module VX_reset_relay (
	clk,
	reset,
	reset_o
);
	// Trace: ../../rtl/libs/VX_reset_relay.sv:4:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_reset_relay.sv:5:15
	parameter DEPTH = 1;
	// Trace: ../../rtl/libs/VX_reset_relay.sv:7:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_reset_relay.sv:8:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_reset_relay.sv:9:5
	output wire [N - 1:0] reset_o;
	// Trace: ../../rtl/libs/VX_reset_relay.sv:12:5
	generate
		if (DEPTH > 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_reset_relay.sv:13:37
			reg [N - 1:0] reset_r [DEPTH - 1:0];
			// Trace: ../../rtl/libs/VX_reset_relay.sv:14:9
			always @(posedge clk) begin
				// Trace: ../../rtl/libs/VX_reset_relay.sv:15:13
				begin : sv2v_autoblock_1
					// Trace: ../../rtl/libs/VX_reset_relay.sv:15:18
					integer i;
					// Trace: ../../rtl/libs/VX_reset_relay.sv:15:18
					for (i = DEPTH - 1; i > 0; i = i - 1)
						begin
							// Trace: ../../rtl/libs/VX_reset_relay.sv:16:17
							reset_r[i] <= reset_r[i - 1];
						end
				end
				// Trace: ../../rtl/libs/VX_reset_relay.sv:17:13
				reset_r[0] <= {N {reset}};
			end
			// Trace: ../../rtl/libs/VX_reset_relay.sv:19:9
			assign reset_o = reset_r[DEPTH - 1];
		end
		else if (DEPTH == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_reset_relay.sv:21:23
			reg [N - 1:0] reset_r;
			// Trace: ../../rtl/libs/VX_reset_relay.sv:22:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_reset_relay.sv:23:13
				reset_r <= {N {reset}};
			// Trace: ../../rtl/libs/VX_reset_relay.sv:25:9
			assign reset_o = reset_r;
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_reset_relay.sv:28:9
			assign reset_o = {N {reset}};
		end
	endgenerate
endmodule
module VX_sp_ram (
	clk,
	addr,
	wren,
	wdata,
	rdata
);
	// Trace: ../../rtl/libs/VX_sp_ram.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:6:15
	parameter SIZE = 1;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:7:15
	parameter BYTEENW = 1;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:8:15
	parameter OUT_REG = 0;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:9:15
	parameter NO_RWCHECK = 0;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:10:15
	parameter LUTRAM = 0;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:11:15
	parameter ADDRW = $clog2(SIZE);
	// Trace: ../../rtl/libs/VX_sp_ram.sv:12:15
	parameter INIT_ENABLE = 0;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:13:15
	parameter INIT_FILE = "";
	// Trace: ../../rtl/libs/VX_sp_ram.sv:14:15
	parameter [DATAW - 1:0] INIT_VALUE = 0;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:16:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:17:5
	input wire [ADDRW - 1:0] addr;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:18:5
	input wire [BYTEENW - 1:0] wren;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:19:5
	input wire [DATAW - 1:0] wdata;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:20:5
	output wire [DATAW - 1:0] rdata;
	// Trace: ../../rtl/libs/VX_sp_ram.sv:37:5
	generate
		if (LUTRAM) begin : genblk1
			if (OUT_REG) begin : genblk1
				// Trace: ../../rtl/libs/VX_sp_ram.sv:39:13
				reg [DATAW - 1:0] rdata_r;
				if (BYTEENW > 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_sp_ram.sv:42:32
					reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:44:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:44:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:44:234
							initial begin : sv2v_autoblock_1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:44:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:44:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:44:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_sp_ram.sv:46:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_sp_ram.sv:47:21
						begin : sv2v_autoblock_2
							// Trace: ../../rtl/libs/VX_sp_ram.sv:47:26
							integer i;
							// Trace: ../../rtl/libs/VX_sp_ram.sv:47:26
							for (i = 0; i < BYTEENW; i = i + 1)
								begin
									// Trace: ../../rtl/libs/VX_sp_ram.sv:48:25
									if (wren[i])
										// Trace: ../../rtl/libs/VX_sp_ram.sv:49:29
										ram[addr][i * 8+:8] <= wdata[i * 8+:8];
								end
						end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:51:21
						rdata_r <= ram[addr];
					end
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_sp_ram.sv:54:32
					reg [DATAW - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:56:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:56:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:56:234
							initial begin : sv2v_autoblock_3
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:56:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:56:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:56:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_sp_ram.sv:58:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_sp_ram.sv:59:21
						if (wren)
							// Trace: ../../rtl/libs/VX_sp_ram.sv:60:25
							ram[addr] <= wdata;
						// Trace: ../../rtl/libs/VX_sp_ram.sv:61:21
						rdata_r <= ram[addr];
					end
				end
				// Trace: ../../rtl/libs/VX_sp_ram.sv:64:13
				assign rdata = rdata_r;
			end
			else begin : genblk1
				if (BYTEENW > 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_sp_ram.sv:67:32
					reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:69:131
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:69:139
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:69:233
							initial begin : sv2v_autoblock_4
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:69:293
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:69:293
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:69:343
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_sp_ram.sv:71:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_sp_ram.sv:72:21
						begin : sv2v_autoblock_5
							// Trace: ../../rtl/libs/VX_sp_ram.sv:72:26
							integer i;
							// Trace: ../../rtl/libs/VX_sp_ram.sv:72:26
							for (i = 0; i < BYTEENW; i = i + 1)
								begin
									// Trace: ../../rtl/libs/VX_sp_ram.sv:73:25
									if (wren[i])
										// Trace: ../../rtl/libs/VX_sp_ram.sv:74:29
										ram[addr][i * 8+:8] <= wdata[i * 8+:8];
								end
						end
					// Trace: ../../rtl/libs/VX_sp_ram.sv:77:17
					assign rdata = ram[addr];
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_sp_ram.sv:79:32
					reg [DATAW - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:81:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:81:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:81:234
							initial begin : sv2v_autoblock_6
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:81:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:81:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:81:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_sp_ram.sv:83:17
					always @(posedge clk)
						// Trace: ../../rtl/libs/VX_sp_ram.sv:84:21
						if (wren)
							// Trace: ../../rtl/libs/VX_sp_ram.sv:85:25
							ram[addr] <= wdata;
					// Trace: ../../rtl/libs/VX_sp_ram.sv:87:17
					assign rdata = ram[addr];
				end
			end
		end
		else begin : genblk1
			if (OUT_REG) begin : genblk1
				// Trace: ../../rtl/libs/VX_sp_ram.sv:92:13
				reg [DATAW - 1:0] rdata_r;
				if (BYTEENW > 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_sp_ram.sv:95:17
					reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:97:132
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:97:140
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:97:234
							initial begin : sv2v_autoblock_7
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:97:294
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:97:294
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:97:344
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_sp_ram.sv:99:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_sp_ram.sv:100:21
						begin : sv2v_autoblock_8
							// Trace: ../../rtl/libs/VX_sp_ram.sv:100:26
							integer i;
							// Trace: ../../rtl/libs/VX_sp_ram.sv:100:26
							for (i = 0; i < BYTEENW; i = i + 1)
								begin
									// Trace: ../../rtl/libs/VX_sp_ram.sv:101:25
									if (wren[i])
										// Trace: ../../rtl/libs/VX_sp_ram.sv:102:29
										ram[addr][i * 8+:8] <= wdata[i * 8+:8];
								end
						end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:104:21
						rdata_r <= ram[addr];
					end
				end
				else begin : genblk1
					// Trace: ../../rtl/libs/VX_sp_ram.sv:107:17
					reg [DATAW - 1:0] ram [SIZE - 1:0];
					if (INIT_ENABLE) begin : genblk1
						if (INIT_FILE != "") begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:109:131
							initial begin
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:109:139
								$readmemh(INIT_FILE, ram);
							end
						end
						else begin : genblk1
							// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:109:233
							initial begin : sv2v_autoblock_9
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:109:293
								integer i;
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:109:293
								for (i = 0; i < SIZE; i = i + 1)
									begin
										// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:109:343
										ram[i] = INIT_VALUE;
									end
							end
						end
					end
					// Trace: ../../rtl/libs/VX_sp_ram.sv:111:17
					always @(posedge clk) begin
						// Trace: ../../rtl/libs/VX_sp_ram.sv:112:21
						if (wren)
							// Trace: ../../rtl/libs/VX_sp_ram.sv:113:25
							ram[addr] <= wdata;
						// Trace: ../../rtl/libs/VX_sp_ram.sv:114:21
						rdata_r <= ram[addr];
					end
				end
				// Trace: ../../rtl/libs/VX_sp_ram.sv:117:13
				assign rdata = rdata_r;
			end
			else begin : genblk1
				if (NO_RWCHECK) begin : genblk1
					if (BYTEENW > 1) begin : genblk1
						// Trace: ../../rtl/libs/VX_sp_ram.sv:121:38
						reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:123:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:123:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:123:238
								initial begin : sv2v_autoblock_10
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:123:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:123:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:123:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:125:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_sp_ram.sv:126:25
							begin : sv2v_autoblock_11
								// Trace: ../../rtl/libs/VX_sp_ram.sv:126:30
								integer i;
								// Trace: ../../rtl/libs/VX_sp_ram.sv:126:30
								for (i = 0; i < BYTEENW; i = i + 1)
									begin
										// Trace: ../../rtl/libs/VX_sp_ram.sv:127:29
										if (wren[i])
											// Trace: ../../rtl/libs/VX_sp_ram.sv:128:33
											ram[addr][i * 8+:8] <= wdata[i * 8+:8];
									end
							end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:131:21
						assign rdata = ram[addr];
					end
					else begin : genblk1
						// Trace: ../../rtl/libs/VX_sp_ram.sv:133:38
						reg [DATAW - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:135:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:135:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:135:238
								initial begin : sv2v_autoblock_12
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:135:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:135:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:135:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:137:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_sp_ram.sv:138:25
							if (wren)
								// Trace: ../../rtl/libs/VX_sp_ram.sv:139:29
								ram[addr] <= wdata;
						// Trace: ../../rtl/libs/VX_sp_ram.sv:141:21
						assign rdata = ram[addr];
					end
				end
				else begin : genblk1
					if (BYTEENW > 1) begin : genblk1
						// Trace: ../../rtl/libs/VX_sp_ram.sv:145:21
						reg [(BYTEENW * 8) - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:147:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:147:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:147:238
								initial begin : sv2v_autoblock_13
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:147:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:147:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:147:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:149:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_sp_ram.sv:150:25
							begin : sv2v_autoblock_14
								// Trace: ../../rtl/libs/VX_sp_ram.sv:150:30
								integer i;
								// Trace: ../../rtl/libs/VX_sp_ram.sv:150:30
								for (i = 0; i < BYTEENW; i = i + 1)
									begin
										// Trace: ../../rtl/libs/VX_sp_ram.sv:151:29
										if (wren[i])
											// Trace: ../../rtl/libs/VX_sp_ram.sv:152:33
											ram[addr][i * 8+:8] <= wdata[i * 8+:8];
									end
							end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:155:21
						assign rdata = ram[addr];
					end
					else begin : genblk1
						// Trace: ../../rtl/libs/VX_sp_ram.sv:157:21
						reg [DATAW - 1:0] ram [SIZE - 1:0];
						if (INIT_ENABLE) begin : genblk1
							if (INIT_FILE != "") begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:159:136
								initial begin
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:159:144
									$readmemh(INIT_FILE, ram);
								end
							end
							else begin : genblk1
								// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:159:238
								initial begin : sv2v_autoblock_15
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:159:298
									integer i;
									// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:159:298
									for (i = 0; i < SIZE; i = i + 1)
										begin
											// Trace: macro expansion of RAM_INITIALIZATION at ../../rtl/libs/VX_sp_ram.sv:159:348
											ram[i] = INIT_VALUE;
										end
								end
							end
						end
						// Trace: ../../rtl/libs/VX_sp_ram.sv:161:21
						always @(posedge clk)
							// Trace: ../../rtl/libs/VX_sp_ram.sv:162:25
							if (wren)
								// Trace: ../../rtl/libs/VX_sp_ram.sv:163:29
								ram[addr] <= wdata;
						// Trace: ../../rtl/libs/VX_sp_ram.sv:165:21
						assign rdata = ram[addr];
					end
				end
			end
		end
	endgenerate
endmodule
module VX_onehot_mux (
	data_in,
	sel_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_onehot_mux.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_onehot_mux.sv:6:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_onehot_mux.sv:7:15
	parameter MODEL = 1;
	// Trace: ../../rtl/libs/VX_onehot_mux.sv:9:5
	input wire [(N * DATAW) - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_onehot_mux.sv:10:5
	input wire [N - 1:0] sel_in;
	// Trace: ../../rtl/libs/VX_onehot_mux.sv:11:5
	output wire [DATAW - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_onehot_mux.sv:13:5
	generate
		if (N > 1) begin : genblk1
			if (MODEL == 1) begin : genblk1
				genvar i;
				for (i = 0; i < N; i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:16:17
					assign data_out = (sel_in[i] ? data_in[i * DATAW+:DATAW] : {DATAW {1'sbz}});
				end
			end
			else if (MODEL == 2) begin : genblk1
				// Trace: ../../rtl/libs/VX_onehot_mux.sv:19:13
				reg [DATAW - 1:0] data_out_r;
				// Trace: ../../rtl/libs/VX_onehot_mux.sv:20:13
				always @(*) begin
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:21:17
					data_out_r = 1'sb0;
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:22:17
					begin : sv2v_autoblock_1
						// Trace: ../../rtl/libs/VX_onehot_mux.sv:22:22
						integer i;
						// Trace: ../../rtl/libs/VX_onehot_mux.sv:22:22
						for (i = 0; i < N; i = i + 1)
							begin
								// Trace: ../../rtl/libs/VX_onehot_mux.sv:23:21
								data_out_r = data_out_r | ({DATAW {sel_in[i]}} & data_in[i * DATAW+:DATAW]);
							end
					end
				end
				// Trace: ../../rtl/libs/VX_onehot_mux.sv:26:13
				assign data_out = data_out_r;
			end
			else if (MODEL == 3) begin : genblk1
				// Trace: ../../rtl/libs/VX_onehot_mux.sv:28:13
				wire [(N * DATAW) - 1:0] mask;
				genvar i;
				for (i = 0; i < N; i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:30:17
					assign mask[i * DATAW+:DATAW] = {DATAW {sel_in[i]}} & data_in[i * DATAW+:DATAW];
				end
				for (i = 0; i < DATAW; i = i + 1) begin : genblk2
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:33:17
					wire [N - 1:0] gather;
					genvar j;
					for (j = 0; j < N; j = j + 1) begin : genblk1
						// Trace: ../../rtl/libs/VX_onehot_mux.sv:35:21
						assign gather[j] = mask[(j * DATAW) + i];
					end
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:37:17
					assign data_out[i] = |gather;
				end
			end
			else begin : genblk1
				// Trace: ../../rtl/libs/VX_onehot_mux.sv:40:13
				reg [DATAW - 1:0] data_out_r;
				// Trace: ../../rtl/libs/VX_onehot_mux.sv:41:13
				always @(*) begin
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:42:17
					data_out_r = 1'sbx;
					// Trace: ../../rtl/libs/VX_onehot_mux.sv:43:17
					begin : sv2v_autoblock_2
						// Trace: ../../rtl/libs/VX_onehot_mux.sv:43:22
						integer i;
						// Trace: ../../rtl/libs/VX_onehot_mux.sv:43:22
						for (i = N - 1; i >= 0; i = i - 1)
							begin
								// Trace: ../../rtl/libs/VX_onehot_mux.sv:44:21
								if (sel_in[i])
									// Trace: ../../rtl/libs/VX_onehot_mux.sv:45:25
									data_out_r = data_in[i * DATAW+:DATAW];
							end
					end
				end
				// Trace: ../../rtl/libs/VX_onehot_mux.sv:49:13
				assign data_out = data_out_r;
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_onehot_mux.sv:53:9
			assign data_out = data_in;
		end
	endgenerate
endmodule
module VX_rr_arbiter (
	clk,
	reset,
	enable,
	requests,
	grant_index,
	grant_onehot,
	grant_valid
);
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:5:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:6:15
	parameter LOCK_ENABLE = 0;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:7:15
	parameter MODEL = 1;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:8:15
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:10:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:11:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:12:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:13:5
	input wire [NUM_REQS - 1:0] requests;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:14:5
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:15:5
	output wire [NUM_REQS - 1:0] grant_onehot;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:16:5
	output wire grant_valid;
	// Trace: ../../rtl/libs/VX_rr_arbiter.sv:19:5
	function automatic signed [LOG_NUM_REQS - 1:0] sv2v_cast_76B5F_signed;
		input reg signed [LOG_NUM_REQS - 1:0] inp;
		sv2v_cast_76B5F_signed = inp;
	endfunction
	generate
		if (NUM_REQS == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:24:9
			assign grant_index = 0;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:25:9
			assign grant_onehot = requests;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:26:9
			assign grant_valid = requests[0];
		end
		else if (NUM_REQS == 2) begin : genblk1
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:30:9
			reg [LOG_NUM_REQS - 1:0] grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:31:9
			reg [NUM_REQS - 1:0] grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:32:9
			reg [LOG_NUM_REQS - 1:0] state;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:34:9
			always @(*)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:35:13
				casez ({state, requests})
					3'b001, 3'b1z1: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:37:28
						grant_onehot_r = 2'b01;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:37:52
						grant_index_r = sv2v_cast_76B5F_signed(0);
					end
					default: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:38:28
						grant_onehot_r = 2'b10;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:38:52
						grant_index_r = sv2v_cast_76B5F_signed(1);
					end
				endcase
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:42:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:43:13
				if (reset)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:44:17
					state <= 0;
				else if (!LOCK_ENABLE || enable)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:46:17
					state <= grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:50:9
			assign grant_index = grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:51:9
			assign grant_onehot = grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:52:9
			assign grant_valid = |requests;
		end
		else if (NUM_REQS == 4) begin : genblk1
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:56:9
			reg [LOG_NUM_REQS - 1:0] grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:57:9
			reg [NUM_REQS - 1:0] grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:58:9
			reg [LOG_NUM_REQS - 1:0] state;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:60:9
			always @(*)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:61:13
				casez ({state, requests})
					6'b000001, 6'b0100z1, 6'b100zz1, 6'b11zzz1: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:65:31
						grant_onehot_r = 4'b0001;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:65:57
						grant_index_r = sv2v_cast_76B5F_signed(0);
					end
					6'b00zz1z, 6'b010010, 6'b100z10, 6'b11zz10: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:69:31
						grant_onehot_r = 4'b0010;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:69:57
						grant_index_r = sv2v_cast_76B5F_signed(1);
					end
					6'b00z10z, 6'b01z1zz, 6'b100100, 6'b11z100: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:73:31
						grant_onehot_r = 4'b0100;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:73:57
						grant_index_r = sv2v_cast_76B5F_signed(2);
					end
					default: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:74:31
						grant_onehot_r = 4'b1000;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:74:57
						grant_index_r = sv2v_cast_76B5F_signed(3);
					end
				endcase
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:78:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:79:13
				if (reset)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:80:17
					state <= 0;
				else if (!LOCK_ENABLE || enable)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:82:17
					state <= grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:86:9
			assign grant_index = grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:87:9
			assign grant_onehot = grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:88:9
			assign grant_valid = |requests;
		end
		else if (NUM_REQS == 8) begin : genblk1
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:92:9
			reg [LOG_NUM_REQS - 1:0] grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:93:9
			reg [NUM_REQS - 1:0] grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:94:9
			reg [LOG_NUM_REQS - 1:0] state;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:96:9
			always @(*)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:97:13
				casez ({state, requests})
					11'b00000000001, 11'b001000000z1, 11'b01000000zz1, 11'b0110000zzz1, 11'b100000zzzz1, 11'b10100zzzzz1, 11'b1100zzzzzz1, 11'b111zzzzzzz1: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:105:37
						grant_onehot_r = 8'b00000001;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:105:67
						grant_index_r = sv2v_cast_76B5F_signed(0);
					end
					11'b000zzzzzz1z, 11'b00100000010, 11'b01000000z10, 11'b0110000zz10, 11'b100000zzz10, 11'b10100zzzz10, 11'b1100zzzzz10, 11'b111zzzzzz10: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:113:37
						grant_onehot_r = 8'b00000010;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:113:67
						grant_index_r = sv2v_cast_76B5F_signed(1);
					end
					11'b000zzzzz10z, 11'b001zzzzz1zz, 11'b01000000100, 11'b0110000z100, 11'b100000zz100, 11'b10100zzz100, 11'b1100zzzz100, 11'b111zzzzz100: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:121:37
						grant_onehot_r = 8'b00000100;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:121:67
						grant_index_r = sv2v_cast_76B5F_signed(2);
					end
					11'b000zzzz100z, 11'b001zzzz10zz, 11'b010zzzz1zzz, 11'b01100001000, 11'b100000z1000, 11'b10100zz1000, 11'b1100zzz1000, 11'b111zzzz1000: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:129:37
						grant_onehot_r = 8'b00001000;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:129:67
						grant_index_r = sv2v_cast_76B5F_signed(3);
					end
					11'b000zzz1000z, 11'b001zzz100zz, 11'b010zzz10zzz, 11'b011zzz1zzzz, 11'b10000010000, 11'b10100z10000, 11'b1100zz10000, 11'b111zzz10000: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:137:37
						grant_onehot_r = 8'b00010000;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:137:67
						grant_index_r = sv2v_cast_76B5F_signed(4);
					end
					11'b000zz10000z, 11'b001zz1000zz, 11'b010zz100zzz, 11'b011zz10zzzz, 11'b100zz1zzzzz, 11'b10100100000, 11'b1100z100000, 11'b111zz100000: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:145:37
						grant_onehot_r = 8'b00100000;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:145:67
						grant_index_r = sv2v_cast_76B5F_signed(5);
					end
					11'b000z100000z, 11'b001z10000zz, 11'b010z1000zzz, 11'b011z100zzzz, 11'b100z10zzzzz, 11'b101z1zzzzzz, 11'b11001000000, 11'b111z1000000: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:153:37
						grant_onehot_r = 8'b01000000;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:153:67
						grant_index_r = sv2v_cast_76B5F_signed(6);
					end
					default: begin
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:154:37
						grant_onehot_r = 8'b10000000;
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:154:67
						grant_index_r = sv2v_cast_76B5F_signed(7);
					end
				endcase
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:158:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:159:13
				if (reset)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:160:17
					state <= 0;
				else if (!LOCK_ENABLE || enable)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:162:17
					state <= grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:166:9
			assign grant_index = grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:167:9
			assign grant_onehot = grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:168:9
			assign grant_valid = |requests;
		end
		else if (MODEL == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:173:9
			wire [NUM_REQS - 1:0] mask_higher_pri_regs;
			wire [NUM_REQS - 1:0] unmask_higher_pri_regs;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:175:9
			wire [NUM_REQS - 1:0] grant_masked;
			wire [NUM_REQS - 1:0] grant_unmasked;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:177:9
			reg [NUM_REQS - 1:0] pointer_reg;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:179:9
			wire [NUM_REQS - 1:0] req_masked = requests & pointer_reg;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:181:9
			assign mask_higher_pri_regs[NUM_REQS - 1:1] = mask_higher_pri_regs[NUM_REQS - 2:0] | req_masked[NUM_REQS - 2:0];
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:182:9
			assign mask_higher_pri_regs[0] = 1'b0;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:183:9
			assign grant_masked[NUM_REQS - 1:0] = req_masked[NUM_REQS - 1:0] & ~mask_higher_pri_regs[NUM_REQS - 1:0];
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:185:9
			assign unmask_higher_pri_regs[NUM_REQS - 1:1] = unmask_higher_pri_regs[NUM_REQS - 2:0] | requests[NUM_REQS - 2:0];
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:186:9
			assign unmask_higher_pri_regs[0] = 1'b0;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:187:9
			assign grant_unmasked[NUM_REQS - 1:0] = requests[NUM_REQS - 1:0] & ~unmask_higher_pri_regs[NUM_REQS - 1:0];
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:189:9
			wire no_req_masked = ~(|req_masked);
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:190:9
			assign grant_onehot = ({NUM_REQS {no_req_masked}} & grant_unmasked) | grant_masked;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:192:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:193:7
				if (reset)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:194:5
					pointer_reg <= {NUM_REQS {1'b1}};
				else if (!LOCK_ENABLE || enable)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:196:5
					if (|req_masked)
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:197:21
						pointer_reg <= mask_higher_pri_regs;
					else if (|requests)
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:199:21
						pointer_reg <= unmask_higher_pri_regs;
					else
						// Trace: ../../rtl/libs/VX_rr_arbiter.sv:201:21
						pointer_reg <= pointer_reg;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:206:9
			assign grant_valid = |requests;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:208:9
			VX_onehot_encoder #(.N(NUM_REQS)) onehot_encoder(
				.data_in(grant_onehot),
				.data_out(grant_index)
			);
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:218:9
			reg [LOG_NUM_REQS - 1:0] grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:219:9
			reg [NUM_REQS - 1:0] grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:220:9
			reg [NUM_REQS - 1:0] state;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:222:9
			always @(*) begin
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:223:13
				grant_index_r = 1'sbx;
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:224:13
				grant_onehot_r = 1'sbx;
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:225:13
				begin : sv2v_autoblock_1
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:225:18
					integer i;
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:225:18
					for (i = 0; i < NUM_REQS; i = i + 1)
						begin
							// Trace: ../../rtl/libs/VX_rr_arbiter.sv:226:17
							begin : sv2v_autoblock_2
								// Trace: ../../rtl/libs/VX_rr_arbiter.sv:226:22
								integer j;
								// Trace: ../../rtl/libs/VX_rr_arbiter.sv:226:22
								for (j = 0; j < NUM_REQS; j = j + 1)
									begin
										// Trace: ../../rtl/libs/VX_rr_arbiter.sv:227:21
										if (state[i] && requests[(j + 1) % NUM_REQS]) begin
											// Trace: ../../rtl/libs/VX_rr_arbiter.sv:228:25
											grant_index_r = sv2v_cast_76B5F_signed((j + 1) % NUM_REQS);
											// Trace: ../../rtl/libs/VX_rr_arbiter.sv:229:25
											grant_onehot_r = 1'sb0;
											// Trace: ../../rtl/libs/VX_rr_arbiter.sv:230:25
											grant_onehot_r[(j + 1) % NUM_REQS] = 1;
										end
									end
							end
						end
				end
			end
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:236:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_rr_arbiter.sv:237:13
				if (reset)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:238:17
					state <= 0;
				else if (!LOCK_ENABLE || enable)
					// Trace: ../../rtl/libs/VX_rr_arbiter.sv:240:17
					state <= grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:244:9
			assign grant_index = grant_index_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:245:9
			assign grant_onehot = grant_onehot_r;
			// Trace: ../../rtl/libs/VX_rr_arbiter.sv:246:9
			assign grant_valid = |requests;
		end
	endgenerate
endmodule
module VX_fixed_arbiter (
	clk,
	reset,
	requests,
	enable,
	grant_index,
	grant_onehot,
	grant_valid
);
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:5:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:6:15
	parameter LOCK_ENABLE = 0;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:7:15
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:9:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:10:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:11:5
	input wire [NUM_REQS - 1:0] requests;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:12:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:13:5
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:14:5
	output wire [NUM_REQS - 1:0] grant_onehot;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:15:5
	output wire grant_valid;
	// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:23:5
	generate
		if (NUM_REQS == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:25:9
			assign grant_index = 0;
			// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:26:9
			assign grant_onehot = requests;
			// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:27:9
			assign grant_valid = requests[0];
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_fixed_arbiter.sv:31:9
			VX_priority_encoder #(.N(NUM_REQS)) tid_select(
				.data_in(requests),
				.index(grant_index),
				.onehot(grant_onehot),
				.valid_out(grant_valid)
			);
		end
	endgenerate
endmodule
module VX_scope (
	clk,
	reset,
	start,
	stop,
	changed,
	data_in,
	bus_in,
	bus_out,
	bus_write,
	bus_read
);
	// Trace: ../../rtl/libs/VX_scope.sv:5:15
	parameter DATAW = 64;
	// Trace: ../../rtl/libs/VX_scope.sv:6:15
	parameter BUSW = 64;
	// Trace: ../../rtl/libs/VX_scope.sv:7:15
	parameter SIZE = 16;
	// Trace: ../../rtl/libs/VX_scope.sv:8:15
	parameter UPDW = 1;
	// Trace: ../../rtl/libs/VX_scope.sv:9:15
	parameter DELTAW = 16;
	// Trace: ../../rtl/libs/VX_scope.sv:11:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_scope.sv:12:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_scope.sv:13:5
	input wire start;
	// Trace: ../../rtl/libs/VX_scope.sv:14:5
	input wire stop;
	// Trace: ../../rtl/libs/VX_scope.sv:15:5
	input wire changed;
	// Trace: ../../rtl/libs/VX_scope.sv:16:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_scope.sv:17:5
	input wire [BUSW - 1:0] bus_in;
	// Trace: ../../rtl/libs/VX_scope.sv:18:5
	output wire [BUSW - 1:0] bus_out;
	// Trace: ../../rtl/libs/VX_scope.sv:19:5
	input wire bus_write;
	// Trace: ../../rtl/libs/VX_scope.sv:20:5
	input wire bus_read;
	// Trace: ../../rtl/libs/VX_scope.sv:22:5
	localparam UPDW_ENABLE = UPDW != 0;
	// Trace: ../../rtl/libs/VX_scope.sv:23:5
	localparam MAX_DELTA = (2 ** DELTAW) - 1;
	// Trace: ../../rtl/libs/VX_scope.sv:25:5
	localparam CMD_GET_VALID = 3'd0;
	// Trace: ../../rtl/libs/VX_scope.sv:26:5
	localparam CMD_GET_DATA = 3'd1;
	// Trace: ../../rtl/libs/VX_scope.sv:27:5
	localparam CMD_GET_WIDTH = 3'd2;
	// Trace: ../../rtl/libs/VX_scope.sv:28:5
	localparam CMD_GET_COUNT = 3'd3;
	// Trace: ../../rtl/libs/VX_scope.sv:29:5
	localparam CMD_SET_START = 3'd4;
	// Trace: ../../rtl/libs/VX_scope.sv:30:5
	localparam CMD_SET_STOP = 3'd5;
	// Trace: ../../rtl/libs/VX_scope.sv:31:5
	localparam CMD_GET_OFFSET = 3'd6;
	// Trace: ../../rtl/libs/VX_scope.sv:33:5
	localparam GET_VALID = 3'd0;
	// Trace: ../../rtl/libs/VX_scope.sv:34:5
	localparam GET_DATA = 3'd1;
	// Trace: ../../rtl/libs/VX_scope.sv:35:5
	localparam GET_WIDTH = 3'd2;
	// Trace: ../../rtl/libs/VX_scope.sv:36:5
	localparam GET_COUNT = 3'd3;
	// Trace: ../../rtl/libs/VX_scope.sv:37:5
	localparam GET_OFFSET = 3'd6;
	// Trace: ../../rtl/libs/VX_scope.sv:39:22
	reg [DATAW - 1:0] data_store [SIZE - 1:0];
	// Trace: ../../rtl/libs/VX_scope.sv:40:22
	reg [DELTAW - 1:0] delta_store [SIZE - 1:0];
	// Trace: ../../rtl/libs/VX_scope.sv:42:5
	reg [UPDW - 1:0] prev_trigger_id;
	// Trace: ../../rtl/libs/VX_scope.sv:43:5
	reg [DELTAW - 1:0] delta;
	// Trace: ../../rtl/libs/VX_scope.sv:44:5
	reg [BUSW - 1:0] bus_out_r;
	// Trace: ../../rtl/libs/VX_scope.sv:45:5
	reg [63:0] timestamp;
	reg [63:0] start_time;
	// Trace: ../../rtl/libs/VX_scope.sv:47:5
	reg [$clog2(SIZE) - 1:0] raddr;
	reg [$clog2(SIZE) - 1:0] waddr;
	reg [$clog2(SIZE) - 1:0] waddr_end;
	// Trace: ../../rtl/libs/VX_scope.sv:49:5
	reg [(DATAW > 1 ? $clog2(DATAW) : 1) - 1:0] read_offset;
	// Trace: ../../rtl/libs/VX_scope.sv:51:5
	reg cmd_start;
	reg started;
	reg start_wait;
	reg recording;
	reg data_valid;
	reg read_delta;
	reg delta_flush;
	// Trace: ../../rtl/libs/VX_scope.sv:53:5
	reg [BUSW - 3:0] delay_val;
	reg [BUSW - 3:0] delay_cntr;
	// Trace: ../../rtl/libs/VX_scope.sv:55:5
	reg [2:0] get_cmd;
	// Trace: ../../rtl/libs/VX_scope.sv:56:5
	wire [2:0] cmd_type;
	// Trace: ../../rtl/libs/VX_scope.sv:57:5
	wire [BUSW - 4:0] cmd_data;
	// Trace: ../../rtl/libs/VX_scope.sv:58:5
	assign {cmd_data, cmd_type} = bus_in;
	// Trace: ../../rtl/libs/VX_scope.sv:60:5
	wire [UPDW - 1:0] trigger_id = data_in[UPDW - 1:0];
	// Trace: ../../rtl/libs/VX_scope.sv:62:5
	function automatic [2:0] sv2v_cast_796CB;
		input reg [2:0] inp;
		sv2v_cast_796CB = inp;
	endfunction
	function automatic signed [$clog2(SIZE) - 1:0] sv2v_cast_088D1_signed;
		input reg signed [$clog2(SIZE) - 1:0] inp;
		sv2v_cast_088D1_signed = inp;
	endfunction
	function automatic [((BUSW - 3) >= 0 ? BUSW - 2 : 4 - BUSW) - 1:0] sv2v_cast_E8B95;
		input reg [((BUSW - 3) >= 0 ? BUSW - 2 : 4 - BUSW) - 1:0] inp;
		sv2v_cast_E8B95 = inp;
	endfunction
	function automatic [$clog2(SIZE) - 1:0] sv2v_cast_088D1;
		input reg [$clog2(SIZE) - 1:0] inp;
		sv2v_cast_088D1 = inp;
	endfunction
	function automatic signed [DELTAW - 1:0] sv2v_cast_B4011_signed;
		input reg signed [DELTAW - 1:0] inp;
		sv2v_cast_B4011_signed = inp;
	endfunction
	function automatic signed [(DATAW > 1 ? $clog2(DATAW) : 1) - 1:0] sv2v_cast_11141_signed;
		input reg signed [(DATAW > 1 ? $clog2(DATAW) : 1) - 1:0] inp;
		sv2v_cast_11141_signed = inp;
	endfunction
	always @(posedge clk) begin
		// Trace: ../../rtl/libs/VX_scope.sv:63:9
		if (reset) begin
			// Trace: ../../rtl/libs/VX_scope.sv:64:13
			get_cmd <= sv2v_cast_796CB(CMD_GET_VALID);
			// Trace: ../../rtl/libs/VX_scope.sv:65:13
			raddr <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:66:13
			waddr <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:67:13
			waddr_end <= sv2v_cast_088D1_signed(SIZE - 1);
			// Trace: ../../rtl/libs/VX_scope.sv:68:13
			cmd_start <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:69:13
			started <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:70:13
			start_wait <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:71:13
			recording <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:72:13
			delay_val <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:73:13
			delay_cntr <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:74:13
			delta <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:75:13
			delta_flush <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:76:13
			prev_trigger_id <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:77:13
			read_offset <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:78:13
			read_delta <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:79:13
			data_valid <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:80:13
			timestamp <= 0;
			// Trace: ../../rtl/libs/VX_scope.sv:81:13
			start_time <= 0;
		end
		else begin
			// Trace: ../../rtl/libs/VX_scope.sv:84:13
			timestamp <= timestamp + 1;
			// Trace: ../../rtl/libs/VX_scope.sv:86:13
			if (bus_write)
				// Trace: ../../rtl/libs/VX_scope.sv:87:17
				case (cmd_type)
					CMD_GET_VALID, CMD_GET_DATA, CMD_GET_WIDTH, CMD_GET_OFFSET, CMD_GET_COUNT:
						// Trace: ../../rtl/libs/VX_scope.sv:92:36
						get_cmd <= sv2v_cast_796CB(cmd_type);
					CMD_SET_START: begin
						// Trace: ../../rtl/libs/VX_scope.sv:94:25
						delay_val <= sv2v_cast_E8B95(cmd_data);
						// Trace: ../../rtl/libs/VX_scope.sv:95:25
						cmd_start <= 1;
					end
					CMD_SET_STOP:
						// Trace: ../../rtl/libs/VX_scope.sv:101:25
						waddr_end <= sv2v_cast_088D1(cmd_data);
					default:
						;
				endcase
			if (!started && (start || cmd_start)) begin
				// Trace: ../../rtl/libs/VX_scope.sv:111:17
				started <= 1;
				// Trace: ../../rtl/libs/VX_scope.sv:112:17
				delta_flush <= 1;
				// Trace: ../../rtl/libs/VX_scope.sv:113:17
				if (0 == delay_val) begin
					// Trace: ../../rtl/libs/VX_scope.sv:114:21
					start_wait <= 0;
					// Trace: ../../rtl/libs/VX_scope.sv:115:21
					recording <= 1;
					// Trace: ../../rtl/libs/VX_scope.sv:116:21
					delta <= 0;
					// Trace: ../../rtl/libs/VX_scope.sv:117:21
					delay_cntr <= 0;
					// Trace: ../../rtl/libs/VX_scope.sv:118:21
					start_time <= timestamp;
				end
				else begin
					// Trace: ../../rtl/libs/VX_scope.sv:123:21
					start_wait <= 1;
					// Trace: ../../rtl/libs/VX_scope.sv:124:21
					delay_cntr <= delay_val;
				end
			end
			if (start_wait) begin
				// Trace: ../../rtl/libs/VX_scope.sv:129:17
				delay_cntr <= delay_cntr - 1;
				// Trace: ../../rtl/libs/VX_scope.sv:130:17
				if (1 == delay_cntr) begin
					// Trace: ../../rtl/libs/VX_scope.sv:131:21
					start_wait <= 0;
					// Trace: ../../rtl/libs/VX_scope.sv:132:21
					recording <= 1;
					// Trace: ../../rtl/libs/VX_scope.sv:133:21
					delta <= 0;
					// Trace: ../../rtl/libs/VX_scope.sv:134:21
					start_time <= timestamp;
				end
			end
			if (recording) begin
				// Trace: ../../rtl/libs/VX_scope.sv:142:17
				if (UPDW_ENABLE) begin
					// Trace: ../../rtl/libs/VX_scope.sv:143:21
					if ((delta_flush || changed) || (trigger_id != prev_trigger_id)) begin
						// Trace: ../../rtl/libs/VX_scope.sv:146:25
						delta_store[waddr] <= delta;
						// Trace: ../../rtl/libs/VX_scope.sv:147:25
						data_store[waddr] <= data_in;
						// Trace: ../../rtl/libs/VX_scope.sv:148:25
						waddr <= waddr + sv2v_cast_088D1_signed(1);
						// Trace: ../../rtl/libs/VX_scope.sv:149:25
						delta <= 0;
						// Trace: ../../rtl/libs/VX_scope.sv:150:25
						delta_flush <= 0;
					end
					else begin
						// Trace: ../../rtl/libs/VX_scope.sv:152:25
						delta <= delta + sv2v_cast_B4011_signed(1);
						// Trace: ../../rtl/libs/VX_scope.sv:153:25
						delta_flush <= delta == (MAX_DELTA - 1);
					end
					// Trace: ../../rtl/libs/VX_scope.sv:155:21
					prev_trigger_id <= trigger_id;
				end
				else begin
					// Trace: ../../rtl/libs/VX_scope.sv:157:21
					delta_store[waddr] <= 0;
					// Trace: ../../rtl/libs/VX_scope.sv:158:21
					data_store[waddr] <= data_in;
					// Trace: ../../rtl/libs/VX_scope.sv:159:21
					waddr <= waddr + 1;
				end
				if (stop || (waddr >= waddr_end)) begin
					// Trace: ../../rtl/libs/VX_scope.sv:167:21
					waddr <= waddr;
					// Trace: ../../rtl/libs/VX_scope.sv:168:21
					recording <= 0;
					// Trace: ../../rtl/libs/VX_scope.sv:169:21
					data_valid <= 1;
					// Trace: ../../rtl/libs/VX_scope.sv:170:21
					read_delta <= 1;
				end
			end
			if ((bus_read && (get_cmd == GET_DATA)) && data_valid)
				// Trace: ../../rtl/libs/VX_scope.sv:177:17
				if (read_delta)
					// Trace: ../../rtl/libs/VX_scope.sv:178:21
					read_delta <= 0;
				else
					// Trace: ../../rtl/libs/VX_scope.sv:180:21
					if (DATAW > BUSW) begin
						begin
							// Trace: ../../rtl/libs/VX_scope.sv:181:25
							if (read_offset < sv2v_cast_11141_signed(DATAW - BUSW))
								// Trace: ../../rtl/libs/VX_scope.sv:182:29
								read_offset <= read_offset + sv2v_cast_11141_signed(BUSW);
							else begin
								// Trace: ../../rtl/libs/VX_scope.sv:184:29
								raddr <= raddr + sv2v_cast_088D1_signed(1);
								// Trace: ../../rtl/libs/VX_scope.sv:185:29
								read_offset <= 0;
								// Trace: ../../rtl/libs/VX_scope.sv:186:29
								read_delta <= 1;
								// Trace: ../../rtl/libs/VX_scope.sv:187:29
								if (raddr == waddr)
									// Trace: ../../rtl/libs/VX_scope.sv:188:33
									data_valid <= 0;
							end
						end
					end
					else begin
						// Trace: ../../rtl/libs/VX_scope.sv:192:25
						raddr <= raddr + 1;
						// Trace: ../../rtl/libs/VX_scope.sv:193:25
						read_delta <= 1;
						// Trace: ../../rtl/libs/VX_scope.sv:194:25
						if (raddr == waddr)
							// Trace: ../../rtl/libs/VX_scope.sv:195:29
							data_valid <= 0;
					end
		end
		if (recording)
			// Trace: ../../rtl/libs/VX_scope.sv:203:13
			if (UPDW_ENABLE) begin
				begin
					// Trace: ../../rtl/libs/VX_scope.sv:204:17
					if ((delta_flush || changed) || (trigger_id != prev_trigger_id)) begin
						// Trace: ../../rtl/libs/VX_scope.sv:207:21
						delta_store[waddr] <= delta;
						// Trace: ../../rtl/libs/VX_scope.sv:208:21
						data_store[waddr] <= data_in;
					end
				end
			end
			else begin
				// Trace: ../../rtl/libs/VX_scope.sv:211:17
				delta_store[waddr] <= 0;
				// Trace: ../../rtl/libs/VX_scope.sv:212:17
				data_store[waddr] <= data_in;
			end
	end
	// Trace: ../../rtl/libs/VX_scope.sv:217:5
	function automatic [BUSW - 1:0] sv2v_cast_39A33;
		input reg [BUSW - 1:0] inp;
		sv2v_cast_39A33 = inp;
	endfunction
	function automatic signed [BUSW - 1:0] sv2v_cast_39A33_signed;
		input reg signed [BUSW - 1:0] inp;
		sv2v_cast_39A33_signed = inp;
	endfunction
	always @(*)
		// Trace: ../../rtl/libs/VX_scope.sv:218:9
		case (get_cmd)
			GET_VALID:
				// Trace: ../../rtl/libs/VX_scope.sv:219:25
				bus_out_r = sv2v_cast_39A33(data_valid);
			GET_WIDTH:
				// Trace: ../../rtl/libs/VX_scope.sv:220:25
				bus_out_r = sv2v_cast_39A33_signed(DATAW);
			GET_COUNT:
				// Trace: ../../rtl/libs/VX_scope.sv:221:25
				bus_out_r = sv2v_cast_39A33(waddr) + sv2v_cast_39A33_signed(1);
			GET_OFFSET:
				// Trace: ../../rtl/libs/VX_scope.sv:222:25
				bus_out_r = sv2v_cast_39A33(start_time);
			GET_DATA:
				// Trace: ../../rtl/libs/VX_scope.sv:224:25
				bus_out_r = (read_delta ? sv2v_cast_39A33(delta_store[raddr]) : sv2v_cast_39A33(data_store[raddr] >> read_offset));
			default:
				// Trace: ../../rtl/libs/VX_scope.sv:226:25
				bus_out_r = 0;
		endcase
	// Trace: ../../rtl/libs/VX_scope.sv:230:5
	assign bus_out = bus_out_r;
endmodule
module VX_shift_register_nr (
	clk,
	enable,
	data_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_shift_register.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:6:15
	parameter DEPTH = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:7:15
	parameter NTAPS = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:8:15
	parameter DEPTHW = $clog2(DEPTH);
	// Trace: ../../rtl/libs/VX_shift_register.sv:9:15
	function automatic signed [DEPTHW - 1:0] sv2v_cast_5F7C4_signed;
		input reg signed [DEPTHW - 1:0] inp;
		sv2v_cast_5F7C4_signed = inp;
	endfunction
	parameter [(DEPTHW * NTAPS) - 1:0] TAPS = {NTAPS {sv2v_cast_5F7C4_signed(DEPTH - 1)}};
	// Trace: ../../rtl/libs/VX_shift_register.sv:11:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_shift_register.sv:12:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_shift_register.sv:13:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_shift_register.sv:14:5
	output wire [(NTAPS * DATAW) - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_shift_register.sv:16:5
	reg [(DEPTH * DATAW) - 1:0] entries;
	// Trace: ../../rtl/libs/VX_shift_register.sv:18:5
	always @(posedge clk)
		// Trace: ../../rtl/libs/VX_shift_register.sv:19:9
		if (enable) begin
			// Trace: ../../rtl/libs/VX_shift_register.sv:20:13
			begin : sv2v_autoblock_1
				// Trace: ../../rtl/libs/VX_shift_register.sv:20:18
				integer i;
				// Trace: ../../rtl/libs/VX_shift_register.sv:20:18
				for (i = DEPTH - 1; i > 0; i = i - 1)
					begin
						// Trace: ../../rtl/libs/VX_shift_register.sv:21:17
						entries[i * DATAW+:DATAW] <= entries[(i - 1) * DATAW+:DATAW];
					end
			end
			// Trace: ../../rtl/libs/VX_shift_register.sv:22:13
			entries[0+:DATAW] <= data_in;
		end
	// Trace: ../../rtl/libs/VX_shift_register.sv:26:5
	genvar i;
	generate
		for (i = 0; i < NTAPS; i = i + 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_shift_register.sv:27:9
			assign data_out[i * DATAW+:DATAW] = entries[TAPS[i * DEPTHW+:DEPTHW] * DATAW+:DATAW];
		end
	endgenerate
endmodule
module VX_shift_register_wr (
	clk,
	reset,
	enable,
	data_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_shift_register.sv:33:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:34:15
	parameter DEPTH = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:35:15
	parameter NTAPS = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:36:15
	parameter DEPTHW = $clog2(DEPTH);
	// Trace: ../../rtl/libs/VX_shift_register.sv:37:15
	function automatic signed [DEPTHW - 1:0] sv2v_cast_5F7C4_signed;
		input reg signed [DEPTHW - 1:0] inp;
		sv2v_cast_5F7C4_signed = inp;
	endfunction
	parameter [(DEPTHW * NTAPS) - 1:0] TAPS = {NTAPS {sv2v_cast_5F7C4_signed(DEPTH - 1)}};
	// Trace: ../../rtl/libs/VX_shift_register.sv:39:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_shift_register.sv:40:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_shift_register.sv:41:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_shift_register.sv:42:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_shift_register.sv:43:5
	output wire [(NTAPS * DATAW) - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_shift_register.sv:45:5
	reg [(DEPTH * DATAW) - 1:0] entries;
	// Trace: ../../rtl/libs/VX_shift_register.sv:47:5
	always @(posedge clk)
		// Trace: ../../rtl/libs/VX_shift_register.sv:48:9
		if (reset)
			// Trace: ../../rtl/libs/VX_shift_register.sv:49:13
			entries <= 1'sb0;
		else if (enable) begin
			// Trace: ../../rtl/libs/VX_shift_register.sv:51:13
			begin : sv2v_autoblock_1
				// Trace: ../../rtl/libs/VX_shift_register.sv:51:18
				integer i;
				// Trace: ../../rtl/libs/VX_shift_register.sv:51:18
				for (i = DEPTH - 1; i > 0; i = i - 1)
					begin
						// Trace: ../../rtl/libs/VX_shift_register.sv:52:17
						entries[i * DATAW+:DATAW] <= entries[(i - 1) * DATAW+:DATAW];
					end
			end
			// Trace: ../../rtl/libs/VX_shift_register.sv:53:13
			entries[0+:DATAW] <= data_in;
		end
	// Trace: ../../rtl/libs/VX_shift_register.sv:57:5
	genvar i;
	generate
		for (i = 0; i < NTAPS; i = i + 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_shift_register.sv:58:9
			assign data_out[i * DATAW+:DATAW] = entries[TAPS[i * DEPTHW+:DEPTHW] * DATAW+:DATAW];
		end
	endgenerate
endmodule
module VX_shift_register (
	clk,
	reset,
	enable,
	data_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_shift_register.sv:64:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:65:15
	parameter RESETW = 0;
	// Trace: ../../rtl/libs/VX_shift_register.sv:66:15
	parameter DEPTH = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:67:15
	parameter NTAPS = 1;
	// Trace: ../../rtl/libs/VX_shift_register.sv:68:15
	parameter DEPTHW = $clog2(DEPTH);
	// Trace: ../../rtl/libs/VX_shift_register.sv:69:15
	function automatic signed [DEPTHW - 1:0] sv2v_cast_5F7C4_signed;
		input reg signed [DEPTHW - 1:0] inp;
		sv2v_cast_5F7C4_signed = inp;
	endfunction
	parameter [(DEPTHW * NTAPS) - 1:0] TAPS = {NTAPS {sv2v_cast_5F7C4_signed(DEPTH - 1)}};
	// Trace: ../../rtl/libs/VX_shift_register.sv:71:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_shift_register.sv:72:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_shift_register.sv:73:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_shift_register.sv:74:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_shift_register.sv:75:5
	output wire [(NTAPS * DATAW) - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_shift_register.sv:77:5
	generate
		if (RESETW != 0) begin : genblk1
			if (RESETW == DATAW) begin : genblk1
				// Trace: ../../rtl/libs/VX_shift_register.sv:80:13
				VX_shift_register_wr #(
					.DATAW(DATAW),
					.DEPTH(DEPTH),
					.NTAPS(NTAPS),
					.TAPS(TAPS)
				) sr(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.data_in(data_in),
					.data_out(data_out)
				);
			end
			else begin : genblk1
				// Trace: ../../rtl/libs/VX_shift_register.sv:95:13
				VX_shift_register_wr #(
					.DATAW(RESETW),
					.DEPTH(DEPTH),
					.NTAPS(NTAPS),
					.TAPS(TAPS)
				) sr_wr(
					.clk(clk),
					.reset(reset),
					.enable(enable),
					.data_in(data_in[DATAW - 1:DATAW - RESETW]),
					.data_out(data_out[DATAW - 1:DATAW - RESETW])
				);
				// Trace: ../../rtl/libs/VX_shift_register.sv:108:13
				VX_shift_register_nr #(
					.DATAW(DATAW - RESETW),
					.DEPTH(DEPTH),
					.NTAPS(NTAPS),
					.TAPS(TAPS)
				) sr_nr(
					.clk(clk),
					.enable(enable),
					.data_in(data_in[(DATAW - RESETW) - 1:0]),
					.data_out(data_out[(DATAW - RESETW) - 1:0])
				);
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_shift_register.sv:126:9
			VX_shift_register_nr #(
				.DATAW(DATAW),
				.DEPTH(DEPTH),
				.NTAPS(NTAPS),
				.TAPS(TAPS)
			) sr(
				.clk(clk),
				.enable(enable),
				.data_in(data_in),
				.data_out(data_out)
			);
		end
	endgenerate
endmodule
module VX_lzc (
	in_i,
	cnt_o,
	valid_o
);
	// Trace: ../../rtl/libs/VX_lzc.sv:5:15
	parameter N = 2;
	// Trace: ../../rtl/libs/VX_lzc.sv:6:15
	parameter MODE = 0;
	// Trace: ../../rtl/libs/VX_lzc.sv:7:15
	parameter LOGN = $clog2(N);
	// Trace: ../../rtl/libs/VX_lzc.sv:9:5
	input wire [N - 1:0] in_i;
	// Trace: ../../rtl/libs/VX_lzc.sv:10:5
	output wire [LOGN - 1:0] cnt_o;
	// Trace: ../../rtl/libs/VX_lzc.sv:11:5
	output wire valid_o;
	// Trace: ../../rtl/libs/VX_lzc.sv:13:5
	wire [(N * LOGN) - 1:0] indices;
	// Trace: ../../rtl/libs/VX_lzc.sv:15:5
	genvar i;
	function automatic signed [LOGN - 1:0] sv2v_cast_B9644_signed;
		input reg signed [LOGN - 1:0] inp;
		sv2v_cast_B9644_signed = inp;
	endfunction
	generate
		for (i = 0; i < N; i = i + 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_lzc.sv:16:9
			assign indices[i * LOGN+:LOGN] = (MODE ? sv2v_cast_B9644_signed((N - 1) - i) : sv2v_cast_B9644_signed(i));
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_lzc.sv:19:5
	VX_find_first #(
		.N(N),
		.DATAW(LOGN),
		.REVERSE(MODE)
	) find_first(
		.data_i(indices),
		.valid_i(in_i),
		.data_o(cnt_o),
		.valid_o(valid_o)
	);
endmodule
module VX_bypass_buffer (
	clk,
	reset,
	valid_in,
	ready_in,
	data_in,
	data_out,
	ready_out,
	valid_out
);
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:4:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:5:15
	parameter PASSTHRU = 0;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:7:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:8:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:9:5
	input wire valid_in;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:10:5
	output wire ready_in;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:11:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:12:5
	output wire [DATAW - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:13:5
	input wire ready_out;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:14:5
	output wire valid_out;
	// Trace: ../../rtl/libs/VX_bypass_buffer.sv:16:5
	generate
		if (PASSTHRU) begin : genblk1
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:19:9
			assign ready_in = ready_out;
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:20:9
			assign valid_out = valid_in;
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:21:9
			assign data_out = data_in;
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:23:9
			reg [DATAW - 1:0] buffer;
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:24:9
			reg buffer_valid;
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:26:9
			always @(posedge clk) begin
				// Trace: ../../rtl/libs/VX_bypass_buffer.sv:27:13
				if (reset)
					// Trace: ../../rtl/libs/VX_bypass_buffer.sv:28:17
					buffer_valid <= 0;
				else begin
					// Trace: ../../rtl/libs/VX_bypass_buffer.sv:30:17
					if (ready_out)
						// Trace: ../../rtl/libs/VX_bypass_buffer.sv:31:21
						buffer_valid <= 0;
					if (valid_in && ~ready_out) begin
						// Trace: macro expansion of ASSERT at ../../rtl/libs/VX_bypass_buffer.sv:34:55
						if (!buffer_valid)
							;
						// Trace: ../../rtl/libs/VX_bypass_buffer.sv:35:21
						buffer_valid <= 1;
					end
				end
				if (valid_in && ~ready_out)
					// Trace: ../../rtl/libs/VX_bypass_buffer.sv:40:17
					buffer <= data_in;
			end
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:44:9
			assign ready_in = ready_out || !buffer_valid;
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:45:9
			assign data_out = (buffer_valid ? buffer : data_in);
			// Trace: ../../rtl/libs/VX_bypass_buffer.sv:46:9
			assign valid_out = valid_in || buffer_valid;
		end
	endgenerate
endmodule
module VX_stream_demux (
	clk,
	reset,
	sel_in,
	valid_in,
	data_in,
	ready_in,
	valid_out,
	data_out,
	ready_out
);
	// Trace: ../../rtl/libs/VX_stream_demux.sv:4:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:5:15
	parameter LANES = 1;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:6:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:7:15
	parameter BUFFERED = 0;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:8:15
	parameter LOG_NUM_REQS = (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1);
	// Trace: ../../rtl/libs/VX_stream_demux.sv:10:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:11:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:13:5
	input wire [(LANES * LOG_NUM_REQS) - 1:0] sel_in;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:15:5
	input wire [LANES - 1:0] valid_in;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:16:5
	input wire [(LANES * DATAW) - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:17:5
	output wire [LANES - 1:0] ready_in;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:19:5
	output wire [(NUM_REQS * LANES) - 1:0] valid_out;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:20:5
	output wire [((NUM_REQS * LANES) * DATAW) - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:21:5
	input wire [(NUM_REQS * LANES) - 1:0] ready_out;
	// Trace: ../../rtl/libs/VX_stream_demux.sv:24:5
	generate
		if (NUM_REQS > 1) begin : genblk1
			genvar j;
			for (j = 0; j < LANES; j = j + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_stream_demux.sv:28:13
				reg [NUM_REQS - 1:0] valid_in_sel;
				// Trace: ../../rtl/libs/VX_stream_demux.sv:29:13
				wire [NUM_REQS - 1:0] ready_in_sel;
				// Trace: ../../rtl/libs/VX_stream_demux.sv:31:13
				always @(*) begin
					// Trace: ../../rtl/libs/VX_stream_demux.sv:32:17
					valid_in_sel = 1'sb0;
					// Trace: ../../rtl/libs/VX_stream_demux.sv:33:17
					valid_in_sel[sel_in[j * LOG_NUM_REQS+:LOG_NUM_REQS]] = valid_in[j];
				end
				// Trace: ../../rtl/libs/VX_stream_demux.sv:36:13
				assign ready_in[j] = ready_in_sel[sel_in[j * LOG_NUM_REQS+:LOG_NUM_REQS]];
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/libs/VX_stream_demux.sv:39:17
					VX_skid_buffer #(
						.DATAW(DATAW),
						.PASSTHRU(0 == BUFFERED),
						.OUT_REG(2 == BUFFERED)
					) out_buffer(
						.clk(clk),
						.reset(reset),
						.valid_in(valid_in_sel[i]),
						.data_in(data_in[j * DATAW+:DATAW]),
						.ready_in(ready_in_sel[i]),
						.valid_out(valid_out[(i * LANES) + j]),
						.data_out(data_out[((i * LANES) + j) * DATAW+:DATAW]),
						.ready_out(ready_out[(i * LANES) + j])
					);
				end
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_stream_demux.sv:62:9
			assign valid_out = valid_in;
			// Trace: ../../rtl/libs/VX_stream_demux.sv:63:9
			assign data_out = data_in;
			// Trace: ../../rtl/libs/VX_stream_demux.sv:64:9
			assign ready_in = ready_out;
		end
	endgenerate
endmodule
module VX_fair_arbiter (
	clk,
	reset,
	enable,
	requests,
	grant_index,
	grant_onehot,
	grant_valid
);
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:5:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:6:15
	parameter LOCK_ENABLE = 0;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:7:15
	parameter LOG_NUM_REQS = $clog2(NUM_REQS);
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:9:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:10:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:11:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:12:5
	input wire [NUM_REQS - 1:0] requests;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:13:5
	output wire [LOG_NUM_REQS - 1:0] grant_index;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:14:5
	output wire [NUM_REQS - 1:0] grant_onehot;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:15:5
	output wire grant_valid;
	// Trace: ../../rtl/libs/VX_fair_arbiter.sv:18:5
	generate
		if (NUM_REQS == 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:22:9
			assign grant_index = 0;
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:23:9
			assign grant_onehot = requests;
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:24:9
			assign grant_valid = requests[0];
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:28:9
			reg [NUM_REQS - 1:0] buffer;
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:29:9
			reg use_buffer;
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:31:9
			wire [NUM_REQS - 1:0] requests_qual = (use_buffer ? buffer : requests);
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:32:9
			wire [NUM_REQS - 1:0] buffer_n = requests_qual & ~grant_onehot;
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:34:9
			always @(posedge clk) begin
				// Trace: ../../rtl/libs/VX_fair_arbiter.sv:35:13
				if (reset)
					// Trace: ../../rtl/libs/VX_fair_arbiter.sv:36:17
					use_buffer <= 0;
				else if (!LOCK_ENABLE || enable)
					// Trace: ../../rtl/libs/VX_fair_arbiter.sv:38:17
					use_buffer <= buffer_n != 0;
				if (!LOCK_ENABLE || enable)
					// Trace: ../../rtl/libs/VX_fair_arbiter.sv:41:17
					buffer <= buffer_n;
			end
			// Trace: ../../rtl/libs/VX_fair_arbiter.sv:45:9
			VX_fixed_arbiter #(
				.NUM_REQS(NUM_REQS),
				.LOCK_ENABLE(LOCK_ENABLE)
			) fixed_arbiter(
				.clk(clk),
				.reset(reset),
				.enable(enable),
				.requests(requests_qual),
				.grant_index(grant_index),
				.grant_onehot(grant_onehot),
				.grant_valid(grant_valid)
			);
		end
	endgenerate
endmodule
module VX_skid_buffer (
	clk,
	reset,
	valid_in,
	ready_in,
	data_in,
	data_out,
	ready_out,
	valid_out
);
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:6:15
	parameter PASSTHRU = 0;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:7:15
	parameter NOBACKPRESSURE = 0;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:8:15
	parameter OUT_REG = 0;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:10:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:11:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:13:5
	input wire valid_in;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:14:5
	output wire ready_in;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:15:5
	input wire [DATAW - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:17:5
	output wire [DATAW - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:18:5
	input wire ready_out;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:19:5
	output wire valid_out;
	// Trace: ../../rtl/libs/VX_skid_buffer.sv:22:5
	generate
		if (PASSTHRU) begin : genblk1
			// Trace: ../../rtl/libs/VX_skid_buffer.sv:27:9
			assign valid_out = valid_in;
			// Trace: ../../rtl/libs/VX_skid_buffer.sv:28:9
			assign data_out = data_in;
			// Trace: ../../rtl/libs/VX_skid_buffer.sv:29:9
			assign ready_in = ready_out;
		end
		else if (NOBACKPRESSURE) begin : genblk1
			// Trace: ../../rtl/libs/VX_skid_buffer.sv:35:9
			wire stall = valid_out && ~ready_out;
			// Trace: ../../rtl/libs/VX_skid_buffer.sv:37:9
			VX_pipe_register #(
				.DATAW(1 + DATAW),
				.RESETW(1)
			) pipe_reg(
				.clk(clk),
				.reset(reset),
				.enable(!stall),
				.data_in({valid_in, data_in}),
				.data_out({valid_out, data_out})
			);
			// Trace: ../../rtl/libs/VX_skid_buffer.sv:48:9
			assign ready_in = ~stall;
		end
		else begin : genblk1
			if (OUT_REG) begin : genblk1
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:54:13
				reg [DATAW - 1:0] data_out_r;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:55:13
				reg [DATAW - 1:0] buffer;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:56:13
				reg valid_out_r;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:57:13
				reg use_buffer;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:59:13
				wire push = valid_in && ready_in;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:60:13
				wire pop = !valid_out_r || ready_out;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:62:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_skid_buffer.sv:63:17
					if (reset) begin
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:64:21
						valid_out_r <= 0;
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:65:21
						use_buffer <= 0;
					end
					else begin
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:67:21
						if (ready_out)
							// Trace: ../../rtl/libs/VX_skid_buffer.sv:68:25
							use_buffer <= 0;
						else if (valid_in && valid_out_r)
							// Trace: ../../rtl/libs/VX_skid_buffer.sv:70:25
							use_buffer <= 1;
						if (pop)
							// Trace: ../../rtl/libs/VX_skid_buffer.sv:73:25
							valid_out_r <= valid_in || use_buffer;
					end
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:78:13
				always @(posedge clk) begin
					// Trace: ../../rtl/libs/VX_skid_buffer.sv:79:17
					if (push)
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:80:21
						buffer <= data_in;
					if (pop && !use_buffer)
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:83:21
						data_out_r <= data_in;
					else if (ready_out)
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:85:21
						data_out_r <= buffer;
				end
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:89:13
				assign ready_in = !use_buffer;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:90:13
				assign valid_out = valid_out_r;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:91:13
				assign data_out = data_out_r;
			end
			else begin : genblk1
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:95:13
				reg [DATAW - 1:0] shift_reg [1:0];
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:96:13
				reg valid_out_r;
				reg ready_in_r;
				reg rd_ptr_r;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:98:13
				wire push = valid_in && ready_in;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:99:13
				wire pop = valid_out_r && ready_out;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:101:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_skid_buffer.sv:102:17
					if (reset) begin
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:103:21
						valid_out_r <= 0;
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:104:21
						ready_in_r <= 1;
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:105:21
						rd_ptr_r <= 1;
					end
					else begin
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:107:21
						if (push) begin
							begin
								// Trace: ../../rtl/libs/VX_skid_buffer.sv:108:25
								if (!pop) begin
									// Trace: ../../rtl/libs/VX_skid_buffer.sv:109:29
									ready_in_r <= rd_ptr_r;
									// Trace: ../../rtl/libs/VX_skid_buffer.sv:110:29
									valid_out_r <= 1;
								end
							end
						end
						else if (pop) begin
							// Trace: ../../rtl/libs/VX_skid_buffer.sv:113:25
							ready_in_r <= 1;
							// Trace: ../../rtl/libs/VX_skid_buffer.sv:114:25
							valid_out_r <= rd_ptr_r;
						end
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:116:21
						rd_ptr_r <= rd_ptr_r ^ (push ^ pop);
					end
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:120:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_skid_buffer.sv:121:17
					if (push) begin
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:122:21
						shift_reg[1] <= shift_reg[0];
						// Trace: ../../rtl/libs/VX_skid_buffer.sv:123:21
						shift_reg[0] <= data_in;
					end
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:127:13
				assign ready_in = ready_in_r;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:128:13
				assign valid_out = valid_out_r;
				// Trace: ../../rtl/libs/VX_skid_buffer.sv:129:13
				assign data_out = shift_reg[rd_ptr_r];
			end
		end
	endgenerate
endmodule
module VX_bits_remove (
	data_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_bits_remove.sv:4:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_bits_remove.sv:5:15
	parameter S = 1;
	// Trace: ../../rtl/libs/VX_bits_remove.sv:6:15
	parameter POS = 0;
	// Trace: ../../rtl/libs/VX_bits_remove.sv:8:5
	input wire [N - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_bits_remove.sv:9:5
	output wire [(N - S) - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_bits_remove.sv:13:5
	generate
		if (POS == 0) begin : genblk1
			// Trace: ../../rtl/libs/VX_bits_remove.sv:14:9
			assign data_out = data_in[N - 1:S];
		end
		else if (POS == N) begin : genblk1
			// Trace: ../../rtl/libs/VX_bits_remove.sv:16:9
			assign data_out = data_in[(N - S) - 1:0];
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_bits_remove.sv:18:9
			assign data_out = {data_in[N - 1:POS + S], data_in[POS - 1:0]};
		end
	endgenerate
endmodule
module VX_multiplier (
	clk,
	enable,
	dataa,
	datab,
	result
);
	// Trace: ../../rtl/libs/VX_multiplier.sv:5:15
	parameter WIDTHA = 1;
	// Trace: ../../rtl/libs/VX_multiplier.sv:6:15
	parameter WIDTHB = 1;
	// Trace: ../../rtl/libs/VX_multiplier.sv:7:15
	parameter WIDTHP = 1;
	// Trace: ../../rtl/libs/VX_multiplier.sv:8:15
	parameter SIGNED = 0;
	// Trace: ../../rtl/libs/VX_multiplier.sv:9:15
	parameter LATENCY = 0;
	// Trace: ../../rtl/libs/VX_multiplier.sv:11:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_multiplier.sv:12:5
	input wire enable;
	// Trace: ../../rtl/libs/VX_multiplier.sv:13:5
	input wire [WIDTHA - 1:0] dataa;
	// Trace: ../../rtl/libs/VX_multiplier.sv:14:5
	input wire [WIDTHB - 1:0] datab;
	// Trace: ../../rtl/libs/VX_multiplier.sv:15:5
	output wire [WIDTHP - 1:0] result;
	// Trace: ../../rtl/libs/VX_multiplier.sv:40:5
	wire [WIDTHP - 1:0] result_unqual;
	// Trace: ../../rtl/libs/VX_multiplier.sv:42:5
	generate
		if (SIGNED) begin : genblk1
			// Trace: ../../rtl/libs/VX_multiplier.sv:43:9
			assign result_unqual = $signed(dataa) * $signed(datab);
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_multiplier.sv:45:9
			assign result_unqual = dataa * datab;
		end
	endgenerate
	// Trace: ../../rtl/libs/VX_multiplier.sv:48:5
	generate
		if (LATENCY == 0) begin : genblk2
			// Trace: ../../rtl/libs/VX_multiplier.sv:49:9
			assign result = result_unqual;
		end
		else begin : genblk2
			// Trace: ../../rtl/libs/VX_multiplier.sv:51:9
			reg [WIDTHP - 1:0] result_pipe [LATENCY - 1:0];
			// Trace: ../../rtl/libs/VX_multiplier.sv:52:9
			always @(posedge clk)
				// Trace: ../../rtl/libs/VX_multiplier.sv:53:13
				if (enable)
					// Trace: ../../rtl/libs/VX_multiplier.sv:54:17
					result_pipe[0] <= result_unqual;
			genvar i;
			for (i = 1; i < LATENCY; i = i + 1) begin : genblk1
				// Trace: ../../rtl/libs/VX_multiplier.sv:58:13
				always @(posedge clk)
					// Trace: ../../rtl/libs/VX_multiplier.sv:59:17
					if (enable)
						// Trace: ../../rtl/libs/VX_multiplier.sv:60:21
						result_pipe[i] <= result_pipe[i - 1];
			end
			// Trace: ../../rtl/libs/VX_multiplier.sv:64:9
			assign result = result_pipe[LATENCY - 1];
		end
	endgenerate
endmodule
module VX_pending_size (
	clk,
	reset,
	incr,
	decr,
	empty,
	full,
	size
);
	// Trace: ../../rtl/libs/VX_pending_size.sv:5:15
	parameter SIZE = 1;
	// Trace: ../../rtl/libs/VX_pending_size.sv:6:15
	parameter SIZEW = $clog2(SIZE + 1);
	// Trace: ../../rtl/libs/VX_pending_size.sv:8:5
	input wire clk;
	// Trace: ../../rtl/libs/VX_pending_size.sv:9:5
	input wire reset;
	// Trace: ../../rtl/libs/VX_pending_size.sv:10:5
	input wire incr;
	// Trace: ../../rtl/libs/VX_pending_size.sv:11:5
	input wire decr;
	// Trace: ../../rtl/libs/VX_pending_size.sv:12:5
	output wire empty;
	// Trace: ../../rtl/libs/VX_pending_size.sv:13:5
	output wire full;
	// Trace: ../../rtl/libs/VX_pending_size.sv:14:5
	output wire [SIZEW - 1:0] size;
	// Trace: ../../rtl/libs/VX_pending_size.sv:16:5
	localparam ADDRW = $clog2(SIZE);
	// Trace: ../../rtl/libs/VX_pending_size.sv:18:5
	reg [ADDRW - 1:0] used_r;
	// Trace: ../../rtl/libs/VX_pending_size.sv:19:5
	reg empty_r;
	// Trace: ../../rtl/libs/VX_pending_size.sv:20:5
	reg full_r;
	// Trace: ../../rtl/libs/VX_pending_size.sv:22:5
	function automatic signed [ADDRW - 1:0] sv2v_cast_8BB5D_signed;
		input reg signed [ADDRW - 1:0] inp;
		sv2v_cast_8BB5D_signed = inp;
	endfunction
	function automatic [1:0] sv2v_cast_2;
		input reg [1:0] inp;
		sv2v_cast_2 = inp;
	endfunction
	always @(posedge clk)
		// Trace: ../../rtl/libs/VX_pending_size.sv:23:9
		if (reset) begin
			// Trace: ../../rtl/libs/VX_pending_size.sv:24:13
			used_r <= 0;
			// Trace: ../../rtl/libs/VX_pending_size.sv:25:13
			empty_r <= 1;
			// Trace: ../../rtl/libs/VX_pending_size.sv:26:13
			full_r <= 0;
		end
		else begin
			// Trace: macro expansion of ASSERT at ../../rtl/libs/VX_pending_size.sv:28:48
			if (!incr || !full)
				;
			if (incr) begin
				begin
					// Trace: ../../rtl/libs/VX_pending_size.sv:30:17
					if (!decr) begin
						// Trace: ../../rtl/libs/VX_pending_size.sv:31:21
						empty_r <= 0;
						// Trace: ../../rtl/libs/VX_pending_size.sv:32:21
						if (used_r == sv2v_cast_8BB5D_signed(SIZE - 1))
							// Trace: ../../rtl/libs/VX_pending_size.sv:33:25
							full_r <= 1;
					end
				end
			end
			else if (decr) begin
				// Trace: ../../rtl/libs/VX_pending_size.sv:36:17
				full_r <= 0;
				// Trace: ../../rtl/libs/VX_pending_size.sv:37:17
				if (used_r == sv2v_cast_8BB5D_signed(1))
					// Trace: ../../rtl/libs/VX_pending_size.sv:38:21
					empty_r <= 1;
			end
			// Trace: ../../rtl/libs/VX_pending_size.sv:40:13
			used_r <= used_r + sv2v_cast_8BB5D_signed($signed(sv2v_cast_2(incr && !decr) - sv2v_cast_2(decr && !incr)));
		end
	// Trace: ../../rtl/libs/VX_pending_size.sv:44:5
	assign empty = empty_r;
	// Trace: ../../rtl/libs/VX_pending_size.sv:45:5
	assign full = full_r;
	// Trace: ../../rtl/libs/VX_pending_size.sv:46:5
	assign size = {full_r, used_r};
endmodule
module VX_mux (
	data_in,
	sel_in,
	data_out
);
	// Trace: ../../rtl/libs/VX_mux.sv:5:15
	parameter DATAW = 1;
	// Trace: ../../rtl/libs/VX_mux.sv:6:15
	parameter N = 1;
	// Trace: ../../rtl/libs/VX_mux.sv:7:15
	parameter LN = $clog2(N);
	// Trace: ../../rtl/libs/VX_mux.sv:9:5
	input wire [(N * DATAW) - 1:0] data_in;
	// Trace: ../../rtl/libs/VX_mux.sv:10:5
	input wire [LN - 1:0] sel_in;
	// Trace: ../../rtl/libs/VX_mux.sv:11:5
	output wire [DATAW - 1:0] data_out;
	// Trace: ../../rtl/libs/VX_mux.sv:13:5
	generate
		if (N > 1) begin : genblk1
			// Trace: ../../rtl/libs/VX_mux.sv:14:9
			assign data_out = data_in[sel_in * DATAW+:DATAW];
		end
		else begin : genblk1
			// Trace: ../../rtl/libs/VX_mux.sv:17:9
			assign data_out = data_in;
		end
	endgenerate
endmodule
// removed interface: VX_perf_cache_if
// removed interface: VX_warp_ctl_if
// removed interface: VX_perf_tex_if
// removed interface: VX_ifetch_rsp_if
// removed interface: VX_join_if
// removed interface: VX_commit_if
// removed interface: VX_icache_rsp_if
// removed interface: VX_icache_req_if
// removed interface: VX_ibuffer_if
// removed interface: VX_tex_rsp_if
// removed interface: VX_gpu_req_if
// removed interface: VX_fpu_req_if
// removed interface: VX_gpr_rsp_if
// removed interface: VX_gpr_req_if
// removed interface: VX_lsu_req_if
// removed interface: VX_tex_csr_if
// removed interface: VX_csr_req_if
// removed interface: VX_cmt_to_csr_if
// removed interface: VX_perf_pipeline_if
// removed interface: VX_fpu_to_csr_if
// removed interface: VX_branch_ctl_if
// removed interface: VX_perf_memsys_if
// removed interface: VX_wstall_if
// removed interface: VX_alu_req_if
// removed interface: VX_mem_rsp_if
// removed interface: VX_dcache_rsp_if
// removed interface: VX_dcache_req_if
// removed interface: VX_writeback_if
// removed interface: VX_decode_if
// removed interface: VX_fetch_to_csr_if
// removed interface: VX_mem_req_if
// removed interface: VX_ifetch_req_if
// removed interface: VX_tex_req_if
module VX_core_rsp_merge (
	clk,
	reset,
	per_bank_core_rsp_valid,
	per_bank_core_rsp_pmask,
	per_bank_core_rsp_data,
	per_bank_core_rsp_tid,
	per_bank_core_rsp_tag,
	per_bank_core_rsp_ready,
	core_rsp_valid,
	core_rsp_tmask,
	core_rsp_tag,
	core_rsp_data,
	core_rsp_ready
);
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:7:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:9:15
	parameter NUM_BANKS = 1;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:11:15
	parameter NUM_PORTS = 1;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:13:15
	parameter WORD_SIZE = 1;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:15:15
	parameter CORE_TAG_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:17:15
	parameter CORE_TAG_ID_BITS = 0;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:19:15
	parameter OUT_REG = 0;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:21:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:22:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:25:5
	input wire [NUM_BANKS - 1:0] per_bank_core_rsp_valid;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:26:5
	input wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_pmask;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:27:5
	input wire [((NUM_BANKS * NUM_PORTS) * (8 * WORD_SIZE)) - 1:0] per_bank_core_rsp_data;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:28:5
	input wire [((NUM_BANKS * NUM_PORTS) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] per_bank_core_rsp_tid;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:29:5
	input wire [((NUM_BANKS * NUM_PORTS) * CORE_TAG_WIDTH) - 1:0] per_bank_core_rsp_tag;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:30:5
	output wire [NUM_BANKS - 1:0] per_bank_core_rsp_ready;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:33:5
	output wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_valid;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:34:5
	output wire [NUM_REQS - 1:0] core_rsp_tmask;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:35:5
	output wire [((CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) * CORE_TAG_WIDTH) - 1:0] core_rsp_tag;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:36:5
	output wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:37:5
	input wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_ready;
	// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:41:5
	function automatic signed [(NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1) - 1:0] sv2v_cast_B86A1_signed;
		input reg signed [(NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1) - 1:0] inp;
		sv2v_cast_B86A1_signed = inp;
	endfunction
	function automatic signed [$clog2(NUM_BANKS) - 1:0] sv2v_cast_748B1_signed;
		input reg signed [$clog2(NUM_BANKS) - 1:0] inp;
		sv2v_cast_748B1_signed = inp;
	endfunction
	generate
		if (NUM_BANKS > 1) begin : genblk1
			// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:43:9
			reg [NUM_REQS - 1:0] core_rsp_valid_unqual;
			// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:44:9
			reg [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data_unqual;
			// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:45:9
			reg [NUM_BANKS - 1:0] per_bank_core_rsp_ready_r;
			if (CORE_TAG_ID_BITS != 0) begin : genblk1
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:53:13
				wire [CORE_TAG_WIDTH - 1:0] core_rsp_tag_unqual;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:54:13
				wire core_rsp_ready_unqual;
				if (NUM_PORTS > 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:58:17
					reg [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_sent_r;
					reg [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_sent;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:59:17
					wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_sent_n;
					genvar i;
					for (i = 0; i < NUM_BANKS; i = i + 1) begin : genblk1
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:62:21
						assign per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS] = per_bank_core_rsp_sent_r[i * NUM_PORTS+:NUM_PORTS] | per_bank_core_rsp_sent[i * NUM_PORTS+:NUM_PORTS];
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:65:17
					always @(posedge clk)
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:66:21
						if (reset)
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:67:25
							per_bank_core_rsp_sent_r <= 1'sb0;
						else
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:69:25
							begin : sv2v_autoblock_1
								// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:69:30
								integer i;
								// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:69:30
								for (i = 0; i < NUM_BANKS; i = i + 1)
									begin
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:70:29
										if (per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS] == per_bank_core_rsp_pmask[i * NUM_PORTS+:NUM_PORTS])
											// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:71:33
											per_bank_core_rsp_sent_r[i * NUM_PORTS+:NUM_PORTS] <= 1'sb0;
										else
											// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:73:33
											per_bank_core_rsp_sent_r[i * NUM_PORTS+:NUM_PORTS] <= per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS];
									end
							end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:79:17
					wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_valid_p;
					for (i = 0; i < NUM_BANKS; i = i + 1) begin : genblk2
						genvar p;
						for (p = 0; p < NUM_PORTS; p = p + 1) begin : genblk1
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:82:25
							assign per_bank_core_rsp_valid_p[(i * NUM_PORTS) + p] = (per_bank_core_rsp_valid[i] && per_bank_core_rsp_pmask[(i * NUM_PORTS) + p]) && !per_bank_core_rsp_sent_r[(i * NUM_PORTS) + p];
						end
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:88:17
					VX_find_first #(
						.N(NUM_BANKS * NUM_PORTS),
						.DATAW(CORE_TAG_WIDTH)
					) find_first(
						.valid_i(per_bank_core_rsp_valid_p),
						.data_i(per_bank_core_rsp_tag),
						.data_o(core_rsp_tag_unqual)
					);
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:98:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:99:21
						core_rsp_valid_unqual = 0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:100:21
						core_rsp_data_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:101:21
						per_bank_core_rsp_sent = 0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:103:21
						begin : sv2v_autoblock_2
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:103:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:103:26
							for (i = 0; i < NUM_BANKS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:104:25
									begin : sv2v_autoblock_3
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:104:30
										integer p;
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:104:30
										for (p = 0; p < NUM_PORTS; p = p + 1)
											begin
												// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:105:29
												if (((per_bank_core_rsp_valid[i] && per_bank_core_rsp_pmask[(i * NUM_PORTS) + p]) && !per_bank_core_rsp_sent_r[(i * NUM_PORTS) + p]) && (per_bank_core_rsp_tag[(((i * NUM_PORTS) + p) * CORE_TAG_WIDTH) + (CORE_TAG_ID_BITS - 1)-:CORE_TAG_ID_BITS] == core_rsp_tag_unqual[CORE_TAG_ID_BITS - 1:0])) begin
													// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:109:33
													core_rsp_valid_unqual[per_bank_core_rsp_tid[((i * NUM_PORTS) + p) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)]] = 1;
													// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:110:33
													core_rsp_data_unqual[per_bank_core_rsp_tid[((i * NUM_PORTS) + p) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)] * (8 * WORD_SIZE)+:8 * WORD_SIZE] = per_bank_core_rsp_data[((i * NUM_PORTS) + p) * (8 * WORD_SIZE)+:8 * WORD_SIZE];
													// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:111:33
													per_bank_core_rsp_sent[(i * NUM_PORTS) + p] = core_rsp_ready_unqual;
												end
											end
									end
								end
						end
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:117:17
					always @(*)
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:118:21
						begin : sv2v_autoblock_4
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:118:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:118:26
							for (i = 0; i < NUM_BANKS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:119:25
									per_bank_core_rsp_ready_r[i] = per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS] == per_bank_core_rsp_pmask[i * NUM_PORTS+:NUM_PORTS];
								end
						end
				end
				else begin : genblk1
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:127:17
					VX_find_first #(
						.N(NUM_BANKS),
						.DATAW(CORE_TAG_WIDTH)
					) find_first(
						.valid_i(per_bank_core_rsp_valid),
						.data_i(per_bank_core_rsp_tag),
						.data_o(core_rsp_tag_unqual)
					);
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:137:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:138:21
						core_rsp_valid_unqual = 0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:139:21
						core_rsp_data_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:140:21
						per_bank_core_rsp_ready_r = 0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:142:21
						begin : sv2v_autoblock_5
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:142:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:142:26
							for (i = 0; i < NUM_BANKS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:143:25
									if (per_bank_core_rsp_valid[i] && (per_bank_core_rsp_tag[((i * NUM_PORTS) * CORE_TAG_WIDTH) + (CORE_TAG_ID_BITS - 1)-:CORE_TAG_ID_BITS] == core_rsp_tag_unqual[CORE_TAG_ID_BITS - 1:0])) begin
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:145:29
										core_rsp_valid_unqual[per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS]] = 1;
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:146:29
										core_rsp_data_unqual[per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] * (8 * WORD_SIZE)+:8 * WORD_SIZE] = per_bank_core_rsp_data[(8 * WORD_SIZE) * (i * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS];
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:147:29
										per_bank_core_rsp_ready_r[i] = core_rsp_ready_unqual;
									end
								end
						end
					end
				end
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:153:13
				wire core_rsp_valid_any = |per_bank_core_rsp_valid;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:155:13
				VX_skid_buffer #(
					.DATAW((NUM_REQS + CORE_TAG_WIDTH) + (NUM_REQS * (8 * WORD_SIZE))),
					.PASSTHRU(0 == OUT_REG)
				) out_sbuf(
					.clk(clk),
					.reset(reset),
					.valid_in(core_rsp_valid_any),
					.data_in({core_rsp_valid_unqual, core_rsp_tag_unqual, core_rsp_data_unqual}),
					.ready_in(core_rsp_ready_unqual),
					.valid_out(core_rsp_valid),
					.data_out({core_rsp_tmask, core_rsp_tag, core_rsp_data}),
					.ready_out(core_rsp_ready)
				);
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:171:13
				reg [(NUM_REQS * CORE_TAG_WIDTH) - 1:0] core_rsp_tag_unqual;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:172:13
				wire [NUM_REQS - 1:0] core_rsp_ready_unqual;
				if (NUM_PORTS > 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:176:17
					reg [(NUM_REQS * ((NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1) + $clog2(NUM_BANKS))) - 1:0] bank_select_table;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:178:17
					reg [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_sent_r;
					reg [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_sent;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:179:17
					wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_sent_n;
					genvar i;
					for (i = 0; i < NUM_BANKS; i = i + 1) begin : genblk1
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:182:21
						assign per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS] = per_bank_core_rsp_sent_r[i * NUM_PORTS+:NUM_PORTS] | per_bank_core_rsp_sent[i * NUM_PORTS+:NUM_PORTS];
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:185:17
					always @(posedge clk)
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:186:21
						if (reset)
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:187:25
							per_bank_core_rsp_sent_r <= 1'sb0;
						else
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:189:25
							begin : sv2v_autoblock_6
								// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:189:30
								integer i;
								// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:189:30
								for (i = 0; i < NUM_BANKS; i = i + 1)
									begin
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:190:29
										if (per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS] == per_bank_core_rsp_pmask[i * NUM_PORTS+:NUM_PORTS])
											// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:191:33
											per_bank_core_rsp_sent_r[i * NUM_PORTS+:NUM_PORTS] <= 1'sb0;
										else
											// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:193:33
											per_bank_core_rsp_sent_r[i * NUM_PORTS+:NUM_PORTS] <= per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS];
									end
							end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:199:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:200:21
						core_rsp_valid_unqual = 1'sb0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:201:21
						core_rsp_tag_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:202:21
						core_rsp_data_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:203:21
						bank_select_table = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:205:21
						begin : sv2v_autoblock_7
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:205:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:205:26
							for (i = NUM_BANKS - 1; i >= 0; i = i - 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:206:25
									begin : sv2v_autoblock_8
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:206:30
										integer p;
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:206:30
										for (p = 0; p < NUM_PORTS; p = p + 1)
											begin
												// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:207:29
												if ((per_bank_core_rsp_valid[i] && per_bank_core_rsp_pmask[(i * NUM_PORTS) + p]) && !per_bank_core_rsp_sent_r[(i * NUM_PORTS) + p]) begin
													// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:210:33
													core_rsp_valid_unqual[per_bank_core_rsp_tid[((i * NUM_PORTS) + p) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)]] = 1;
													// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:211:33
													core_rsp_tag_unqual[per_bank_core_rsp_tid[((i * NUM_PORTS) + p) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)] * CORE_TAG_WIDTH+:CORE_TAG_WIDTH] = per_bank_core_rsp_tag[((i * NUM_PORTS) + p) * CORE_TAG_WIDTH+:CORE_TAG_WIDTH];
													// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:212:33
													core_rsp_data_unqual[per_bank_core_rsp_tid[((i * NUM_PORTS) + p) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)] * (8 * WORD_SIZE)+:8 * WORD_SIZE] = per_bank_core_rsp_data[((i * NUM_PORTS) + p) * (8 * WORD_SIZE)+:8 * WORD_SIZE];
													// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:213:33
													bank_select_table[per_bank_core_rsp_tid[((i * NUM_PORTS) + p) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)] * ((NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1) + $clog2(NUM_BANKS))+:(NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1) + $clog2(NUM_BANKS)] = {sv2v_cast_B86A1_signed(p), sv2v_cast_748B1_signed(i)};
												end
											end
									end
								end
						end
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:219:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:220:21
						per_bank_core_rsp_sent = 1'sb0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:221:21
						begin : sv2v_autoblock_9
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:221:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:221:26
							for (i = 0; i < NUM_REQS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:222:25
									if (core_rsp_valid_unqual[i])
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:223:29
										per_bank_core_rsp_sent[(bank_select_table[i * ((NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1) + $clog2(NUM_BANKS))+:$clog2(NUM_BANKS)] * NUM_PORTS) + bank_select_table[(i * ((NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1) + $clog2(NUM_BANKS))) + $clog2(NUM_BANKS)+:(NUM_PORTS > 1 ? $clog2(NUM_PORTS) : 1)]] = core_rsp_ready_unqual[i];
								end
						end
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:228:17
					always @(*)
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:229:21
						begin : sv2v_autoblock_10
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:229:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:229:26
							for (i = 0; i < NUM_BANKS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:230:25
									per_bank_core_rsp_ready_r[i] = per_bank_core_rsp_sent_n[i * NUM_PORTS+:NUM_PORTS] == per_bank_core_rsp_pmask[i * NUM_PORTS+:NUM_PORTS];
								end
						end
				end
				else begin : genblk1
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:237:17
					reg [(NUM_REQS * NUM_BANKS) - 1:0] bank_select_table;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:239:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:240:21
						core_rsp_valid_unqual = 0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:241:21
						core_rsp_tag_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:242:21
						core_rsp_data_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:243:21
						bank_select_table = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:245:21
						begin : sv2v_autoblock_11
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:245:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:245:26
							for (i = NUM_BANKS - 1; i >= 0; i = i - 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:246:25
									if (per_bank_core_rsp_valid[i]) begin
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:247:29
										core_rsp_valid_unqual[per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS]] = 1;
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:248:29
										core_rsp_tag_unqual[per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] * CORE_TAG_WIDTH+:CORE_TAG_WIDTH] = per_bank_core_rsp_tag[CORE_TAG_WIDTH * (i * NUM_PORTS)+:CORE_TAG_WIDTH * NUM_PORTS];
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:249:29
										core_rsp_data_unqual[per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] * (8 * WORD_SIZE)+:8 * WORD_SIZE] = per_bank_core_rsp_data[(8 * WORD_SIZE) * (i * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS];
										// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:250:29
										bank_select_table[per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] * NUM_BANKS+:NUM_BANKS] = 1 << i;
									end
								end
						end
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:255:17
					always @(*)
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:256:21
						begin : sv2v_autoblock_12
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:256:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:256:26
							for (i = 0; i < NUM_BANKS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:257:25
									per_bank_core_rsp_ready_r[i] = core_rsp_ready_unqual[per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS]] && bank_select_table[(per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] * NUM_BANKS) + i];
								end
						end
				end
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk2
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:264:17
					VX_skid_buffer #(
						.DATAW(CORE_TAG_WIDTH + (8 * WORD_SIZE)),
						.PASSTHRU(0 == OUT_REG)
					) out_sbuf(
						.clk(clk),
						.reset(reset),
						.valid_in(core_rsp_valid_unqual[i]),
						.data_in({core_rsp_tag_unqual[i * CORE_TAG_WIDTH+:CORE_TAG_WIDTH], core_rsp_data_unqual[i * (8 * WORD_SIZE)+:8 * WORD_SIZE]}),
						.ready_in(core_rsp_ready_unqual[i]),
						.valid_out(core_rsp_valid[i]),
						.data_out({core_rsp_tag[i * CORE_TAG_WIDTH+:CORE_TAG_WIDTH], core_rsp_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE]}),
						.ready_out(core_rsp_ready[i])
					);
				end
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:279:13
				assign core_rsp_tmask = core_rsp_valid;
			end
			// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:283:9
			assign per_bank_core_rsp_ready = per_bank_core_rsp_ready_r;
		end
		else begin : genblk1
			if (NUM_REQS > 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:293:13
				reg [((CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) * CORE_TAG_WIDTH) - 1:0] core_rsp_tag_unqual;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:294:13
				reg [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data_unqual;
				if (CORE_TAG_ID_BITS != 0) begin : genblk1
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:298:17
					reg [NUM_REQS - 1:0] core_rsp_tmask_unqual;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:300:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:301:21
						core_rsp_tmask_unqual = 0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:302:21
						core_rsp_tmask_unqual[per_bank_core_rsp_tid] = per_bank_core_rsp_valid;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:304:21
						core_rsp_tag_unqual = per_bank_core_rsp_tag;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:306:21
						core_rsp_data_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:307:21
						core_rsp_data_unqual[per_bank_core_rsp_tid * (8 * WORD_SIZE)+:8 * WORD_SIZE] = per_bank_core_rsp_data;
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:310:17
					assign core_rsp_valid = per_bank_core_rsp_valid;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:311:17
					assign core_rsp_tmask = core_rsp_tmask_unqual;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:312:17
					assign per_bank_core_rsp_ready = core_rsp_ready;
				end
				else begin : genblk1
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:316:17
					reg [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_valid_unqual;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:318:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:319:21
						core_rsp_valid_unqual = 0;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:320:21
						core_rsp_valid_unqual[per_bank_core_rsp_tid] = per_bank_core_rsp_valid;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:322:21
						core_rsp_tag_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:323:21
						core_rsp_tag_unqual[per_bank_core_rsp_tid * CORE_TAG_WIDTH+:CORE_TAG_WIDTH] = per_bank_core_rsp_tag;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:325:21
						core_rsp_data_unqual = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:326:21
						core_rsp_data_unqual[per_bank_core_rsp_tid * (8 * WORD_SIZE)+:8 * WORD_SIZE] = per_bank_core_rsp_data;
					end
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:329:17
					assign core_rsp_valid = core_rsp_valid_unqual;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:330:17
					assign core_rsp_tmask = core_rsp_valid_unqual;
					// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:331:17
					assign per_bank_core_rsp_ready = core_rsp_ready[per_bank_core_rsp_tid];
				end
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:335:13
				assign core_rsp_tag = core_rsp_tag_unqual;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:336:13
				assign core_rsp_data = core_rsp_data_unqual;
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:341:13
				assign core_rsp_valid = per_bank_core_rsp_valid;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:342:13
				assign core_rsp_tmask = per_bank_core_rsp_valid;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:343:13
				assign core_rsp_tag = per_bank_core_rsp_tag;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:344:13
				assign core_rsp_data = per_bank_core_rsp_data;
				// Trace: ../../rtl/cache/VX_core_rsp_merge.sv:345:13
				assign per_bank_core_rsp_ready = core_rsp_ready;
			end
		end
	endgenerate
endmodule
module VX_data_access (
	clk,
	reset,
	req_id,
	stall,
	read,
	fill,
	write,
	addr,
	wsel,
	pmask,
	byteen,
	fill_data,
	write_data,
	read_data
);
	// Trace: ../../rtl/cache/VX_data_access.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_data_access.sv:5:15
	parameter BANK_ID = 0;
	// Trace: ../../rtl/cache/VX_data_access.sv:7:15
	parameter CACHE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_data_access.sv:9:15
	parameter CACHE_LINE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_data_access.sv:11:15
	parameter NUM_BANKS = 1;
	// Trace: ../../rtl/cache/VX_data_access.sv:13:15
	parameter NUM_PORTS = 1;
	// Trace: ../../rtl/cache/VX_data_access.sv:15:15
	parameter WORD_SIZE = 1;
	// Trace: ../../rtl/cache/VX_data_access.sv:17:15
	parameter WRITE_ENABLE = 1;
	// Trace: ../../rtl/cache/VX_data_access.sv:19:15
	parameter WORD_SELECT_BITS = ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1);
	// Trace: ../../rtl/cache/VX_data_access.sv:21:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_data_access.sv:22:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_data_access.sv:25:5
	input wire [43:0] req_id;
	// Trace: ../../rtl/cache/VX_data_access.sv:28:5
	input wire stall;
	// Trace: ../../rtl/cache/VX_data_access.sv:30:5
	input wire read;
	// Trace: ../../rtl/cache/VX_data_access.sv:31:5
	input wire fill;
	// Trace: ../../rtl/cache/VX_data_access.sv:32:5
	input wire write;
	// Trace: ../../rtl/cache/VX_data_access.sv:33:5
	input wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] addr;
	// Trace: ../../rtl/cache/VX_data_access.sv:34:5
	input wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] wsel;
	// Trace: ../../rtl/cache/VX_data_access.sv:35:5
	input wire [NUM_PORTS - 1:0] pmask;
	// Trace: ../../rtl/cache/VX_data_access.sv:36:5
	input wire [(NUM_PORTS * WORD_SIZE) - 1:0] byteen;
	// Trace: ../../rtl/cache/VX_data_access.sv:37:5
	input wire [((CACHE_LINE_SIZE / WORD_SIZE) * (8 * WORD_SIZE)) - 1:0] fill_data;
	// Trace: ../../rtl/cache/VX_data_access.sv:38:5
	input wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] write_data;
	// Trace: ../../rtl/cache/VX_data_access.sv:39:5
	output wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] read_data;
	// Trace: ../../rtl/cache/VX_data_access.sv:48:5
	localparam BYTEENW = (WRITE_ENABLE ? CACHE_LINE_SIZE : 1);
	// Trace: ../../rtl/cache/VX_data_access.sv:50:5
	wire [((CACHE_LINE_SIZE / WORD_SIZE) * (8 * WORD_SIZE)) - 1:0] rdata;
	// Trace: ../../rtl/cache/VX_data_access.sv:51:5
	wire [((CACHE_LINE_SIZE / WORD_SIZE) * (8 * WORD_SIZE)) - 1:0] wdata;
	// Trace: ../../rtl/cache/VX_data_access.sv:52:5
	wire [BYTEENW - 1:0] wren;
	// Trace: ../../rtl/cache/VX_data_access.sv:54:5
	wire [$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0] line_addr = addr[$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0];
	// Trace: ../../rtl/cache/VX_data_access.sv:56:5
	generate
		if (WRITE_ENABLE) begin : genblk1
			if ((CACHE_LINE_SIZE / WORD_SIZE) > 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_data_access.sv:58:13
				reg [((CACHE_LINE_SIZE / WORD_SIZE) * (8 * WORD_SIZE)) - 1:0] wdata_r;
				// Trace: ../../rtl/cache/VX_data_access.sv:59:13
				reg [((CACHE_LINE_SIZE / WORD_SIZE) * WORD_SIZE) - 1:0] wren_r;
				if (NUM_PORTS > 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_data_access.sv:61:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_data_access.sv:62:21
						wdata_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_data_access.sv:63:21
						wren_r = 0;
						// Trace: ../../rtl/cache/VX_data_access.sv:64:21
						begin : sv2v_autoblock_1
							// Trace: ../../rtl/cache/VX_data_access.sv:64:26
							integer i;
							// Trace: ../../rtl/cache/VX_data_access.sv:64:26
							for (i = 0; i < NUM_PORTS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_data_access.sv:65:25
									if (pmask[i]) begin
										// Trace: ../../rtl/cache/VX_data_access.sv:66:29
										wdata_r[wsel[i * WORD_SELECT_BITS+:WORD_SELECT_BITS] * (8 * WORD_SIZE)+:8 * WORD_SIZE] = write_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE];
										// Trace: ../../rtl/cache/VX_data_access.sv:67:29
										wren_r[wsel[i * WORD_SELECT_BITS+:WORD_SELECT_BITS] * WORD_SIZE+:WORD_SIZE] = byteen[i * WORD_SIZE+:WORD_SIZE];
									end
								end
						end
					end
				end
				else begin : genblk1
					// Trace: ../../rtl/cache/VX_data_access.sv:73:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_data_access.sv:74:21
						wdata_r = {CACHE_LINE_SIZE / WORD_SIZE {write_data}};
						// Trace: ../../rtl/cache/VX_data_access.sv:75:21
						wren_r = 0;
						// Trace: ../../rtl/cache/VX_data_access.sv:76:21
						wren_r[wsel * WORD_SIZE+:WORD_SIZE] = byteen;
					end
				end
				// Trace: ../../rtl/cache/VX_data_access.sv:79:13
				assign wdata = (write ? wdata_r : fill_data);
				// Trace: ../../rtl/cache/VX_data_access.sv:80:13
				assign wren = (write ? wren_r : {BYTEENW {fill}});
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_data_access.sv:84:13
				assign wdata = (write ? write_data : fill_data);
				// Trace: ../../rtl/cache/VX_data_access.sv:85:13
				assign wren = (write ? byteen : {BYTEENW {fill}});
			end
		end
		else begin : genblk1
			// Trace: ../../rtl/cache/VX_data_access.sv:92:9
			assign wdata = fill_data;
			// Trace: ../../rtl/cache/VX_data_access.sv:93:9
			assign wren = fill;
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_data_access.sv:96:5
	VX_sp_ram #(
		.DATAW(8 * CACHE_LINE_SIZE),
		.SIZE((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE),
		.BYTEENW(BYTEENW),
		.NO_RWCHECK(1)
	) data_store(
		.clk(clk),
		.addr(line_addr),
		.wren(wren),
		.wdata(wdata),
		.rdata(rdata)
	);
	// Trace: ../../rtl/cache/VX_data_access.sv:109:5
	generate
		if ((CACHE_LINE_SIZE / WORD_SIZE) > 1) begin : genblk2
			genvar i;
			for (i = 0; i < NUM_PORTS; i = i + 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_data_access.sv:111:13
				assign read_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE] = rdata[wsel[i * WORD_SELECT_BITS+:WORD_SELECT_BITS] * (8 * WORD_SIZE)+:8 * WORD_SIZE];
			end
		end
		else begin : genblk2
			// Trace: ../../rtl/cache/VX_data_access.sv:114:9
			assign read_data = rdata;
		end
	endgenerate
endmodule
module VX_cache (
	clk,
	reset,
	core_req_valid,
	core_req_rw,
	core_req_addr,
	core_req_byteen,
	core_req_data,
	core_req_tag,
	core_req_ready,
	core_rsp_valid,
	core_rsp_tmask,
	core_rsp_data,
	core_rsp_tag,
	core_rsp_ready,
	mem_req_valid,
	mem_req_rw,
	mem_req_byteen,
	mem_req_addr,
	mem_req_data,
	mem_req_tag,
	mem_req_ready,
	mem_rsp_valid,
	mem_rsp_data,
	mem_rsp_tag,
	mem_rsp_ready
);
	// Trace: ../../rtl/cache/VX_cache.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_cache.sv:7:15
	parameter NUM_REQS = 4;
	// Trace: ../../rtl/cache/VX_cache.sv:10:15
	parameter CACHE_SIZE = 16384;
	// Trace: ../../rtl/cache/VX_cache.sv:12:15
	parameter CACHE_LINE_SIZE = 64;
	// Trace: ../../rtl/cache/VX_cache.sv:14:15
	parameter NUM_BANKS = NUM_REQS;
	// Trace: ../../rtl/cache/VX_cache.sv:16:15
	parameter NUM_PORTS = 1;
	// Trace: ../../rtl/cache/VX_cache.sv:18:15
	parameter WORD_SIZE = 4;
	// Trace: ../../rtl/cache/VX_cache.sv:21:15
	parameter CREQ_SIZE = 0;
	// Trace: ../../rtl/cache/VX_cache.sv:23:15
	parameter CRSQ_SIZE = 2;
	// Trace: ../../rtl/cache/VX_cache.sv:25:15
	parameter MSHR_SIZE = 8;
	// Trace: ../../rtl/cache/VX_cache.sv:27:15
	parameter MRSQ_SIZE = 0;
	// Trace: ../../rtl/cache/VX_cache.sv:29:15
	parameter MREQ_SIZE = 4;
	// Trace: ../../rtl/cache/VX_cache.sv:32:15
	parameter WRITE_ENABLE = 1;
	// Trace: ../../rtl/cache/VX_cache.sv:35:15
	parameter CORE_TAG_WIDTH = $clog2(MSHR_SIZE);
	// Trace: ../../rtl/cache/VX_cache.sv:38:15
	parameter CORE_TAG_ID_BITS = CORE_TAG_WIDTH;
	// Trace: ../../rtl/cache/VX_cache.sv:41:15
	parameter MEM_TAG_WIDTH = 32 - $clog2(CACHE_LINE_SIZE);
	// Trace: ../../rtl/cache/VX_cache.sv:44:15
	parameter BANK_ADDR_OFFSET = 0;
	// Trace: ../../rtl/cache/VX_cache.sv:47:15
	parameter NC_ENABLE = 0;
	// Trace: ../../rtl/cache/VX_cache.sv:49:15
	parameter WORD_SELECT_BITS = ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1);
	// Trace: ../../rtl/cache/VX_cache.sv:58:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_cache.sv:59:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_cache.sv:62:5
	input wire [NUM_REQS - 1:0] core_req_valid;
	// Trace: ../../rtl/cache/VX_cache.sv:63:5
	input wire [NUM_REQS - 1:0] core_req_rw;
	// Trace: ../../rtl/cache/VX_cache.sv:64:5
	input wire [(NUM_REQS * (32 - $clog2(WORD_SIZE))) - 1:0] core_req_addr;
	// Trace: ../../rtl/cache/VX_cache.sv:65:5
	input wire [(NUM_REQS * WORD_SIZE) - 1:0] core_req_byteen;
	// Trace: ../../rtl/cache/VX_cache.sv:66:5
	input wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_req_data;
	// Trace: ../../rtl/cache/VX_cache.sv:67:5
	input wire [(NUM_REQS * CORE_TAG_WIDTH) - 1:0] core_req_tag;
	// Trace: ../../rtl/cache/VX_cache.sv:68:5
	output wire [NUM_REQS - 1:0] core_req_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:71:5
	output wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_valid;
	// Trace: ../../rtl/cache/VX_cache.sv:72:5
	output wire [NUM_REQS - 1:0] core_rsp_tmask;
	// Trace: ../../rtl/cache/VX_cache.sv:73:5
	output wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data;
	// Trace: ../../rtl/cache/VX_cache.sv:74:5
	output wire [((CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) * CORE_TAG_WIDTH) - 1:0] core_rsp_tag;
	// Trace: ../../rtl/cache/VX_cache.sv:75:5
	input wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:78:5
	output wire mem_req_valid;
	// Trace: ../../rtl/cache/VX_cache.sv:79:5
	output wire mem_req_rw;
	// Trace: ../../rtl/cache/VX_cache.sv:80:5
	output wire [CACHE_LINE_SIZE - 1:0] mem_req_byteen;
	// Trace: ../../rtl/cache/VX_cache.sv:81:5
	output wire [(32 - $clog2(CACHE_LINE_SIZE)) - 1:0] mem_req_addr;
	// Trace: ../../rtl/cache/VX_cache.sv:82:5
	output wire [(8 * CACHE_LINE_SIZE) - 1:0] mem_req_data;
	// Trace: ../../rtl/cache/VX_cache.sv:83:5
	output wire [MEM_TAG_WIDTH - 1:0] mem_req_tag;
	// Trace: ../../rtl/cache/VX_cache.sv:84:5
	input wire mem_req_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:87:5
	input wire mem_rsp_valid;
	// Trace: ../../rtl/cache/VX_cache.sv:88:5
	input wire [(8 * CACHE_LINE_SIZE) - 1:0] mem_rsp_data;
	// Trace: ../../rtl/cache/VX_cache.sv:89:5
	input wire [MEM_TAG_WIDTH - 1:0] mem_rsp_tag;
	// Trace: ../../rtl/cache/VX_cache.sv:90:5
	output wire mem_rsp_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:96:5
	localparam MSHR_ADDR_WIDTH = $clog2(MSHR_SIZE);
	// Trace: ../../rtl/cache/VX_cache.sv:97:5
	localparam MEM_TAG_IN_WIDTH = $clog2(NUM_BANKS) + MSHR_ADDR_WIDTH;
	// Trace: ../../rtl/cache/VX_cache.sv:98:5
	localparam CORE_TAG_X_WIDTH = CORE_TAG_WIDTH - NC_ENABLE;
	// Trace: ../../rtl/cache/VX_cache.sv:99:5
	localparam CORE_TAG_ID_X_BITS = (CORE_TAG_ID_BITS != 0 ? CORE_TAG_ID_BITS - NC_ENABLE : CORE_TAG_ID_BITS);
	// Trace: ../../rtl/cache/VX_cache.sv:109:5
	wire mem_req_valid_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:110:5
	wire mem_req_rw_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:111:5
	wire [CACHE_LINE_SIZE - 1:0] mem_req_byteen_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:112:5
	wire [(32 - $clog2(CACHE_LINE_SIZE)) - 1:0] mem_req_addr_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:113:5
	wire [(8 * CACHE_LINE_SIZE) - 1:0] mem_req_data_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:114:5
	wire [MEM_TAG_WIDTH - 1:0] mem_req_tag_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:115:5
	wire mem_req_ready_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:117:5
	VX_skid_buffer #(
		.DATAW((((1 + CACHE_LINE_SIZE) + (32 - $clog2(CACHE_LINE_SIZE))) + (8 * CACHE_LINE_SIZE)) + MEM_TAG_WIDTH),
		.PASSTHRU(1 == NUM_BANKS)
	) mem_req_sbuf(
		.clk(clk),
		.reset(reset),
		.valid_in(mem_req_valid_sb),
		.ready_in(mem_req_ready_sb),
		.data_in({mem_req_rw_sb, mem_req_byteen_sb, mem_req_addr_sb, mem_req_data_sb, mem_req_tag_sb}),
		.data_out({mem_req_rw, mem_req_byteen, mem_req_addr, mem_req_data, mem_req_tag}),
		.valid_out(mem_req_valid),
		.ready_out(mem_req_ready)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:133:5
	wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_valid_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:134:5
	wire [NUM_REQS - 1:0] core_rsp_tmask_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:135:5
	wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:136:5
	wire [((CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) * CORE_TAG_WIDTH) - 1:0] core_rsp_tag_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:137:5
	wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_ready_sb;
	// Trace: ../../rtl/cache/VX_cache.sv:139:5
	generate
		if (CORE_TAG_ID_BITS != 0) begin : genblk1
			// Trace: ../../rtl/cache/VX_cache.sv:140:9
			VX_skid_buffer #(
				.DATAW((NUM_REQS + (NUM_REQS * (8 * WORD_SIZE))) + CORE_TAG_WIDTH),
				.PASSTHRU(1 == NUM_BANKS)
			) core_rsp_sbuf(
				.clk(clk),
				.reset(reset),
				.valid_in(core_rsp_valid_sb),
				.ready_in(core_rsp_ready_sb),
				.data_in({core_rsp_tmask_sb, core_rsp_data_sb, core_rsp_tag_sb}),
				.data_out({core_rsp_tmask, core_rsp_data, core_rsp_tag}),
				.valid_out(core_rsp_valid),
				.ready_out(core_rsp_ready)
			);
		end
		else begin : genblk1
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_cache.sv:155:13
				VX_skid_buffer #(
					.DATAW((1 + (8 * WORD_SIZE)) + CORE_TAG_WIDTH),
					.PASSTHRU(1 == NUM_BANKS)
				) core_rsp_sbuf(
					.clk(clk),
					.reset(reset),
					.valid_in(core_rsp_valid_sb[i]),
					.ready_in(core_rsp_ready_sb[i]),
					.data_in({core_rsp_tmask_sb[i], core_rsp_data_sb[i * (8 * WORD_SIZE)+:8 * WORD_SIZE], core_rsp_tag_sb[i * CORE_TAG_WIDTH+:CORE_TAG_WIDTH]}),
					.data_out({core_rsp_tmask[i], core_rsp_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE], core_rsp_tag[i * CORE_TAG_WIDTH+:CORE_TAG_WIDTH]}),
					.valid_out(core_rsp_valid[i]),
					.ready_out(core_rsp_ready[i])
				);
			end
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_cache.sv:174:5
	wire [(NUM_PORTS * WORD_SIZE) - 1:0] mem_req_byteen_p;
	// Trace: ../../rtl/cache/VX_cache.sv:175:5
	wire [NUM_PORTS - 1:0] mem_req_pmask_p;
	// Trace: ../../rtl/cache/VX_cache.sv:176:5
	wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] mem_req_wsel_p;
	// Trace: ../../rtl/cache/VX_cache.sv:177:5
	wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] mem_req_data_p;
	// Trace: ../../rtl/cache/VX_cache.sv:178:5
	wire mem_req_rw_p;
	// Trace: ../../rtl/cache/VX_cache.sv:180:5
	generate
		if (WRITE_ENABLE) begin : genblk2
			if ((CACHE_LINE_SIZE / WORD_SIZE) > 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_cache.sv:182:13
				reg [CACHE_LINE_SIZE - 1:0] mem_req_byteen_r;
				// Trace: ../../rtl/cache/VX_cache.sv:183:13
				reg [(8 * CACHE_LINE_SIZE) - 1:0] mem_req_data_r;
				// Trace: ../../rtl/cache/VX_cache.sv:185:13
				always @(*) begin
					// Trace: ../../rtl/cache/VX_cache.sv:186:17
					mem_req_byteen_r = 0;
					// Trace: ../../rtl/cache/VX_cache.sv:187:17
					mem_req_data_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_cache.sv:188:17
					begin : sv2v_autoblock_1
						// Trace: ../../rtl/cache/VX_cache.sv:188:22
						integer i;
						// Trace: ../../rtl/cache/VX_cache.sv:188:22
						for (i = 0; i < NUM_PORTS; i = i + 1)
							begin
								// Trace: ../../rtl/cache/VX_cache.sv:189:21
								if ((1 == NUM_PORTS) || mem_req_pmask_p[i]) begin
									// Trace: ../../rtl/cache/VX_cache.sv:190:25
									mem_req_byteen_r[mem_req_wsel_p[i * WORD_SELECT_BITS+:WORD_SELECT_BITS] * WORD_SIZE+:WORD_SIZE] = mem_req_byteen_p[i * WORD_SIZE+:WORD_SIZE];
									// Trace: ../../rtl/cache/VX_cache.sv:191:25
									mem_req_data_r[mem_req_wsel_p[i * WORD_SELECT_BITS+:WORD_SELECT_BITS] * (8 * WORD_SIZE)+:8 * WORD_SIZE] = mem_req_data_p[i * (8 * WORD_SIZE)+:8 * WORD_SIZE];
								end
							end
					end
				end
				// Trace: ../../rtl/cache/VX_cache.sv:196:13
				assign mem_req_rw_sb = mem_req_rw_p;
				// Trace: ../../rtl/cache/VX_cache.sv:197:13
				assign mem_req_byteen_sb = mem_req_byteen_r;
				// Trace: ../../rtl/cache/VX_cache.sv:198:13
				assign mem_req_data_sb = mem_req_data_r;
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_cache.sv:202:13
				assign mem_req_rw_sb = mem_req_rw_p;
				// Trace: ../../rtl/cache/VX_cache.sv:203:13
				assign mem_req_byteen_sb = mem_req_byteen_p;
				// Trace: ../../rtl/cache/VX_cache.sv:204:13
				assign mem_req_data_sb = mem_req_data_p;
			end
		end
		else begin : genblk2
			// Trace: ../../rtl/cache/VX_cache.sv:213:9
			assign mem_req_rw_sb = 0;
			// Trace: ../../rtl/cache/VX_cache.sv:214:9
			assign mem_req_byteen_sb = 1'sbx;
			// Trace: ../../rtl/cache/VX_cache.sv:215:9
			assign mem_req_data_sb = 1'sbx;
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_cache.sv:221:5
	wire [NUM_REQS - 1:0] core_req_valid_c;
	// Trace: ../../rtl/cache/VX_cache.sv:222:5
	wire [NUM_REQS - 1:0] core_req_rw_c;
	// Trace: ../../rtl/cache/VX_cache.sv:223:5
	wire [(NUM_REQS * (32 - $clog2(WORD_SIZE))) - 1:0] core_req_addr_c;
	// Trace: ../../rtl/cache/VX_cache.sv:224:5
	wire [(NUM_REQS * WORD_SIZE) - 1:0] core_req_byteen_c;
	// Trace: ../../rtl/cache/VX_cache.sv:225:5
	wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_req_data_c;
	// Trace: ../../rtl/cache/VX_cache.sv:226:5
	wire [(NUM_REQS * CORE_TAG_X_WIDTH) - 1:0] core_req_tag_c;
	// Trace: ../../rtl/cache/VX_cache.sv:227:5
	wire [NUM_REQS - 1:0] core_req_ready_c;
	// Trace: ../../rtl/cache/VX_cache.sv:230:5
	wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_valid_c;
	// Trace: ../../rtl/cache/VX_cache.sv:231:5
	wire [NUM_REQS - 1:0] core_rsp_tmask_c;
	// Trace: ../../rtl/cache/VX_cache.sv:232:5
	wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data_c;
	// Trace: ../../rtl/cache/VX_cache.sv:233:5
	wire [((CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) * CORE_TAG_X_WIDTH) - 1:0] core_rsp_tag_c;
	// Trace: ../../rtl/cache/VX_cache.sv:234:5
	wire [(CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS) - 1:0] core_rsp_ready_c;
	// Trace: ../../rtl/cache/VX_cache.sv:237:5
	wire mem_req_valid_c;
	// Trace: ../../rtl/cache/VX_cache.sv:238:5
	wire mem_req_rw_c;
	// Trace: ../../rtl/cache/VX_cache.sv:239:5
	wire [(32 - $clog2(CACHE_LINE_SIZE)) - 1:0] mem_req_addr_c;
	// Trace: ../../rtl/cache/VX_cache.sv:240:5
	wire [NUM_PORTS - 1:0] mem_req_pmask_c;
	// Trace: ../../rtl/cache/VX_cache.sv:241:5
	wire [(NUM_PORTS * WORD_SIZE) - 1:0] mem_req_byteen_c;
	// Trace: ../../rtl/cache/VX_cache.sv:242:5
	wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] mem_req_wsel_c;
	// Trace: ../../rtl/cache/VX_cache.sv:243:5
	wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] mem_req_data_c;
	// Trace: ../../rtl/cache/VX_cache.sv:244:5
	wire [MEM_TAG_IN_WIDTH - 1:0] mem_req_tag_c;
	// Trace: ../../rtl/cache/VX_cache.sv:245:5
	wire mem_req_ready_c;
	// Trace: ../../rtl/cache/VX_cache.sv:248:5
	wire mem_rsp_valid_c;
	// Trace: ../../rtl/cache/VX_cache.sv:249:5
	wire [(8 * CACHE_LINE_SIZE) - 1:0] mem_rsp_data_c;
	// Trace: ../../rtl/cache/VX_cache.sv:250:5
	wire [MEM_TAG_IN_WIDTH - 1:0] mem_rsp_tag_c;
	// Trace: ../../rtl/cache/VX_cache.sv:251:5
	wire mem_rsp_ready_c;
	// Trace: ../../rtl/cache/VX_cache.sv:253:5
	generate
		if (NC_ENABLE) begin : genblk3
			// Trace: ../../rtl/cache/VX_cache.sv:254:9
			VX_nc_bypass #(
				.NUM_PORTS(NUM_PORTS),
				.NUM_REQS(NUM_REQS),
				.NUM_RSP_TAGS((CORE_TAG_ID_BITS != 0 ? 1 : NUM_REQS)),
				.NC_TAG_BIT(0),
				.CORE_ADDR_WIDTH(32 - $clog2(WORD_SIZE)),
				.CORE_DATA_SIZE(WORD_SIZE),
				.CORE_TAG_IN_WIDTH(CORE_TAG_WIDTH),
				.MEM_ADDR_WIDTH(32 - $clog2(CACHE_LINE_SIZE)),
				.MEM_DATA_SIZE(CACHE_LINE_SIZE),
				.MEM_TAG_IN_WIDTH(MEM_TAG_IN_WIDTH),
				.MEM_TAG_OUT_WIDTH(MEM_TAG_WIDTH)
			) nc_bypass(
				.clk(clk),
				.reset(reset),
				.core_req_valid_in(core_req_valid),
				.core_req_rw_in(core_req_rw),
				.core_req_byteen_in(core_req_byteen),
				.core_req_addr_in(core_req_addr),
				.core_req_data_in(core_req_data),
				.core_req_tag_in(core_req_tag),
				.core_req_ready_in(core_req_ready),
				.core_req_valid_out(core_req_valid_c),
				.core_req_rw_out(core_req_rw_c),
				.core_req_byteen_out(core_req_byteen_c),
				.core_req_addr_out(core_req_addr_c),
				.core_req_data_out(core_req_data_c),
				.core_req_tag_out(core_req_tag_c),
				.core_req_ready_out(core_req_ready_c),
				.core_rsp_valid_in(core_rsp_valid_c),
				.core_rsp_tmask_in(core_rsp_tmask_c),
				.core_rsp_data_in(core_rsp_data_c),
				.core_rsp_tag_in(core_rsp_tag_c),
				.core_rsp_ready_in(core_rsp_ready_c),
				.core_rsp_valid_out(core_rsp_valid_sb),
				.core_rsp_tmask_out(core_rsp_tmask_sb),
				.core_rsp_data_out(core_rsp_data_sb),
				.core_rsp_tag_out(core_rsp_tag_sb),
				.core_rsp_ready_out(core_rsp_ready_sb),
				.mem_req_valid_in(mem_req_valid_c),
				.mem_req_rw_in(mem_req_rw_c),
				.mem_req_addr_in(mem_req_addr_c),
				.mem_req_pmask_in(mem_req_pmask_c),
				.mem_req_byteen_in(mem_req_byteen_c),
				.mem_req_wsel_in(mem_req_wsel_c),
				.mem_req_data_in(mem_req_data_c),
				.mem_req_tag_in(mem_req_tag_c),
				.mem_req_ready_in(mem_req_ready_c),
				.mem_req_valid_out(mem_req_valid_sb),
				.mem_req_addr_out(mem_req_addr_sb),
				.mem_req_rw_out(mem_req_rw_p),
				.mem_req_pmask_out(mem_req_pmask_p),
				.mem_req_byteen_out(mem_req_byteen_p),
				.mem_req_wsel_out(mem_req_wsel_p),
				.mem_req_data_out(mem_req_data_p),
				.mem_req_tag_out(mem_req_tag_sb),
				.mem_req_ready_out(mem_req_ready_sb),
				.mem_rsp_valid_in(mem_rsp_valid),
				.mem_rsp_data_in(mem_rsp_data),
				.mem_rsp_tag_in(mem_rsp_tag),
				.mem_rsp_ready_in(mem_rsp_ready),
				.mem_rsp_valid_out(mem_rsp_valid_c),
				.mem_rsp_data_out(mem_rsp_data_c),
				.mem_rsp_tag_out(mem_rsp_tag_c),
				.mem_rsp_ready_out(mem_rsp_ready_c)
			);
		end
		else begin : genblk3
			// Trace: ../../rtl/cache/VX_cache.sv:339:9
			assign core_req_valid_c = core_req_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:340:9
			assign core_req_rw_c = core_req_rw;
			// Trace: ../../rtl/cache/VX_cache.sv:341:9
			assign core_req_addr_c = core_req_addr;
			// Trace: ../../rtl/cache/VX_cache.sv:342:9
			assign core_req_byteen_c = core_req_byteen;
			// Trace: ../../rtl/cache/VX_cache.sv:343:9
			assign core_req_data_c = core_req_data;
			// Trace: ../../rtl/cache/VX_cache.sv:344:9
			assign core_req_tag_c = core_req_tag;
			// Trace: ../../rtl/cache/VX_cache.sv:345:9
			assign core_req_ready = core_req_ready_c;
			// Trace: ../../rtl/cache/VX_cache.sv:347:9
			assign core_rsp_valid_sb = core_rsp_valid_c;
			// Trace: ../../rtl/cache/VX_cache.sv:348:9
			assign core_rsp_tmask_sb = core_rsp_tmask_c;
			// Trace: ../../rtl/cache/VX_cache.sv:349:9
			assign core_rsp_data_sb = core_rsp_data_c;
			// Trace: ../../rtl/cache/VX_cache.sv:350:9
			assign core_rsp_tag_sb = core_rsp_tag_c;
			// Trace: ../../rtl/cache/VX_cache.sv:351:9
			assign core_rsp_ready_c = core_rsp_ready_sb;
			// Trace: ../../rtl/cache/VX_cache.sv:353:9
			assign mem_req_valid_sb = mem_req_valid_c;
			// Trace: ../../rtl/cache/VX_cache.sv:354:9
			assign mem_req_addr_sb = mem_req_addr_c;
			// Trace: ../../rtl/cache/VX_cache.sv:355:9
			assign mem_req_rw_p = mem_req_rw_c;
			// Trace: ../../rtl/cache/VX_cache.sv:356:9
			assign mem_req_pmask_p = mem_req_pmask_c;
			// Trace: ../../rtl/cache/VX_cache.sv:357:9
			assign mem_req_byteen_p = mem_req_byteen_c;
			// Trace: ../../rtl/cache/VX_cache.sv:358:9
			assign mem_req_wsel_p = mem_req_wsel_c;
			// Trace: ../../rtl/cache/VX_cache.sv:359:9
			assign mem_req_data_p = mem_req_data_c;
			// Trace: ../../rtl/cache/VX_cache.sv:360:9
			assign mem_req_tag_sb = mem_req_tag_c;
			// Trace: ../../rtl/cache/VX_cache.sv:361:9
			assign mem_req_ready_c = mem_req_ready_sb;
			// Trace: ../../rtl/cache/VX_cache.sv:363:9
			assign mem_rsp_valid_c = mem_rsp_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:364:9
			assign mem_rsp_data_c = mem_rsp_data;
			// Trace: ../../rtl/cache/VX_cache.sv:365:9
			assign mem_rsp_tag_c = mem_rsp_tag;
			// Trace: ../../rtl/cache/VX_cache.sv:366:9
			assign mem_rsp_ready = mem_rsp_ready_c;
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_cache.sv:371:5
	wire [(8 * CACHE_LINE_SIZE) - 1:0] mem_rsp_data_qual;
	// Trace: ../../rtl/cache/VX_cache.sv:372:5
	wire [MEM_TAG_IN_WIDTH - 1:0] mem_rsp_tag_qual;
	// Trace: ../../rtl/cache/VX_cache.sv:374:5
	wire mrsq_out_valid;
	wire mrsq_out_ready;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:376:23
	wire mrsq_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:376:56
	VX_reset_relay __mrsq_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(mrsq_reset)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:378:5
	VX_elastic_buffer #(
		.DATAW(MEM_TAG_IN_WIDTH + (8 * CACHE_LINE_SIZE)),
		.SIZE(MRSQ_SIZE),
		.OUT_REG(MRSQ_SIZE > 2)
	) mem_rsp_queue(
		.clk(clk),
		.reset(mrsq_reset),
		.ready_in(mem_rsp_ready_c),
		.valid_in(mem_rsp_valid_c),
		.data_in({mem_rsp_tag_c, mem_rsp_data_c}),
		.data_out({mem_rsp_tag_qual, mem_rsp_data_qual}),
		.ready_out(mrsq_out_ready),
		.valid_out(mrsq_out_valid)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:397:5
	wire [$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0] flush_addr;
	// Trace: ../../rtl/cache/VX_cache.sv:398:5
	wire flush_enable;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:400:24
	wire flush_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:400:57
	VX_reset_relay __flush_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(flush_reset)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:402:5
	VX_flush_ctrl #(
		.CACHE_SIZE(CACHE_SIZE),
		.CACHE_LINE_SIZE(CACHE_LINE_SIZE),
		.NUM_BANKS(NUM_BANKS)
	) flush_ctrl(
		.clk(clk),
		.reset(flush_reset),
		.addr_out(flush_addr),
		.valid_out(flush_enable)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:415:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_valid;
	// Trace: ../../rtl/cache/VX_cache.sv:416:5
	wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_req_pmask;
	// Trace: ../../rtl/cache/VX_cache.sv:417:5
	wire [((NUM_BANKS * NUM_PORTS) * WORD_SELECT_BITS) - 1:0] per_bank_core_req_wsel;
	// Trace: ../../rtl/cache/VX_cache.sv:418:5
	wire [((NUM_BANKS * NUM_PORTS) * WORD_SIZE) - 1:0] per_bank_core_req_byteen;
	// Trace: ../../rtl/cache/VX_cache.sv:419:5
	wire [((NUM_BANKS * NUM_PORTS) * (8 * WORD_SIZE)) - 1:0] per_bank_core_req_data;
	// Trace: ../../rtl/cache/VX_cache.sv:420:5
	wire [((NUM_BANKS * NUM_PORTS) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] per_bank_core_req_tid;
	// Trace: ../../rtl/cache/VX_cache.sv:421:5
	wire [((NUM_BANKS * NUM_PORTS) * CORE_TAG_X_WIDTH) - 1:0] per_bank_core_req_tag;
	// Trace: ../../rtl/cache/VX_cache.sv:422:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_rw;
	// Trace: ../../rtl/cache/VX_cache.sv:423:5
	wire [(NUM_BANKS * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] per_bank_core_req_addr;
	// Trace: ../../rtl/cache/VX_cache.sv:424:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:426:5
	wire [NUM_BANKS - 1:0] per_bank_core_rsp_valid;
	// Trace: ../../rtl/cache/VX_cache.sv:427:5
	wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_rsp_pmask;
	// Trace: ../../rtl/cache/VX_cache.sv:428:5
	wire [((NUM_BANKS * NUM_PORTS) * (8 * WORD_SIZE)) - 1:0] per_bank_core_rsp_data;
	// Trace: ../../rtl/cache/VX_cache.sv:429:5
	wire [((NUM_BANKS * NUM_PORTS) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] per_bank_core_rsp_tid;
	// Trace: ../../rtl/cache/VX_cache.sv:430:5
	wire [((NUM_BANKS * NUM_PORTS) * CORE_TAG_X_WIDTH) - 1:0] per_bank_core_rsp_tag;
	// Trace: ../../rtl/cache/VX_cache.sv:431:5
	wire [NUM_BANKS - 1:0] per_bank_core_rsp_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:433:5
	wire [NUM_BANKS - 1:0] per_bank_mem_req_valid;
	// Trace: ../../rtl/cache/VX_cache.sv:434:5
	wire [NUM_BANKS - 1:0] per_bank_mem_req_rw;
	// Trace: ../../rtl/cache/VX_cache.sv:435:5
	wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_mem_req_pmask;
	// Trace: ../../rtl/cache/VX_cache.sv:436:5
	wire [((NUM_BANKS * NUM_PORTS) * WORD_SIZE) - 1:0] per_bank_mem_req_byteen;
	// Trace: ../../rtl/cache/VX_cache.sv:437:5
	wire [((NUM_BANKS * NUM_PORTS) * WORD_SELECT_BITS) - 1:0] per_bank_mem_req_wsel;
	// Trace: ../../rtl/cache/VX_cache.sv:438:5
	wire [(NUM_BANKS * (32 - $clog2(CACHE_LINE_SIZE))) - 1:0] per_bank_mem_req_addr;
	// Trace: ../../rtl/cache/VX_cache.sv:439:5
	wire [(NUM_BANKS * MSHR_ADDR_WIDTH) - 1:0] per_bank_mem_req_id;
	// Trace: ../../rtl/cache/VX_cache.sv:440:5
	wire [((NUM_BANKS * NUM_PORTS) * (8 * WORD_SIZE)) - 1:0] per_bank_mem_req_data;
	// Trace: ../../rtl/cache/VX_cache.sv:441:5
	wire [NUM_BANKS - 1:0] per_bank_mem_req_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:443:5
	wire [NUM_BANKS - 1:0] per_bank_mem_rsp_ready;
	// Trace: ../../rtl/cache/VX_cache.sv:445:5
	generate
		if (NUM_BANKS == 1) begin : genblk4
			// Trace: ../../rtl/cache/VX_cache.sv:446:9
			assign mrsq_out_ready = per_bank_mem_rsp_ready;
		end
		else begin : genblk4
			// Trace: ../../rtl/cache/VX_cache.sv:448:9
			assign mrsq_out_ready = per_bank_mem_rsp_ready[mem_rsp_tag_qual[MSHR_ADDR_WIDTH+:$clog2(NUM_BANKS)]];
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_cache.sv:451:5
	VX_core_req_bank_sel #(
		.CACHE_ID(CACHE_ID),
		.CACHE_LINE_SIZE(CACHE_LINE_SIZE),
		.NUM_BANKS(NUM_BANKS),
		.NUM_PORTS(NUM_PORTS),
		.WORD_SIZE(WORD_SIZE),
		.NUM_REQS(NUM_REQS),
		.CORE_TAG_WIDTH(CORE_TAG_X_WIDTH),
		.BANK_ADDR_OFFSET(BANK_ADDR_OFFSET)
	) core_req_bank_sel(
		.clk(clk),
		.reset(reset),
		.core_req_valid(core_req_valid_c),
		.core_req_rw(core_req_rw_c),
		.core_req_addr(core_req_addr_c),
		.core_req_byteen(core_req_byteen_c),
		.core_req_data(core_req_data_c),
		.core_req_tag(core_req_tag_c),
		.core_req_ready(core_req_ready_c),
		.per_bank_core_req_valid(per_bank_core_req_valid),
		.per_bank_core_req_pmask(per_bank_core_req_pmask),
		.per_bank_core_req_rw(per_bank_core_req_rw),
		.per_bank_core_req_addr(per_bank_core_req_addr),
		.per_bank_core_req_wsel(per_bank_core_req_wsel),
		.per_bank_core_req_byteen(per_bank_core_req_byteen),
		.per_bank_core_req_data(per_bank_core_req_data),
		.per_bank_core_req_tag(per_bank_core_req_tag),
		.per_bank_core_req_tid(per_bank_core_req_tid),
		.per_bank_core_req_ready(per_bank_core_req_ready)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:487:5
	genvar i;
	function automatic signed [$clog2(NUM_BANKS) - 1:0] sv2v_cast_748B1_signed;
		input reg signed [$clog2(NUM_BANKS) - 1:0] inp;
		sv2v_cast_748B1_signed = inp;
	endfunction
	generate
		for (i = 0; i < NUM_BANKS; i = i + 1) begin : genblk5
			// Trace: ../../rtl/cache/VX_cache.sv:488:9
			wire curr_bank_core_req_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:489:9
			wire [NUM_PORTS - 1:0] curr_bank_core_req_pmask;
			// Trace: ../../rtl/cache/VX_cache.sv:490:9
			wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] curr_bank_core_req_wsel;
			// Trace: ../../rtl/cache/VX_cache.sv:491:9
			wire [(NUM_PORTS * WORD_SIZE) - 1:0] curr_bank_core_req_byteen;
			// Trace: ../../rtl/cache/VX_cache.sv:492:9
			wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] curr_bank_core_req_data;
			// Trace: ../../rtl/cache/VX_cache.sv:493:9
			wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] curr_bank_core_req_tid;
			// Trace: ../../rtl/cache/VX_cache.sv:494:9
			wire [(NUM_PORTS * CORE_TAG_X_WIDTH) - 1:0] curr_bank_core_req_tag;
			// Trace: ../../rtl/cache/VX_cache.sv:495:9
			wire curr_bank_core_req_rw;
			// Trace: ../../rtl/cache/VX_cache.sv:496:9
			wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] curr_bank_core_req_addr;
			// Trace: ../../rtl/cache/VX_cache.sv:497:9
			wire curr_bank_core_req_ready;
			// Trace: ../../rtl/cache/VX_cache.sv:499:9
			wire curr_bank_core_rsp_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:500:9
			wire [NUM_PORTS - 1:0] curr_bank_core_rsp_pmask;
			// Trace: ../../rtl/cache/VX_cache.sv:501:9
			wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] curr_bank_core_rsp_data;
			// Trace: ../../rtl/cache/VX_cache.sv:502:9
			wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] curr_bank_core_rsp_tid;
			// Trace: ../../rtl/cache/VX_cache.sv:503:9
			wire [(NUM_PORTS * CORE_TAG_X_WIDTH) - 1:0] curr_bank_core_rsp_tag;
			// Trace: ../../rtl/cache/VX_cache.sv:504:9
			wire curr_bank_core_rsp_ready;
			// Trace: ../../rtl/cache/VX_cache.sv:506:9
			wire curr_bank_mem_req_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:507:9
			wire curr_bank_mem_req_rw;
			// Trace: ../../rtl/cache/VX_cache.sv:508:9
			wire [NUM_PORTS - 1:0] curr_bank_mem_req_pmask;
			// Trace: ../../rtl/cache/VX_cache.sv:509:9
			wire [(NUM_PORTS * WORD_SIZE) - 1:0] curr_bank_mem_req_byteen;
			// Trace: ../../rtl/cache/VX_cache.sv:510:9
			wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] curr_bank_mem_req_wsel;
			// Trace: ../../rtl/cache/VX_cache.sv:511:9
			wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] curr_bank_mem_req_addr;
			// Trace: ../../rtl/cache/VX_cache.sv:512:9
			wire [MSHR_ADDR_WIDTH - 1:0] curr_bank_mem_req_id;
			// Trace: ../../rtl/cache/VX_cache.sv:513:9
			wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] curr_bank_mem_req_data;
			// Trace: ../../rtl/cache/VX_cache.sv:514:9
			wire curr_bank_mem_req_ready;
			// Trace: ../../rtl/cache/VX_cache.sv:516:9
			wire curr_bank_mem_rsp_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:517:9
			wire [MSHR_ADDR_WIDTH - 1:0] curr_bank_mem_rsp_id;
			// Trace: ../../rtl/cache/VX_cache.sv:518:9
			wire [(8 * CACHE_LINE_SIZE) - 1:0] curr_bank_mem_rsp_data;
			// Trace: ../../rtl/cache/VX_cache.sv:519:9
			wire curr_bank_mem_rsp_ready;
			// Trace: ../../rtl/cache/VX_cache.sv:522:9
			assign curr_bank_core_req_valid = per_bank_core_req_valid[i];
			// Trace: ../../rtl/cache/VX_cache.sv:523:9
			assign curr_bank_core_req_pmask = per_bank_core_req_pmask[i * NUM_PORTS+:NUM_PORTS];
			// Trace: ../../rtl/cache/VX_cache.sv:524:9
			assign curr_bank_core_req_addr = per_bank_core_req_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)];
			// Trace: ../../rtl/cache/VX_cache.sv:525:9
			assign curr_bank_core_req_rw = per_bank_core_req_rw[i];
			// Trace: ../../rtl/cache/VX_cache.sv:526:9
			assign curr_bank_core_req_wsel = per_bank_core_req_wsel[WORD_SELECT_BITS * (i * NUM_PORTS)+:WORD_SELECT_BITS * NUM_PORTS];
			// Trace: ../../rtl/cache/VX_cache.sv:527:9
			assign curr_bank_core_req_byteen = per_bank_core_req_byteen[WORD_SIZE * (i * NUM_PORTS)+:WORD_SIZE * NUM_PORTS];
			// Trace: ../../rtl/cache/VX_cache.sv:528:9
			assign curr_bank_core_req_data = per_bank_core_req_data[(8 * WORD_SIZE) * (i * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS];
			// Trace: ../../rtl/cache/VX_cache.sv:529:9
			assign curr_bank_core_req_tag = per_bank_core_req_tag[CORE_TAG_X_WIDTH * (i * NUM_PORTS)+:CORE_TAG_X_WIDTH * NUM_PORTS];
			// Trace: ../../rtl/cache/VX_cache.sv:530:9
			assign curr_bank_core_req_tid = per_bank_core_req_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS];
			// Trace: ../../rtl/cache/VX_cache.sv:531:9
			assign per_bank_core_req_ready[i] = curr_bank_core_req_ready;
			// Trace: ../../rtl/cache/VX_cache.sv:534:9
			assign curr_bank_core_rsp_ready = per_bank_core_rsp_ready[i];
			// Trace: ../../rtl/cache/VX_cache.sv:535:9
			assign per_bank_core_rsp_valid[i] = curr_bank_core_rsp_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:536:9
			assign per_bank_core_rsp_pmask[i * NUM_PORTS+:NUM_PORTS] = curr_bank_core_rsp_pmask;
			// Trace: ../../rtl/cache/VX_cache.sv:537:9
			assign per_bank_core_rsp_tid[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] = curr_bank_core_rsp_tid;
			// Trace: ../../rtl/cache/VX_cache.sv:538:9
			assign per_bank_core_rsp_tag[CORE_TAG_X_WIDTH * (i * NUM_PORTS)+:CORE_TAG_X_WIDTH * NUM_PORTS] = curr_bank_core_rsp_tag;
			// Trace: ../../rtl/cache/VX_cache.sv:539:9
			assign per_bank_core_rsp_data[(8 * WORD_SIZE) * (i * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS] = curr_bank_core_rsp_data;
			// Trace: ../../rtl/cache/VX_cache.sv:542:9
			assign per_bank_mem_req_valid[i] = curr_bank_mem_req_valid;
			// Trace: ../../rtl/cache/VX_cache.sv:543:9
			assign per_bank_mem_req_rw[i] = curr_bank_mem_req_rw;
			// Trace: ../../rtl/cache/VX_cache.sv:544:9
			assign per_bank_mem_req_pmask[i * NUM_PORTS+:NUM_PORTS] = curr_bank_mem_req_pmask;
			// Trace: ../../rtl/cache/VX_cache.sv:545:9
			assign per_bank_mem_req_byteen[WORD_SIZE * (i * NUM_PORTS)+:WORD_SIZE * NUM_PORTS] = curr_bank_mem_req_byteen;
			// Trace: ../../rtl/cache/VX_cache.sv:546:9
			assign per_bank_mem_req_wsel[WORD_SELECT_BITS * (i * NUM_PORTS)+:WORD_SELECT_BITS * NUM_PORTS] = curr_bank_mem_req_wsel;
			if (NUM_BANKS == 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_cache.sv:548:13
				assign per_bank_mem_req_addr[i * (32 - $clog2(CACHE_LINE_SIZE))+:32 - $clog2(CACHE_LINE_SIZE)] = curr_bank_mem_req_addr;
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_cache.sv:550:13
				assign per_bank_mem_req_addr[i * (32 - $clog2(CACHE_LINE_SIZE))+:32 - $clog2(CACHE_LINE_SIZE)] = {curr_bank_mem_req_addr, sv2v_cast_748B1_signed(i)};
			end
			// Trace: ../../rtl/cache/VX_cache.sv:552:9
			assign per_bank_mem_req_id[i * MSHR_ADDR_WIDTH+:MSHR_ADDR_WIDTH] = curr_bank_mem_req_id;
			// Trace: ../../rtl/cache/VX_cache.sv:553:9
			assign per_bank_mem_req_data[(8 * WORD_SIZE) * (i * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS] = curr_bank_mem_req_data;
			// Trace: ../../rtl/cache/VX_cache.sv:554:9
			assign curr_bank_mem_req_ready = per_bank_mem_req_ready[i];
			if (NUM_BANKS == 1) begin : genblk2
				// Trace: ../../rtl/cache/VX_cache.sv:558:13
				assign curr_bank_mem_rsp_valid = mrsq_out_valid;
			end
			else begin : genblk2
				// Trace: ../../rtl/cache/VX_cache.sv:560:13
				assign curr_bank_mem_rsp_valid = mrsq_out_valid && (mem_rsp_tag_qual[MSHR_ADDR_WIDTH+:$clog2(NUM_BANKS)] == i);
			end
			// Trace: ../../rtl/cache/VX_cache.sv:562:9
			assign curr_bank_mem_rsp_id = mem_rsp_tag_qual[MSHR_ADDR_WIDTH - 1:0];
			// Trace: ../../rtl/cache/VX_cache.sv:563:9
			assign curr_bank_mem_rsp_data = mem_rsp_data_qual;
			// Trace: ../../rtl/cache/VX_cache.sv:564:9
			assign per_bank_mem_rsp_ready[i] = curr_bank_mem_rsp_ready;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:566:27
			wire bank_reset;
			// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:566:60
			VX_reset_relay __bank_reset(
				.clk(clk),
				.reset(reset),
				.reset_o(bank_reset)
			);
			// Trace: ../../rtl/cache/VX_cache.sv:568:9
			VX_bank #(
				.BANK_ID(i),
				.CACHE_ID(CACHE_ID),
				.CACHE_SIZE(CACHE_SIZE),
				.CACHE_LINE_SIZE(CACHE_LINE_SIZE),
				.NUM_BANKS(NUM_BANKS),
				.NUM_PORTS(NUM_PORTS),
				.WORD_SIZE(WORD_SIZE),
				.NUM_REQS(NUM_REQS),
				.CREQ_SIZE(CREQ_SIZE),
				.CRSQ_SIZE(CRSQ_SIZE),
				.MSHR_SIZE(MSHR_SIZE),
				.MREQ_SIZE(MREQ_SIZE),
				.WRITE_ENABLE(WRITE_ENABLE),
				.CORE_TAG_WIDTH(CORE_TAG_X_WIDTH),
				.BANK_ADDR_OFFSET(BANK_ADDR_OFFSET)
			) bank(
				.clk(clk),
				.reset(bank_reset),
				.core_req_valid(curr_bank_core_req_valid),
				.core_req_pmask(curr_bank_core_req_pmask),
				.core_req_rw(curr_bank_core_req_rw),
				.core_req_byteen(curr_bank_core_req_byteen),
				.core_req_addr(curr_bank_core_req_addr),
				.core_req_wsel(curr_bank_core_req_wsel),
				.core_req_data(curr_bank_core_req_data),
				.core_req_tag(curr_bank_core_req_tag),
				.core_req_tid(curr_bank_core_req_tid),
				.core_req_ready(curr_bank_core_req_ready),
				.core_rsp_valid(curr_bank_core_rsp_valid),
				.core_rsp_pmask(curr_bank_core_rsp_pmask),
				.core_rsp_tid(curr_bank_core_rsp_tid),
				.core_rsp_data(curr_bank_core_rsp_data),
				.core_rsp_tag(curr_bank_core_rsp_tag),
				.core_rsp_ready(curr_bank_core_rsp_ready),
				.mem_req_valid(curr_bank_mem_req_valid),
				.mem_req_rw(curr_bank_mem_req_rw),
				.mem_req_pmask(curr_bank_mem_req_pmask),
				.mem_req_byteen(curr_bank_mem_req_byteen),
				.mem_req_wsel(curr_bank_mem_req_wsel),
				.mem_req_addr(curr_bank_mem_req_addr),
				.mem_req_id(curr_bank_mem_req_id),
				.mem_req_data(curr_bank_mem_req_data),
				.mem_req_ready(curr_bank_mem_req_ready),
				.mem_rsp_valid(curr_bank_mem_rsp_valid),
				.mem_rsp_id(curr_bank_mem_rsp_id),
				.mem_rsp_data(curr_bank_mem_rsp_data),
				.mem_rsp_ready(curr_bank_mem_rsp_ready),
				.flush_enable(flush_enable),
				.flush_addr(flush_addr)
			);
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_cache.sv:639:5
	VX_core_rsp_merge #(
		.CACHE_ID(CACHE_ID),
		.NUM_BANKS(NUM_BANKS),
		.NUM_PORTS(NUM_PORTS),
		.WORD_SIZE(WORD_SIZE),
		.NUM_REQS(NUM_REQS),
		.CORE_TAG_WIDTH(CORE_TAG_X_WIDTH),
		.CORE_TAG_ID_BITS(CORE_TAG_ID_X_BITS)
	) core_rsp_merge(
		.clk(clk),
		.reset(reset),
		.per_bank_core_rsp_valid(per_bank_core_rsp_valid),
		.per_bank_core_rsp_pmask(per_bank_core_rsp_pmask),
		.per_bank_core_rsp_data(per_bank_core_rsp_data),
		.per_bank_core_rsp_tag(per_bank_core_rsp_tag),
		.per_bank_core_rsp_tid(per_bank_core_rsp_tid),
		.per_bank_core_rsp_ready(per_bank_core_rsp_ready),
		.core_rsp_valid(core_rsp_valid_c),
		.core_rsp_tmask(core_rsp_tmask_c),
		.core_rsp_tag(core_rsp_tag_c),
		.core_rsp_data(core_rsp_data_c),
		.core_rsp_ready(core_rsp_ready_c)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:663:5
	wire [(NUM_BANKS * ((((32 - $clog2(CACHE_LINE_SIZE)) + MSHR_ADDR_WIDTH) + 1) + (NUM_PORTS * (((1 + WORD_SIZE) + WORD_SELECT_BITS) + (8 * WORD_SIZE))))) - 1:0] data_in;
	// Trace: ../../rtl/cache/VX_cache.sv:664:5
	generate
		for (i = 0; i < NUM_BANKS; i = i + 1) begin : genblk6
			// Trace: ../../rtl/cache/VX_cache.sv:665:9
			assign data_in[i * ((((32 - $clog2(CACHE_LINE_SIZE)) + MSHR_ADDR_WIDTH) + 1) + (NUM_PORTS * (((1 + WORD_SIZE) + WORD_SELECT_BITS) + (8 * WORD_SIZE))))+:(((32 - $clog2(CACHE_LINE_SIZE)) + MSHR_ADDR_WIDTH) + 1) + (NUM_PORTS * (((1 + WORD_SIZE) + WORD_SELECT_BITS) + (8 * WORD_SIZE)))] = {per_bank_mem_req_addr[i * (32 - $clog2(CACHE_LINE_SIZE))+:32 - $clog2(CACHE_LINE_SIZE)], per_bank_mem_req_id[i * MSHR_ADDR_WIDTH+:MSHR_ADDR_WIDTH], per_bank_mem_req_rw[i], per_bank_mem_req_pmask[i * NUM_PORTS+:NUM_PORTS], per_bank_mem_req_byteen[WORD_SIZE * (i * NUM_PORTS)+:WORD_SIZE * NUM_PORTS], per_bank_mem_req_wsel[WORD_SELECT_BITS * (i * NUM_PORTS)+:WORD_SELECT_BITS * NUM_PORTS], per_bank_mem_req_data[(8 * WORD_SIZE) * (i * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS]};
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_cache.sv:668:5
	wire [MSHR_ADDR_WIDTH - 1:0] mem_req_id;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:670:23
	wire mreq_reset;
	// Trace: macro expansion of RESET_RELAY at ../../rtl/cache/VX_cache.sv:670:56
	VX_reset_relay __mreq_reset(
		.clk(clk),
		.reset(reset),
		.reset_o(mreq_reset)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:672:5
	VX_stream_arbiter #(
		.NUM_REQS(NUM_BANKS),
		.DATAW((((32 - $clog2(CACHE_LINE_SIZE)) + MSHR_ADDR_WIDTH) + 1) + (NUM_PORTS * (((1 + WORD_SIZE) + WORD_SELECT_BITS) + (8 * WORD_SIZE)))),
		.TYPE("R")
	) mem_req_arb(
		.clk(clk),
		.reset(mreq_reset),
		.valid_in(per_bank_mem_req_valid),
		.data_in(data_in),
		.ready_in(per_bank_mem_req_ready),
		.valid_out(mem_req_valid_c),
		.data_out({mem_req_addr_c, mem_req_id, mem_req_rw_c, mem_req_pmask_c, mem_req_byteen_c, mem_req_wsel_c, mem_req_data_c}),
		.ready_out(mem_req_ready_c)
	);
	// Trace: ../../rtl/cache/VX_cache.sv:687:5
	function automatic [MEM_TAG_IN_WIDTH - 1:0] sv2v_cast_4ECAF;
		input reg [MEM_TAG_IN_WIDTH - 1:0] inp;
		sv2v_cast_4ECAF = inp;
	endfunction
	generate
		if (NUM_BANKS == 1) begin : genblk7
			// Trace: ../../rtl/cache/VX_cache.sv:688:9
			assign mem_req_tag_c = sv2v_cast_4ECAF(mem_req_id);
		end
		else begin : genblk7
			// Trace: ../../rtl/cache/VX_cache.sv:690:9
			assign mem_req_tag_c = sv2v_cast_4ECAF({mem_req_addr_c[0+:$clog2(NUM_BANKS)], mem_req_id});
		end
	endgenerate
endmodule
module VX_nc_bypass (
	clk,
	reset,
	core_req_valid_in,
	core_req_rw_in,
	core_req_addr_in,
	core_req_byteen_in,
	core_req_data_in,
	core_req_tag_in,
	core_req_ready_in,
	core_req_valid_out,
	core_req_rw_out,
	core_req_addr_out,
	core_req_byteen_out,
	core_req_data_out,
	core_req_tag_out,
	core_req_ready_out,
	core_rsp_valid_in,
	core_rsp_tmask_in,
	core_rsp_data_in,
	core_rsp_tag_in,
	core_rsp_ready_in,
	core_rsp_valid_out,
	core_rsp_tmask_out,
	core_rsp_data_out,
	core_rsp_tag_out,
	core_rsp_ready_out,
	mem_req_valid_in,
	mem_req_rw_in,
	mem_req_addr_in,
	mem_req_pmask_in,
	mem_req_byteen_in,
	mem_req_wsel_in,
	mem_req_data_in,
	mem_req_tag_in,
	mem_req_ready_in,
	mem_req_valid_out,
	mem_req_rw_out,
	mem_req_addr_out,
	mem_req_pmask_out,
	mem_req_byteen_out,
	mem_req_wsel_out,
	mem_req_data_out,
	mem_req_tag_out,
	mem_req_ready_out,
	mem_rsp_valid_in,
	mem_rsp_data_in,
	mem_rsp_tag_in,
	mem_rsp_ready_in,
	mem_rsp_valid_out,
	mem_rsp_data_out,
	mem_rsp_tag_out,
	mem_rsp_ready_out
);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:4:15
	parameter NUM_PORTS = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:5:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:6:15
	parameter NUM_RSP_TAGS = 0;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:7:15
	parameter NC_TAG_BIT = 0;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:9:15
	parameter CORE_ADDR_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:10:15
	parameter CORE_DATA_SIZE = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:11:15
	parameter CORE_TAG_IN_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:13:15
	parameter MEM_ADDR_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:14:15
	parameter MEM_DATA_SIZE = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:15:15
	parameter MEM_TAG_IN_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:16:15
	parameter MEM_TAG_OUT_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:18:15
	parameter CORE_DATA_WIDTH = CORE_DATA_SIZE * 8;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:19:15
	parameter MEM_DATA_WIDTH = MEM_DATA_SIZE * 8;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:20:15
	parameter CORE_TAG_OUT_WIDTH = CORE_TAG_IN_WIDTH - 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:21:15
	parameter MEM_SELECT_BITS = ($clog2(MEM_DATA_SIZE / CORE_DATA_SIZE) > 0 ? $clog2(MEM_DATA_SIZE / CORE_DATA_SIZE) : 1);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:23:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:24:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:27:5
	input wire [NUM_REQS - 1:0] core_req_valid_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:28:5
	input wire [NUM_REQS - 1:0] core_req_rw_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:29:5
	input wire [(NUM_REQS * CORE_ADDR_WIDTH) - 1:0] core_req_addr_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:30:5
	input wire [(NUM_REQS * CORE_DATA_SIZE) - 1:0] core_req_byteen_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:31:5
	input wire [(NUM_REQS * CORE_DATA_WIDTH) - 1:0] core_req_data_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:32:5
	input wire [(NUM_REQS * CORE_TAG_IN_WIDTH) - 1:0] core_req_tag_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:33:5
	output wire [NUM_REQS - 1:0] core_req_ready_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:36:5
	output wire [NUM_REQS - 1:0] core_req_valid_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:37:5
	output wire [NUM_REQS - 1:0] core_req_rw_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:38:5
	output wire [(NUM_REQS * CORE_ADDR_WIDTH) - 1:0] core_req_addr_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:39:5
	output wire [(NUM_REQS * CORE_DATA_SIZE) - 1:0] core_req_byteen_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:40:5
	output wire [(NUM_REQS * CORE_DATA_WIDTH) - 1:0] core_req_data_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:41:5
	output wire [(NUM_REQS * CORE_TAG_OUT_WIDTH) - 1:0] core_req_tag_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:42:5
	input wire [NUM_REQS - 1:0] core_req_ready_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:45:5
	input wire [NUM_RSP_TAGS - 1:0] core_rsp_valid_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:46:5
	input wire [NUM_REQS - 1:0] core_rsp_tmask_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:47:5
	input wire [(NUM_REQS * CORE_DATA_WIDTH) - 1:0] core_rsp_data_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:48:5
	input wire [(NUM_RSP_TAGS * CORE_TAG_OUT_WIDTH) - 1:0] core_rsp_tag_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:49:5
	output wire [NUM_RSP_TAGS - 1:0] core_rsp_ready_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:52:5
	output wire [NUM_RSP_TAGS - 1:0] core_rsp_valid_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:53:5
	output wire [NUM_REQS - 1:0] core_rsp_tmask_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:54:5
	output wire [(NUM_REQS * CORE_DATA_WIDTH) - 1:0] core_rsp_data_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:55:5
	output wire [(NUM_RSP_TAGS * CORE_TAG_IN_WIDTH) - 1:0] core_rsp_tag_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:56:5
	input wire [NUM_RSP_TAGS - 1:0] core_rsp_ready_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:59:5
	input wire mem_req_valid_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:60:5
	input wire mem_req_rw_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:61:5
	input wire [MEM_ADDR_WIDTH - 1:0] mem_req_addr_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:62:5
	input wire [NUM_PORTS - 1:0] mem_req_pmask_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:63:5
	input wire [(NUM_PORTS * CORE_DATA_SIZE) - 1:0] mem_req_byteen_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:64:5
	input wire [(NUM_PORTS * MEM_SELECT_BITS) - 1:0] mem_req_wsel_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:65:5
	input wire [(NUM_PORTS * CORE_DATA_WIDTH) - 1:0] mem_req_data_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:66:5
	input wire [MEM_TAG_IN_WIDTH - 1:0] mem_req_tag_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:67:5
	output wire mem_req_ready_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:70:5
	output wire mem_req_valid_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:71:5
	output wire mem_req_rw_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:72:5
	output wire [MEM_ADDR_WIDTH - 1:0] mem_req_addr_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:73:5
	output wire [NUM_PORTS - 1:0] mem_req_pmask_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:74:5
	output wire [(NUM_PORTS * CORE_DATA_SIZE) - 1:0] mem_req_byteen_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:75:5
	output wire [(NUM_PORTS * MEM_SELECT_BITS) - 1:0] mem_req_wsel_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:76:5
	output wire [(NUM_PORTS * CORE_DATA_WIDTH) - 1:0] mem_req_data_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:77:5
	output wire [MEM_TAG_OUT_WIDTH - 1:0] mem_req_tag_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:78:5
	input wire mem_req_ready_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:81:5
	input wire mem_rsp_valid_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:82:5
	input wire [MEM_DATA_WIDTH - 1:0] mem_rsp_data_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:83:5
	input wire [MEM_TAG_OUT_WIDTH - 1:0] mem_rsp_tag_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:84:5
	output wire mem_rsp_ready_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:87:5
	output wire mem_rsp_valid_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:88:5
	output wire [MEM_DATA_WIDTH - 1:0] mem_rsp_data_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:89:5
	output wire [MEM_TAG_IN_WIDTH - 1:0] mem_rsp_tag_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:90:5
	input wire mem_rsp_ready_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:97:5
	localparam CORE_REQ_TIDW = $clog2(NUM_REQS);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:98:5
	localparam MUX_DATAW = (((CORE_TAG_IN_WIDTH + CORE_DATA_WIDTH) + CORE_DATA_SIZE) + CORE_ADDR_WIDTH) + 1;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:100:5
	localparam CORE_LDATAW = $clog2(CORE_DATA_WIDTH);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:101:5
	localparam MEM_LDATAW = $clog2(MEM_DATA_WIDTH);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:102:5
	localparam D = MEM_LDATAW - CORE_LDATAW;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:106:5
	wire [NUM_REQS - 1:0] core_req_valid_in_nc;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:107:5
	wire [NUM_REQS - 1:0] core_req_nc_tids;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:108:5
	wire [(CORE_REQ_TIDW > 0 ? CORE_REQ_TIDW : 1) - 1:0] core_req_nc_tid;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:109:5
	wire [NUM_REQS - 1:0] core_req_nc_sel;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:110:5
	wire core_req_nc_valid;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:112:5
	genvar i;
	generate
		for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:113:9
			assign core_req_nc_tids[i] = core_req_tag_in[(i * CORE_TAG_IN_WIDTH) + NC_TAG_BIT];
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:116:5
	assign core_req_valid_in_nc = core_req_valid_in & core_req_nc_tids;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:118:5
	VX_priority_encoder #(.N(NUM_REQS)) core_req_sel(
		.data_in(core_req_valid_in_nc),
		.index(core_req_nc_tid),
		.onehot(core_req_nc_sel),
		.valid_out(core_req_nc_valid)
	);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:127:5
	assign core_req_valid_out = core_req_valid_in & ~core_req_nc_tids;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:128:5
	assign core_req_rw_out = core_req_rw_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:129:5
	assign core_req_addr_out = core_req_addr_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:130:5
	assign core_req_byteen_out = core_req_byteen_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:131:5
	assign core_req_data_out = core_req_data_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:133:5
	generate
		for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk2
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:134:9
			VX_bits_remove #(
				.N(CORE_TAG_IN_WIDTH),
				.S(1),
				.POS(NC_TAG_BIT)
			) core_req_tag_remove(
				.data_in(core_req_tag_in[i * CORE_TAG_IN_WIDTH+:CORE_TAG_IN_WIDTH]),
				.data_out(core_req_tag_out[i * CORE_TAG_OUT_WIDTH+:CORE_TAG_OUT_WIDTH])
			);
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:144:5
	generate
		if (NUM_REQS > 1) begin : genblk3
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:146:13
				assign core_req_ready_in[i] = (core_req_valid_in_nc[i] ? (~mem_req_valid_in && mem_req_ready_out) && core_req_nc_sel[i] : core_req_ready_out[i]);
			end
		end
		else begin : genblk3
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:150:9
			assign core_req_ready_in = (core_req_valid_in_nc ? ~mem_req_valid_in && mem_req_ready_out : core_req_ready_out);
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:155:5
	assign mem_req_valid_out = mem_req_valid_in || core_req_nc_valid;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:156:5
	assign mem_req_ready_in = mem_req_ready_out;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:158:5
	wire [MEM_TAG_IN_WIDTH + 0:0] mem_req_tag_in_c;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:160:5
	localparam sv2v_uu_mem_req_tag_insert_S = 1;
	// removed localparam type sv2v_uu_mem_req_tag_insert_sel_in
	localparam [0:0] sv2v_uu_mem_req_tag_insert_ext_sel_in_0 = 1'sb0;
	VX_bits_insert #(
		.N(MEM_TAG_IN_WIDTH),
		.S(1),
		.POS(NC_TAG_BIT)
	) mem_req_tag_insert(
		.data_in(mem_req_tag_in),
		.sel_in(sv2v_uu_mem_req_tag_insert_ext_sel_in_0),
		.data_out(mem_req_tag_in_c)
	);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:170:5
	wire [CORE_TAG_IN_WIDTH - 1:0] core_req_tag_in_sel;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:171:5
	wire [CORE_DATA_WIDTH - 1:0] core_req_data_in_sel;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:172:5
	wire [CORE_DATA_SIZE - 1:0] core_req_byteen_in_sel;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:173:5
	wire [CORE_ADDR_WIDTH - 1:0] core_req_addr_in_sel;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:174:5
	wire core_req_rw_in_sel;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:176:5
	generate
		if (NUM_REQS > 1) begin : genblk4
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:177:9
			wire [(NUM_REQS * MUX_DATAW) - 1:0] core_req_nc_mux_in;
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:179:13
				assign core_req_nc_mux_in[i * MUX_DATAW+:MUX_DATAW] = {core_req_tag_in[i * CORE_TAG_IN_WIDTH+:CORE_TAG_IN_WIDTH], core_req_data_in[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH], core_req_byteen_in[i * CORE_DATA_SIZE+:CORE_DATA_SIZE], core_req_addr_in[i * CORE_ADDR_WIDTH+:CORE_ADDR_WIDTH], core_req_rw_in[i]};
			end
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:182:9
			assign {core_req_tag_in_sel, core_req_data_in_sel, core_req_byteen_in_sel, core_req_addr_in_sel, core_req_rw_in_sel} = core_req_nc_mux_in[core_req_nc_tid * MUX_DATAW+:MUX_DATAW];
		end
		else begin : genblk4
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:184:9
			assign core_req_tag_in_sel = core_req_tag_in;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:185:9
			assign core_req_data_in_sel = core_req_data_in;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:186:9
			assign core_req_byteen_in_sel = core_req_byteen_in;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:187:9
			assign core_req_addr_in_sel = core_req_addr_in;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:188:9
			assign core_req_rw_in_sel = core_req_rw_in;
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:191:5
	assign mem_req_rw_out = (mem_req_valid_in ? mem_req_rw_in : core_req_rw_in_sel);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:192:5
	assign mem_req_addr_out = (mem_req_valid_in ? mem_req_addr_in : core_req_addr_in_sel[D+:MEM_ADDR_WIDTH]);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:194:5
	function automatic [MEM_TAG_OUT_WIDTH - 1:0] sv2v_cast_CEA83;
		input reg [MEM_TAG_OUT_WIDTH - 1:0] inp;
		sv2v_cast_CEA83 = inp;
	endfunction
	function automatic [NUM_PORTS - 1:0] sv2v_cast_1AD22;
		input reg [NUM_PORTS - 1:0] inp;
		sv2v_cast_1AD22 = inp;
	endfunction
	generate
		if (D != 0) begin : genblk5
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:195:9
			reg [(NUM_PORTS * CORE_DATA_SIZE) - 1:0] mem_req_byteen_in_r;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:196:9
			reg [(NUM_PORTS * MEM_SELECT_BITS) - 1:0] mem_req_wsel_in_r;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:197:9
			reg [(NUM_PORTS * CORE_DATA_WIDTH) - 1:0] mem_req_data_in_r;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:199:9
			wire [D - 1:0] req_addr_idx = core_req_addr_in_sel[D - 1:0];
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:201:9
			always @(*) begin
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:202:13
				mem_req_byteen_in_r = 0;
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:203:13
				mem_req_byteen_in_r[0+:CORE_DATA_SIZE] = core_req_byteen_in_sel;
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:205:13
				mem_req_wsel_in_r = 1'sbx;
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:206:13
				mem_req_wsel_in_r[0+:MEM_SELECT_BITS] = req_addr_idx;
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:208:13
				mem_req_data_in_r = 1'sbx;
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:209:13
				mem_req_data_in_r[0+:CORE_DATA_WIDTH] = core_req_data_in_sel;
			end
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:212:9
			assign mem_req_pmask_out = (mem_req_valid_in ? mem_req_pmask_in : sv2v_cast_1AD22(1'b1));
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:213:9
			assign mem_req_byteen_out = (mem_req_valid_in ? mem_req_byteen_in : mem_req_byteen_in_r);
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:214:9
			assign mem_req_wsel_out = (mem_req_valid_in ? mem_req_wsel_in : mem_req_wsel_in_r);
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:215:9
			assign mem_req_data_out = (mem_req_valid_in ? mem_req_data_in : mem_req_data_in_r);
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:216:9
			assign mem_req_tag_out = (mem_req_valid_in ? sv2v_cast_CEA83(mem_req_tag_in_c) : sv2v_cast_CEA83({core_req_nc_tid, req_addr_idx, core_req_tag_in_sel}));
		end
		else begin : genblk5
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:220:9
			assign mem_req_pmask_out = 0;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:221:9
			assign mem_req_byteen_out = (mem_req_valid_in ? mem_req_byteen_in : core_req_byteen_in_sel);
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:222:9
			assign mem_req_data_out = (mem_req_valid_in ? mem_req_data_in : core_req_data_in_sel);
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:223:9
			assign mem_req_wsel_out = 0;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:224:9
			assign mem_req_tag_out = (mem_req_valid_in ? sv2v_cast_CEA83(mem_req_tag_in_c) : sv2v_cast_CEA83({core_req_nc_tid, core_req_tag_in_sel}));
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:229:5
	wire [(NUM_RSP_TAGS * CORE_TAG_IN_WIDTH) - 1:0] core_rsp_tag_out_c;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:231:5
	wire is_mem_rsp_nc = mem_rsp_valid_in && mem_rsp_tag_in[NC_TAG_BIT];
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:233:5
	generate
		for (i = 0; i < NUM_RSP_TAGS; i = i + 1) begin : genblk6
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:234:9
			localparam sv2v_uu_core_rsp_tag_insert_S = 1;
			// removed localparam type sv2v_uu_core_rsp_tag_insert_sel_in
			localparam [0:0] sv2v_uu_core_rsp_tag_insert_ext_sel_in_0 = 1'sb0;
			VX_bits_insert #(
				.N(CORE_TAG_OUT_WIDTH),
				.S(1),
				.POS(NC_TAG_BIT)
			) core_rsp_tag_insert(
				.data_in(core_rsp_tag_in[i * CORE_TAG_OUT_WIDTH+:CORE_TAG_OUT_WIDTH]),
				.sel_in(sv2v_uu_core_rsp_tag_insert_ext_sel_in_0),
				.data_out(core_rsp_tag_out_c[i * CORE_TAG_IN_WIDTH+:CORE_TAG_IN_WIDTH])
			);
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:245:5
	generate
		if (NUM_RSP_TAGS > 1) begin : genblk7
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:246:9
			wire [CORE_REQ_TIDW - 1:0] rsp_tid = mem_rsp_tag_in[CORE_TAG_IN_WIDTH + D+:CORE_REQ_TIDW];
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:247:9
			reg [NUM_REQS - 1:0] rsp_nc_valid_r;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:248:9
			always @(*) begin
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:249:13
				rsp_nc_valid_r = 0;
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:250:13
				rsp_nc_valid_r[rsp_tid] = is_mem_rsp_nc;
			end
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:253:9
			assign core_rsp_valid_out = core_rsp_valid_in | rsp_nc_valid_r;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:254:9
			assign core_rsp_tmask_out = core_rsp_tmask_in;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:255:9
			assign core_rsp_ready_in = core_rsp_ready_out;
			if (D != 0) begin : genblk1
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:258:13
				wire [D - 1:0] rsp_addr_idx = mem_rsp_tag_in[CORE_TAG_IN_WIDTH+:D];
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_nc_bypass.sv:260:17
					assign core_rsp_data_out[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] = (core_rsp_valid_in[i] ? core_rsp_data_in[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] : mem_rsp_data_in[rsp_addr_idx * CORE_DATA_WIDTH+:CORE_DATA_WIDTH]);
				end
			end
			else begin : genblk1
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_nc_bypass.sv:265:17
					assign core_rsp_data_out[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] = (core_rsp_valid_in[i] ? core_rsp_data_in[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] : mem_rsp_data_in);
				end
			end
			genvar i;
			for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk2
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:270:13
				assign core_rsp_tag_out[i * CORE_TAG_IN_WIDTH+:CORE_TAG_IN_WIDTH] = (core_rsp_valid_in[i] ? core_rsp_tag_out_c[i * CORE_TAG_IN_WIDTH+:CORE_TAG_IN_WIDTH] : mem_rsp_tag_in[CORE_TAG_IN_WIDTH - 1:0]);
			end
		end
		else begin : genblk7
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:273:9
			assign core_rsp_valid_out = core_rsp_valid_in || is_mem_rsp_nc;
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:274:9
			assign core_rsp_tag_out = (core_rsp_valid_in ? core_rsp_tag_out_c : mem_rsp_tag_in[CORE_TAG_IN_WIDTH - 1:0]);
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:275:9
			assign core_rsp_ready_in = core_rsp_ready_out;
			if (NUM_REQS > 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:278:13
				wire [CORE_REQ_TIDW - 1:0] rsp_tid = mem_rsp_tag_in[CORE_TAG_IN_WIDTH + D+:CORE_REQ_TIDW];
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:279:13
				reg [NUM_REQS - 1:0] core_rsp_tmask_in_r;
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:280:13
				always @(*) begin
					// Trace: ../../rtl/cache/VX_nc_bypass.sv:281:17
					core_rsp_tmask_in_r = 0;
					// Trace: ../../rtl/cache/VX_nc_bypass.sv:282:17
					core_rsp_tmask_in_r[rsp_tid] = 1;
				end
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:284:13
				assign core_rsp_tmask_out = (core_rsp_valid_in ? core_rsp_tmask_in : core_rsp_tmask_in_r);
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:286:13
				assign core_rsp_tmask_out = core_rsp_tmask_in || is_mem_rsp_nc;
			end
			if (D != 0) begin : genblk2
				// Trace: ../../rtl/cache/VX_nc_bypass.sv:290:13
				wire [D - 1:0] rsp_addr_idx = mem_rsp_tag_in[CORE_TAG_IN_WIDTH+:D];
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_nc_bypass.sv:292:17
					assign core_rsp_data_out[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] = (core_rsp_valid_in ? core_rsp_data_in[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] : mem_rsp_data_in[rsp_addr_idx * CORE_DATA_WIDTH+:CORE_DATA_WIDTH]);
				end
			end
			else begin : genblk2
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_nc_bypass.sv:297:17
					assign core_rsp_data_out[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] = (core_rsp_valid_in ? core_rsp_data_in[i * CORE_DATA_WIDTH+:CORE_DATA_WIDTH] : mem_rsp_data_in);
				end
			end
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:304:5
	assign mem_rsp_valid_out = mem_rsp_valid_in && ~mem_rsp_tag_in[NC_TAG_BIT];
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:305:5
	assign mem_rsp_data_out = mem_rsp_data_in;
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:307:5
	VX_bits_remove #(
		.N(MEM_TAG_IN_WIDTH + 1),
		.S(1),
		.POS(NC_TAG_BIT)
	) mem_rsp_tag_remove(
		.data_in(mem_rsp_tag_in[MEM_TAG_IN_WIDTH + 0:0]),
		.data_out(mem_rsp_tag_out)
	);
	// Trace: ../../rtl/cache/VX_nc_bypass.sv:316:5
	generate
		if (NUM_RSP_TAGS > 1) begin : genblk8
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:317:9
			wire [CORE_REQ_TIDW - 1:0] rsp_tid = mem_rsp_tag_in[CORE_TAG_IN_WIDTH + D+:CORE_REQ_TIDW];
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:318:9
			assign mem_rsp_ready_in = (is_mem_rsp_nc ? ~core_rsp_valid_in[rsp_tid] && core_rsp_ready_out[rsp_tid] : mem_rsp_ready_out);
		end
		else begin : genblk8
			// Trace: ../../rtl/cache/VX_nc_bypass.sv:320:9
			assign mem_rsp_ready_in = (is_mem_rsp_nc ? ~core_rsp_valid_in && core_rsp_ready_out : mem_rsp_ready_out);
		end
	endgenerate
endmodule
module VX_flush_ctrl (
	clk,
	reset,
	addr_out,
	valid_out
);
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:5:15
	parameter CACHE_SIZE = 16384;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:7:15
	parameter CACHE_LINE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:9:15
	parameter NUM_BANKS = 1;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:11:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:12:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:13:5
	output wire [$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0] addr_out;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:14:5
	output wire valid_out;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:16:5
	reg flush_enable;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:17:5
	reg [$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0] flush_ctr;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:19:5
	always @(posedge clk)
		// Trace: ../../rtl/cache/VX_flush_ctrl.sv:20:9
		if (reset) begin
			// Trace: ../../rtl/cache/VX_flush_ctrl.sv:21:13
			flush_enable <= 1;
			// Trace: ../../rtl/cache/VX_flush_ctrl.sv:22:13
			flush_ctr <= 0;
		end
		else
			// Trace: ../../rtl/cache/VX_flush_ctrl.sv:24:13
			if (flush_enable) begin
				// Trace: ../../rtl/cache/VX_flush_ctrl.sv:25:17
				if (flush_ctr == ((2 ** $clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE)) - 1))
					// Trace: ../../rtl/cache/VX_flush_ctrl.sv:26:21
					flush_enable <= 0;
				// Trace: ../../rtl/cache/VX_flush_ctrl.sv:28:17
				flush_ctr <= flush_ctr + 1;
			end
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:33:5
	assign addr_out = flush_ctr;
	// Trace: ../../rtl/cache/VX_flush_ctrl.sv:34:5
	assign valid_out = flush_enable;
endmodule
module VX_core_req_bank_sel (
	clk,
	reset,
	core_req_valid,
	core_req_rw,
	core_req_addr,
	core_req_byteen,
	core_req_data,
	core_req_tag,
	core_req_ready,
	per_bank_core_req_valid,
	per_bank_core_req_pmask,
	per_bank_core_req_rw,
	per_bank_core_req_addr,
	per_bank_core_req_wsel,
	per_bank_core_req_byteen,
	per_bank_core_req_data,
	per_bank_core_req_tid,
	per_bank_core_req_tag,
	per_bank_core_req_ready
);
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:7:15
	parameter CACHE_LINE_SIZE = 64;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:9:15
	parameter WORD_SIZE = 4;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:11:15
	parameter NUM_BANKS = 4;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:13:15
	parameter NUM_PORTS = 1;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:15:15
	parameter NUM_REQS = 4;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:17:15
	parameter CORE_TAG_WIDTH = 3;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:19:15
	parameter BANK_ADDR_OFFSET = 0;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:21:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:22:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:28:5
	input wire [NUM_REQS - 1:0] core_req_valid;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:29:5
	input wire [NUM_REQS - 1:0] core_req_rw;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:30:5
	input wire [(NUM_REQS * (32 - $clog2(WORD_SIZE))) - 1:0] core_req_addr;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:31:5
	input wire [(NUM_REQS * WORD_SIZE) - 1:0] core_req_byteen;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:32:5
	input wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_req_data;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:33:5
	input wire [(NUM_REQS * CORE_TAG_WIDTH) - 1:0] core_req_tag;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:34:5
	output wire [NUM_REQS - 1:0] core_req_ready;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:36:5
	output wire [NUM_BANKS - 1:0] per_bank_core_req_valid;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:37:5
	output wire [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_req_pmask;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:38:5
	output wire [NUM_BANKS - 1:0] per_bank_core_req_rw;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:39:5
	output wire [(NUM_BANKS * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] per_bank_core_req_addr;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:40:5
	output wire [((NUM_BANKS * NUM_PORTS) * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)) - 1:0] per_bank_core_req_wsel;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:41:5
	output wire [((NUM_BANKS * NUM_PORTS) * WORD_SIZE) - 1:0] per_bank_core_req_byteen;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:42:5
	output wire [((NUM_BANKS * NUM_PORTS) * (8 * WORD_SIZE)) - 1:0] per_bank_core_req_data;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:43:5
	output wire [((NUM_BANKS * NUM_PORTS) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] per_bank_core_req_tid;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:44:5
	output wire [((NUM_BANKS * NUM_PORTS) * CORE_TAG_WIDTH) - 1:0] per_bank_core_req_tag;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:45:5
	input wire [NUM_BANKS - 1:0] per_bank_core_req_ready;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:54:5
	wire [(NUM_REQS * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] core_req_line_addr;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:55:5
	wire [(NUM_REQS * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)) - 1:0] core_req_wsel;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:56:5
	wire [(NUM_REQS * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)) - 1:0] core_req_bid;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:58:5
	genvar i;
	generate
		for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
			if (BANK_ADDR_OFFSET == 0) begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:60:13
				assign core_req_line_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = core_req_addr[(i * (32 - $clog2(WORD_SIZE))) + (((32 - $clog2(WORD_SIZE)) - 1) >= (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) ? (32 - $clog2(WORD_SIZE)) - 1 : (((32 - $clog2(WORD_SIZE)) - 1) + (((32 - $clog2(WORD_SIZE)) - 1) >= (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) ? (((32 - $clog2(WORD_SIZE)) - 1) - (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0)) + 1 : ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) - ((32 - $clog2(WORD_SIZE)) - 1)) + 1)) - 1)-:(((32 - $clog2(WORD_SIZE)) - 1) >= (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) ? (((32 - $clog2(WORD_SIZE)) - 1) - (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0)) + 1 : ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) - ((32 - $clog2(WORD_SIZE)) - 1)) + 1)];
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:62:13
				assign core_req_line_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = {core_req_addr[(i * (32 - $clog2(WORD_SIZE))) + (((32 - $clog2(WORD_SIZE)) - 1) >= (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) ? (32 - $clog2(WORD_SIZE)) - 1 : (((32 - $clog2(WORD_SIZE)) - 1) + (((32 - $clog2(WORD_SIZE)) - 1) >= (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) ? (((32 - $clog2(WORD_SIZE)) - 1) - (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0)) + 1 : ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) - ((32 - $clog2(WORD_SIZE)) - 1)) + 1)) - 1)-:(((32 - $clog2(WORD_SIZE)) - 1) >= (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) ? (((32 - $clog2(WORD_SIZE)) - 1) - (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0)) + 1 : ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) - ((32 - $clog2(WORD_SIZE)) - 1)) + 1)], core_req_addr[(i * (32 - $clog2(WORD_SIZE))) + (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1) >= ((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) ? (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1 : (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1) + (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1) >= ((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) ? (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1) - ((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0)) + 1 : (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) - ((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1)) + 1)) - 1)-:(((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1) >= ((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) ? (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1) - ((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0)) + 1 : (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) - ((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - 1)) + 1)]};
			end
			// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:64:9
			assign core_req_wsel[i * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)] = core_req_addr[(i * (32 - $clog2(WORD_SIZE))) + (($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1) - 1)-:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)];
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:67:5
	generate
		for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk2
			if (NUM_BANKS > 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:69:13
				assign core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] = core_req_addr[(i * (32 - $clog2(WORD_SIZE))) + ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1) >= (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) ? ((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1 : ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1) + ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1) >= (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) ? ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1) - (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET)) + 1 : ((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1)) + 1)) - 1)-:((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1) >= (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) ? ((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1) - (((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET)) + 1 : ((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) - (((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) - 1)) + 1)];
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:71:13
				assign core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] = 0;
			end
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:75:5
	reg [NUM_BANKS - 1:0] per_bank_core_req_valid_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:76:5
	reg [(NUM_BANKS * NUM_PORTS) - 1:0] per_bank_core_req_pmask_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:77:5
	reg [((NUM_BANKS * NUM_PORTS) * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)) - 1:0] per_bank_core_req_wsel_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:78:5
	reg [((NUM_BANKS * NUM_PORTS) * WORD_SIZE) - 1:0] per_bank_core_req_byteen_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:79:5
	reg [((NUM_BANKS * NUM_PORTS) * (8 * WORD_SIZE)) - 1:0] per_bank_core_req_data_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:80:5
	reg [((NUM_BANKS * NUM_PORTS) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] per_bank_core_req_tid_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:81:5
	reg [((NUM_BANKS * NUM_PORTS) * CORE_TAG_WIDTH) - 1:0] per_bank_core_req_tag_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:82:5
	reg [NUM_BANKS - 1:0] per_bank_core_req_rw_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:83:5
	reg [(NUM_BANKS * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] per_bank_core_req_addr_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:84:5
	reg [NUM_REQS - 1:0] core_req_ready_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:86:5
	function automatic signed [(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) - 1:0] sv2v_cast_CC627_signed;
		input reg signed [(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) - 1:0] inp;
		sv2v_cast_CC627_signed = inp;
	endfunction
	generate
		if (NUM_REQS > 1) begin : genblk3
			if (NUM_PORTS > 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:90:13
				reg [(NUM_BANKS * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] per_bank_line_addr_r;
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:91:13
				reg [NUM_BANKS - 1:0] per_bank_rw_r;
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:92:13
				wire [NUM_REQS - 1:0] core_req_line_match;
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:94:13
				always @(*) begin
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:95:17
					per_bank_line_addr_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:96:17
					begin : sv2v_autoblock_1
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:96:22
						integer i;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:96:22
						for (i = NUM_REQS - 1; i >= 0; i = i - 1)
							begin
								// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:97:21
								if (core_req_valid[i]) begin
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:98:25
									per_bank_line_addr_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = core_req_line_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)];
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:99:25
									per_bank_rw_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = core_req_rw[i];
								end
							end
					end
				end
				genvar i;
				for (i = 0; i < NUM_REQS; i = i + 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:105:17
					assign core_req_line_match[i] = (core_req_line_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] == per_bank_line_addr_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)]) && (core_req_rw[i] == per_bank_rw_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]]);
				end
				if (NUM_PORTS < NUM_REQS) begin : genblk2
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:111:17
					reg [((NUM_BANKS * NUM_PORTS) * NUM_REQS) - 1:0] req_select_table_r;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:113:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:114:21
						per_bank_core_req_valid_r = 0;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:115:21
						per_bank_core_req_pmask_r = 0;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:116:21
						per_bank_core_req_rw_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:117:21
						per_bank_core_req_addr_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:118:21
						per_bank_core_req_wsel_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:119:21
						per_bank_core_req_byteen_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:120:21
						per_bank_core_req_data_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:121:21
						per_bank_core_req_tag_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:122:21
						per_bank_core_req_tid_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:123:21
						req_select_table_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:125:21
						begin : sv2v_autoblock_2
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:125:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:125:26
							for (i = NUM_REQS - 1; i >= 0; i = i - 1)
								begin
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:126:25
									if (core_req_valid[i]) begin
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:127:29
										per_bank_core_req_valid_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = 1;
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:128:29
										per_bank_core_req_pmask_r[(core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)] = core_req_line_match[i];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:129:29
										per_bank_core_req_wsel_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)] = core_req_wsel[i * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:130:29
										per_bank_core_req_byteen_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * WORD_SIZE+:WORD_SIZE] = core_req_byteen[i * WORD_SIZE+:WORD_SIZE];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:131:29
										per_bank_core_req_data_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * (8 * WORD_SIZE)+:8 * WORD_SIZE] = core_req_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:132:29
										per_bank_core_req_tid_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)] = sv2v_cast_CC627_signed(i);
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:133:29
										per_bank_core_req_tag_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * CORE_TAG_WIDTH+:CORE_TAG_WIDTH] = core_req_tag[i * CORE_TAG_WIDTH+:CORE_TAG_WIDTH];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:134:29
										per_bank_core_req_rw_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = core_req_rw[i];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:135:29
										per_bank_core_req_addr_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = core_req_line_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:136:29
										req_select_table_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * NUM_REQS+:NUM_REQS] = 1 << i;
									end
								end
						end
					end
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:141:17
					always @(*)
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:142:21
						begin : sv2v_autoblock_3
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:142:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:142:26
							for (i = 0; i < NUM_REQS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:143:25
									core_req_ready_r[i] = (per_bank_core_req_ready[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] && core_req_line_match[i]) && req_select_table_r[(((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * NUM_REQS) + i];
								end
						end
				end
				else begin : genblk2
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:151:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:152:21
						per_bank_core_req_valid_r = 0;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:153:21
						per_bank_core_req_pmask_r = 0;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:154:21
						per_bank_core_req_rw_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:155:21
						per_bank_core_req_addr_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:156:21
						per_bank_core_req_wsel_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:157:21
						per_bank_core_req_byteen_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:158:21
						per_bank_core_req_data_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:159:21
						per_bank_core_req_tag_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:160:21
						per_bank_core_req_tid_r = 1'sbx;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:162:21
						begin : sv2v_autoblock_4
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:162:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:162:26
							for (i = NUM_REQS - 1; i >= 0; i = i - 1)
								begin
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:163:25
									if (core_req_valid[i]) begin
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:164:29
										per_bank_core_req_valid_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = 1;
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:165:29
										per_bank_core_req_pmask_r[(core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)] = core_req_line_match[i];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:166:29
										per_bank_core_req_wsel_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)] = core_req_wsel[i * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:167:29
										per_bank_core_req_byteen_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * WORD_SIZE+:WORD_SIZE] = core_req_byteen[i * WORD_SIZE+:WORD_SIZE];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:168:29
										per_bank_core_req_data_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * (8 * WORD_SIZE)+:8 * WORD_SIZE] = core_req_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:169:29
										per_bank_core_req_tid_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)] = sv2v_cast_CC627_signed(i);
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:170:29
										per_bank_core_req_tag_r[((core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS) + (i % NUM_PORTS)) * CORE_TAG_WIDTH+:CORE_TAG_WIDTH] = core_req_tag[i * CORE_TAG_WIDTH+:CORE_TAG_WIDTH];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:171:29
										per_bank_core_req_rw_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = core_req_rw[i];
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:172:29
										per_bank_core_req_addr_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = core_req_line_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)];
									end
								end
						end
					end
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:177:17
					always @(*)
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:178:21
						begin : sv2v_autoblock_5
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:178:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:178:26
							for (i = 0; i < NUM_REQS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:179:25
									core_req_ready_r[i] = per_bank_core_req_ready[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] && core_req_line_match[i];
								end
						end
				end
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:187:13
				always @(*) begin
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:188:17
					per_bank_core_req_valid_r = 0;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:189:17
					per_bank_core_req_rw_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:190:17
					per_bank_core_req_addr_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:191:17
					per_bank_core_req_wsel_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:192:17
					per_bank_core_req_byteen_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:193:17
					per_bank_core_req_data_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:194:17
					per_bank_core_req_tag_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:195:17
					per_bank_core_req_tid_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:197:17
					begin : sv2v_autoblock_6
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:197:22
						integer i;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:197:22
						for (i = NUM_REQS - 1; i >= 0; i = i - 1)
							begin
								// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:198:21
								if (core_req_valid[i]) begin
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:199:25
									per_bank_core_req_valid_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = 1;
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:200:25
									per_bank_core_req_rw_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = core_req_rw[i];
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:201:25
									per_bank_core_req_addr_r[core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = core_req_line_addr[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)];
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:202:25
									per_bank_core_req_wsel_r[($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1) * (core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1) * NUM_PORTS] = core_req_wsel[i * ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)];
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:203:25
									per_bank_core_req_byteen_r[WORD_SIZE * (core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:WORD_SIZE * NUM_PORTS] = core_req_byteen[i * WORD_SIZE+:WORD_SIZE];
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:204:25
									per_bank_core_req_data_r[(8 * WORD_SIZE) * (core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS] = core_req_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE];
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:205:25
									per_bank_core_req_tag_r[CORE_TAG_WIDTH * (core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:CORE_TAG_WIDTH * NUM_PORTS] = core_req_tag[i * CORE_TAG_WIDTH+:CORE_TAG_WIDTH];
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:206:25
									per_bank_core_req_tid_r[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (core_req_bid[i * ($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] = sv2v_cast_CC627_signed(i);
								end
							end
					end
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:210:17
					per_bank_core_req_pmask_r = per_bank_core_req_valid_r;
				end
				if (NUM_BANKS > 1) begin : genblk1
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:214:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:215:21
						core_req_ready_r = 0;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:216:21
						begin : sv2v_autoblock_7
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:216:26
							integer i;
							// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:216:26
							for (i = 0; i < NUM_BANKS; i = i + 1)
								begin
									// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:217:25
									if (per_bank_core_req_valid_r[i])
										// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:218:29
										core_req_ready_r[per_bank_core_req_tid_r[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (i * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS]] = per_bank_core_req_ready[i];
								end
						end
					end
				end
				else begin : genblk1
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:223:17
					always @(*) begin
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:224:21
						core_req_ready_r = 0;
						// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:225:21
						core_req_ready_r[per_bank_core_req_tid_r[0+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS]] = per_bank_core_req_ready;
					end
				end
			end
		end
		else begin : genblk3
			if (NUM_BANKS > 1) begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:233:13
				always @(*) begin
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:234:17
					per_bank_core_req_valid_r = 0;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:235:17
					per_bank_core_req_rw_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:236:17
					per_bank_core_req_addr_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:237:17
					per_bank_core_req_wsel_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:238:17
					per_bank_core_req_byteen_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:239:17
					per_bank_core_req_data_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:240:17
					per_bank_core_req_tag_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:241:17
					per_bank_core_req_tid_r = 1'sbx;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:242:17
					per_bank_core_req_valid_r[core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = core_req_valid;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:243:17
					per_bank_core_req_rw_r[core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]] = core_req_rw;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:244:17
					per_bank_core_req_addr_r[core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = core_req_line_addr;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:245:17
					per_bank_core_req_wsel_r[($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1) * (core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1) * NUM_PORTS] = core_req_wsel;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:246:17
					per_bank_core_req_byteen_r[WORD_SIZE * (core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:WORD_SIZE * NUM_PORTS] = core_req_byteen;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:247:17
					per_bank_core_req_data_r[(8 * WORD_SIZE) * (core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:(8 * WORD_SIZE) * NUM_PORTS] = core_req_data;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:248:17
					per_bank_core_req_tag_r[CORE_TAG_WIDTH * (core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:CORE_TAG_WIDTH * NUM_PORTS] = core_req_tag;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:249:17
					per_bank_core_req_tid_r[(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * (core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)] * NUM_PORTS)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1) * NUM_PORTS] = 0;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:250:17
					core_req_ready_r = per_bank_core_req_ready[core_req_bid[0+:($clog2(NUM_BANKS) > 0 ? $clog2(NUM_BANKS) : 1)]];
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:252:17
					per_bank_core_req_pmask_r = per_bank_core_req_valid_r;
				end
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:256:13
				always @(*) begin
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:257:17
					per_bank_core_req_valid_r = core_req_valid;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:258:17
					per_bank_core_req_rw_r = core_req_rw;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:259:17
					per_bank_core_req_addr_r = core_req_line_addr;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:260:17
					per_bank_core_req_wsel_r = core_req_wsel;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:261:17
					per_bank_core_req_byteen_r = core_req_byteen;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:262:17
					per_bank_core_req_data_r = core_req_data;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:263:17
					per_bank_core_req_tag_r = core_req_tag;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:264:17
					per_bank_core_req_tid_r = 0;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:265:17
					core_req_ready_r = per_bank_core_req_ready;
					// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:267:17
					per_bank_core_req_pmask_r = per_bank_core_req_valid_r;
				end
			end
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:273:5
	assign per_bank_core_req_valid = per_bank_core_req_valid_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:274:5
	assign per_bank_core_req_pmask = per_bank_core_req_pmask_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:275:5
	assign per_bank_core_req_rw = per_bank_core_req_rw_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:276:5
	assign per_bank_core_req_addr = per_bank_core_req_addr_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:277:5
	assign per_bank_core_req_wsel = per_bank_core_req_wsel_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:278:5
	assign per_bank_core_req_byteen = per_bank_core_req_byteen_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:279:5
	assign per_bank_core_req_data = per_bank_core_req_data_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:280:5
	assign per_bank_core_req_tag = per_bank_core_req_tag_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:281:5
	assign per_bank_core_req_tid = per_bank_core_req_tid_r;
	// Trace: ../../rtl/cache/VX_core_req_bank_sel.sv:282:5
	assign core_req_ready = core_req_ready_r;
endmodule
module VX_shared_mem (
	clk,
	reset,
	core_req_valid,
	core_req_rw,
	core_req_addr,
	core_req_byteen,
	core_req_data,
	core_req_tag,
	core_req_ready,
	core_rsp_valid,
	core_rsp_tmask,
	core_rsp_data,
	core_rsp_tag,
	core_rsp_ready
);
	// Trace: ../../rtl/cache/VX_shared_mem.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:7:15
	parameter CACHE_SIZE = 16384;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:9:15
	parameter NUM_BANKS = 2;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:11:15
	parameter WORD_SIZE = 4;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:13:15
	parameter NUM_REQS = 4;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:16:15
	parameter CREQ_SIZE = 2;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:18:15
	parameter CRSQ_SIZE = 2;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:21:15
	parameter CORE_TAG_ID_BITS = 8;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:24:15
	parameter CORE_TAG_WIDTH = 2 + CORE_TAG_ID_BITS;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:27:15
	parameter BANK_ADDR_OFFSET = 8;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:29:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:30:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:38:5
	input wire [NUM_REQS - 1:0] core_req_valid;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:39:5
	input wire [NUM_REQS - 1:0] core_req_rw;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:40:5
	input wire [(NUM_REQS * (32 - $clog2(WORD_SIZE))) - 1:0] core_req_addr;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:41:5
	input wire [(NUM_REQS * WORD_SIZE) - 1:0] core_req_byteen;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:42:5
	input wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_req_data;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:43:5
	input wire [(NUM_REQS * CORE_TAG_WIDTH) - 1:0] core_req_tag;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:44:5
	output wire [NUM_REQS - 1:0] core_req_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:47:5
	output wire core_rsp_valid;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:48:5
	output wire [NUM_REQS - 1:0] core_rsp_tmask;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:49:5
	output wire [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:50:5
	output wire [CORE_TAG_WIDTH - 1:0] core_rsp_tag;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:51:5
	input wire core_rsp_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:58:5
	localparam CACHE_LINE_SIZE = WORD_SIZE;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:60:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_valid_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:61:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_rw_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:62:5
	wire [(NUM_BANKS * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] per_bank_core_req_addr_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:63:5
	wire [(NUM_BANKS * WORD_SIZE) - 1:0] per_bank_core_req_byteen_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:64:5
	wire [(NUM_BANKS * (8 * WORD_SIZE)) - 1:0] per_bank_core_req_data_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:65:5
	wire [(NUM_BANKS * CORE_TAG_WIDTH) - 1:0] per_bank_core_req_tag_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:66:5
	wire [(NUM_BANKS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] per_bank_core_req_tid_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:67:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_ready_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:69:5
	VX_core_req_bank_sel #(
		.CACHE_ID(CACHE_ID),
		.CACHE_LINE_SIZE(WORD_SIZE),
		.NUM_BANKS(NUM_BANKS),
		.NUM_PORTS(1),
		.WORD_SIZE(WORD_SIZE),
		.NUM_REQS(NUM_REQS),
		.CORE_TAG_WIDTH(CORE_TAG_WIDTH),
		.BANK_ADDR_OFFSET(BANK_ADDR_OFFSET)
	) core_req_bank_sel(
		.clk(clk),
		.reset(reset),
		.core_req_valid(core_req_valid),
		.core_req_rw(core_req_rw),
		.core_req_addr(core_req_addr),
		.core_req_byteen(core_req_byteen),
		.core_req_data(core_req_data),
		.core_req_tag(core_req_tag),
		.core_req_ready(core_req_ready),
		.per_bank_core_req_valid(per_bank_core_req_valid_unqual),
		.per_bank_core_req_tid(per_bank_core_req_tid_unqual),
		.per_bank_core_req_rw(per_bank_core_req_rw_unqual),
		.per_bank_core_req_addr(per_bank_core_req_addr_unqual),
		.per_bank_core_req_byteen(per_bank_core_req_byteen_unqual),
		.per_bank_core_req_tag(per_bank_core_req_tag_unqual),
		.per_bank_core_req_data(per_bank_core_req_data_unqual),
		.per_bank_core_req_ready(per_bank_core_req_ready_unqual)
	);
	// Trace: ../../rtl/cache/VX_shared_mem.sv:103:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_valid;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:104:5
	wire [NUM_BANKS - 1:0] per_bank_core_req_rw;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:105:5
	wire [(NUM_BANKS * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] per_bank_core_req_addr;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:106:5
	wire [(NUM_BANKS * WORD_SIZE) - 1:0] per_bank_core_req_byteen;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:107:5
	wire [(NUM_BANKS * (8 * WORD_SIZE)) - 1:0] per_bank_core_req_data;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:108:5
	wire [(NUM_BANKS * CORE_TAG_WIDTH) - 1:0] per_bank_core_req_tag;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:109:5
	wire [(NUM_BANKS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] per_bank_core_req_tid;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:111:5
	wire creq_out_valid;
	wire creq_out_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:112:5
	wire creq_in_valid;
	wire creq_in_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:114:5
	wire creq_in_fire = creq_in_valid && creq_in_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:117:5
	wire creq_out_fire = creq_out_valid && creq_out_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:120:5
	assign creq_in_valid = |core_req_valid;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:121:5
	assign per_bank_core_req_ready_unqual = {NUM_BANKS {creq_in_ready}};
	// Trace: ../../rtl/cache/VX_shared_mem.sv:123:5
	wire [NUM_BANKS - 1:0] core_req_read_mask;
	wire [NUM_BANKS - 1:0] core_req_read_mask_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:124:5
	wire core_req_writeonly;
	wire core_req_writeonly_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:126:5
	assign core_req_read_mask_unqual = per_bank_core_req_valid_unqual & ~per_bank_core_req_rw_unqual;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:127:5
	assign core_req_writeonly_unqual = ~(|core_req_read_mask_unqual);
	// Trace: ../../rtl/cache/VX_shared_mem.sv:129:5
	VX_elastic_buffer #(
		.DATAW(((NUM_BANKS * (((((2 + ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) + WORD_SIZE) + (8 * WORD_SIZE)) + CORE_TAG_WIDTH) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1))) + NUM_BANKS) + 1),
		.SIZE(CREQ_SIZE),
		.OUT_REG(1)
	) core_req_queue(
		.clk(clk),
		.reset(reset),
		.ready_in(creq_in_ready),
		.valid_in(creq_in_valid),
		.data_in({per_bank_core_req_valid_unqual, per_bank_core_req_rw_unqual, per_bank_core_req_addr_unqual, per_bank_core_req_byteen_unqual, per_bank_core_req_data_unqual, per_bank_core_req_tag_unqual, per_bank_core_req_tid_unqual, core_req_read_mask_unqual, core_req_writeonly_unqual}),
		.data_out({per_bank_core_req_valid, per_bank_core_req_rw, per_bank_core_req_addr, per_bank_core_req_byteen, per_bank_core_req_data, per_bank_core_req_tag, per_bank_core_req_tid, core_req_read_mask, core_req_writeonly}),
		.ready_out(creq_out_ready),
		.valid_out(creq_out_valid)
	);
	// Trace: ../../rtl/cache/VX_shared_mem.sv:160:5
	wire crsq_in_valid;
	wire crsq_in_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:161:5
	wire crsq_last_read;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:163:5
	assign creq_out_ready = core_req_writeonly || (crsq_in_ready && crsq_last_read);
	// Trace: ../../rtl/cache/VX_shared_mem.sv:166:5
	wire [(NUM_BANKS * (8 * WORD_SIZE)) - 1:0] per_bank_core_rsp_data;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:168:5
	genvar i;
	generate
		for (i = 0; i < NUM_BANKS; i = i + 1) begin : genblk1
			// Trace: ../../rtl/cache/VX_shared_mem.sv:170:9
			wire [WORD_SIZE - 1:0] wren = per_bank_core_req_byteen[i * WORD_SIZE+:WORD_SIZE] & {WORD_SIZE {per_bank_core_req_valid[i] && per_bank_core_req_rw[i]}};
			// Trace: ../../rtl/cache/VX_shared_mem.sv:174:9
			wire [$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0] addr = per_bank_core_req_addr[(i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) + ($clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1)-:$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE)];
			// Trace: ../../rtl/cache/VX_shared_mem.sv:176:9
			VX_sp_ram #(
				.DATAW(8 * WORD_SIZE),
				.SIZE((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE),
				.BYTEENW(WORD_SIZE),
				.NO_RWCHECK(1)
			) data_store(
				.clk(clk),
				.addr(addr),
				.wren(wren),
				.wdata(per_bank_core_req_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE]),
				.rdata(per_bank_core_rsp_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE])
			);
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_shared_mem.sv:194:5
	reg [NUM_REQS - 1:0] core_rsp_valids_in;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:195:5
	reg [(NUM_REQS * (8 * WORD_SIZE)) - 1:0] core_rsp_data_in;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:196:5
	wire [CORE_TAG_WIDTH - 1:0] core_rsp_tag_in;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:197:5
	reg [NUM_BANKS - 1:0] bank_rsp_sel_r;
	reg [NUM_BANKS - 1:0] bank_rsp_sel_n;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:199:5
	wire crsq_in_fire = crsq_in_valid && crsq_in_ready;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:201:5
	assign crsq_last_read = bank_rsp_sel_n == core_req_read_mask;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:203:5
	always @(posedge clk)
		// Trace: ../../rtl/cache/VX_shared_mem.sv:204:9
		if (reset)
			// Trace: ../../rtl/cache/VX_shared_mem.sv:205:13
			bank_rsp_sel_r <= 0;
		else
			// Trace: ../../rtl/cache/VX_shared_mem.sv:207:13
			if (crsq_in_fire)
				// Trace: ../../rtl/cache/VX_shared_mem.sv:208:17
				if (crsq_last_read)
					// Trace: ../../rtl/cache/VX_shared_mem.sv:209:21
					bank_rsp_sel_r <= 0;
				else
					// Trace: ../../rtl/cache/VX_shared_mem.sv:211:21
					bank_rsp_sel_r <= bank_rsp_sel_n;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:217:5
	VX_find_first #(
		.N(NUM_BANKS),
		.DATAW(CORE_TAG_WIDTH)
	) find_first(
		.valid_i(core_req_read_mask & ~bank_rsp_sel_r),
		.data_i(per_bank_core_req_tag),
		.data_o(core_rsp_tag_in)
	);
	// Trace: ../../rtl/cache/VX_shared_mem.sv:227:5
	always @(*) begin
		// Trace: ../../rtl/cache/VX_shared_mem.sv:228:9
		core_rsp_valids_in = 0;
		// Trace: ../../rtl/cache/VX_shared_mem.sv:229:9
		core_rsp_data_in = 1'sbx;
		// Trace: ../../rtl/cache/VX_shared_mem.sv:230:9
		bank_rsp_sel_n = bank_rsp_sel_r;
		// Trace: ../../rtl/cache/VX_shared_mem.sv:231:9
		begin : sv2v_autoblock_1
			// Trace: ../../rtl/cache/VX_shared_mem.sv:231:14
			integer i;
			// Trace: ../../rtl/cache/VX_shared_mem.sv:231:14
			for (i = 0; i < NUM_BANKS; i = i + 1)
				begin
					// Trace: ../../rtl/cache/VX_shared_mem.sv:232:13
					if (core_req_read_mask[i] && (core_rsp_tag_in[CORE_TAG_ID_BITS - 1:0] == per_bank_core_req_tag[(i * CORE_TAG_WIDTH) + (CORE_TAG_ID_BITS - 1)-:CORE_TAG_ID_BITS])) begin
						// Trace: ../../rtl/cache/VX_shared_mem.sv:234:17
						core_rsp_valids_in[per_bank_core_req_tid[i * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)]] = 1;
						// Trace: ../../rtl/cache/VX_shared_mem.sv:235:17
						core_rsp_data_in[per_bank_core_req_tid[i * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)+:(NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)] * (8 * WORD_SIZE)+:8 * WORD_SIZE] = per_bank_core_rsp_data[i * (8 * WORD_SIZE)+:8 * WORD_SIZE];
						// Trace: ../../rtl/cache/VX_shared_mem.sv:236:17
						bank_rsp_sel_n[i] = 1;
					end
				end
		end
	end
	// Trace: ../../rtl/cache/VX_shared_mem.sv:241:5
	assign crsq_in_valid = creq_out_valid && ~core_req_writeonly;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:243:5
	VX_elastic_buffer #(
		.DATAW((NUM_BANKS * (1 + (8 * WORD_SIZE))) + CORE_TAG_WIDTH),
		.SIZE(CRSQ_SIZE)
	) core_rsp_req(
		.clk(clk),
		.reset(reset),
		.valid_in(crsq_in_valid),
		.data_in({core_rsp_valids_in, core_rsp_data_in, core_rsp_tag_in}),
		.ready_in(crsq_in_ready),
		.valid_out(core_rsp_valid),
		.data_out({core_rsp_tmask, core_rsp_data, core_rsp_tag}),
		.ready_out(core_rsp_ready)
	);
	// Trace: ../../rtl/cache/VX_shared_mem.sv:258:5
	wire [(NUM_BANKS * 44) - 1:0] req_id_st0;
	wire [(NUM_BANKS * 44) - 1:0] req_id_st1;
	// Trace: ../../rtl/cache/VX_shared_mem.sv:261:5
	generate
		for (i = 0; i < NUM_BANKS; i = i + 1) begin : genblk2
			if ((CORE_TAG_WIDTH != CORE_TAG_ID_BITS) && (CORE_TAG_ID_BITS != 0)) begin : genblk1
				// Trace: ../../rtl/cache/VX_shared_mem.sv:263:13
				assign req_id_st0[i * 44+:44] = per_bank_core_req_tag_unqual[(i * CORE_TAG_WIDTH) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? CORE_TAG_WIDTH - 1 : ((CORE_TAG_WIDTH - 1) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)) - 1)-:((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)];
				// Trace: ../../rtl/cache/VX_shared_mem.sv:264:13
				assign req_id_st1[i * 44+:44] = per_bank_core_req_tag[(i * CORE_TAG_WIDTH) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? CORE_TAG_WIDTH - 1 : ((CORE_TAG_WIDTH - 1) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)) - 1)-:((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)];
			end
			else begin : genblk1
				// Trace: ../../rtl/cache/VX_shared_mem.sv:266:13
				assign req_id_st0[i * 44+:44] = 0;
				// Trace: ../../rtl/cache/VX_shared_mem.sv:267:13
				assign req_id_st1[i * 44+:44] = 0;
			end
		end
	endgenerate
endmodule
module VX_tag_access (
	clk,
	reset,
	req_id,
	stall,
	lookup,
	addr,
	fill,
	flush,
	tag_match
);
	// Trace: ../../rtl/cache/VX_tag_access.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_tag_access.sv:5:15
	parameter BANK_ID = 0;
	// Trace: ../../rtl/cache/VX_tag_access.sv:7:15
	parameter CACHE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_tag_access.sv:9:15
	parameter CACHE_LINE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_tag_access.sv:11:15
	parameter NUM_BANKS = 1;
	// Trace: ../../rtl/cache/VX_tag_access.sv:13:15
	parameter WORD_SIZE = 1;
	// Trace: ../../rtl/cache/VX_tag_access.sv:15:15
	parameter BANK_ADDR_OFFSET = 0;
	// Trace: ../../rtl/cache/VX_tag_access.sv:17:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_tag_access.sv:18:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_tag_access.sv:21:5
	input wire [43:0] req_id;
	// Trace: ../../rtl/cache/VX_tag_access.sv:24:5
	input wire stall;
	// Trace: ../../rtl/cache/VX_tag_access.sv:27:5
	input wire lookup;
	// Trace: ../../rtl/cache/VX_tag_access.sv:28:5
	input wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] addr;
	// Trace: ../../rtl/cache/VX_tag_access.sv:29:5
	input wire fill;
	// Trace: ../../rtl/cache/VX_tag_access.sv:30:5
	input wire flush;
	// Trace: ../../rtl/cache/VX_tag_access.sv:31:5
	output wire tag_match;
	// Trace: ../../rtl/cache/VX_tag_access.sv:39:5
	wire [(((32 - $clog2(WORD_SIZE)) - 1) - ((((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) - BANK_ADDR_OFFSET) + $clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE)) - 1)) - 1:0] read_tag;
	// Trace: ../../rtl/cache/VX_tag_access.sv:40:5
	wire read_valid;
	// Trace: ../../rtl/cache/VX_tag_access.sv:42:5
	wire [$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0] line_addr = addr[$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0];
	// Trace: ../../rtl/cache/VX_tag_access.sv:43:5
	wire [(((32 - $clog2(WORD_SIZE)) - 1) - ((((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) - BANK_ADDR_OFFSET) + $clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE)) - 1)) - 1:0] line_tag = addr[((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE)];
	// Trace: ../../rtl/cache/VX_tag_access.sv:45:5
	VX_sp_ram #(
		.DATAW((((32 - $clog2(WORD_SIZE)) - 1) - ((((((((0 + $clog2(CACHE_LINE_SIZE / WORD_SIZE)) + 0) + BANK_ADDR_OFFSET) + $clog2(NUM_BANKS)) + 0) - BANK_ADDR_OFFSET) + $clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE)) - 1)) + 1),
		.SIZE((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE),
		.NO_RWCHECK(1)
	) tag_store(
		.clk(clk),
		.addr(line_addr),
		.wren(fill || flush),
		.wdata({!flush, line_tag}),
		.rdata({read_valid, read_tag})
	);
	// Trace: ../../rtl/cache/VX_tag_access.sv:57:5
	assign tag_match = read_valid && (line_tag == read_tag);
endmodule
module VX_miss_resrv (
	clk,
	reset,
	deq_req_id,
	lkp_req_id,
	rel_req_id,
	allocate_valid,
	allocate_addr,
	allocate_data,
	allocate_id,
	allocate_ready,
	fill_valid,
	fill_id,
	fill_addr,
	lookup_valid,
	lookup_replay,
	lookup_id,
	lookup_addr,
	lookup_match,
	dequeue_valid,
	dequeue_id,
	dequeue_addr,
	dequeue_data,
	dequeue_ready,
	release_valid,
	release_id
);
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:5:15
	parameter BANK_ID = 0;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:8:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:11:15
	parameter CACHE_LINE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:13:15
	parameter NUM_BANKS = 1;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:15:15
	parameter NUM_PORTS = 1;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:17:15
	parameter WORD_SIZE = 1;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:19:15
	parameter MSHR_SIZE = 1;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:21:15
	parameter CORE_TAG_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:23:15
	parameter MSHR_ADDR_WIDTH = $clog2(MSHR_SIZE);
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:25:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:26:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:29:5
	input wire [43:0] deq_req_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:30:5
	input wire [43:0] lkp_req_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:31:5
	input wire [43:0] rel_req_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:35:5
	input wire allocate_valid;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:36:5
	input wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] allocate_addr;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:37:5
	input wire [((((CORE_TAG_WIDTH + 1) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) + ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)) * NUM_PORTS) - 1:0] allocate_data;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:38:5
	output wire [MSHR_ADDR_WIDTH - 1:0] allocate_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:39:5
	output wire allocate_ready;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:42:5
	input wire fill_valid;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:43:5
	input wire [MSHR_ADDR_WIDTH - 1:0] fill_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:44:5
	output wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] fill_addr;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:47:5
	input wire lookup_valid;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:48:5
	input wire lookup_replay;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:49:5
	input wire [MSHR_ADDR_WIDTH - 1:0] lookup_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:50:5
	input wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] lookup_addr;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:51:5
	output wire lookup_match;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:54:5
	output wire dequeue_valid;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:55:5
	output wire [MSHR_ADDR_WIDTH - 1:0] dequeue_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:56:5
	output wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] dequeue_addr;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:57:5
	output wire [((((CORE_TAG_WIDTH + 1) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) + ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)) * NUM_PORTS) - 1:0] dequeue_data;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:58:5
	input wire dequeue_ready;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:61:5
	input wire release_valid;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:62:5
	input wire [MSHR_ADDR_WIDTH - 1:0] release_id;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:67:5
	reg [(MSHR_SIZE * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] addr_table;
	reg [(MSHR_SIZE * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) - 1:0] addr_table_n;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:68:5
	reg [MSHR_SIZE - 1:0] valid_table;
	reg [MSHR_SIZE - 1:0] valid_table_n;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:69:5
	reg [MSHR_SIZE - 1:0] ready_table;
	reg [MSHR_SIZE - 1:0] ready_table_n;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:71:5
	reg allocate_rdy_r;
	reg allocate_rdy_n;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:72:5
	reg [MSHR_ADDR_WIDTH - 1:0] allocate_id_r;
	reg [MSHR_ADDR_WIDTH - 1:0] allocate_id_n;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:74:5
	reg dequeue_val_r;
	reg dequeue_val_n;
	reg dequeue_val_x;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:75:5
	reg [MSHR_ADDR_WIDTH - 1:0] dequeue_id_r;
	reg [MSHR_ADDR_WIDTH - 1:0] dequeue_id_n;
	reg [MSHR_ADDR_WIDTH - 1:0] dequeue_id_x;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:77:5
	reg [MSHR_SIZE - 1:0] valid_table_x;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:78:5
	reg [MSHR_SIZE - 1:0] ready_table_x;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:80:5
	wire [MSHR_SIZE - 1:0] addr_matches;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:82:5
	wire allocate_fire = allocate_valid && allocate_ready;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:84:5
	wire dequeue_fire = dequeue_valid && dequeue_ready;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:86:5
	genvar i;
	generate
		for (i = 0; i < MSHR_SIZE; i = i + 1) begin : genblk1
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:87:9
			assign addr_matches[i] = addr_table[i * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] == lookup_addr;
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:90:5
	always @(*) begin
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:91:9
		valid_table_x = valid_table;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:92:9
		ready_table_x = ready_table;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:93:9
		if (dequeue_fire)
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:94:13
			valid_table_x[dequeue_id] = 0;
		if (lookup_replay)
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:97:13
			ready_table_x = ready_table_x | addr_matches;
	end
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:101:5
	// rewrote reg-to-output bindings
	wire [MSHR_ADDR_WIDTH:1] sv2v_tmp_dequeue_sel_cnt_o;
	always @(*) dequeue_id_x = sv2v_tmp_dequeue_sel_cnt_o;
	wire [1:1] sv2v_tmp_dequeue_sel_valid_o;
	always @(*) dequeue_val_x = sv2v_tmp_dequeue_sel_valid_o;
	VX_lzc #(.N(MSHR_SIZE)) dequeue_sel(
		.in_i(valid_table_x & ready_table_x),
		.cnt_o(sv2v_tmp_dequeue_sel_cnt_o),
		.valid_o(sv2v_tmp_dequeue_sel_valid_o)
	);
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:109:5
	// rewrote reg-to-output bindings
	wire [MSHR_ADDR_WIDTH:1] sv2v_tmp_allocate_sel_cnt_o;
	always @(*) allocate_id_n = sv2v_tmp_allocate_sel_cnt_o;
	wire [1:1] sv2v_tmp_allocate_sel_valid_o;
	always @(*) allocate_rdy_n = sv2v_tmp_allocate_sel_valid_o;
	VX_lzc #(.N(MSHR_SIZE)) allocate_sel(
		.in_i(~valid_table_n),
		.cnt_o(sv2v_tmp_allocate_sel_cnt_o),
		.valid_o(sv2v_tmp_allocate_sel_valid_o)
	);
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:117:5
	always @(*) begin
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:118:9
		valid_table_n = valid_table_x;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:119:9
		ready_table_n = ready_table_x;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:120:9
		addr_table_n = addr_table;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:121:9
		dequeue_val_n = dequeue_val_r;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:122:9
		dequeue_id_n = dequeue_id_r;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:124:9
		if (dequeue_fire) begin
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:125:13
			dequeue_val_n = dequeue_val_x;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:126:13
			dequeue_id_n = dequeue_id_x;
		end
		if (allocate_fire) begin
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:130:13
			valid_table_n[allocate_id] = 1;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:131:13
			ready_table_n[allocate_id] = 0;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:132:13
			addr_table_n[allocate_id * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)] = allocate_addr;
		end
		if (fill_valid) begin
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:136:13
			dequeue_val_n = 1;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:137:13
			dequeue_id_n = fill_id;
		end
		if (release_valid)
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:141:13
			valid_table_n[release_id] = 0;
	end
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:145:5
	always @(posedge clk) begin
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:146:9
		if (reset) begin
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:147:13
			valid_table <= 0;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:148:13
			allocate_rdy_r <= 0;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:149:13
			dequeue_val_r <= 0;
		end
		else begin
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:151:13
			valid_table <= valid_table_n;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:152:13
			allocate_rdy_r <= allocate_rdy_n;
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:153:13
			dequeue_val_r <= dequeue_val_n;
		end
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:155:9
		ready_table <= ready_table_n;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:156:9
		addr_table <= addr_table_n;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:157:9
		dequeue_id_r <= dequeue_id_n;
		// Trace: ../../rtl/cache/VX_miss_resrv.sv:158:9
		allocate_id_r <= allocate_id_n;
		if (!allocate_fire || !valid_table[allocate_id_r])
			;
		if (!release_valid || valid_table[release_id])
			;
	end
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:170:5
	VX_dp_ram #(
		.DATAW((((CORE_TAG_WIDTH + 1) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) + ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1)) * NUM_PORTS),
		.SIZE(MSHR_SIZE),
		.LUTRAM(1)
	) entries(
		.clk(clk),
		.waddr(allocate_id_r),
		.raddr(dequeue_id_r),
		.wren(allocate_valid),
		.wdata(allocate_data),
		.rdata(dequeue_data)
	);
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:183:5
	assign fill_addr = addr_table[fill_id * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)];
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:185:5
	assign allocate_ready = allocate_rdy_r;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:186:5
	assign allocate_id = allocate_id_r;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:188:5
	assign dequeue_valid = dequeue_val_r;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:189:5
	assign dequeue_id = dequeue_id_r;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:190:5
	assign dequeue_addr = addr_table[dequeue_id_r * ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))+:(32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)];
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:192:5
	wire [MSHR_SIZE - 1:0] lookup_entries;
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:193:5
	generate
		for (i = 0; i < MSHR_SIZE; i = i + 1) begin : genblk2
			// Trace: ../../rtl/cache/VX_miss_resrv.sv:194:9
			assign lookup_entries[i] = i != lookup_id;
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_miss_resrv.sv:196:5
	assign lookup_match = |((lookup_entries & valid_table) & addr_matches);
endmodule
module VX_bank (
	clk,
	reset,
	core_req_valid,
	core_req_pmask,
	core_req_wsel,
	core_req_byteen,
	core_req_data,
	core_req_tid,
	core_req_tag,
	core_req_rw,
	core_req_addr,
	core_req_ready,
	core_rsp_valid,
	core_rsp_pmask,
	core_rsp_tid,
	core_rsp_data,
	core_rsp_tag,
	core_rsp_ready,
	mem_req_valid,
	mem_req_rw,
	mem_req_pmask,
	mem_req_byteen,
	mem_req_wsel,
	mem_req_addr,
	mem_req_id,
	mem_req_data,
	mem_req_ready,
	mem_rsp_valid,
	mem_rsp_id,
	mem_rsp_data,
	mem_rsp_ready,
	flush_enable,
	flush_addr
);
	// Trace: ../../rtl/cache/VX_bank.sv:4:15
	parameter CACHE_ID = 0;
	// Trace: ../../rtl/cache/VX_bank.sv:5:15
	parameter BANK_ID = 0;
	// Trace: ../../rtl/cache/VX_bank.sv:8:15
	parameter NUM_REQS = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:11:15
	parameter CACHE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:13:15
	parameter CACHE_LINE_SIZE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:15:15
	parameter NUM_BANKS = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:17:15
	parameter NUM_PORTS = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:19:15
	parameter WORD_SIZE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:22:15
	parameter CREQ_SIZE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:24:15
	parameter CRSQ_SIZE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:26:15
	parameter MSHR_SIZE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:28:15
	parameter MREQ_SIZE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:31:15
	parameter WRITE_ENABLE = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:34:15
	parameter CORE_TAG_WIDTH = 1;
	// Trace: ../../rtl/cache/VX_bank.sv:37:15
	parameter BANK_ADDR_OFFSET = 0;
	// Trace: ../../rtl/cache/VX_bank.sv:39:15
	parameter MSHR_ADDR_WIDTH = $clog2(MSHR_SIZE);
	// Trace: ../../rtl/cache/VX_bank.sv:40:15
	parameter WORD_SELECT_BITS = ($clog2(CACHE_LINE_SIZE / WORD_SIZE) > 0 ? $clog2(CACHE_LINE_SIZE / WORD_SIZE) : 1);
	// Trace: ../../rtl/cache/VX_bank.sv:44:5
	input wire clk;
	// Trace: ../../rtl/cache/VX_bank.sv:45:5
	input wire reset;
	// Trace: ../../rtl/cache/VX_bank.sv:54:5
	input wire core_req_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:55:5
	input wire [NUM_PORTS - 1:0] core_req_pmask;
	// Trace: ../../rtl/cache/VX_bank.sv:56:5
	input wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] core_req_wsel;
	// Trace: ../../rtl/cache/VX_bank.sv:57:5
	input wire [(NUM_PORTS * WORD_SIZE) - 1:0] core_req_byteen;
	// Trace: ../../rtl/cache/VX_bank.sv:58:5
	input wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] core_req_data;
	// Trace: ../../rtl/cache/VX_bank.sv:59:5
	input wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] core_req_tid;
	// Trace: ../../rtl/cache/VX_bank.sv:60:5
	input wire [(NUM_PORTS * CORE_TAG_WIDTH) - 1:0] core_req_tag;
	// Trace: ../../rtl/cache/VX_bank.sv:61:5
	input wire core_req_rw;
	// Trace: ../../rtl/cache/VX_bank.sv:62:5
	input wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] core_req_addr;
	// Trace: ../../rtl/cache/VX_bank.sv:63:5
	output wire core_req_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:66:5
	output wire core_rsp_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:67:5
	output wire [NUM_PORTS - 1:0] core_rsp_pmask;
	// Trace: ../../rtl/cache/VX_bank.sv:68:5
	output wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] core_rsp_tid;
	// Trace: ../../rtl/cache/VX_bank.sv:69:5
	output wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] core_rsp_data;
	// Trace: ../../rtl/cache/VX_bank.sv:70:5
	output wire [(NUM_PORTS * CORE_TAG_WIDTH) - 1:0] core_rsp_tag;
	// Trace: ../../rtl/cache/VX_bank.sv:71:5
	input wire core_rsp_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:74:5
	output wire mem_req_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:75:5
	output wire mem_req_rw;
	// Trace: ../../rtl/cache/VX_bank.sv:76:5
	output wire [NUM_PORTS - 1:0] mem_req_pmask;
	// Trace: ../../rtl/cache/VX_bank.sv:77:5
	output wire [(NUM_PORTS * WORD_SIZE) - 1:0] mem_req_byteen;
	// Trace: ../../rtl/cache/VX_bank.sv:78:5
	output wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] mem_req_wsel;
	// Trace: ../../rtl/cache/VX_bank.sv:79:5
	output wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] mem_req_addr;
	// Trace: ../../rtl/cache/VX_bank.sv:80:5
	output wire [MSHR_ADDR_WIDTH - 1:0] mem_req_id;
	// Trace: ../../rtl/cache/VX_bank.sv:81:5
	output wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] mem_req_data;
	// Trace: ../../rtl/cache/VX_bank.sv:82:5
	input wire mem_req_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:85:5
	input wire mem_rsp_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:86:5
	input wire [MSHR_ADDR_WIDTH - 1:0] mem_rsp_id;
	// Trace: ../../rtl/cache/VX_bank.sv:87:5
	input wire [(8 * CACHE_LINE_SIZE) - 1:0] mem_rsp_data;
	// Trace: ../../rtl/cache/VX_bank.sv:88:5
	output wire mem_rsp_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:91:5
	input wire flush_enable;
	// Trace: ../../rtl/cache/VX_bank.sv:92:5
	input wire [$clog2((CACHE_SIZE / NUM_BANKS) / CACHE_LINE_SIZE) - 1:0] flush_addr;
	// Trace: ../../rtl/cache/VX_bank.sv:96:5
	wire [43:0] req_id_sel;
	wire [43:0] req_id_st0;
	wire [43:0] req_id_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:99:5
	wire [NUM_PORTS - 1:0] creq_pmask;
	// Trace: ../../rtl/cache/VX_bank.sv:100:5
	wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] creq_wsel;
	// Trace: ../../rtl/cache/VX_bank.sv:101:5
	wire [(NUM_PORTS * WORD_SIZE) - 1:0] creq_byteen;
	// Trace: ../../rtl/cache/VX_bank.sv:102:5
	wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] creq_data;
	// Trace: ../../rtl/cache/VX_bank.sv:103:5
	wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] creq_tid;
	// Trace: ../../rtl/cache/VX_bank.sv:104:5
	wire [(NUM_PORTS * CORE_TAG_WIDTH) - 1:0] creq_tag;
	// Trace: ../../rtl/cache/VX_bank.sv:105:5
	wire creq_rw;
	// Trace: ../../rtl/cache/VX_bank.sv:106:5
	wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] creq_addr;
	// Trace: ../../rtl/cache/VX_bank.sv:108:5
	wire creq_valid;
	wire creq_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:110:5
	VX_elastic_buffer #(
		.DATAW((1 + ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) + (NUM_PORTS * (((((1 + WORD_SELECT_BITS) + WORD_SIZE) + (8 * WORD_SIZE)) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) + CORE_TAG_WIDTH))),
		.SIZE(CREQ_SIZE)
	) core_req_queue(
		.clk(clk),
		.reset(reset),
		.ready_in(core_req_ready),
		.valid_in(core_req_valid),
		.data_in({core_req_rw, core_req_addr, core_req_pmask, core_req_wsel, core_req_byteen, core_req_data, core_req_tid, core_req_tag}),
		.data_out({creq_rw, creq_addr, creq_pmask, creq_wsel, creq_byteen, creq_data, creq_tid, creq_tag}),
		.ready_out(creq_ready),
		.valid_out(creq_valid)
	);
	// Trace: ../../rtl/cache/VX_bank.sv:124:5
	wire mreq_alm_full;
	// Trace: ../../rtl/cache/VX_bank.sv:125:5
	wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] mem_rsp_addr;
	// Trace: ../../rtl/cache/VX_bank.sv:126:5
	wire crsq_valid;
	wire crsq_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:127:5
	wire crsq_stall;
	// Trace: ../../rtl/cache/VX_bank.sv:129:5
	wire mshr_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:130:5
	wire mshr_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:131:5
	wire [MSHR_ADDR_WIDTH - 1:0] mshr_alloc_id;
	// Trace: ../../rtl/cache/VX_bank.sv:132:5
	wire mshr_alm_full;
	// Trace: ../../rtl/cache/VX_bank.sv:133:5
	wire [MSHR_ADDR_WIDTH - 1:0] mshr_dequeue_id;
	// Trace: ../../rtl/cache/VX_bank.sv:134:5
	wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] mshr_addr;
	// Trace: ../../rtl/cache/VX_bank.sv:135:5
	wire [(NUM_PORTS * CORE_TAG_WIDTH) - 1:0] mshr_tag;
	// Trace: ../../rtl/cache/VX_bank.sv:136:5
	wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] mshr_wsel;
	// Trace: ../../rtl/cache/VX_bank.sv:137:5
	wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] mshr_tid;
	// Trace: ../../rtl/cache/VX_bank.sv:138:5
	wire [NUM_PORTS - 1:0] mshr_pmask;
	// Trace: ../../rtl/cache/VX_bank.sv:140:5
	wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] addr_st0;
	wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] addr_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:141:5
	wire is_read_st0;
	wire is_read_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:142:5
	wire is_write_st0;
	wire is_write_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:143:5
	wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] wsel_st0;
	wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] wsel_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:144:5
	wire [(NUM_PORTS * WORD_SIZE) - 1:0] byteen_st0;
	wire [(NUM_PORTS * WORD_SIZE) - 1:0] byteen_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:145:5
	wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] req_tid_st0;
	wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] req_tid_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:146:5
	wire [NUM_PORTS - 1:0] pmask_st0;
	wire [NUM_PORTS - 1:0] pmask_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:147:5
	wire [(NUM_PORTS * CORE_TAG_WIDTH) - 1:0] tag_st0;
	wire [(NUM_PORTS * CORE_TAG_WIDTH) - 1:0] tag_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:148:5
	wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] rdata_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:149:5
	wire [(8 * CACHE_LINE_SIZE) - 1:0] wdata_st0;
	wire [(8 * CACHE_LINE_SIZE) - 1:0] wdata_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:150:5
	wire [MSHR_ADDR_WIDTH - 1:0] mshr_id_st0;
	wire [MSHR_ADDR_WIDTH - 1:0] mshr_id_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:151:5
	wire valid_st0;
	wire valid_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:152:5
	wire is_fill_st0;
	wire is_fill_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:153:5
	wire is_mshr_st0;
	wire is_mshr_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:154:5
	wire miss_st0;
	wire miss_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:155:5
	wire is_flush_st0;
	// Trace: ../../rtl/cache/VX_bank.sv:156:5
	wire mshr_pending_st0;
	wire mshr_pending_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:159:5
	wire rdw_fill_hazard = valid_st0 && is_fill_st0;
	// Trace: ../../rtl/cache/VX_bank.sv:160:5
	wire rdw_write_hazard = (valid_st0 && is_write_st0) && ~creq_rw;
	// Trace: ../../rtl/cache/VX_bank.sv:163:5
	wire mshr_grant = !flush_enable;
	// Trace: ../../rtl/cache/VX_bank.sv:164:5
	wire mshr_enable = mshr_grant && mshr_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:166:5
	wire mrsq_grant = !flush_enable && !mshr_enable;
	// Trace: ../../rtl/cache/VX_bank.sv:167:5
	wire mrsq_enable = mrsq_grant && mem_rsp_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:168:5
	wire creq_grant = (!flush_enable && !mshr_enable) && !mrsq_enable;
	// Trace: ../../rtl/cache/VX_bank.sv:170:5
	wire creq_enable = creq_grant && creq_valid;
	// Trace: ../../rtl/cache/VX_bank.sv:172:5
	assign mshr_ready = (mshr_grant && !rdw_fill_hazard) && !crsq_stall;
	// Trace: ../../rtl/cache/VX_bank.sv:177:5
	assign mem_rsp_ready = mrsq_grant && !crsq_stall;
	// Trace: ../../rtl/cache/VX_bank.sv:180:5
	assign creq_ready = (((creq_grant && !rdw_write_hazard) && !mreq_alm_full) && !mshr_alm_full) && !crsq_stall;
	// Trace: ../../rtl/cache/VX_bank.sv:186:5
	wire flush_fire = flush_enable;
	// Trace: ../../rtl/cache/VX_bank.sv:187:5
	wire mshr_fire = mshr_valid && mshr_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:188:5
	wire mem_rsp_fire = mem_rsp_valid && mem_rsp_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:189:5
	wire creq_fire = creq_valid && creq_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:191:5
	assign req_id_sel = (mshr_enable ? mshr_tag[0 + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? CORE_TAG_WIDTH - 1 : ((CORE_TAG_WIDTH - 1) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)) - 1)-:((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)] : creq_tag[0 + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? CORE_TAG_WIDTH - 1 : ((CORE_TAG_WIDTH - 1) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)) - 1)-:((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)]);
	// Trace: ../../rtl/cache/VX_bank.sv:193:5
	wire [(8 * CACHE_LINE_SIZE) - 1:0] wdata_sel;
	// Trace: ../../rtl/cache/VX_bank.sv:194:5
	assign wdata_sel[(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] = (mem_rsp_valid || !WRITE_ENABLE ? mem_rsp_data[(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] : creq_data);
	// Trace: ../../rtl/cache/VX_bank.sv:195:5
	genvar i;
	generate
		for (i = NUM_PORTS * (8 * WORD_SIZE); i < (8 * CACHE_LINE_SIZE); i = i + 1) begin : genblk1
			// Trace: ../../rtl/cache/VX_bank.sv:196:9
			assign wdata_sel[i] = mem_rsp_data[i];
		end
	endgenerate
	// Trace: ../../rtl/cache/VX_bank.sv:199:5
	function automatic [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] sv2v_cast_FD4D3;
		input reg [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] inp;
		sv2v_cast_FD4D3 = inp;
	endfunction
	VX_pipe_register #(
		.DATAW((((6 + ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) + (8 * CACHE_LINE_SIZE)) + (NUM_PORTS * ((((WORD_SELECT_BITS + WORD_SIZE) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) + 1) + CORE_TAG_WIDTH))) + MSHR_ADDR_WIDTH),
		.RESETW(1)
	) pipe_reg0(
		.clk(clk),
		.reset(reset),
		.enable(!crsq_stall),
		.data_in({((flush_fire || mshr_fire) || mem_rsp_fire) || creq_fire, flush_enable, mshr_enable, mrsq_enable, creq_enable && ~creq_rw, creq_enable && creq_rw, (flush_enable ? sv2v_cast_FD4D3(flush_addr) : (mshr_valid ? mshr_addr : (mem_rsp_valid ? mem_rsp_addr : creq_addr))), wdata_sel, (mshr_valid ? mshr_wsel : creq_wsel), creq_byteen, (mshr_valid ? mshr_tid : creq_tid), (mshr_valid ? mshr_pmask : creq_pmask), (mshr_valid ? mshr_tag : creq_tag), (mshr_valid ? mshr_dequeue_id : mem_rsp_id)}),
		.data_out({valid_st0, is_flush_st0, is_mshr_st0, is_fill_st0, is_read_st0, is_write_st0, addr_st0, wdata_st0, wsel_st0, byteen_st0, req_tid_st0, pmask_st0, tag_st0, mshr_id_st0})
	);
	// Trace: ../../rtl/cache/VX_bank.sv:225:5
	assign req_id_st0 = tag_st0[0 + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? CORE_TAG_WIDTH - 1 : ((CORE_TAG_WIDTH - 1) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)) - 1)-:((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)];
	// Trace: ../../rtl/cache/VX_bank.sv:227:5
	wire do_fill_st0 = valid_st0 && is_fill_st0;
	// Trace: ../../rtl/cache/VX_bank.sv:228:5
	wire do_flush_st0 = valid_st0 && is_flush_st0;
	// Trace: ../../rtl/cache/VX_bank.sv:229:5
	wire do_lookup_st0 = valid_st0 && ~(is_fill_st0 || is_flush_st0);
	// Trace: ../../rtl/cache/VX_bank.sv:231:5
	wire tag_match_st0;
	// Trace: ../../rtl/cache/VX_bank.sv:233:5
	VX_tag_access #(
		.BANK_ID(BANK_ID),
		.CACHE_ID(CACHE_ID),
		.CACHE_SIZE(CACHE_SIZE),
		.CACHE_LINE_SIZE(CACHE_LINE_SIZE),
		.NUM_BANKS(NUM_BANKS),
		.WORD_SIZE(WORD_SIZE),
		.BANK_ADDR_OFFSET(BANK_ADDR_OFFSET)
	) tag_access(
		.clk(clk),
		.reset(reset),
		.req_id(req_id_st0),
		.stall(crsq_stall),
		.lookup(do_lookup_st0),
		.addr(addr_st0),
		.fill(do_fill_st0),
		.flush(do_flush_st0),
		.tag_match(tag_match_st0)
	);
	// Trace: ../../rtl/cache/VX_bank.sv:258:5
	assign miss_st0 = (is_read_st0 || is_write_st0) && ~tag_match_st0;
	// Trace: ../../rtl/cache/VX_bank.sv:260:5
	wire [MSHR_ADDR_WIDTH - 1:0] mshr_id_a_st0 = (is_read_st0 || is_write_st0 ? mshr_alloc_id : mshr_id_st0);
	// Trace: ../../rtl/cache/VX_bank.sv:262:5
	VX_pipe_register #(
		.DATAW(((((6 + ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) + (8 * CACHE_LINE_SIZE)) + (NUM_PORTS * ((((WORD_SELECT_BITS + WORD_SIZE) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) + 1) + CORE_TAG_WIDTH))) + MSHR_ADDR_WIDTH) + 1),
		.RESETW(1)
	) pipe_reg1(
		.clk(clk),
		.reset(reset),
		.enable(!crsq_stall),
		.data_in({valid_st0, is_mshr_st0, is_fill_st0, is_read_st0, is_write_st0, miss_st0, addr_st0, wdata_st0, wsel_st0, byteen_st0, req_tid_st0, pmask_st0, tag_st0, mshr_id_a_st0, mshr_pending_st0}),
		.data_out({valid_st1, is_mshr_st1, is_fill_st1, is_read_st1, is_write_st1, miss_st1, addr_st1, wdata_st1, wsel_st1, byteen_st1, req_tid_st1, pmask_st1, tag_st1, mshr_id_st1, mshr_pending_st1})
	);
	// Trace: ../../rtl/cache/VX_bank.sv:273:5
	assign req_id_st1 = tag_st1[0 + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? CORE_TAG_WIDTH - 1 : ((CORE_TAG_WIDTH - 1) + ((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)) - 1)-:((CORE_TAG_WIDTH - 1) >= (CORE_TAG_WIDTH - 44) ? ((CORE_TAG_WIDTH - 1) - (CORE_TAG_WIDTH - 44)) + 1 : ((CORE_TAG_WIDTH - 44) - (CORE_TAG_WIDTH - 1)) + 1)];
	// Trace: ../../rtl/cache/VX_bank.sv:275:5
	wire do_read_st0 = valid_st0 && is_read_st0;
	// Trace: ../../rtl/cache/VX_bank.sv:276:5
	wire do_read_st1 = valid_st1 && is_read_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:277:5
	wire do_fill_st1 = valid_st1 && is_fill_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:278:5
	wire do_write_st1 = valid_st1 && is_write_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:279:5
	wire do_mshr_st1 = valid_st1 && is_mshr_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:281:5
	wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] creq_data_st1 = wdata_st1[0+:NUM_PORTS * (8 * WORD_SIZE)];
	// Trace: ../../rtl/cache/VX_bank.sv:284:5
	VX_data_access #(
		.BANK_ID(BANK_ID),
		.CACHE_ID(CACHE_ID),
		.CACHE_SIZE(CACHE_SIZE),
		.CACHE_LINE_SIZE(CACHE_LINE_SIZE),
		.NUM_BANKS(NUM_BANKS),
		.NUM_PORTS(NUM_PORTS),
		.WORD_SIZE(WORD_SIZE),
		.WRITE_ENABLE(WRITE_ENABLE)
	) data_access(
		.clk(clk),
		.reset(reset),
		.req_id(req_id_st1),
		.stall(crsq_stall),
		.read(do_read_st1 || do_mshr_st1),
		.fill(do_fill_st1),
		.write(do_write_st1 && !miss_st1),
		.addr(addr_st1),
		.wsel(wsel_st1),
		.pmask(pmask_st1),
		.byteen(byteen_st1),
		.fill_data(wdata_st1),
		.write_data(creq_data_st1),
		.read_data(rdata_st1)
	);
	// Trace: ../../rtl/cache/VX_bank.sv:313:5
	wire mshr_allocate = do_read_st0 && !crsq_stall;
	// Trace: ../../rtl/cache/VX_bank.sv:314:5
	wire mshr_replay = do_fill_st0 && !crsq_stall;
	// Trace: ../../rtl/cache/VX_bank.sv:315:5
	wire mshr_lookup = mshr_allocate;
	// Trace: ../../rtl/cache/VX_bank.sv:316:5
	wire mshr_release = (do_read_st1 && !miss_st1) && !crsq_stall;
	// Trace: ../../rtl/cache/VX_bank.sv:318:5
	VX_pending_size #(.SIZE(MSHR_SIZE)) mshr_pending_size(
		.clk(clk),
		.reset(reset),
		.incr(creq_fire && ~creq_rw),
		.decr(mshr_fire || mshr_release),
		.full(mshr_alm_full)
	);
	// Trace: ../../rtl/cache/VX_bank.sv:330:5
	VX_miss_resrv #(
		.BANK_ID(BANK_ID),
		.CACHE_ID(CACHE_ID),
		.CACHE_LINE_SIZE(CACHE_LINE_SIZE),
		.NUM_BANKS(NUM_BANKS),
		.NUM_PORTS(NUM_PORTS),
		.WORD_SIZE(WORD_SIZE),
		.NUM_REQS(NUM_REQS),
		.MSHR_SIZE(MSHR_SIZE),
		.CORE_TAG_WIDTH(CORE_TAG_WIDTH)
	) miss_resrv(
		.clk(clk),
		.reset(reset),
		.deq_req_id(req_id_sel),
		.lkp_req_id(req_id_st0),
		.rel_req_id(req_id_st1),
		.allocate_valid(mshr_allocate),
		.allocate_addr(addr_st0),
		.allocate_data({wsel_st0, tag_st0, req_tid_st0, pmask_st0}),
		.allocate_id(mshr_alloc_id),
		.lookup_valid(mshr_lookup),
		.lookup_replay(mshr_replay),
		.lookup_id(mshr_alloc_id),
		.lookup_addr(addr_st0),
		.lookup_match(mshr_pending_st0),
		.fill_valid(mem_rsp_fire),
		.fill_id(mem_rsp_id),
		.fill_addr(mem_rsp_addr),
		.dequeue_valid(mshr_valid),
		.dequeue_id(mshr_dequeue_id),
		.dequeue_addr(mshr_addr),
		.dequeue_data({mshr_wsel, mshr_tag, mshr_tid, mshr_pmask}),
		.dequeue_ready(mshr_ready),
		.release_valid(mshr_release),
		.release_id(mshr_id_st1)
	);
	// Trace: ../../rtl/cache/VX_bank.sv:381:5
	wire [NUM_PORTS - 1:0] crsq_pmask;
	// Trace: ../../rtl/cache/VX_bank.sv:382:5
	wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] crsq_data;
	// Trace: ../../rtl/cache/VX_bank.sv:383:5
	wire [(NUM_PORTS * (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1)) - 1:0] crsq_tid;
	// Trace: ../../rtl/cache/VX_bank.sv:384:5
	wire [(NUM_PORTS * CORE_TAG_WIDTH) - 1:0] crsq_tag;
	// Trace: ../../rtl/cache/VX_bank.sv:386:5
	assign crsq_valid = (do_read_st1 && !miss_st1) || do_mshr_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:389:5
	assign crsq_stall = crsq_valid && !crsq_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:391:5
	assign crsq_pmask = pmask_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:392:5
	assign crsq_tid = req_tid_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:393:5
	assign crsq_data = rdata_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:394:5
	assign crsq_tag = tag_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:396:5
	VX_elastic_buffer #(
		.DATAW(NUM_PORTS * (((CORE_TAG_WIDTH + 1) + (8 * WORD_SIZE)) + (NUM_REQS > 1 ? $clog2(NUM_REQS) : 1))),
		.SIZE(CRSQ_SIZE),
		.OUT_REG(1)
	) core_rsp_req(
		.clk(clk),
		.reset(reset),
		.valid_in(crsq_valid),
		.data_in({crsq_tag, crsq_pmask, crsq_data, crsq_tid}),
		.ready_in(crsq_ready),
		.valid_out(core_rsp_valid),
		.data_out({core_rsp_tag, core_rsp_pmask, core_rsp_data, core_rsp_tid}),
		.ready_out(core_rsp_ready)
	);
	// Trace: ../../rtl/cache/VX_bank.sv:413:5
	wire mreq_push;
	wire mreq_pop;
	wire mreq_empty;
	// Trace: ../../rtl/cache/VX_bank.sv:414:5
	wire [(NUM_PORTS * (8 * WORD_SIZE)) - 1:0] mreq_data;
	// Trace: ../../rtl/cache/VX_bank.sv:415:5
	wire [(NUM_PORTS * WORD_SIZE) - 1:0] mreq_byteen;
	// Trace: ../../rtl/cache/VX_bank.sv:416:5
	wire [(NUM_PORTS * WORD_SELECT_BITS) - 1:0] mreq_wsel;
	// Trace: ../../rtl/cache/VX_bank.sv:417:5
	wire [NUM_PORTS - 1:0] mreq_pmask;
	// Trace: ../../rtl/cache/VX_bank.sv:418:5
	wire [((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS)) - 1:0] mreq_addr;
	// Trace: ../../rtl/cache/VX_bank.sv:419:5
	wire [MSHR_ADDR_WIDTH - 1:0] mreq_id;
	// Trace: ../../rtl/cache/VX_bank.sv:420:5
	wire mreq_rw;
	// Trace: ../../rtl/cache/VX_bank.sv:422:5
	assign mreq_push = ((do_read_st1 && miss_st1) && !mshr_pending_st1) || do_write_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:425:5
	assign mreq_pop = mem_req_valid && mem_req_ready;
	// Trace: ../../rtl/cache/VX_bank.sv:427:5
	assign mreq_rw = WRITE_ENABLE && is_write_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:428:5
	assign mreq_addr = addr_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:429:5
	assign mreq_id = mshr_id_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:430:5
	assign mreq_pmask = pmask_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:431:5
	assign mreq_wsel = wsel_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:432:5
	assign mreq_byteen = byteen_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:433:5
	assign mreq_data = creq_data_st1;
	// Trace: ../../rtl/cache/VX_bank.sv:435:5
	VX_fifo_queue #(
		.DATAW(((1 + ((32 - $clog2(CACHE_LINE_SIZE)) - $clog2(NUM_BANKS))) + MSHR_ADDR_WIDTH) + (NUM_PORTS * (((1 + WORD_SIZE) + WORD_SELECT_BITS) + (8 * WORD_SIZE)))),
		.SIZE(MREQ_SIZE),
		.ALM_FULL(MREQ_SIZE - 2),
		.OUT_REG(1 == NUM_BANKS)
	) mem_req_queue(
		.clk(clk),
		.reset(reset),
		.push(mreq_push),
		.pop(mreq_pop),
		.data_in({mreq_rw, mreq_addr, mreq_id, mreq_pmask, mreq_byteen, mreq_wsel, mreq_data}),
		.data_out({mem_req_rw, mem_req_addr, mem_req_id, mem_req_pmask, mem_req_byteen, mem_req_wsel, mem_req_data}),
		.empty(mreq_empty),
		.alm_full(mreq_alm_full)
	);
	// Trace: ../../rtl/cache/VX_bank.sv:454:5
	assign mem_req_valid = !mreq_empty;
endmodule