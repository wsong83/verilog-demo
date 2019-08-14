
// 1位全加器
module adder(input a, b, ci, output s, co);
  assign s = a ^ b ^ ci;
  assign co = (a&b) | (b&ci) | (a&ci);
endmodule

// 串行4位加法器
module add4(
  input [3:0] a, b,
  output [3:0] s,
  output co );
  wire [2:0] m; // internal wire
  adder A0(.a(a[0]), .b(b[0]), .ci(1'b0), .s(s[0]), .co(m[0]));
  adder A1(.a(a[1]), .b(b[1]), .ci(m[0]), .s(s[1]), .co(m[1]));
  adder A2(.a(a[2]), .b(b[2]), .ci(m[1]), .s(s[2]), .co(m[2]));
  adder A3(.a(a[3]), .b(b[3]), .ci(m[2]), .s(s[3]), .co(co));
endmodule

// 并行4位加法器
module adder4(
  input [3:0] a, b,
  output [3:0] s,
  output co );
  assign {co, s} = {1'b0, a} + {1'b0, b};
endmodule

