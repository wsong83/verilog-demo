`timescale 1ns/1ps

module test;
  reg  [3:0] d1, d2;
  reg [1:0] a, s;
  wire [1:0] y1, y2, y3;

  ic74hc153       dut1(d1, d2, a, s, y1);
  ic74hc153_case  dut2(d1, d2, a, s, y2);
  ic74hc153_index dut3(d1, d2, a, s, y3);

  initial begin
    d1 = 0;
    d2 = 0;
    a = 0;
    s = 0;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 {d1,d2,a,s} = $random;
    #10 $finish();
  end

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
  end
endmodule
