module VX_wnd_dec_unit (
    input logic reg_offset, 
    // input logic reg_wnd_size,
    input logic reg_wnd_en,
    input logic rs1_i, rs2_i, rs3_i,
    output logic rs1_o, rs2_o, rs3_o
);


// 2^N vectore registers
// 2^W warps
// 2^O as window size ("in" + "local")
logic [2^W-1:0][N-W-O-1:0] CWP, CWP_nxt;

typedef struct packed {
    idle, newptr, restore
} wnd_state;

wnd_state state, state_next;
logic [31:0] CWP_buff

always_comb begin
    casez (state)
        idle: begin
            // pass through signals
        end
        newptr: begin
            // if we get a function call, start windowing
            if (another_window)
                CWP_buff[top_of_CWP_buff] = offset;

            if (end_of_func)
                state_next = restore;

            //use this to create an LIFO (stack) of pointers to define the offset from the 

        end
        restore: begin
            // if end of func go to idle

        end
    endcase

end
//function call wind from r3 (r4)
    //function call  r7 r8 

// r1 r2 r3  r4  r5 r6 r7  r8
//       wr1 wr2       wr3 wr4

always_ff begin
    if(!nRST) begin
        state = idle;
    end else begin 
        state = state_next;
    end

end

//offset = rs1
//size   = rs2 (static for now, lets say 1 byte)

//muxes 
always_comb begin
    rs1_o = reg_wnd_en ?  : rs1_i;
    rs2_o = reg_wnd_en ?  : rs2_i;
    rs3_o = reg_wnd_en ?  : rs3_i;
end

// Questions:

// not sure how to address to vector reg file with WarpIDs, working with Zhaoyu on that

// does this need compiler changes? Like if we were to compile code with function calls do we want to
// have new functions for JAL like JALW (jump-and-link-window) or BW 

// Gdoc for Questions: https://docs.google.com/document/d/1ORtKf3I7MQDR89E0QIDPLdhS2ttQoNUf5SxBB3j17Ns/edit
// Gdoc for psudocode: https://docs.google.com/document/d/1wMDKfh24dMHNgilFOCy2GET8NrVlFINnr3iEOmQ3SVE/edit
endmodule