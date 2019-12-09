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
  wire token[N-1:0];

  assign req_o = |req_i;
  generate for(i=0; i<N; i=i+1) begin
    if(i==0) begin
      assign ack_i[0] = req_i[0] & ack_o;
      assign token[0] = ~req_i[0];
    end else begin
      assign ack_i[i] = token[i-1] & req_i[i] & ack_o;
      assign token[i] = token[i-1] & ~req_i[i];
    end
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
  wire token[2*N-1:0];


  assign req_o = |req_i;
  generate for(i=0; i<N; i=i+1) begin
    if(i==0) begin
      assign ack_i[0] = (prio[0] | token[N-1]) & req_i[0] & ack_o;
      assign token[0] = prio[0] & ~req_i[0];
      assign token[N] = token[N-1] & ~req_i[0];
    end else begin
      assign ack_i[i] = (token[i-1] | prio[i] | token[N+i-1]) & req_i[i] & ack_o;
      assign token[i] = (token[i-1] | prio[i]) & ~req_i[i];
      assign token[N+i] = token[N+i-1] & ~req_i[i];
    end
  end endgenerate
endmodule

module ArbRR #(parameter N=8)
   (input clk, rstn,
   input [N-1:0] req_i,
   output [N-1:0] ack_i,
   output req_o,
   input ack_o);

  genvar i;
  wire token[2*N-1:0];
  reg [N-1:0] prio;

  always @(posedge clk or negedge rstn)
    if(~rstn)      prio <= 1;
    else if(ack_o) prio <= {ack_i[N-2:0], ack_i[N-1]};
  
  assign req_o = |req_i;
  generate for(i=0; i<N; i=i+1) begin
    if(i==0) begin
      assign ack_i[0] = (prio[0] | token[N-1]) & req_i[0] & ack_o;
      assign token[0] = prio[0] & ~req_i[0];
      assign token[N] = token[N-1] & ~req_i[0];
    end else begin
      assign ack_i[i] = (token[i-1] | prio[i] | token[N+i-1]) & req_i[i] & ack_o;
      assign token[i] = (token[i-1] | prio[i]) & ~req_i[i];
      assign token[N+i] = token[N+i-1] & ~req_i[i];
    end
  end endgenerate
endmodule
