`include "VX_define.vh"
//Author of interpolate unit: Raghul Prakash
module VX_interpolate #(  
    parameter CORE_ID = 0
) (
    input wire  clk,
    input wire  reset,    


    // Inputs
    VX_inter_req_if.slave     inter_req_if,
    VX_inter_csr_if.slave     inter_csr_if,

    // Outputs
    VX_inter_rsp_if.master    inter_rsp_if
);

    `UNUSED_PARAM (CORE_ID)

    reg [31:0] inter_operand_a;
    reg [31:0] inter_operand_b;
    reg [31:0] inter_operand_c;

    // CSRs programming

    always @(posedge clk) begin
        if (inter_csr_if.write_enable) begin
            case (inter_csr_if.write_addr)
                `CSR_INTER_A: begin 
                    inter_operand_a <= inter_csr_if.write_data[31:0];
                end
                `CSR_INTER_B: begin 
                    inter_operand_b <= inter_csr_if.write_data[31:0];
                end
                `CSR_INTER_C: begin
                    inter_operand_c <= inter_csr_if.write_data[31:0];
                end
                
            endcase
        end
    end


   //result = ax + by + c 
   always_comb begin
	if (inter_req_if.valid) begin
   		inter_rsp_if.data = inter_operand_a * inter_req_if.x_operand + inter_operand_b * inter_req_if.y_operand + inter_operand_c;
		inter_rsp_if.req_ready = 1;   
		inter_rsp_if.rsp_valid = 1;
		
		inter_rsp_if.uuid = inter_req_if.uuid;
		inter_rsp_if.wid = inter_req_if.uuid;
		inter_rsp_if.tmask = inter_req_if.uuid;
		inter_rsp_if.PC inter_req_if.uuid;
		inter_rsp_if.rd = inter_req_if.uuid; 
		inter_rsp_if.wb = inter_req_if.uuid;
	end
   end





endmodule
