// Guillaume Hu - hu724@purdue.edu

//`include "local_mem.vh"
`include "VX_define.vh"

`timescale 1 ps / 1 ps

module VX_local_mem_tb; 

    parameter PERIOD = 2;
    logic clk = 0;
    logic reset; 

    // parameters
    parameter WORD_W = 32;
    parameter DRAM_SIZE = 64;
    parameter RSP_DELAY = 15 * PERIOD; 

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

    // tb signals
    logic                               tb_mem_req_valid;
    logic                               tb_mem_req_rw;    
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    tb_mem_req_byteen;    
    logic [`VX_MEM_ADDR_WIDTH-1:0]      tb_mem_req_addr;
    logic [`VX_MEM_DATA_WIDTH-1:0]      tb_mem_req_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       tb_mem_req_tag;
    // vortex inputs
    logic                               tb_mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                               tb_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      tb_mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       tb_mem_rsp_tag;
    // vortex outputs
    logic                               tb_mem_rsp_ready;

    // Status:
    // vortex outputs
    logic                               tb_busy;

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

    local_mem MEM(.clk(clk), 
                  .reset(reset), 
                  .mem_req_valid(tb_mem_req_valid), 
                  .mem_req_rw(tb_mem_req_rw), 
                  .mem_req_byteen(tb_mem_req_byteen),
                  .mem_req_addr(tb_mem_req_addr), 
                  .mem_req_data(tb_mem_req_data), 
                  .mem_req_tag(tb_mem_req_tag), 
                  //.mem_req_ready(tb_mem_req_ready), // Signal driven in tb -> induce a delay
                  .mem_rsp_valid(tb_mem_rsp_valid), 
                  .mem_rsp_data(tb_mem_rsp_data), 
                  .mem_rsp_tag(tb_mem_rsp_tag), 
                  .mem_rsp_ready(tb_mem_rsp_ready), 
                  .busy(tb_busy), 
                  .tb_addr_out_of_bounds(tb_addr_out_of_bounds)
    ); 

    // assign tb_mem_req_valid = mem_req_valid; 
    // assign tb_mem_req_rw = mem_req_rw; 
    // assign tb_mem_req_byteen = mem_req_byteen; 
    // assign tb_mem_req_addr = mem_req_addr; 
    // assign tb_mem_req_data = mem_req_data; 
    // assign tb_mem_req_tag = mem_req_tag; 
    // assign tb_mem_rsp_ready = mem_rsp_ready; 
    // assign tb_busy = busy; 

    //local_mem MEM(.*); 

    initial begin 
        mem_req_ready = 1'b0; 
        mem_rsp_valid = 1'b0; 
        mem_rsp_data = '0; 
        mem_rsp_tag = '0; 
        reset = 1'b1; 
        // Reset
        #(PERIOD * 12); 
        reset = 1'b0; 

        // Handshake to GPU 
        #(PERIOD); 
        mem_req_ready = 1'b1; 

        forever begin 
            @(posedge mem_req_valid);
            tb_mem_rsp_tag = mem_req_tag; // Buffer the tag and addr
            tb_mem_req_addr = mem_req_addr; 
            tb_mem_req_byteen = mem_req_byteen; 
            tb_mem_req_rw = mem_req_rw; 
            tb_mem_req_data = mem_req_data; 
            tb_mem_rsp_ready = mem_rsp_ready; 
            #(RSP_DELAY);

            // Response to Vortex's request
            tb_mem_req_valid = 1'b1; 
            mem_rsp_valid = 1'b1; 
            mem_rsp_data = tb_mem_rsp_data; 
            mem_rsp_tag = tb_mem_rsp_tag; 
            #(PERIOD); 
            mem_rsp_valid = 1'b0; 
        end  
        
    end

    // Force end of sim
    initial begin 
        #3000; 
        $stop(); 
    end 

    initial begin 

    end 


endmodule 