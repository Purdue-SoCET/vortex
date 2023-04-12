    // mapped needs this
    // `include "register_file_if.vh"

    // mapped timing needs this. 1ns is too fast
    `timescale 1 ns / 1 ns

    module VX_wnd_dec_unit_tb;

    parameter PERIOD = 10;
    parameter N = 8:
    parameter W = 2,
    parameter R = 5,
    parameter O = 20

    logic CLK = 0, nRST;

    // clock
    always #(PERIOD/2) CLK++;

    // test program
    test PROG (CLK, nRST,
        save, restore,
        [W-1:0] warp_id,
        [R-1:0] rs1, rs2, rd,
        deschedule, //this goes to the warp_sched
        [N-W-1:0] rs1_o, rs2_o, rd_o
    );

    // DUT
    // `ifndef MAPPED
    wnd_decode_ctrl #(
        .N(N), 
        .W(W), 
        .R(R), 
        .O(O)
    ) DUT (
        CLK, nRST, 
        save, restore,
        [W-1:0] warp_id,
        [R-1:0] rs1, rs2, rd,
        deschedule, //this goes to the warp_sched
        [N-W-1:0] rs1_o, rs2_o, rd_o
    );
    // `else
    //   register_file DUT(
    //     .\rfif.rdat2 (rfif.rdat2),
    //     .\rfif.rdat1 (rfif.rdat1),
    //     .\rfif.wdat (rfif.wdat),
    //     .\rfif.rsel2 (rfif.rsel2),
    //     .\rfif.rsel1 (rfif.rsel1),
    //     .\rfif.wsel (rfif.wsel),
    //     .\rfif.WEN (rfif.WEN),
    //     .\nRST (nRST),
    //     .\CLK (CLK)
    //   );
    // `endif

    endmodule

    program test (
    input logic CLK,
    output logic nRST,
    //signals to VX_wnd_dec_unit.sv
    output logic save, restore,
    output logic [W-1:0] warp_id,
    output logic [R-1:0] rs1, rs2, rd,
    input logic deschedule, //this goes to the warp_sched
    input logic [N-W-1:0] rs1_o, rs2_o, rd_o
    );

    // test case signals
    localparam MAX_VAL = ~(32'b0);
    localparam MIN_VAL =   32'b0;
    parameter PERIOD = 10; 
    integer tb_test_num;
    string  tb_test_case;
    logic   tb_expected_ouput;

    task reset_dut;
        begin
        // Activate the reset
        nRST = 1'b0;
        rfif.wsel = 0;
        rfif.wdat = '0;
        rfif.WEN = 0;
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

    task check_rdat1;
        input string check_tag;
        begin
        if(tb_expected_ouput == rfif.rdat1) begin // Check passed
            $info("Correct output %s during %s test case", check_tag, tb_test_case);
        end
        else begin // Check failed
            $error("Incorrect output %s during %s test case", check_tag, tb_test_case);
        end

        // Wait some small amount of time so check pulse timing is visible on waves
        #(0.1);
        end
    endtask

    task check_rdat2;
        input string check_tag;
        begin
        if(tb_expected_ouput == rfif.rdat2) begin // Check passed
        $info("Correct output %s during %s test case", check_tag, tb_test_case);
        end
        else begin // Check failed
            $error("Incorrect output %s during %s test case", check_tag, tb_test_case);
        end

        // Wait some small amount of time so check pulse timing is visible on waves
        #(0.1);
        end
    endtask

    initial begin

        //initialize all signals
        tb_test_num = 0;
        nRST = 1'b1;
        rfif.wsel = 0;
        rfif.wdat = '0;
        rfif.WEN = 0;
        rfif.rsel1 = 0;
        rfif.rsel2 = 0;
        
        // ************************************************************************
        // Test Case 1: Power-on Reset of the DUT and mash values
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Power on Reset and mash values";
        #(0.1);
        // Apply test case initial stimulus (non-reset value parralel input)
        nRST = 1'b0;
        // Check that the reset value is maintained during a clock cycle
        #(PERIOD);
        tb_expected_ouput = MIN_VAL;
        check_rdat1("after clock cycle while in reset");
        rfif.wdat = MAX_VAL;
        for (int i = 0; i < 32; i++) begin
        rfif.wsel = i;
        rfif.rsel1 = i;
        rfif.WEN = 1;
        #(PERIOD);
        check_rdat1("chk output value at reg");
        rfif.WEN = 0;
        #(PERIOD);
        tb_test_num  = tb_test_num + 1;
        end
        // Release the reset away from a clock edge
        nRST  = 1'b1;   // Deactivate the chip reset
        // Check that internal state was correctly keep after reset release
        #(PERIOD);
        check_rdat1("after reset was released");

        // ************************************************************************
        // Test Case 2: Write to Reg Zero then Read
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Write to Reg Zero then Read";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        reset_dut();

        // Define the expected result
        tb_expected_ouput = MIN_VAL;
        // send the data,
        // 1. assert data on wdat
        // 2. assert WEN
        // 3. wait 1 clk cycle, assert rsel1 and check output to match wdat
        // 4. assert rsel2 and check output to previous wdat to check for changes
        rfif.wdat = MAX_VAL;
        rfif.wsel = 0;
        rfif.rsel1 = 0;
        rfif.rsel2 = 0;
        rfif.WEN = 1;
        #(PERIOD);
        check_rdat1("chk output value at reg 0 with rsel1");
        check_rdat2("chk output value at reg 0 with rsel2");
        rfif.WEN = 0;
        #(PERIOD);
        check_rdat1("after writing to reg zero and reading");

        // ************************************************************************
        // Test Case 3: Check all other regs
        // ************************************************************************
        tb_test_num  = tb_test_num + 1;
        tb_test_case = "Write to Reg 1-31";
        // Start out with inactive value and reset the DUT to isolate from prior tests
        reset_dut();

        // Define the expected result
        tb_expected_ouput = MAX_VAL;

        // send the data,
        // 1. assert data on wdat
        // 2. assert WEN
        // 3. wait 1 clk cycle, assert rsel1 and check output to match wdat
        // 4. assert rsel2 and check output to previous wdat to check for changes
        rfif.wdat = MAX_VAL;
        for (int i = 1; i < 32; i++) begin
        rfif.wsel = i;
        rfif.rsel1 = i;
        rfif.WEN = 1;
        #(PERIOD);
        check_rdat1("chk output value at reg with rsel1");
        rfif.WEN = 0;
        #(PERIOD);
        tb_test_num  = tb_test_num + 1;
        end

        for (int i = 31; i >= 0; i--) begin
        rfif.wsel = i;
        rfif.rsel2 = i;
        rfif.WEN = 1;
        #(PERIOD);
        check_rdat2("chk output value at reg with rsel2");
        rfif.WEN = 0;
        #(PERIOD);
        tb_test_num  = tb_test_num + 1;
        end

        $finish;
    end
    endprogram