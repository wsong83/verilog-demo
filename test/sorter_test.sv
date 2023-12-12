`timescale 1ns/1ps

module test;
  parameter dw = 16;
  parameter LP = 4;

  reg clk;

  reg  [2**LP-1:0][dw-1:0] d_in;
  wire [2**LP-1:0][dw-1:0] d_out;

  BN #(LP, 16, 0) dut(d_in, d_out);

  initial begin
    clk = 0;
    forever #5 clk = !clk;
  end

  always @(posedge clk) begin // set all signals to random values
    int i;
    for(i=0; i<2**LP; i=i+1) begin
      d_in[i] = $random;
    end
  end

  always @(negedge clk) begin
    int i;
    for(i=1; i<2**LP; i=i+1) begin
      assert(d_out[i] >= d_out[i-1]);
      $display("%d: %d >= %d", i, d_out[i], d_out[i-1]);
    end
  end

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
    #1000 $finish();
  end
endmodule
