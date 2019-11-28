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

