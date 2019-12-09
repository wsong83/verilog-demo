`timescale 1ns/1ps

module test;

  reg clk, x;
  wire y;

  burst_detect #(3) dut(clk, x, y);

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  always @(posedge clk)
    x <= $random;

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
    #1000 $finish();
  end
endmodule

