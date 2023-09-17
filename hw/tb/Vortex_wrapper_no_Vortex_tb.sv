/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    testbench for Vortex_mem_slave, simulating memory interface and AHB generic bus interface
*/

// temporary include to have defined vals
`include "Vortex_mem_slave.vh"

// include for Vortex widths
`include "../include/VX_define.vh"

`timescale 1 ns / 1 ns

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter MEM_SLAVE_AHB_BASE_ADDR = 32'hF000_0000;
parameter BUSY_REG_AHB_BASE_ADDR = 32'hF000_8000;
parameter START_REG_AHB_BASE_ADDR = 32'hF000_8004;;
parameter PC_RESET_VAL_REG_AHB_BASE_ADDR = 32'hF000_8008;
parameter MEM_SLAVE_ADDR_SPACE_BITS = 14;
parameter BUFFER_WIDTH = 1;

module Vortex_wrapper_no_Vortex_tb ();

    logic clk = 0, nRST;

    logic                             Vortex_mem_req_valid;
    logic                             Vortex_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]  Vortex_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]    Vortex_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]    Vortex_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]     Vortex_mem_req_tag;    // 56 (55 for SM disabled)
    // vortex inputs
    logic                            Vortex_mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                            Vortex_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]   Vortex_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]    Vortex_mem_rsp_tag;    // 56 (55 for SM disabled)
    // vortex outputs
    logic                             Vortex_mem_rsp_ready;

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if        mem_slave_bpif();
        // // Vital signals
        // logic wen; // request is a data write
        // logic ren; // request is a data read
        // logic request_stall; // High when protocol should insert wait states in transaction
        // logic [ADDR_WIDTH-1 : 0] addr; // *offset* address of request TODO: Is this good for general use?
        // logic error; // Indicate error condition to bus
        // logic [(DATA_WIDTH/8)-1 : 0] strobe; // byte enable for writes
        // logic [DATA_WIDTH-1 : 0] wdata, rdata; // data lines -- from perspective of bus master. rdata should be data read from peripheral.

        // modport peripheral_vital (
        //     input wen, ren, addr, wdata, strobe,
        //     output rdata, error, request_stall
        // );

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if        ctrl_status_bpif();
        // // Vital signals
        // logic wen; // request is a data write
        // logic ren; // request is a data read
        // logic request_stall; // High when protocol should insert wait states in transaction
        // logic [ADDR_WIDTH-1 : 0] addr; // *offset* address of request TODO: Is this good for general use?
        // logic error; // Indicate error condition to bus
        // logic [(DATA_WIDTH/8)-1 : 0] strobe; // byte enable for writes
        // logic [DATA_WIDTH-1 : 0] wdata, rdata; // data lines -- from perspective of bus master. rdata should be data read from peripheral.

        // modport peripheral_vital (
        //     input wen, ren, addr, wdata, strobe,
        //     output rdata, error, request_stall
        // );

    //////////////////////////////////
    // AHB Manager for Vortex_... : //
    //////////////////////////////////

    ahb_if #(
        // .DATA_WIDTH(AHB_DATA_WIDTH),
        .DATA_WIDTH(32),
        // .ADDR_WIDTH(AHB_ADDR_WIDTH)
        .ADDR_WIDTH(32)
    ) ahb_manager_ahbif (.HCLK(clk), .HRESETn(nRST));
        // logic HSEL;
        // logic HREADY;
        // logic HREADYOUT;
        // logic HWRITE;
        // logic HMASTLOCK; // UNUSED
        // logic HRESP;
        // logic [1:0] HTRANS;
        // logic [2:0] HBURST; // UNUSED
        // logic [2:0] HSIZE;
        // logic [ADDR_WIDTH - 1:0] HADDR;
        // logic [DATA_WIDTH - 1:0] HWDATA;
        // logic [DATA_WIDTH - 1:0] HRDATA;
        // logic [(DATA_WIDTH/8) - 1:0] HWSTRB;

        // assign HREADY = HREADYOUT;

        // modport manager(
        //     input HCLK, HRESETn,
        //     input HREADY, HRESP, HRDATA,
        //     output HWRITE, HMASTLOCK, HTRANS,
        //     HBURST, HSIZE, HADDR, HWDATA, HWSTRB, HSEL
        // );

    /////////////////////////////////
    // CTRL/STATUS to/from Vortex: //
    /////////////////////////////////

    logic Vortex_busy;
    logic Vortex_reset;
    logic [32-1:0] Vortex_PC_reset_val;

    //////////////////////////////////////
    // Vortex_wrapper_no_Vortex module: //
    //////////////////////////////////////

    Vortex_wrapper_no_Vortex #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_SLAVE_AHB_BASE_ADDR(MEM_SLAVE_AHB_BASE_ADDR),
        .BUSY_REG_AHB_BASE_ADDR(BUSY_REG_AHB_BASE_ADDR),
        .START_REG_AHB_BASE_ADDR(START_REG_AHB_BASE_ADDR),
        .PC_RESET_VAL_REG_AHB_BASE_ADDR(PC_RESET_VAL_REG_AHB_BASE_ADDR),
        .MEM_SLAVE_ADDR_SPACE_BITS(MEM_SLAVE_ADDR_SPACE_BITS),
        .BUFFER_WIDTH(BUFFER_WIDTH)
    ) DUT (.*);

    /////////////////////////////
    // Testbench Info Signals: //
    /////////////////////////////

    // testbench info signal declarations
    string test_case;
    string sub_test_case;
    int num_errors;
    localparam PERIOD = 20;

    /////////////////////////////////
    // Testbench Expected Signals: //
    /////////////////////////////////

    // Vortex req wrapper outputs
    logic expected_Vortex_mem_req_ready;

    // Vortex rsp wrapper outputs
    logic expected_Vortex_mem_rsp_valid; 
    logic [`VX_MEM_DATA_WIDTH-1:0] expected_Vortex_mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0] expected_Vortex_mem_rsp_tag;

    // Vortex_mem_slave bpif outputs
    logic [DATA_WIDTH-1:0] expected_mem_slave_bpif_rdata;
    logic expected_mem_slave_bpif_error;
    logic expected_mem_slave_bpif_request_stall;

    // CTRL/Status reg bpif outputs
    logic [DATA_WIDTH-1:0] expected_ctrl_status_bpif_rdata;
    logic expected_ctrl_status_bpif_error;
    logic expected_ctrl_status_bpif_request_stall;

    // CTRL/Status outputs
    logic expected_Vortex_reset;
    logic [32-1:0] expected_Vortex_PC_reset_val;

    // VX_ahb_manager ahbif outputs
    logic expected_ahb_manager_ahbif_HWRITE;
    // logic expected_ahb_manager_ahbif_HMASTLOCK; // UNUSED
    logic [1:0] expected_ahb_manager_ahbif_HTRANS;
    // logic [2:0] expected_ahb_manager_ahbif_HBURST; // UNUSED
    logic [2:0] expected_ahb_manager_ahbif_HSIZE;
    logic [ADDR_WIDTH-1:0] expected_ahb_manager_ahbif_HADDR;
    logic [DATA_WIDTH-1:0] expected_ahb_manager_ahbif_HWDATA;
    logic [(DATA_WIDTH/8)-1:0] expected_ahb_manager_ahbif_HWSTRB;
    logic expected_ahb_manager_ahbif_HSEL;

    /////////////
    // clkgen: //
    /////////////

    always #(PERIOD/2) clk++;

    //////////////////////
    // Testbench tasks: //
    //////////////////////

    localparam MAX_WIDTH = 32;
    task check_signal(
        string signal_name,
        logic [MAX_WIDTH-1:0] real_val, 
        logic [MAX_WIDTH-1:0] expected_val
    );
    begin
        assert(real_val === expected_val) 
        begin
            // fill in?
        end
        else
        begin
            $display($sformatf("\t\tTB ERROR: incorrect output for %s = 0x%h | expect 0x%h",
                signal_name,
                real_val,
                expected_val
            ));
            num_errors++;
        end
    end
    endtask

    task check_outputs();
    begin
        // Vortex req wrapper outputs
        check_signal("Vortex_mem_req_ready", Vortex_mem_req_ready, expected_Vortex_mem_req_ready);

        // Vortex rsp wrapper outputs
        check_signal("Vortex_mem_rsp_valid", Vortex_mem_rsp_valid, expected_Vortex_mem_rsp_valid);
        check_signal("Vortex_mem_rsp_data", Vortex_mem_rsp_data, expected_Vortex_mem_rsp_data);
        check_signal("Vortex_mem_rsp_tag", Vortex_mem_rsp_tag, expected_Vortex_mem_rsp_tag);

        // Vortex_mem_slave bpif outputs
        check_signal("mem_slave_bpif.rdata", mem_slave_bpif.rdata, expected_mem_slave_bpif_rdata);
        check_signal("mem_slave_bpif.error", mem_slave_bpif.error, expected_mem_slave_bpif_error);
        check_signal("mem_slave_bpif.request_stall", mem_slave_bpif.request_stall, expected_mem_slave_bpif_request_stall);

        // CTRL/Status reg bpif outputs
        check_signal("ctrl_status_bpif.rdata", ctrl_status_bpif.rdata, expected_ctrl_status_bpif_rdata);
        check_signal("ctrl_status_bpif.error", ctrl_status_bpif.error, expected_ctrl_status_bpif_error);
        check_signal("ctrl_status_bpif.request_stall", ctrl_status_bpif.request_stall, expected_ctrl_status_bpif_request_stall);

        // CTRL/Status outputs
        check_signal("Vortex_reset", Vortex_reset, expected_Vortex_reset);
        check_signal("Vortex_PC_reset_val", Vortex_PC_reset_val, expected_Vortex_PC_reset_val);

        // VX_ahb_manager ahbif outputs
        check_signal("ahb_manager_ahbif.HWRITE", ahb_manager_ahbif.HWRITE, expected_ahb_manager_ahbif_HWRITE);
        // check_signal("ahb_manager_ahbif.HMASTLOCK", ahb_manager_ahbif.HMASTLOCK, expected_ahb_manager_ahbif_HMASTLOCK); // UNUSED
        check_signal("ahb_manager_ahbif.HTRANS", ahb_manager_ahbif.HTRANS, expected_ahb_manager_ahbif_HTRANS);
        // check_signal("ahb_manager_ahbif.HBURST", ahb_manager_ahbif.HBURST, expected_ahb_manager_ahbif_HBURST); // UNUSED
        check_signal("ahb_manager_ahbif.HSIZE", ahb_manager_ahbif.HSIZE, expected_ahb_manager_ahbif_HSIZE);
        check_signal("ahb_manager_ahbif.HADDR", ahb_manager_ahbif.HADDR, expected_ahb_manager_ahbif_HADDR);
        check_signal("ahb_manager_ahbif.HWDATA", ahb_manager_ahbif.HWDATA, expected_ahb_manager_ahbif_HWDATA);
        check_signal("ahb_manager_ahbif.HWSTRB", ahb_manager_ahbif.HWSTRB, expected_ahb_manager_ahbif_HWSTRB);
        check_signal("ahb_manager_ahbif.HSEL", ahb_manager_ahbif.HSEL, expected_ahb_manager_ahbif_HSEL);
    end
    endtask;

    //////////////////////////////
    // Testbench initial block: //
    //////////////////////////////

    initial begin

        $display();
        $display("Testing with MEM_SLAVE_ADDR_SPACE_BITS = ", MEM_SLAVE_ADDR_SPACE_BITS);

        /* --------------------------------------------------------------------------------------------- */
        // Reset Testing
        $display();
        test_case = "Reset Testing";
        $display("test_case: ", test_case);

        // default wrapper inputs:

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b0;
        Vortex_mem_req_rw = 1'b0;
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'hF000_0000;
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h0;

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b0;
        mem_slave_bpif.ren = 1'b0;
        mem_slave_bpif.addr = 32'h0;
        mem_slave_bpif.wdata = 32'h0;
        mem_slave_bpif.strobe = 4'b0;

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0;
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        // CTRL/Status inputs
        Vortex_busy = 1'b0;

        // VX_ahb_manager ahbif inputs
        // ahb_manager_ahbif.HREADY = 1'b1;
        ahb_manager_ahbif.HRESP = 1'b0;
        ahb_manager_ahbif.HRDATA = 32'h0;

        nRST = 1'b0;
        sub_test_case = "reset asserted";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        sub_test_case = "checking values during reset";
        $display("\tsub_test_case: ", sub_test_case);

        // default wrapper outputs:

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 32'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h0;
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0;
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;

        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hF000_0000;

        // VX_ahb_manager ahbif outputs
        expected_ahb_manager_ahbif_HWRITE = 1'b0;
        // expected_ahb_manager_ahbif_HMASTLOCK = 1'b0; // UNUSED
        expected_ahb_manager_ahbif_HTRANS = 2'h0;
        // expected_ahb_manager_ahbif_HBURST = 3'h0; // UNUSED
        expected_ahb_manager_ahbif_HSIZE = 3'h0;
        expected_ahb_manager_ahbif_HADDR = 32'h0;
        expected_ahb_manager_ahbif_HWDATA = 32'h0;
        expected_ahb_manager_ahbif_HWSTRB = 4'b0;
        expected_ahb_manager_ahbif_HSEL = 1'b0;

        // do checks
        check_outputs();

        #(PERIOD/2);

        nRST = 1'b1;
        sub_test_case = "reset deasserted";
        $display("\tsub_test_case: ", sub_test_case);

        #(PERIOD/2);

        sub_test_case = "checking values after reset";
        $display("\tsub_test_case: ", sub_test_case);

        // do checks
        check_outputs();

        #(PERIOD/2);

        /* --------------------------------------------------------------------------------------------- */
        // FSM, Mem-Mapped Reg Testing
        $display();
        test_case = "FSM, Mem-Mapped Reg Testing";
        $display("test_case: ", test_case);

        /* --------------------------------------------------------------------------------------------- */
        // End of Testbench
        $display();
        test_case = "End of Testbench";
        $display("test_case: ", test_case);
        #(PERIOD);

        // check for errors
        if (num_errors)
        begin
            $display($sformatf("\nERROR: %d Errors in Testbench", num_errors));
        end
        else
        begin
            $display("\nSUCCESS: No Errors in Testbench");
        end

        $display();
        $finish();
    end

endmodule
