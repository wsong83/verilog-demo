module fifo #(parameter dw=8, L=4)
( input clk, rstn,
  input [dw-1:0] d_in, input req_in, output ack_in,
  output [dw-1:0] d_out, output req_out, input ack_out);

  reg [dw-1:0] data [L-1:0];
  reg [L-1:0] valid;
  reg [L-1:0] wp, rp;

  assign d_out = data[rp];
  assign req_out = valid[rp];
  assign ack_in = ~valid[wp];

  always @(posedge clk or negedge rstn)
    if(~rstn) begin
      wp <= 0; rp <= 0; valid <= 0;
    end else begin
      if(req_in & ack_in) begin
        wp <= wp == L-1 ? 0 : wp + 1;
        valid[wp] <= 1'b1;
        data[wp] <= d_in;
      end

      if(req_out & ack_out) begin
        rp <= rp == L-1 ? 0 : rp + 1;
        valid[rp] <= 1'b0;
      end
    end
endmodule

module fifo0 #(parameter dw=8, L=7)
( input clk, rstn,
  input [dw-1:0] d_in, input req_in, output ack_in,
  output [dw-1:0] d_out, output req_out, input ack_out);

  reg [dw-1:0] data [L-1:0];
  reg [L-1:0] valid;
  reg [L-1:0] wp, rp;
  wire empty;

  assign empty = (wp == rp) & ~valid[rp];
  assign d_out = empty ? d_in : data[rp];
  assign req_out = empty ? req_in : valid[rp];
  assign ack_in = ~valid[wp];

  always @(posedge clk or negedge rstn)
    if(~rstn) begin
      wp <= 0; rp <= 0; valid <= 0;
    end else begin
      if(req_in & ack_in & (~empty | ~ack_out))
      begin
        wp <= wp == L-1 ? 0 : wp + 1;
        valid[wp] <= 1'b1;
        data[wp] <= d_in;
      end

      if(req_out & ack_out & ~empty) begin
        rp <= rp == L-1 ? 0 : rp + 1;
        valid[rp] <= 1'b0;
      end
    end
endmodule

module fifoRO #(parameter dw=8, L=7)
( input clk, rstn,
  input [dw-1:0] d_in, input req_in, output ack_in,
  output [dw-1:0] d_out, output req_out, input ack_out);

  reg [dw-1:0] data [L-1:0];
  reg [L-1:0] valid;
  reg [L-1:0] wp;
  wire full;

  assign d_out = data[0];
  assign req_out = valid[0];
  assign ack_in = ~full;
  assign full = (wp == L-1) & valid[wp];

  integer i;
  always @(posedge clk or negedge rstn)
    if(~rstn) begin
      wp <= 0; valid <= 0;
    end else begin
      if(req_in & ack_in) begin
        data[wp] = d_in;
        valid[wp] = 1'b1;
        if(wp != L-1) wp = wp + 1;
      end

      if(req_out & ack_out) begin
        if(~valid[wp]) wp = wp - 1;
        for(i=0; i<L-1; i=i+1) begin
          data[i] = data[i+1];
          valid[i] = valid[i+1];
        end
        valid[L-1] = 1'b0;
      end
    end

endmodule

module fifoRO_norm #(parameter dw=8, L=7)
( input clk, rstn,
  input [dw-1:0] d_in, input req_in, output ack_in,
  output [dw-1:0] d_out, output req_out, input ack_out);

  reg [dw-1:0] data [L-1:0];
  reg [L-1:0] valid;
  reg [L-1:0] wp;

  assign d_out = data[0];
  assign req_out = valid[0];
  assign ack_in = ~valid[wp];

  integer i;
  always @(posedge clk or negedge rstn)
    if(~rstn) begin
      wp <= 0; valid <= 0;
    end else begin
      if(req_in & ack_in & (~req_out | ~ack_out)) begin
        data[wp] <= d_in;
        valid[wp] <= 1'b1;
        if(wp != L-1) wp <= wp + 1;
      end else if(req_out & ack_out & (~req_in | ~ack_in)) begin
        for(i=0; i<L-1; i=i+1) begin
          data[i] <= data[i+1];
          valid[i] <= valid[i+1];
        end
        valid[L-1] <= 1'b0;
        if(~valid[wp]) wp <= wp - 1;
      end else if(req_in & ack_in & req_out & ack_out) begin
        for(i=0; i<L-1; i=i+1) begin
          data[i] <= wp == i+1 ? d_in : data[i+1];
          valid[i] <= wp == i+1 ? 1'b1 : valid[i+1];
        end
        valid[L-1] <= 1'b0;
      end
    end

endmodule
