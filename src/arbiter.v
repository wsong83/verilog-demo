module ArbStatic3 (input clk, rstn,
                   input [2:0] req_i,
                   output [2:0] ack_i,
                   output req_o,
                   input ack_o);
  reg [2:0] ack_i;

  assign req_o = |req_i;

  always @(req_i, ack_o) begin
    if(ack_o)
      casez(req_i)
      3'b??1:  ack_i = 3'b001;
      3'b?10:  ack_i = 3'b010;
      3'b100:  ack_i = 3'b100;
      default: ack_i = 3'b000;
      endcase
    else
      ack_i = 3'b000;
  end

endmodule

module ArbStatic
  #(parameter N=8)
   (input clk, rstn,
   input [N-1:0] req_i,
   output [N-1:0] ack_i,
   output req_o,
   input ack_o);

  genvar i;

  assign req_o = |req_i;

  generate for(i=0; i<N; i=i+1) begin
    if(i==0)
      assign ack_i[i] = req_i[i] & ack_o;
    else
      assign ack_i[i] = (~ack_i[i-1]) & req_i[i] & ack_o;
  end endgenerate

endmodule

module ArbPriority
  #(parameter N=8)
   (input clk, rstn,
   input [N-1:0] req_i,
   input [N-1:0] prio,
   output [N-1:0] ack_i,
   output req_o,
   input ack_o);

  genvar i;
  wire [2*N-1:0] ack_m, prio_m, req_m, ack_en;

  assign req_o = |req_i;
  assign prio_m = {{N{1'b0}}, prio};
  assign req_m = {req_i, req_i};
  assign ack_i = ack_m[2*N-1:N] | ack_m[N-1:0];

  generate for(i=0; i<2*N; i=i+1) begin
    if(i==0)
      assign ack_en[i] = prio_m[i];
      assign ack_m[i] = ack_en[i] & req_m[i] & ack_o;
    else
      assign ack_en[i] = ack_en[i-1] | prio_m[i];
      assign ack_m[i] = ack_en[i] & ~ack_m[i-1] & req_m[i] & ack_o;
  end endgenerate

endmodule

module ArbRR
  #(parameter N=8)
   (input clk, rstn,
   input [N-1:0] req_i,
   output [N-1:0] ack_i,
   output req_o,
   input ack_o);

  genvar i;
  reg [N-1:0] prio;

  assign req_o = |req_i;
  wire [2*N-1:0] ack_m, prio_m, req_m, ack_en;
  assign prio_m = {{N{1'b0}}, prio_m};
  assign req_m = {req_i, req_i};
  assign ack_i = ack_m[2*N-1:N] | ack_m[N-1:0];

  always @(posedge clk or negedge rstn)
    if(~rstn)      prio <= 0;
    else if(ack_o) prio <= {ack_i[N-2:0], ack_i[N-1]};

  generate for(i=0; i<2*N; i=i+1) begin
    if(i==0)
      assign ack_en[i] = prio_m[i];
      assign ack_m[i] = ack_en[i] & req_m[i] & ack_o;
    else
      assign ack_en[i] = ack_en[i-1] | prio_m[i];
      assign ack_m[i] = ack_en[i] & ~ack_m[i-1] & req_m[i] & ack_o;
  end endgenerate

endmodule
