`timescale 1ns/1ps

module test;
  parameter dw = 8;
  parameter L = 7;

  reg clk;
  wire rstn;
  reg [dw-1:0] local_fifo [$];
  integer data_num = 0;
  integer full_num = 0;
  integer empty_num = 0;

  reg [dw-1:0] d_in;
  reg req_in = 1'b0;
  wire ack_in;
  wire [dw-1:0] d_out;
  wire req_out;
  reg ack_out = 1'b1;

  fifoRO_norm dut(clk, rstn, d_in, req_in, ack_in, d_out, req_out, ack_out);

  initial begin
    //$deposit(dut.q, 0);
    clk = 0;
    $deposit(rstn, 1'b0);
    #13;
    $deposit(rstn, 1'b1);
    forever #5 clk = ~clk;
  end

  always @(posedge clk) begin // set all signals to random values
    req_in <= $random;
    d_in <= $random;
    ack_out <= $random;
  end

  always @(negedge clk) begin // checks
    if(req_in & ack_in) begin
      local_fifo.push_back(d_in);
      data_num = data_num + 1;
    end

    if(req_in & ~ack_in) begin
      full_num = full_num + 1;
      $display($stime, ": Recorded a full FIFO.");
    end

    if(req_out & ack_out) begin
      if(local_fifo.pop_front() != d_out) begin
        $display($stime, ": FIFO produce a WRONG number!\n");
        #1;
        $finish();
      end
    end

    if(~req_out & ack_out) begin
      empty_num = empty_num + 1;
      $display($stime, ": Recorded an empty FIFO.\n");
    end

    if(data_num > 50 & empty_num > 5 & full_num > 5) begin
      $display($stime, ": Seems enough tests have been done, finish.\n");
      $finish();
    end
  end

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0);
    #1000000 $finish();
  end
endmodule
