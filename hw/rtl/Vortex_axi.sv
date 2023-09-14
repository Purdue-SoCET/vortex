`include "VX_define.vh"

module Vortex_axi #(
    parameter AXI_DATA_WIDTH   = `VX_MEM_DATA_WIDTH, 
    parameter AXI_ADDR_WIDTH   = 32,
    parameter AXI_TID_WIDTH    = `VX_MEM_TAG_WIDTH,    
    parameter AXI_STROBE_WIDTH = (`VX_MEM_DATA_WIDTH / 8)
)(
    // Clock
    input  logic                         clk,
    input  logic                         reset,

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
    
    // AXI read request channel
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
    output logic                         m_axi_rready,

    // Status
    output logic                         busy
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

    VX_axi_adapter #(
        .VX_DATA_WIDTH    (`VX_MEM_DATA_WIDTH), 
        .VX_ADDR_WIDTH    (`VX_MEM_ADDR_WIDTH),            
        .VX_TAG_WIDTH     (`VX_MEM_TAG_WIDTH),
        .VX_BYTEEN_WIDTH  (AXI_STROBE_WIDTH),
        .AXI_DATA_WIDTH   (AXI_DATA_WIDTH), 
        .AXI_ADDR_WIDTH   (AXI_ADDR_WIDTH),
        .AXI_TID_WIDTH    (AXI_TID_WIDTH),  
        .AXI_STROBE_WIDTH (AXI_STROBE_WIDTH)
    ) axi_adapter (
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
        
        .m_axi_awid     (m_axi_awid),
        .m_axi_awaddr   (m_axi_awaddr),
        .m_axi_awlen    (m_axi_awlen),
        .m_axi_awsize   (m_axi_awsize),
        .m_axi_awburst  (m_axi_awburst),  
        .m_axi_awlock   (m_axi_awlock),    
        .m_axi_awcache  (m_axi_awcache),
        .m_axi_awprot   (m_axi_awprot),        
        .m_axi_awqos    (m_axi_awqos),  
        .m_axi_awvalid  (m_axi_awvalid),
        .m_axi_awready  (m_axi_awready),

        .m_axi_wdata    (m_axi_wdata),
        .m_axi_wstrb    (m_axi_wstrb),
        .m_axi_wlast    (m_axi_wlast),
        .m_axi_wvalid   (m_axi_wvalid),
        .m_axi_wready   (m_axi_wready),

        .m_axi_bid      (m_axi_bid),
        .m_axi_bresp    (m_axi_bresp),
        .m_axi_bvalid   (m_axi_bvalid),
        .m_axi_bready   (m_axi_bready),
        
        .m_axi_arid     (m_axi_arid),
        .m_axi_araddr   (m_axi_araddr),
        .m_axi_arlen    (m_axi_arlen),
        .m_axi_arsize   (m_axi_arsize),
        .m_axi_arburst  (m_axi_arburst), 
        .m_axi_arlock   (m_axi_arlock),    
        .m_axi_arcache  (m_axi_arcache),
        .m_axi_arprot   (m_axi_arprot),        
        .m_axi_arqos    (m_axi_arqos),
        .m_axi_arvalid  (m_axi_arvalid),
        .m_axi_arready  (m_axi_arready),
        
        .m_axi_rid      (m_axi_rid),
        .m_axi_rdata    (m_axi_rdata),
        .m_axi_rresp    (m_axi_rresp),
        .m_axi_rlast    (m_axi_rlast),
        .m_axi_rvalid   (m_axi_rvalid),
        .m_axi_rready   (m_axi_rready)
    );
    
    Vortex vortex (
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