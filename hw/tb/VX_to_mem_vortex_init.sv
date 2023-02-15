//socet 33: Raghul 
module VX_to_mem_vortex_init(input wire clk, input wire reset);

  wire vx_mem_req_valid, 
  wire vx_mem_req_ready; 
  wire vx_mem_req_rw; 
  wire vx_mem_req_addr; 
  wire vx_mem_req_tag; 
  wire vx_mem_req_data; 
  wire vx_mem_rsp_valid; 
  wire vx_mem_rsp_data; 
  wire vx_mem_rsp_tag;
  wire vx_mem_rsp_ready;
  
  Vortex vortex(.clk            (clk),
                .reset          (reset),

                .mem_req_valid  (vx_mem_req_valid),
                .mem_req_rw     (vx_mem_req_rw),
                .mem_req_byteen (vx_mem_req_byteen),
                .mem_req_addr   (vx_mem_req_addr),
                .mem_req_data   (vx_mem_req_data),
                .mem_req_tag    (vx_mem_req_tag),
                .mem_req_ready  (vx_mem_req_ready),

                .mem_rsp_valid  (vx_mem_rsp_valid),
                .mem_rsp_data   (vx_mem_rsp_data),
                .mem_rsp_tag    (vx_mem_rsp_tag),
                .mem_rsp_ready  (vx_mem_rsp_ready),

                .busy           (busy));
  
  VX_to_mem_bypass RAM( .clk(clk), 
                        .reset(reset), 
                        .mem_req_valid  (vx_mem_req_valid),
                        .mem_req_rw     (vx_mem_req_rw),
                        .mem_req_byteen (vx_mem_req_byteen),
                        .mem_req_addr   (vx_mem_req_addr),
                        .mem_req_data   (vx_mem_req_data),
                        .mem_req_tag    (vx_mem_req_tag),
                        .mem_req_ready  (vx_mem_req_ready),

                        .mem_rsp_valid  (vx_mem_rsp_valid),
                        .mem_rsp_data   (vx_mem_rsp_data),
                        .mem_rsp_tag    (vx_mem_rsp_tag),
                        .mem_rsp_ready  (vx_mem_rsp_ready));


endmodule
