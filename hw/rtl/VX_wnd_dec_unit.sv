module VX_wnd_dec_unit (
    input logic reg_offset, 
    // input logic reg_wnd_size,
    input logic reg_wnd_en,
    input logic rs1_i, rs2_i, rs3_i,
    output logic rs1_o, rs2_o, rs3_o
);

//offset = rs1
//size   = rs2 (static for now, lets say 1 byte)

//muxes
rs1_o = reg_wnd_en ?  : rs1_i;
rs2_o = reg_wnd_en ?  : rs2_i;
rs3_o = reg_wnd_en ?  : rs3_i;

//not sure how to address to vector reg file with WarpIDs, working with Zhaoyu on that

//does this need compiler changes? 

// https://docs.google.com/document/d/1ORtKf3I7MQDR89E0QIDPLdhS2ttQoNUf5SxBB3j17Ns/edit

endmodule