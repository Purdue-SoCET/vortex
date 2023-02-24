// `include "local_mem.vh"

`timescale 1 ns / 1 ns

module VX_local_mem_tb; 

    parameter PERIOD = 10;
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

    Vortex DUT(.*);
    local_mem MEM(.*); 

    initial begin 
        // Reset
        reset = 1'b1; 
        #(PERIOD); 
        reset = 1'b0; 

        // Start the GPU
        //mem_req_ready = 1'b1; 

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
        #3000; 
        $stop(); 
    end 


endmodule 