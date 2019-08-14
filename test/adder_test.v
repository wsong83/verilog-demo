`timescale 1ns/1ps

module test;
  reg  [3:0] a, b;
  wire [3:0] s0, s1;
  wire       co0, co1;

  add4   ADD0(a, b, s0, co0);
  adder4 ADD1(a, b, s1, co1);

  initial begin
    a = 0;
    b = 0;
    #10 a = 1;
    #10 b = 2;
    #10 a = 3;
    #10 b = 4;
    #10 a = 5; b = 6;
    #10 a = 7; b = 8;
    #10 a = 9; b = 10;
    #10;
    $finish();
  end

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
  end
endmodule
