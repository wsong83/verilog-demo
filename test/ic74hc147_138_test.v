`timescale 1ns/1ps

module test;
  reg  [2:0] data_org;
  wire [7:0] data_one_hot;
  wire [3:0] data_gen;

  ic74hc138  decoder(data_org, 3'b001, data_one_hot);
  ic74hc147  encoder({2'b11,data_one_hot}, data_gen);

  initial begin
    data_org = 0;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 data_org = $random;
    #10 $finish();
  end

  wire OK;
  assign OK = {1'b0,data_org} == ~data_gen;

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
  end
endmodule
