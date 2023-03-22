`include "VX_define.vh"

localparam AHB_DATA_WIDTH = 32;
localparam TRANS_PER_BLOCK = `VX_MEM_DATA_WIDTH/AHB_DATA_WIDTH;

module VX_ahb_adapter_tb;
    parameter PERIOD = 10; 
    logic CLK = 0;

    always #(PERIOD/2) CLK = ~CLK; 

    ahb_if #(
        .DATA_WIDTH(AHB_DATA_WIDTH),
        .ADDR_WIDTH(`VX_MEM_ADDR_WIDTH)
    ) ahbif (.HCLK(CLK), .HRESETn(nRST));

    VX_mem_req_if #(
        .DATA_WIDTH(`VX_MEM_DATA_WIDTH),
        .TAG_WIDTH(`VX_MEM_TAG_WIDTH)
    ) mreqif ();

    VX_mem_rsp_if #(
        .DATA_WIDTH(`VX_MEM_DATA_WIDTH),
        .TAG_WIDTH(`VX_MEM_TAG_WIDTH)
    ) mrspif ();

    VX_ahb_adapter DUT(CLK, nRST, ahbif, mreqif, mrspif);

    test prog(CLK, nRST, ahbif, mreqif, mrspif);
endmodule

program test(
    input logic CLK,
    output logic nRST,
    ahb_if.subordinate ahbif,
    VX_mem_req_if.master mreqif,
    VX_mem_rsp_if.slave mrspif
);
    // Signals for keeping track of failures
    integer tests = 0;
    integer fails = 0;

    // Navigation signals
    integer test_num = 0;
    string test_case = "Init";

    // AHB side outputs
    logic                                 expected_HSEL;
    logic                                 expected_HWRITE;
    logic                                 expected_HMASTLOCK;
    logic [1:0]                           expected_HTRANS;
    logic [2:0]                           expected_HBURST;
    logic [2:0]                           expected_HSIZE;
    logic [`VX_MEM_ADDR_WIDTH-1:0]        expected_HADDR;
    logic [`VX_MEM_DATA_WIDTH-1:0]        expected_HWDATA;
    logic [(`VX_MEM_DATA_WIDTH/8) - 1:0]  expected_HWSTRB;

    // Vortex side outputs
    logic                                 expected_req_ready;
    logic                                 expected_rsp_valid;
    logic [`VX_MEM_DATA_WIDTH-1:0]        expected_rsp_data;

    // Buffer to hold data to send via AHB
    logic [`VX_MEM_DATA_WIDTH-1:0]        ahb_buffer;

    task reset_inputs;
        mreqif.valid  = '0;
        mreqif.rw     = '0;
        mreqif.byteen = '1;
        mreqif.addr   = '0;
        mreqif.data   = '0;
        mreqif.tag    = '0;
        mrspif.ready  = '1;

        ahbif.HREADYOUT  = '1;
        ahbif.HRESP   = '0;
        ahbif.HRDATA  = '0;
    endtask

    task check_vx_outputs(input bit check_data_signals = 0);
        tests += 1;
        assert (mreqif.ready == expected_req_ready)
            else begin
                $error("Expected req_ready = %1.d, got %1.d",
                        expected_req_ready, mreqif.ready);
                fails += 1;
            end

        tests += 1;
        assert (mrspif.valid == expected_rsp_valid)
            else begin
                $error("Expected rsp_valid = %1.d, got %1.d",
                        expected_rsp_valid, mrspif.valid);
                fails += 1;
            end

        if (check_data_signals) begin
            tests += 1;
            assert (mrspif.data == expected_rsp_data)
                else begin
                    $error("Expected rsp_data = %128.x, got %128.x",
                            expected_rsp_data, mrspif.data);
                    fails += 1;
                end
        end
    endtask

    task check_ahb_outputs(input bit check_data_signals = 0);
        tests += 1;
        assert (ahbif.HSEL == expected_HSEL)
            else begin
                $error("Expected HSEL = %1.d, got %1.d",
                        expected_HSEL, ahbif.HSEL);
                fails += 1;
            end
        
        tests += 1;
        assert (ahbif.HWRITE == expected_HWRITE)
            else begin
                $error("Expected HWRITE = %1.d, got %1.d",
                        expected_HWRITE, ahbif.HWRITE);
                fails += 1;
            end
        
        /* NOT CHECKED TO ALLOW FLEXIBILITY OF IMPLEMENTATION
        tests += 1;
        assert (ahbif.HTRANS == expected_HTRANS)
            else begin
                $error("Expected HTRANS = %1.d, got %1.d",
                        expected_HTRANS, ahbif.HTRANS);
                fails += 1;
            end

        tests += 1;
        assert (ahbif.HBURST == expected_HBURST)
            else begin
                $error("Expected HBURST = %1.d, got %1.d",
                        expected_HBURST, ahbif.HBURST);
                fails += 1;
            end
        */

        tests += 1;
        assert (ahbif.HSIZE == expected_HSIZE)
            else begin
                $error("Expected HSIZE = %1.d, got %1.d",
                        expected_HSIZE, ahbif.HSIZE);
                fails += 1;
            end

        tests += 1;
        assert (ahbif.HADDR == expected_HADDR)
            else begin
                $error("Expected HADDR = %8.x, got %8.x",
                        expected_HADDR, ahbif.HADDR);
                fails += 1;
            end

        if (check_data_signals) begin
            tests += 1;
            assert (ahbif.HWDATA == expected_HWDATA)
                else begin
                    $error("Expected HWDATA = %8.x, got %8.x",
                            expected_HWDATA, ahbif.HWDATA);
                    fails += 1;
                end

            tests += 1;
            assert (ahbif.HWSTRB == expected_HWSTRB)
                else begin
                    $error("Expected HWSTRB = %4.b, got %4.b",
                            expected_HWSTRB, ahbif.HWSTRB);
                    fails += 1;
                end
        end
    endtask

    // Task to stream data from the AHB buffer to the AHB adapter
    // in case of a read by Vortex. Should be called after the posedge
    // following the read request, and before the negedge following that.
    task check_receive_data(
        input logic [`VX_MEM_ADDR_WIDTH-1:0] base_addr,
        input integer transactions
    );
        expected_HSEL = 1'b1;
        expected_HWRITE = 1'b0;
        expected_HSIZE = $clog2(AHB_DATA_WIDTH/8);
        expected_HADDR = base_addr;

        @(negedge CLK);
        check_ahb_outputs();

        for (integer i = 0; i < transactions; ++i) begin
            @(posedge CLK);
            ahbif.HRDATA = ahb_buffer[i*AHB_DATA_WIDTH +: AHB_DATA_WIDTH];
            expected_HADDR = base_addr + (AHB_DATA_WIDTH*(i + 1))/8;
            if (i < transactions - 1) begin
                @(negedge CLK);
                check_ahb_outputs();
            end
        end

        @(posedge CLK);
    endtask

    initial begin
        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Power-on reset
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Power-on reset";
        $display("Running test %d: %s", test_num, test_case);

        nRST = 1'b1;
        @(negedge CLK);
        nRST = 1'b0;
        @(negedge CLK);
        nRST = 1'b1;
        check_ahb_outputs();
        check_vx_outputs();

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Standalone read
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Standalone read";
        $display("Running test %d: %s", test_num, test_case);

        // Set up request at the Vortex side
        mreqif.valid = 1'b1;
        mreqif.rw = 1'b0;
        mreqif.byteen = '1;
        mreqif.addr = 32'h12340000;
        mrspif.ready = 1'b1;

        // req_ready should go low in the next cycle to prevent another
        // transaction from being queued
        @(posedge CLK);
        expected_req_ready = 1'b0;
        check_vx_outputs();

        // Stream the AHB transactions
        for (int i=0; i<`VX_MEM_DATA_WIDTH/32; ++i) begin
            ahb_buffer[i] = $urandom();
        end
        check_receive_data(mreqif.addr, TRANS_PER_BLOCK);

        // Check that the value correctly gets passed to Vortex
        expected_req_ready = '0;
        expected_rsp_valid = '1;
        expected_rsp_data = ahb_buffer;
        check_vx_outputs();

        $finish;
    end    
endprogram
