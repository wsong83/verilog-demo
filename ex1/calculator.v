
// 多功能计算器
module calculator (
  input [3:0] a, b,
  input [2:0] s,
  output [4:0] y);

// 下面是计算机的内部实现代码

reg [4:0] y;

always @(a, b, s)
  case(s)
    0: y = {1'b0,a} + {1'b0,b};
    1: y = {1'b0,a} - {1'b0,b};
    2: y = ({1'b0,a} + 16) + ({1'b0,b} + 16) -32; 
    3: y = ({1'b0,a} + 16) - ({1'b0,b} + 16) -32;
    4: y = {2'b0, a==b, a>b, a<b};
    5: y = {2'b0, a==b, ({1'b0, a} + 16)>({1'b0, b}+16), ({1'b0, a} + 16)<({1'b0, b}+16)};
    default: y= 0;
  endcase

endmodule


