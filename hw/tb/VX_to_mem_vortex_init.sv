module VX_to_mem_vortex_init(input wire clk, input wire reset);

  Vortex vortex(.clk            (clk),
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

                .busy           (busy));
  
  VX_to_mem_bypass RAM(clk, 
                       reset, 
                       mem_req_valid, 
                       mem_req_ready, 
                       mem_req_rw, 
                       mem_req_addr, 
                       mem_req_tag, 
                       mem_req_data, 
                       mem_rsp_valid, 
                       mem_rsp_data, 
                       mem_rsp_tag, 
                       mem_rsp_ready);
);


endmodule
