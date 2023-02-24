/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    testbench for vortex, simulating memory interface
*/

// temporary include to have defined vals
// `include "local_mem.vh"
`include "../include/VX_define.vh"
// `include "VX_define.vh"

`timescale 1 ns / 1 ns

module local_mem_tb ();

    // testbench signals
    parameter PERIOD = 10;
    logic clk = 0, reset;

    // parameters
    // `VX_MEM_BYTEEN_WIDTH    // 64 (512 / 8)
    // `VX_MEM_ADDR_WIDTH      // 26
    // `VX_MEM_DATA_WIDTH      // 512
    // `VX_MEM_TAG_WIDTH       // 56 (55 for SM disabled)

    // clock gen
    always #(PERIOD/2) clk++;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// memory interfacing signals:

    // Memory request:
    // vortex outputs
    logic                               mem_req_valid;
    logic                               mem_req_rw;    
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    mem_req_byteen;    
    logic [`VX_MEM_ADDR_WIDTH-1:0]      mem_req_addr;
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_req_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_req_tag;
    // vortex inputs
    logic                               mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                               mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_rsp_tag;
    // vortex outputs
    logic                               mem_rsp_ready;

    // Status:
    // vortex outputs
    logic                               busy;

    // TB:
    logic                               tb_addr_out_of_bounds;


    // test program
	test #(.PERIOD(PERIOD)) PROG (
        .clk            (clk),
        .reset          (reset),

        .mem_req_valid  (mem_req_valid),
        .mem_req_rw     (mem_req_rw),
        .mem_req_byteen (mem_req_byteen),
        .mem_req_addr   (mem_req_addr),
        .mem_req_data   (mem_req_data),
        .mem_req_tag    (mem_req_tag),
        .mem_req_ready  (mem_req_ready),

        .mem_rsp_valid  (mem_rsp_valid),
        .mem_rsp_data   (mem_rsp_data),
        .mem_rsp_tag    (mem_rsp_tag),
        .mem_rsp_ready  (mem_rsp_ready),

        .busy           (busy),

        .tb_addr_out_of_bounds (tb_addr_out_of_bounds)
	);
	
    /////////////////////////
	// DUT
    /////////////////////////
	local_mem DUT (
        .clk            (clk),
        .reset          (reset),

        .mem_req_valid  (mem_req_valid),
        .mem_req_rw     (mem_req_rw),
        .mem_req_byteen (mem_req_byteen),
        .mem_req_addr   (mem_req_addr),
        .mem_req_data   (mem_req_data),
        .mem_req_tag    (mem_req_tag),
        .mem_req_ready  (mem_req_ready),

        .mem_rsp_valid  (mem_rsp_valid),
        .mem_rsp_data   (mem_rsp_data),
        .mem_rsp_tag    (mem_rsp_tag),
        .mem_rsp_ready  (mem_rsp_ready),

        .busy           (busy),

        .tb_addr_out_of_bounds (tb_addr_out_of_bounds)
    );
    
endmodule

program test
(
    // seq
    input clk,
    output logic reset,

    // Vortex
    // Memory request
    output logic                            mem_req_valid,
    output logic                            mem_req_rw,    
    output logic [`VX_MEM_BYTEEN_WIDTH-1:0] mem_req_byteen,    
    output logic [`VX_MEM_ADDR_WIDTH-1:0]   mem_req_addr,
    output logic [`VX_MEM_DATA_WIDTH-1:0]   mem_req_data,
    output logic [`VX_MEM_TAG_WIDTH-1:0]    mem_req_tag,
    input logic                             mem_req_ready,
    // Memory response   
    input logic                             mem_rsp_valid,        
    input logic [`VX_MEM_DATA_WIDTH-1:0]    mem_rsp_data,
    input logic [`VX_MEM_TAG_WIDTH-1:0]     mem_rsp_tag,
    output logic                            mem_rsp_ready,
    // Status
    output logic                            busy,

    // tb
    input logic                             tb_addr_out_of_bounds
);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// test signals:
	///////////////////////////////////////////////////////////////////////////////////////////////////////

	// tb signals
	parameter PERIOD 		= 1;
	integer test_num 		= 0;
	string test_string 		= "start";
	string task_string		= "no task";
	logic testing 			= 1'b0;
	logic error				= 1'b0;
	integer num_errors		= 0;

    // tb expected signals
    // Memory Request:
    // vortex inputs
    logic                           expected_mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                           expected_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]  expected_mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]   expected_mem_rsp_tag;

    // tb:
    logic                           expected_tb_addr_out_of_bounds;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// Vortex vs tb control of ram
    logic tb_control_ram;

    // < mux logic for selecting between Vortex or tb to interact with ram >

    ///////////////////////////////////////////////////////////////////////////////////////////////////////


    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// tasks:
	///////////////////////////////////////////////////////////////////////////////////////////////////////

    task check_outputs;
    begin
        testing = 1'b1;

        // check for good output
		assert (
            mem_req_ready === expected_mem_req_ready &
            mem_rsp_valid === expected_mem_rsp_valid &
            mem_rsp_data === expected_mem_rsp_data &
            mem_rsp_tag === expected_mem_rsp_tag & 
            tb_addr_out_of_bounds === expected_tb_addr_out_of_bounds
            )
		begin
			$display("Correct outputs");
		end
        // otherwise, error
        else
        begin
            error = 1'b1;
            
            // check for specific errors:
            if (mem_req_ready !== expected_mem_req_ready)
            begin
                num_errors++;
                $display("\tmem_req_ready:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_ready, mem_req_ready);
            end

            // check for specific errors:
            if (mem_rsp_valid !== expected_mem_rsp_valid)
            begin
                num_errors++;
                $display("\tmem_rsp_valid:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_rsp_valid, mem_rsp_valid);
            end

            // check for specific errors:
            if (mem_rsp_data !== expected_mem_rsp_data)
            begin
                num_errors++;
                $display("\tmem_rsp_data:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_rsp_data, mem_rsp_data);
            end

            // check for specific errors:
            if (mem_rsp_tag !== expected_mem_rsp_tag)
            begin
                num_errors++;
                $display("\tmem_rsp_tag:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_rsp_tag, mem_rsp_tag);
            end

            // check for specific errors:
            if (tb_addr_out_of_bounds !== expected_tb_addr_out_of_bounds)
            begin
                num_errors++;
                $display("\ttb_addr_out_of_bounds:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_tb_addr_out_of_bounds, tb_addr_out_of_bounds);
            end
        end

        #(0.01);
        testing = 1'b0;
        error = 1'b0;
    end
    endtask

    task load_memory ();
        string mem_load_file;
    begin
        // read in file with instructions and data into fake mem
    end
    endtask

    task dump_memory ();
        string mem_dump_file;
    begin
        // write out fake mem contents to file
    end
    endtask

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// tb:
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	
	initial
	begin
		// init valules
		error = 1'b0;
		num_errors = 0;
		test_num = 0;
		test_string = "";
        task_string = "";
		$display("init");
        $display("");

        ///////////////////////
		// load fake memory: //
		///////////////////////
        // load_memory("input_data.hex");

        ////////////////////
		// reset testing: //
		////////////////////
		@(negedge clk);
        test_num++;
        test_string = "reset testing";
		$display("reset testing");
		begin
            task_string = "assert reset";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b0;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = '0;
            mem_req_data = '0;
            mem_req_tag = '0;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;

            reset = 1'b1;
            
            #(PERIOD);
            @(negedge clk);
            task_string = "deassert nRST";
            $display("\n-> testing %s", task_string);

            reset = 1'b0;

            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b0;
            expected_mem_rsp_data[31:0] = 32'h6F008004;
            expected_mem_rsp_data[63:32] = 32'h732F2034;
            expected_mem_rsp_data[95:64] = 32'h930F8000;
            expected_mem_rsp_data[127:96] = 32'h6308FF03;
            expected_mem_rsp_data[159:128] = 32'h930F9000;
            expected_mem_rsp_data[191:160] = 32'h6304FF03;
            expected_mem_rsp_data[223:192] = 32'h930FB000;
            expected_mem_rsp_data[255:224] = 32'h6300FF03;
            expected_mem_rsp_data[287:256] = 32'h130F0000;
            expected_mem_rsp_data[319:288] = 32'h63040F00;
            expected_mem_rsp_data[351:320] = 32'h67000F00;
            expected_mem_rsp_data[383:352] = 32'h732F2034;
            expected_mem_rsp_data[415:384] = 32'h63540F00;
            expected_mem_rsp_data[447:416] = 32'h6F004000;
            expected_mem_rsp_data[479:448] = 32'h93E19153;
            expected_mem_rsp_data[511:480] = 32'h171F0000;
            expected_mem_rsp_tag = 56'd0;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        $display("");

        ///////////////////
		// read testing: //
		///////////////////
		@(negedge clk);
        test_num++;
        test_string = "read testing";
		$display("read testing");
		begin
            @(negedge clk);
            task_string = "read from first reg file 1";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_0000_0000;
            mem_req_data = '0;
            mem_req_tag = 56'd1;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h6F008004;
            expected_mem_rsp_data[63:32] = 32'h732F2034;
            expected_mem_rsp_data[95:64] = 32'h930F8000;
            expected_mem_rsp_data[127:96] = 32'h6308FF03;
            expected_mem_rsp_data[159:128] = 32'h930F9000;
            expected_mem_rsp_data[191:160] = 32'h6304FF03;
            expected_mem_rsp_data[223:192] = 32'h930FB000;
            expected_mem_rsp_data[255:224] = 32'h6300FF03;
            expected_mem_rsp_data[287:256] = 32'h130F0000;
            expected_mem_rsp_data[319:288] = 32'h63040F00;
            expected_mem_rsp_data[351:320] = 32'h67000F00;
            expected_mem_rsp_data[383:352] = 32'h732F2034;
            expected_mem_rsp_data[415:384] = 32'h63540F00;
            expected_mem_rsp_data[447:416] = 32'h6F004000;
            expected_mem_rsp_data[479:448] = 32'h93E19153;
            expected_mem_rsp_data[511:480] = 32'h171F0000;
            expected_mem_rsp_tag = 56'd1;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "read from first reg file 2";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_0000_1101;
            mem_req_data = '0;
            mem_req_tag = 56'd2;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h83234500;
            expected_mem_rsp_data[63:32] = 32'h03250500;
            expected_mem_rsp_data[95:64] = 32'hF3151000;
            expected_mem_rsp_data[127:96] = 32'h13060000;
            expected_mem_rsp_data[159:128] = 32'h631ED50C;
            expected_mem_rsp_data[191:160] = 32'h631C730C;
            expected_mem_rsp_data[223:192] = 32'h639AC50C;
            expected_mem_rsp_data[255:224] = 32'h93019000;
            expected_mem_rsp_data[287:256] = 32'h17250000;
            expected_mem_rsp_data[319:288] = 32'h130505D8;
            expected_mem_rsp_data[351:320] = 32'h07300500;
            expected_mem_rsp_data[383:352] = 32'h87308500;
            expected_mem_rsp_data[415:384] = 32'h07310501;
            expected_mem_rsp_data[447:416] = 32'h83268501;
            expected_mem_rsp_data[479:448] = 32'h0323C501;
            expected_mem_rsp_data[511:480] = 32'hD3711012;
            expected_mem_rsp_tag = 56'd2;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "read from second reg file 1";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_0100_0000;
            mem_req_data = '0;
            mem_req_tag = 56'd3;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h00000000;
            expected_mem_rsp_data[63:32] = 32'h00000000;
            expected_mem_rsp_data[95:64] = 32'h00000000;
            expected_mem_rsp_data[127:96] = 32'h00000000;
            expected_mem_rsp_data[159:128] = 32'h00000000;
            expected_mem_rsp_data[191:160] = 32'h00000000;
            expected_mem_rsp_data[223:192] = 32'h00000000;
            expected_mem_rsp_data[255:224] = 32'h00000000;
            expected_mem_rsp_data[287:256] = 32'h00000000;
            expected_mem_rsp_data[319:288] = 32'h00000000;
            expected_mem_rsp_data[351:320] = 32'h00000000;
            expected_mem_rsp_data[383:352] = 32'h00000000;
            expected_mem_rsp_data[415:384] = 32'h00000000;
            expected_mem_rsp_data[447:416] = 32'h00000000;
            expected_mem_rsp_data[479:448] = 32'h00000000;
            expected_mem_rsp_data[511:480] = 32'h00000000;
            expected_mem_rsp_tag = 56'd3;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "read from second reg file 2";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_0100_0001;
            mem_req_data = '0;
            mem_req_tag = 16'd4;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h00000000;
            expected_mem_rsp_data[63:32] = 32'h00000000;
            expected_mem_rsp_data[95:64] = 32'h00000000;
            expected_mem_rsp_data[127:96] = 32'h00000000;
            expected_mem_rsp_data[159:128] = 32'h00000000;
            expected_mem_rsp_data[191:160] = 32'h00000000;
            expected_mem_rsp_data[223:192] = 32'h00000000;
            expected_mem_rsp_data[255:224] = 32'h00000000;
            expected_mem_rsp_data[287:256] = 32'h00000000;
            expected_mem_rsp_data[319:288] = 32'h00000000;
            expected_mem_rsp_data[351:320] = 32'h00000000;
            expected_mem_rsp_data[383:352] = 32'h00000000;
            expected_mem_rsp_data[415:384] = 32'h00000000;
            expected_mem_rsp_data[447:416] = 32'h00000000;
            expected_mem_rsp_data[479:448] = 32'h00000000;
            expected_mem_rsp_data[511:480] = 32'h00000000;
            expected_mem_rsp_tag = 56'd4;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "read from third reg file 1";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_1000_0000;
            mem_req_data = '0;
            mem_req_tag = 16'd5;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h00000000;
            expected_mem_rsp_data[63:32] = 32'h00000440;
            expected_mem_rsp_data[95:64] = 32'h00000000;
            expected_mem_rsp_data[127:96] = 32'h0000F03F;
            expected_mem_rsp_data[159:128] = 32'h00000000;
            expected_mem_rsp_data[191:160] = 32'h00000000;
            expected_mem_rsp_data[223:192] = 32'h00000000;
            expected_mem_rsp_data[255:224] = 32'h00000C40;
            expected_mem_rsp_data[287:256] = 32'h66666666;
            expected_mem_rsp_data[319:288] = 32'h664C93C0;
            expected_mem_rsp_data[351:320] = 32'h9A999999;
            expected_mem_rsp_data[383:352] = 32'h9999F13F;
            expected_mem_rsp_data[415:384] = 32'h00000000;
            expected_mem_rsp_data[447:416] = 32'h00000000;
            expected_mem_rsp_data[479:448] = 32'h00000000;
            expected_mem_rsp_data[511:480] = 32'h004893C0;
            expected_mem_rsp_tag = 56'd5;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "read from third reg file 2";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_1000_0011;
            mem_req_data = '0;
            mem_req_tag = 16'd6;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h00000000;
            expected_mem_rsp_data[63:32] = 32'h00000440;
            expected_mem_rsp_data[95:64] = 32'h00000000;
            expected_mem_rsp_data[127:96] = 32'h0000F03F;
            expected_mem_rsp_data[159:128] = 32'h00000000;
            expected_mem_rsp_data[191:160] = 32'h00000000;
            expected_mem_rsp_data[223:192] = 32'h00000000;
            expected_mem_rsp_data[255:224] = 32'h00000440;
            expected_mem_rsp_data[287:256] = 32'h66666666;
            expected_mem_rsp_data[319:288] = 32'h664C93C0;
            expected_mem_rsp_data[351:320] = 32'h9A999999;
            expected_mem_rsp_data[383:352] = 32'h9999F1BF;
            expected_mem_rsp_data[415:384] = 32'h00000000;
            expected_mem_rsp_data[447:416] = 32'h00000000;
            expected_mem_rsp_data[479:448] = 32'h3D0AD7A3;
            expected_mem_rsp_data[511:480] = 32'h703A9540;
            expected_mem_rsp_tag = 16'd6;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        $display("");

        ////////////////////
		// write testing: //
		////////////////////
		@(negedge clk);
        test_num++;
        test_string = "write testing";
		$display("write testing");
		begin
            @(negedge clk);
            task_string = "write to second reg file";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b1;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_0100_0000;
            mem_req_data[31:0] = 32'h89abcdef;
            mem_req_data[63:32] = 32'h01234567;
            mem_req_data[95:64] = 32'h89abcdef;
            mem_req_data[127:96] = 32'h01234567;
            mem_req_data[159:128] = 32'h89abcdef;
            mem_req_data[191:160] = 32'h01234567;
            mem_req_data[223:192] = 32'h89abcdef;
            mem_req_data[255:224] = 32'h01234567;
            mem_req_data[287:256] = 32'h89abcdef;
            mem_req_data[319:288] = 32'h01234567;
            mem_req_data[351:320] = 32'h89abcdef;
            mem_req_data[383:352] = 32'h01234567;
            mem_req_data[415:384] = 32'h89abcdef;
            mem_req_data[447:416] = 32'h01234567;
            mem_req_data[479:448] = 32'h89abcdef;
            mem_req_data[511:480] = 32'h01234567;
            mem_req_tag = 16'd7;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h0;
            expected_mem_rsp_data[63:32] = 32'h0;
            expected_mem_rsp_data[95:64] = 32'h0;
            expected_mem_rsp_data[127:96] = 32'h0;
            expected_mem_rsp_data[159:128] = 32'h0;
            expected_mem_rsp_data[191:160] = 32'h0;
            expected_mem_rsp_data[223:192] = 32'h0;
            expected_mem_rsp_data[255:224] = 32'h0;
            expected_mem_rsp_data[287:256] = 32'h0;
            expected_mem_rsp_data[319:288] = 32'h0;
            expected_mem_rsp_data[351:320] = 32'h0;
            expected_mem_rsp_data[383:352] = 32'h0;
            expected_mem_rsp_data[415:384] = 32'h0;
            expected_mem_rsp_data[447:416] = 32'h0;
            expected_mem_rsp_data[479:448] = 32'h0;
            expected_mem_rsp_data[511:480] = 32'h0;
            expected_mem_rsp_tag = 16'd7;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "read after write to second reg file";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_0100_0000;
            mem_req_data = '0;
            mem_req_tag = 16'd8;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h89abcdef;
            expected_mem_rsp_data[63:32] = 32'h01234567;
            expected_mem_rsp_data[95:64] = 32'h89abcdef;
            expected_mem_rsp_data[127:96] = 32'h01234567;
            expected_mem_rsp_data[159:128] = 32'h89abcdef;
            expected_mem_rsp_data[191:160] = 32'h01234567;
            expected_mem_rsp_data[223:192] = 32'h89abcdef;
            expected_mem_rsp_data[255:224] = 32'h01234567;
            expected_mem_rsp_data[287:256] = 32'h89abcdef;
            expected_mem_rsp_data[319:288] = 32'h01234567;
            expected_mem_rsp_data[351:320] = 32'h89abcdef;
            expected_mem_rsp_data[383:352] = 32'h01234567;
            expected_mem_rsp_data[415:384] = 32'h89abcdef;
            expected_mem_rsp_data[447:416] = 32'h01234567;
            expected_mem_rsp_data[479:448] = 32'h89abcdef;
            expected_mem_rsp_data[511:480] = 32'h01234567;
            expected_mem_rsp_tag = 16'd8;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "write to third reg file";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b1;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_1000_0011;
            mem_req_data[31:0] = 32'h89abcdef;
            mem_req_data[63:32] = 32'h01234567;
            mem_req_data[95:64] = 32'h89abcdef;
            mem_req_data[127:96] = 32'h01234567;
            mem_req_data[159:128] = 32'h89abcdef;
            mem_req_data[191:160] = 32'h01234567;
            mem_req_data[223:192] = 32'h89abcdef;
            mem_req_data[255:224] = 32'h01234567;
            mem_req_data[287:256] = 32'h89abcdef;
            mem_req_data[319:288] = 32'h01234567;
            mem_req_data[351:320] = 32'h89abcdef;
            mem_req_data[383:352] = 32'h01234567;
            mem_req_data[415:384] = 32'h89abcdef;
            mem_req_data[447:416] = 32'h01234567;
            mem_req_data[479:448] = 32'h89abcdef;
            mem_req_data[511:480] = 32'h01234567;
            mem_req_tag = 16'd9;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h00000000;
            expected_mem_rsp_data[63:32] = 32'h00000440;
            expected_mem_rsp_data[95:64] = 32'h00000000;
            expected_mem_rsp_data[127:96] = 32'h0000F03F;
            expected_mem_rsp_data[159:128] = 32'h00000000;
            expected_mem_rsp_data[191:160] = 32'h00000000;
            expected_mem_rsp_data[223:192] = 32'h00000000;
            expected_mem_rsp_data[255:224] = 32'h00000440;
            expected_mem_rsp_data[287:256] = 32'h66666666;
            expected_mem_rsp_data[319:288] = 32'h664C93C0;
            expected_mem_rsp_data[351:320] = 32'h9A999999;
            expected_mem_rsp_data[383:352] = 32'h9999F1BF;
            expected_mem_rsp_data[415:384] = 32'h00000000;
            expected_mem_rsp_data[447:416] = 32'h00000000;
            expected_mem_rsp_data[479:448] = 32'h3D0AD7A3;
            expected_mem_rsp_data[511:480] = 32'h703A9540;
            expected_mem_rsp_tag = 16'd9;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end
        begin
            @(negedge clk);
            task_string = "read after write to third reg file";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_valid = 1'b1;
            mem_req_rw = 1'b0;
            mem_req_byteen = '0;
            mem_req_addr = 26'b10_0000_0000_0000_0000_1000_0011;
            mem_req_data = 32'h00000000;
            mem_req_tag = 16'd10;
            mem_rsp_ready = 1'b0;
            busy = 1'b0;
            
            #(PERIOD / 4);

            // expected outputs:
            expected_mem_req_ready = 1'b1;
            expected_mem_rsp_valid = 1'b1;
            expected_mem_rsp_data[31:0] = 32'h89abcdef;
            expected_mem_rsp_data[63:32] = 32'h01234567;
            expected_mem_rsp_data[95:64] = 32'h89abcdef;
            expected_mem_rsp_data[127:96] = 32'h01234567;
            expected_mem_rsp_data[159:128] = 32'h89abcdef;
            expected_mem_rsp_data[191:160] = 32'h01234567;
            expected_mem_rsp_data[223:192] = 32'h89abcdef;
            expected_mem_rsp_data[255:224] = 32'h01234567;
            expected_mem_rsp_data[287:256] = 32'h89abcdef;
            expected_mem_rsp_data[319:288] = 32'h01234567;
            expected_mem_rsp_data[351:320] = 32'h89abcdef;
            expected_mem_rsp_data[383:352] = 32'h01234567;
            expected_mem_rsp_data[415:384] = 32'h89abcdef;
            expected_mem_rsp_data[447:416] = 32'h01234567;
            expected_mem_rsp_data[479:448] = 32'h89abcdef;
            expected_mem_rsp_data[511:480] = 32'h01234567;
            expected_mem_rsp_tag = 16'd10;
            expected_tb_addr_out_of_bounds = 1'b0;
            
            check_outputs();
		end

        ///////////////////////
		// dump fake memory: //
		///////////////////////
        // load_memory("output_data.hex");

        //////////////////////
		// testing results: //
		//////////////////////
        @(negedge clk);
		test_num 			= 0;
		test_string 		= "testing results";
		$display("");
		$display("//////////////////////");
		$display("// testing results: //");
		$display("//////////////////////");
		$display("");
		begin
			#(PERIOD);

			// check for errors
			if (num_errors)
			begin
				$display("UNSUCCESSFUL VERIFICATION\n%d error(s)", num_errors);
			end
			else
			begin
				$display("SUCCESSFUL VERIFICATION\n\tno errors");
			end
		end
		$display("");

        $finish();
    end

endprogram
