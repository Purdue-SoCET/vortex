    // mapped needs this
    // `include "register_file_if.vh"

    // mapped timing needs this. 1ns is too fast
    `timescale 1 ns / 1 ns

    module VX_wnd_dec_unit_tb;

    parameter PERIOD        = 10;
    parameter NUM_REGS      = 192;
    parameter NUM_WARPS     = 4;   
    parameter n_windows     = 4;   
    parameter n_global_regs = 4;  
    parameter n_local_regs  = 4;
    parameter n_in_regs     = 4;
    parameter n_out_regs    = 4;

    logic CLK = 0, nRST;
    logic save, restore;
    logic [1:0] wid;
    logic [$clog2(NUM_REGS) - 1:0] rs1_i, rs2_i, rd_i;
    logic [$clog2(NUM_REGS) - 1:0] rs1_o, rs2_o, rd_o;

    // clock
    always #(PERIOD/2) CLK++;

    // test program
    test PROG (CLK, nRST,
        save, restore, wid,
        rs1_i, rs2_i, rd_i,
        rs1_o, rs2_o, rd_o
    );

    // DUT
    // `ifndef MAPPED
    VX_wnd_dec_unit #(
        .NUM_REGS(NUM_REGS),
        .NUM_WARPS(NUM_WARPS),  
        .n_windows(n_windows),
        .n_global_regs(n_global_regs),  
        .n_local_regs(n_local_regs),
        .n_in_regs(n_in_regs),
        .n_out_regs(n_out_regs)
    ) DUT (
        CLK, nRST,
        save, restore, wid,
        rs1_i, rs2_i, rd_i,
        rs1_o, rs2_o, rd_o
    );
    
    endmodule

    program test (
        input logic CLK,
        output logic nRST,
        //signals to VX_wnd_dec_unit.sv
        output logic save, restore,
        output logic [1:0] wid,
        output logic [8 - 1:0] rs1_i, rs2_i, rd_i,
        input logic [8 - 1:0] rs1_o, rs2_o, rd_o
    );

    // test case signals
    // parameter NUM_REGS      = 192;
    // parameter NUM_WARPS     = 4;   
    // parameter n_windows     = 4;   
    // parameter n_global_regs = 4;  
    // parameter n_local_regs  = 4;
    // parameter n_in_regs     = 4;
    // parameter n_out_regs    = 4;
    parameter PERIOD = 10; 
    integer tb_test_num;
    string  tb_test_case;

    task reset_dut;
        begin
        // Activate the reset
        nRST = 1'b0;
        save = 0;
        restore = 0;
        rs1_i = 0;
        rs2_i = 0;
        rd_i = 0;
        wid = 0;

        // Maintain the reset for more than one cycle
        #(PERIOD);

        // Wait until safely away from rising edge of the clock before releasing
        #(PERIOD);
        nRST = 1'b1;

        // Leave out of reset for a couple cycles before allowing other stimulus
        // Wait for negative clock edges, 
        // since inputs to DUT should normally be applied away from rising clock edges
        #(PERIOD);
        end
    endtask

    initial begin

        //initialize all signals
        tb_test_num = 0;
        nRST = 1'b0;
        save = 0;
        restore = 0;
        rs1_i = 0;
        rs2_i = 0;
        rd_i = 0;
        wid = 0;
        
        // ************************************************************************
        // Test Case 1: Test Reset
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Test Reset";
        #(0.1);
        // reset
        nRST = 1'b0;
        // Check that CWP zeros and holds at zero, and input register addresses are correctly bound to not window.
        save = 1;
        restore = 0;
        rs1_i = 8'h3;
        rs2_i = 8'h4;
        rd_i = 8'h7;
        #(PERIOD);
        restore = 1;
        save = 0;
        #(PERIOD);
        restore = 0;
        nRST = 1'b1;
        #(PERIOD);
        // check wave to ensure that CWP is still at 0 and rs1_o, rs2_o, and rd_o are 3, 4, and 7 respectively

        // ************************************************************************
        // Test Case 2: CWP = 0
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "CWP = 0";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        reset_dut();
        rs1_i = 8'h3;
        rs2_i = 8'h4;
        rd_i = 8'h7;
        #(PERIOD);
        restore = 0;
        #(PERIOD);
        // rs1_o, rs2_o, and rd_o are 3, 4, and 7 respectively
        tb_test_case = "CWP = 0, wid = 1";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        wid = 1;
        #(PERIOD);
        // rs1_o, rs2_o, and rd_o are 3, 4, and 7 respectively
        #(PERIOD);
        #(PERIOD);
        #(PERIOD);
       

        // ************************************************************************
        // Test Case 3: CWP = 1
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "CWP = 1, check global registers 3";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        reset_dut();
        rs1_i = 8'h3;
        rs2_i = 8'h4;
        rd_i = 8'h7;
        #(PERIOD);
        restore = 1;
        #(PERIOD);
        restore = 0;
        #(PERIOD);
        // rs1_o, rs2_o, and rd_o are 3, 16, and 19
        // rs1_o, rs2_o, and rd_o are 3, 4, and 7 respectively
        tb_test_case = "CWP = 0 (wid 0), wid = 1";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        wid = 1;
        #(PERIOD);
        // rs1_o, rs2_o, and rd_o are 3, 4, and 7 respectively
        #(PERIOD);
        #(PERIOD);
        #(PERIOD);

        // ************************************************************************
        // Test Case 4: Overflow Window Case
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Overflow Window Case";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        reset_dut();
        rs1_i = 8'h3;
        rs2_i = 8'h4;
        rd_i = 8'h7;
        #(PERIOD)
        restore = 1;
        #(PERIOD);
        #(PERIOD);
        #(PERIOD);
        #(PERIOD);
        restore = 0;
        // rs1_o, rs2_o, and rd_o are 3, 4, and 7
        #(PERIOD);

        // ************************************************************************
        // Test Case 5: Underflow Window Case
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Underflow Window case";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        reset_dut();
        rs1_i = 8'h3;
        rs2_i = 8'h4;
        rd_i = 8'h7;
        #(PERIOD)
        save = 1;
        #(PERIOD);
        save = 0;
        // rs1_o, rs2_o, and rd_o are 3, 0x1c, and 0x1f
        #(PERIOD);
        $finish;
    end
    endprogram