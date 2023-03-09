module tb_output();
  // Declare inputs as regs and outputs as wires
  reg clk, reset;

  // Initialize all variables
  initial begin
    $display ("time\t clk reset enable counter");
    $monitor ("%03g\t   %b \t %b \t %b \t %d", $time, clock, reset);
    clk = 1;       // initial value of clock
    reset = 0;       // initial value of reset
    #5  reset = 1;    // Assert the reset
    #10  reset = 0;   // De-assert the reset
    #5  $finish;      // Terminate simulation
  end

  // Clock generator
  always begin
     #5  clk = ~clk; // Toggle clock every 5 ticks
  end

  // Connect DUT to test bench
  VX_vortex_to_local_mem DUT (
    clk,
    reset
  );
endmodule
