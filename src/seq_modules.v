module burst_detect #(parameter N=3) (
  input clk,
  input x,
  output y);

  reg [N-1:0] cnt;  // 计数器
  always @(posedge clk) begin
    if(x==0) cnt <= 0;
    else if(cnt != N-1) cnt <= cnt + 1;
  end

  assign y = (cnt == N-1) & x;

endmodule

module counterN #(parameter num=10) (
  input clk, rstn,
  output [3:0] q,
  output c);

  reg [3:0] q;
  always @(negedge clk or negedge rstn)
    if(~rstn)   q <= 0;
    else if(c)  q <= 0;
    else        q <= q + 1;

  assign c = q == num - 1;
endmodule


