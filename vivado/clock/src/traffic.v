module traffic(
  input clk,
  input tick,
  output [2:0] lled, rled,
  output [7:0] lcnt, rcnt,
  output lflash, rflash
);

  reg [7:0] cnt;
  reg [25:0] cdiv;

  always @(posedge clk)
    if(tick)
    	cnt <= cnt == 43 ? 0 : cnt + 1;
  
  always @(posedge clk)
    cdiv <= cdiv + 1;
 
  assign lflash = (cnt >= 20 && cnt < 22) || (cnt >= 38) ? cdiv[24] : 1;
  assign rflash = (cnt >= 16 && cnt < 22) || (cnt >= 42) ? cdiv[24] : 1;
  
  // b, g, r; g+r = y
  // 20r 2y 16g 6y
  assign lled[0] = 0;
  assign lled[1] = cdiv[9:6] == 0 && (cnt >= 20) && lflash;
  assign lled[2] = cdiv[9:6] == 0 && (cnt < 22 || cnt >= 38) && lflash;
  assign lcnt = (cnt < 22) ? 22 - cnt : 44 - cnt ;

  // 16g 6y 20r 2y
  assign rled[0] = 0;
  assign rled[1] = cdiv[9:6] == 0 && (cnt < 22 || cnt >= 42) && rflash;
  assign rled[2] = cdiv[9:6] == 0 && (cnt >= 16) && rflash;
  assign rcnt = (cnt < 22) ? 22 - cnt : 44 - cnt ;

endmodule
