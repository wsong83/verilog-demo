`timescale 1ns/1ps

module test;

  reg clk, rstn;
  wire [3:0] q;
  wire c;

  counterN #(12) dut(clk, rstn, q, c);

  initial begin
    //$deposit(dut.q, 0);
    clk = 0; rstn = 0;
    #13 rstn = 1;
    forever #5 clk = ~clk;
  end

  always @(posedge clk)
    if(c & (q != 11)) begin
      $display("error!\n");
      $finish();
    end

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
    #1000 $finish();
  end
endmodule

