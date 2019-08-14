module ic74hc85(
  input [3:0] a, b,
  input [2:0] i,
  output [2:0] y);

  reg [2:0] m;

  always @(a, b, i) begin
    if(a > b)      m = 3'b100;
    else if(a < b) m = 3'b001;
    else           m = i;
  end

  assign y = m;
endmodule

module ic74hc153(
  input [3:0] d1, d2,
  input [1:0] a, s,
  output [1:0] y);

  reg [1:0] m;

  always @(d1, d2, a) begin
    if(a == 2'd0)      m = {d2[0], d1[0]};
    else if(a == 2'd1) m = {d2[1], d1[1]};
    else if(a == 2'd2) m = {d2[2], d1[2]};
    else               m = {d2[3], d1[3]};
  end

  assign y = (~s)&m;
endmodule

module ic74hc153_case(
  input [3:0] d1, d2,
  input [1:0] a, s,
  output [1:0] y);

  reg [1:0] m;

  always @(d1, d2, a)
    case(a)
      2'd0:    m = {d2[0], d1[0]};
      2'd1:    m = {d2[1], d1[1]};
      2'd2:    m = {d2[2], d1[2]};
      default: m = {d2[3], d1[3]};
    endcase

  assign y = (~s)&m;
endmodule

module ic74hc153_index(
  input [3:0] d1, d2,
  input [1:0] a, s,
  output [1:0] y);

  wire [1:0] m;

  assign m = {d2[a], d1[a]};
  assign y = (~s)&m;
endmodule

module ic74hc147(
  input [9:0] i,
  output [3:0] y);

  reg [3:0] m;

  always @(i)
    casez(i)
    10'b0?????????: m = ~(4'd9);
    10'b10????????: m = ~(4'd8);
    10'b110???????: m = ~(4'd7);
    10'b1110??????: m = ~(4'd6);
    10'b11110?????: m = ~(4'd5);
    10'b111110????: m = ~(4'd4);
    10'b1111110???: m = ~(4'd3);
    10'b11111110??: m = ~(4'd2);
    10'b111111110?: m = ~(4'd1);
    default:        m = ~(4'd0);
    endcase

  assign y = m;
endmodule

module ic74hc138(
  input [2:0] a, s,
  output [7:0] y);

  reg [7:0] m;

  always @(a, s) begin
    m = 8'b1111_1111;
    if(s == 3'b001)
      m[a] = 1'b0;
  end

  assign y = m;
endmodule

