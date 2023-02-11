/*
    socet115 / zlagpaca@purdue.edu

    module for faking DRAM/SRAM with basic register file
*/

module ram_fake_reg_file #(
    parameter WORD_W = 32;
    parameter DRAM_SIZE = 64;
)(
    // seq
    input clk, reset,

    // write handshaking
    input logic                 w_req,
    input logic [WORD_W-1:0]    w_addr,
    input logic [WORD_W-1:0]    w_data_in,
    output logic                w_resp,

    // read handshaking
    input logic                 r_req,
    input logic [WORD_W-1:0]    r_addr,
    output logic [WORD_W-1:0]   r_data_out,
    output logic                r_resp
);
    // register logic:
    logic [WORD_W-1:0] ff_out, next_ff_out [DRAM_SIZE-1:0];
    always_ff @ (posedge clk) begin : REGISTER_LOGIC
        // sync, active high reset
        if (reset)
        begin
            // can load initial instructions and data here
            ff_out <= '{DRAM_SIZE{WORD_W'h0}};

            // ff_out[0] <= <INSTR_1>;
            // ff_out[1] <= <INSTR_2>;
            // ...
        end
        else
        begin
            ff_out <= next_ff_out;
        end
    end

    // output logic:

    // write logic:
    logic next_w_resp;
    // delay resp to req by 1 clk to ensure write on posedge
    always_ff @ (posedge clk) begin : WRITE_REG_LOGIC
        if (reset)
            w_resp <= 1'b0;
        else
            w_resp <= next_w_resp;
    end
    always_comb begin : WRITE_LOGIC
        next_w_resp = w_req;
        // write to w_addr index of reg file
        next_ff_out = ff_out;
        if (w_req)  
            next_ff_out[w_addr] = w_data_in;
    end

    // read logic:
    always_comb begin : READ_LOGIC
        // immediately resp to req
        r_resp = r_req;
        // read from r_addr index of reg file
        r_data_out = ff_out[r_addr];
    end

endmodule
