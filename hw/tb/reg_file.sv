/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    module for single basic r/w register file
*/

module reg_file #(
    parameter WORD_W = 32,
    parameter NUM_WORDS = 32,
    parameter SEL_W = 5,
    parameter [(WORD_W * NUM_WORDS)-1:0] RESET_WORDS
)(
    // seq
    input clk, reset,

    // write
    input wen,
    input [SEL_W-1:0] wsel,
    input [WORD_W-1:0] wdata,

    // read
    input [SEL_W-1:0] rsel,
    output logic [WORD_W-1:0] rdata
);
    // internal signals
    logic [WORD_W-1:0] reg_val, next_reg_val [NUM_WORDS-1:0];

    // register logic
    always_ff @ (posedge clk) begin : REGISTER_LOGIC
        // synchronous active high reset
        if (reset)
        begin
            for (int i = 0; i < NUM_WORDS; i++)
            begin
                reg_val[i] <= RESET_WORDS[i];
            end
        end
        else
        begin
            for (int i = 0; i < NUM_WORDS; i++)
            begin
                reg_val[i] <= next_reg_val[i];
            end
        end
    end

    // write logic
    always_comb begin : WRITE_LOGIC
        // hold reg val by default
        for (int i = 0; i < NUM_WORDS; i++)
        begin
            next_reg_val[i] = reg_val[i];
        end

        // update reg val at wsel if wen
        if (wen)
            next_reg_val[wsel] = wdata;
    end

    // read logic
    always_comb begin : READ_LOGIC
        // read val at rsel
        rdata = reg_val[rsel];
    end


endmodule