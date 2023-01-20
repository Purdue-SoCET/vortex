`include "VX_tex_define.vh"
//Author: Raghul Prakash, SoCET Vortex GPU Team
module tb_VX_tex_unit();
	

  //clock and reset
  reg clk, reset;

  // Clock generator
  always begin
     #5  clk = ~clk; // Toggle clock every 5 ticks
  end
  

  //Interfaces
  // Texture unit <-> Memory Unit
  VX_dcache_req_if dcache_req_if ();
    
  VX_dcache_rsp_if  dcache_rsp_if ();
    
  // Inputs
  VX_tex_req_if  tex_req_if ();
    
  VX_tex_csr_if  tex_csr_if ();
    
  // Outputs
  VX_tex_rsp_if  tex_rsp_if ();
  
  // Connect DUT to test bench
  VX_tex_unit tex_unit (
    clk,
    reset,
    dcache_req_if, dcache_rsp_if,
    tex_req_if, tex_csr_if,
    tex_rsp_if
  );


    //VX_tex_req_if   tex_req_if;
    //VX_tex_rsp_if   tex_rsp_if;    

    //wire is_tex = (gpu_req_if.op_type == `INST_GPU_TEX);



    //assign tex_rsp_if.ready = !stall_out;

    //assign stall_in = (is_tex && ~tex_req_if.ready)
    //               || (~is_tex && (tex_rsp_if.valid || stall_out));

    //assign is_warp_ctl = !(is_tex || tex_rsp_if.valid);

    //assign rsp_valid = tex_rsp_if.valid || (gpu_req_if.valid && ~is_tex);
    //assign rsp_uuid  = tex_rsp_if.valid ? tex_rsp_if.uuid : gpu_req_if.uuid;
    //assign rsp_wid   = tex_rsp_if.valid ? tex_rsp_if.wid : gpu_req_if.wid;
    //assign rsp_tmask = tex_rsp_if.valid ? tex_rsp_if.tmask : gpu_req_if.tmask;
    //assign rsp_PC    = tex_rsp_if.valid ? tex_rsp_if.PC : gpu_req_if.PC;
    //assign rsp_rd    = tex_rsp_if.rd;
    //assign rsp_wb    = tex_rsp_if.valid && tex_rsp_if.wb;
    //assign rsp_data  = tex_rsp_if.valid ? RSP_DATAW'(tex_rsp_if.data) : RSP_DATAW'(warp_ctl_data);

  // Initialize all variables
  initial begin

    clk = 1;       // initial value of clock
    reset = 0;       // initial value of reset
    #5  
    //write using valid ready protocol to write to registers in tex unit
    //tex_csr_if.write_enable = 1'b1;
    //tex_csr_if.write_addr = `CSR_TEX_ADDR;
    #10 
      // request from texture unit
/*
     tex_req_if.valid = gpu_req_if.valid && is_tex;
     tex_req_if.uuid  = gpu_req_if.uuid;
     tex_req_if.wid   = gpu_req_if.wid;
     tex_req_if.tmask = gpu_req_if.tmask;
     tex_req_if.PC    = gpu_req_if.PC;
     tex_req_if.rd    = gpu_req_if.rd;
     tex_req_if.wb    = gpu_req_if.wb;
    
     tex_req_if.unit      = gpu_req_if.op_mod[`NTEX_BITS-1:0];
     tex_req_if.coords[0] = gpu_req_if.rs1_data;
     tex_req_if.coords[1] = gpu_req_if.rs2_data;
     tex_req_if.lod       = gpu_req_if.rs3_data;        
*/
    reset = 1;    // Assert the reset 
    reset = 0;   // De-assert the reset
    #5  
    $finish;      // Terminate simulation
  end



endmodule
