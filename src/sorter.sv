module BM2
  #(parameter dw=8, dir = 0)
   (input [1:0][dw-1:0]  d_in,
    output [1:0][dw-1:0] d_out);
   wire                  swap;
   assign swap  = dir ^ (d_in[0] > d_in[1]);
   assign d_out = swap ? {d_in[0],d_in[1]} :d_in;
endmodule

module BM4
  #(parameter dw=8, dir = 0)
   (
    input [3:0][dw-1:0]  d_in,
    output [3:0][dw-1:0] d_out
    );

   wire [3:0][dw-1:0]    data; 
   wire [1:0]            swap;

   genvar                i;

   generate for (i=0; i<2; i=i+1) begin
      assign swap[i]   = dir ^ (d_in[i] > d_in[2+i]);
      assign data[i]   = swap[i] ? d_in[2+i] : d_in[i];
      assign data[2+i] = swap[i] ? d_in[i]   : d_in[2+i];
   end endgenerate

   BM2 #(dw, dir) M0 (data[1:0], d_out[1:0]);
   BM2 #(dw, dir) M1 (data[3:2], d_out[3:2]);

endmodule

module BM8
  #(parameter dw=8, dir = 0)
   (
    input [7:0][dw-1:0]  d_in,
    output [7:0][dw-1:0] d_out
    );

   wire [7:0][dw-1:0]    data; 
   wire [3:0]            swap;

   genvar                i;

   generate for (i=0; i<4; i=i+1) begin
      assign swap[i]   = dir ^ (d_in[i] > d_in[4+i]);
      assign data[i]   = swap ? d_in[4+i] : d_in[i];
      assign data[4+i] = swap ? d_in[i]   : d_in[4+i];
   end endgenerate

   BM4 #(dw, dir) M0 (data[3:0], d_out[3:0]);
   BM4 #(dw, dir) M1 (data[7:4], d_out[7:4]);

endmodule

module BM
  #(parameter LP=3, dw=8, dir = 0)
   (
    input [2**LP-1:0][dw-1:0]  d_in,
    output [2**LP-1:0][dw-1:0] d_out
    );
   localparam PN = 2**LP;
   localparam HPN = PN/2;
   wire [PN-1:0][dw-1:0]       data; 
   wire [HPN-1:0]              swap;

   genvar                      i;

   generate
      if(LP==1)
        BM2 #(dw, dir) B(d_in, d_out);
      else begin
         for (i=0; i<HPN; i=i+1) begin
            assign swap[i]     = dir ^ (d_in[i] > d_in[HPN+i]);
            assign data[i]     = swap[i] ? d_in[HPN+i] : d_in[i];
            assign data[HPN+i] = swap[i] ? d_in[i]     : d_in[HPN+i];
         end
         BM #(LP-1, dw, dir) M0 (data[HPN-1:0],  d_out[HPN-1:0]);
         BM #(LP-1, dw, dir) M1 (data[PN-1:HPN], d_out[PN-1:HPN]);
      end
   endgenerate

endmodule

module BN
  #(parameter LP=3, dw=8, dir = 0)
   (
    input [2**LP-1:0][dw-1:0]  d_in,
    output [2**LP-1:0][dw-1:0] d_out
    );
   localparam PN = 2**LP;
   localparam HPN = PN/2;
   wire [PN-1:0][dw-1:0]       data;

   genvar                      i;

   generate
      if(LP==1)
        BM2 #(dw, dir) B(d_in, d_out);
      else begin
         BN #(LP-1, dw, 0) BN0 (d_in[HPN-1:0],  data[HPN-1:0]);
         BN #(LP-1, dw, 1) BN1 (d_in[PN-1:HPN], data[PN-1:HPN]);
         BM #(LP, dw, dir) BMOut (data, d_out); 
      end
   endgenerate

endmodule

module seq_merger
  #(parameter dw=8, L=16)
   (
    input           clk, rstn,
    input [dw-1:0]  data_a, input req_a, output ack_a,
    input [dw-1:0]  data_b, input req_b, output ack_b,
    output [dw-1:0] data_o, output req_o, input ack_o
    );

   wire [dw-1:0]    A, B;
   wire             Areq, Aack, Breq, Back, sel;

   fifo #(.L(16), .dw(dw)) fifoA (clk, rstn, data_a, req_a, ack_a, A, Areq, Aack);
   fifo #(.L(16), .dw(dw)) fifoB (clk, rstn, data_b, req_b, ack_b, B, Breq, Back);

   assign sel = A > B;
   assign data_o = sel ? B : A;
   assign req_o = Areq | Breq;
   assign Aack = Areq & ack_o & !sel;
   assign Back = Breq & ack_o & sel;

endmodule
