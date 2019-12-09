module top(
  input clk, rstn,
  output [7:0] seg_valid,
  output [7:0] seg_o,
  output [2:0] lled, rled,
  input  sel_traffic
);

  wire [6:0] ms;
  wire [6:0] sec, min;
  wire tick;
  clock u_clock(clk, rstn, ms, sec, min, tick);

  wire [7:0] ms1, ms0;
  wire [7:0] sec1, sec0;
  wire [7:0] min1, min0;
  led7seg u_led7seg_ms (ms,  1'b1, {ms1,  ms0} );
  led7seg u_led7seg_sec(sec, 1'b1, {sec1, sec0});
  led7seg u_led7seg_min(min, 1'b1, {min1, min0});

  wire [7:0] lcnt, rcnt;
  wire lflash, rflash;
  wire [7:0] lcnt1, lcnt0, rcnt1, rcnt0;
  traffic u_traffic(clk, tick, lled, rled, lcnt, rcnt, lflash, rflash);
  led7seg u_led7seg_lt (lcnt,  lflash, {lcnt1,  lcnt0} );
  led7seg u_led7seg_rt (rcnt,  rflash, {rcnt1,  rcnt0} );

  wire [6*8-1:0] seg_data;
  wire [5:0]     seg_ctl;
  assign seg_data = sel_traffic ? {lcnt1, lcnt0, 16'd0, rcnt1, rcnt0} : {min1, min0, sec1, sec0, ms1, ms0};
  assign seg_ctl  = sel_traffic ? 6'b110011 : 6'b111111;
  seg_driver #(6) (clk, rstn, seg_ctl, seg_data, seg_valid[5:0], seg_o);
  assign seg_valid[7:6] = 2'b11;

  
endmodule
