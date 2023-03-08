// Guillaume Hu - hu724@purdue.edu

// `include "local_mem.vh"
`include "VX_define.vh"

`timescale 1 ns / 1 ns

module VX_local_mem_tb; 

    parameter PERIOD = 2;
    logic clk = 0;
    logic reset; 

    // parameters
    parameter WORD_W = 32;
    parameter DRAM_SIZE = 64;

    // clock gen
    always #(PERIOD/2) clk = ~clk;

    // memory interfacing signals:

    // Memory request:
    // vortex outputs
    logic                               mem_req_valid;
    logic                               mem_req_rw;    
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    mem_req_byteen;    
    logic [`VX_MEM_ADDR_WIDTH-1:0]      mem_req_addr;
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_req_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_req_tag;
    // vortex inputs
    logic                               mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                               mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_rsp_tag;
    // vortex outputs
    logic                               mem_rsp_ready;

    // Status:
    // vortex outputs
    logic                               busy;

    // tb
    logic                             tb_addr_out_of_bounds; 

    Vortex DUT(.clk(clk),
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
    local_mem MEM(.*); 

    initial begin 
        // mem_req_ready = 1'b0; 
        // mem_rsp_valid = 1'b0; 
        // mem_rsp_data = '0; 
        // mem_rsp_tag = '0;
         
        reset = 1'b1; 
        // Reset
        #(PERIOD * 13); 
        reset = 1'b0; 

        @(negedge reset); 

        // Handshake to GPU
        // mem_req_ready = 1'b1; 

        //$display("`VX_MEM_BYTEEN_WIDTH is %d, in VX it is: %d", `VX_MEM_BYTEEN_WIDTH, DUT.)

        // @(DUT.mem_rsp_ready) begin 
        // //@(posedge DUT.mem_req_valid); 
        // $display("Resp ready to be received by VX"); 
        // mem_rsp_valid = 1'b1; 
        // mem_rsp_data = 32'h6F008004; 
        // mem_rsp_tag = 0; 

        // if (DUT.genblk1[0].cluster.genblk1[0].core.mem_unit.icache.NC_ENABLE) begin 
        //     $display("NC is enabled"); 
        // end 
        //end

        //$stop; 

        // forever begin 
        //     @(posedge DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_req_if.valid); 
        //     $info("VX assert mem I-fetch request at PC: %h", DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_req_if.PC);
        //     #(clk); 
        //     //@(posedge mem_rsp_ready); 
        //     DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_rsp_if.valid <= 1'b0;
        //     DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_rsp_if.uuid <= DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_req_if.uuid;
        //     DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_rsp_if.tmask <= DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_req_if.tmask;
        //     DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_rsp_if.wid <= DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_req_if.wid;
        //     DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_rsp_if.PC <= DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_req_if.PC;     
        //     DUT.genblk1[0].cluster.genblk1[0].core.pipeline.fetch.icache_stage.ifetch_rsp_if.data <= 32'h6F008004; 
        //     $info("Memory provided: %h", mem_rsp_data);  
        // end 
    end

    // Force end of sim
    initial begin 
        #30000; 
        $stop(); 
    end 


endmodule 