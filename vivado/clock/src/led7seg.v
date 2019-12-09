module led7seg (
  input [6:0] data,
  input valid,
  output [15:0] seg
);

  reg [3:0]  digit1;
  wire [3:0] digit0;

  always @(valid, data)
         if(data >= 90) digit1 = 9;
    else if(data >= 80) digit1 = 8;
    else if(data >= 70) digit1 = 7;
    else if(data >= 60) digit1 = 6;
    else if(data >= 50) digit1 = 5;
    else if(data >= 40) digit1 = 4;
    else if(data >= 30) digit1 = 3;
    else if(data >= 20) digit1 = 2;
    else if(data >= 10) digit1 = 1;
    else                digit1 = 0;

  assign digit0 = data - digit1 * 10;

  led7seg_decode d0(digit0, valid, seg[7:0]);
  led7seg_decode d1(digit1, valid, seg[15:8]);

endmodule

module led7seg_decode(input [3:0] digit, input valid, output reg [7:0] seg);

  always @(digit)
    if(valid)
      case(digit)
      0: seg = 8'b00111111;
      1: seg = 8'b00000110;
      2: seg = 8'b01011011;
      3: seg = 8'b01001111;
      4: seg = 8'b01100110;
      5: seg = 8'b01101101;
      6: seg = 8'b01111101;
      7: seg = 8'b00000111;
      8: seg = 8'b01111111;
      9: seg = 8'b01101111;
      default: seg = 0;
      endcase
    else seg = 8'd0;

endmodule
