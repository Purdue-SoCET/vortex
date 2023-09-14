`include "VX_define.vh"

module VX_axi_adapter #(
    parameter VX_DATA_WIDTH    = 512, 
    parameter VX_ADDR_WIDTH    = (32 - $clog2(VX_DATA_WIDTH/8)),            
    parameter VX_TAG_WIDTH     = 8,
    parameter AXI_DATA_WIDTH   = VX_DATA_WIDTH, 
    parameter AXI_ADDR_WIDTH   = 32,
    parameter AXI_TID_WIDTH    = VX_TAG_WIDTH,
    
    parameter VX_BYTEEN_WIDTH  = (VX_DATA_WIDTH / 8),
    parameter AXI_STROBE_WIDTH = (AXI_DATA_WIDTH / 8)
) (
    input  logic                         clk,
    input  logic                         reset,

    // Vortex request
    input logic                          mem_req_valid,
    input logic                          mem_req_rw,
    input logic [VX_BYTEEN_WIDTH-1:0]    mem_req_byteen,
    input logic [VX_ADDR_WIDTH-1:0]      mem_req_addr,
    input logic [VX_DATA_WIDTH-1:0]      mem_req_data,
    input logic [VX_TAG_WIDTH-1:0]       mem_req_tag,

    // Vortex response
    input logic                          mem_rsp_ready,
    output logic                         mem_rsp_valid,        
    output logic [VX_DATA_WIDTH-1:0]     mem_rsp_data,
    output logic [VX_TAG_WIDTH-1:0]      mem_rsp_tag,
    output logic                         mem_req_ready,

    // AXI write request address channel    
    output logic [AXI_TID_WIDTH-1:0]     m_axi_awid,
    output logic [AXI_ADDR_WIDTH-1:0]    m_axi_awaddr,
    output logic [7:0]                   m_axi_awlen,
    output logic [2:0]                   m_axi_awsize,
    output logic [1:0]                   m_axi_awburst,
    output logic                         m_axi_awlock,    
    output logic [3:0]                   m_axi_awcache,
    output logic [2:0]                   m_axi_awprot,        
    output logic [3:0]                   m_axi_awqos,
    output logic                         m_axi_awvalid,
    input logic                          m_axi_awready,

    // AXI write request data channel     
    output logic [AXI_DATA_WIDTH-1:0]    m_axi_wdata,
    output logic [AXI_STROBE_WIDTH-1:0]  m_axi_wstrb,    
    output logic                         m_axi_wlast,  
    output logic                         m_axi_wvalid, 
    input logic                          m_axi_wready,

    // AXI write response channel
    input logic [AXI_TID_WIDTH-1:0]      m_axi_bid,
    input logic [1:0]                    m_axi_bresp,  
    input logic                          m_axi_bvalid,
    output logic                         m_axi_bready,
    
    // AXI read address channel
    output logic [AXI_TID_WIDTH-1:0]     m_axi_arid,
    output logic [AXI_ADDR_WIDTH-1:0]    m_axi_araddr,
    output logic [7:0]                   m_axi_arlen,
    output logic [2:0]                   m_axi_arsize,
    output logic [1:0]                   m_axi_arburst,    
    output logic                         m_axi_arlock,    
    output logic [3:0]                   m_axi_arcache,
    output logic [2:0]                   m_axi_arprot,        
    output logic [3:0]                   m_axi_arqos, 
    output logic                         m_axi_arvalid,
    input logic                          m_axi_arready,
    
    // AXI read response channel
    input logic [AXI_TID_WIDTH-1:0]      m_axi_rid,
    input logic [AXI_DATA_WIDTH-1:0]     m_axi_rdata,  
    input logic [1:0]                    m_axi_rresp,
    input logic                          m_axi_rlast,
    input logic                          m_axi_rvalid,
    output logic                         m_axi_rready
);
    localparam AXSIZE = $clog2(VX_DATA_WIDTH/8);

    `STATIC_ASSERT((AXI_DATA_WIDTH == VX_DATA_WIDTH), ("invalid parameter"))
    `STATIC_ASSERT((AXI_TID_WIDTH == VX_TAG_WIDTH), ("invalid parameter"))

    //`UNUSED_VAR ()

    reg awvalid_ack;
    reg wvalid_ack;

    logic mem_req_fire = mem_req_valid && mem_req_ready;

    always @(posedge clk) begin
		if (reset) begin
			awvalid_ack <= 0;
            wvalid_ack  <= 0;
		end else begin			
            if (mem_req_fire) begin
                awvalid_ack <= 0;
                wvalid_ack  <= 0;
            end else begin
                awvalid_ack <= m_axi_awvalid && m_axi_awready;
                wvalid_ack  <= m_axi_wvalid && m_axi_wready;
            end
		end
	end

    logic axi_write_ready = (m_axi_awready || awvalid_ack) && (m_axi_wready || wvalid_ack);

    // AXI write request address channel        
    assign m_axi_awvalid    = mem_req_valid && mem_req_rw && !awvalid_ack;
    assign m_axi_awid       = mem_req_tag;
    assign m_axi_awaddr     = AXI_ADDR_WIDTH'(mem_req_addr) << AXSIZE;
    assign m_axi_awlen      = 8'b00000000;    
    assign m_axi_awsize     = 3'(AXSIZE);
    assign m_axi_awburst    = 2'b00;    
    assign m_axi_awlock     = 1'b0;    
    assign m_axi_awcache    = 4'b0;
    assign m_axi_awprot     = 3'b0;
    assign m_axi_awqos      = 4'b0;

    // AXI write request data channel        
    assign m_axi_wvalid     = mem_req_valid && mem_req_rw && !wvalid_ack;
    assign m_axi_wdata      = mem_req_data;
    assign m_axi_wstrb      = mem_req_byteen;
    assign m_axi_wlast      = 1'b1;

    // AXI write response channel
    `UNUSED_VAR (m_axi_bid);
    `RUNTIME_ASSERT(~m_axi_bvalid || m_axi_bresp == 0, ("%t: *** AXI response error", $time));
    assign m_axi_bready     = 1'b1;

    // AXI read request channel
    assign m_axi_arvalid    = mem_req_valid && !mem_req_rw;
    assign m_axi_arid       = mem_req_tag;
    assign m_axi_araddr     = AXI_ADDR_WIDTH'(mem_req_addr) << AXSIZE;
    assign m_axi_arlen      = 8'b00000000;
    assign m_axi_arsize     = 3'(AXSIZE);
    assign m_axi_arburst    = 2'b00;  
    assign m_axi_arlock     = 1'b0;    
    assign m_axi_arcache    = 4'b0;
    assign m_axi_arprot     = 3'b0;
    assign m_axi_arqos      = 4'b0;

    // AXI read response channel    
    assign mem_rsp_valid    = m_axi_rvalid;
    assign mem_rsp_tag      = m_axi_rid;
    assign mem_rsp_data     = m_axi_rdata;
    `RUNTIME_ASSERT(~m_axi_rvalid || m_axi_rresp == 0, ("%t: *** AXI response error", $time));
    `UNUSED_VAR (m_axi_rlast);
    assign m_axi_rready     = mem_rsp_ready;

    // Vortex request ack
	assign mem_req_ready    = mem_req_rw ? axi_write_ready : m_axi_arready;

endmodule