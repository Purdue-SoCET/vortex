module VX_wnd_dec_unit
#(
// NUM_REGS
// NUM_WARPS
// n_windows, dictates size of windows, does NUM_REGS / 
    parameter NUM_REGS      = 192, // inheret these
    parameter NUM_WARPS     = 4,   // inheret these
    parameter n_windows     = 4,   //each warp assigned 48 registers, windowed 4 times, that means, lowest 4 g
    parameter n_global_regs = 4,  //manually set or do auto calculation before
    parameter n_local_regs  = 4,
    parameter n_in_regs     = 4,
    parameter n_out_regs    = 4
) (
    input logic CLK, nRST,
    input logic save, restore,
    input logic [$clog2(NUM_WARPS) - 1:0] wid,
    input logic [$clog2(NUM_REGS)-1:0] rs1_i, rs2_i, rd_i,
    // output logic deschedule, //this goes to the warp_sched //also I have no idea how to implement this within the actual GPU
    output logic [$clog2(NUM_REGS)-1:0] rs1_o, rs2_o, rd_o
);

// does actually require some psuedoinstructions to be created within function calls due to save and restore requirements

logic [$clog2(n_windows)-1:0] CWP, next_CWP,
                    SWP, next_SWP; //if saving last CWP to memory, use stack window ptr
logic [NUM_WARPS - 1:0][$clog2(n_windows)-1:0] CWP_map, next_CWP_map;

// making the assumption that each category of registers are constant and equal
// total_regs (per core) / n_warps (each warp gets its own registers) / n_windows (split it between the windows)
// logic [n_windows:0] n_global_regs,
//                     n_local_regs,
//                     n_in_regs,
//                     n_out_regs;

// always_comb begin : declare_window_sizes
//     n_global_regs = 
// end

// predetermine the registers,
// each iterative CWP should offset by greater amounts, default offset based on number of global registers

always_comb begin : offset_calculation_block
    next_CWP_map = CWP_map;
    // next_SWP = SWP;
    if(save) begin // we do not care about overflow/underflow as implementation of these windows can be made circular (i.e. restore at CWP 4 (if 4 was max) would restult in next CWP = 0)
        next_CWP_map[wid] = CWP_map[wid] - 1;
        // next_SWP = CWP;
    end
    if(restore) begin
        next_CWP_map[wid] = CWP_map[wid] + 1;
        // next_SWP = CWP;
    end
    
    // calculate the registers based on CWP

    // layout global registers as always ground to r0
    if (rs1_i >= 0 | rs1_i < n_global_regs) begin
        rs1_o = rs1_i;
    end else begin // if not addressing global registers, offset off of global registers || assuming uniformity for now
        rs1_o = rs1_i + (CWP_map[wid] * n_global_regs * 2);
    end

    if (rs2_i >= 0 | rs2_i < n_global_regs) begin
        rs2_o = rs2_i + (CWP_map[wid] * n_global_regs * 2);
    end else begin 
        rs2_o = rs2_i + (CWP_map[wid] * n_global_regs * 2);
    end

    if (rd_i >= 0 | rd_i < n_global_regs) begin
        rd_o = rd_i + (CWP_map[wid] * n_global_regs * 2);
    end else begin 
        rd_o = rd_i + (CWP_map[wid] * n_global_regs * 2);
    end
end

always_ff @ (posedge CLK, negedge nRST) begin
    if(~nRST) begin
        CWP_map <= '0;
        // SWP <= 0;
    end else begin
        CWP_map <= next_CWP_map;
        // SWP <= next_SWP;
    end
end

// Notes:
// need to redefine the stackpointer and frame pointer every time window changes...


// Gdoc for Questions: https://docs.google.com/document/d/1ORtKf3I7MQDR89E0QIDPLdhS2ttQoNUf5SxBB3j17Ns/edit
// Gdoc for psudocode: https://docs.google.com/document/d/1wMDKfh24dMHNgilFOCy2GET8NrVlFINnr3iEOmQ3SVE/edit
endmodule