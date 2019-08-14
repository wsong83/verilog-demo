`timescale 1ns/1ps

module test;
  reg  [7:0] a, b;
  wire [2:0] y, z;
  wire [2:0] i;

  ic74hc85 dut(.a(a[7:4]), .b(b[7:4]), .i(i), .y(y));

  assign i = {a[3:0]>b[3:0], a[3:0]==b[3:0], a[3:0]<b[3:0]};
  assign z = {a>b, a==b, a<b};

  initial begin
    a = 0;
    b = 0;
    #10 a = $random; b = $random;
    #10 a = $random; b = $random;
    #10 a = $random; b = $random;
    #10 a = $random; b = $random;
    #10 a = $random; b = $random;
    #10 a = $random; b = $random;
    #10 a = $random; b = $random;
    #10 $finish();
  end

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
  end
endmodule
