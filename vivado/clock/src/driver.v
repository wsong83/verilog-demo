module seg_driver #(parameter NPorts=8) (
  input clk, rstn,
  input [NPorts-1:0]   valid_i,  // input port valid
  input [NPorts*8-1:0] seg_i,    // segment inputs
  output reg [NPorts-1:0]  valid_o,  // output port valid
  output [7:0]         seg_o     // segment outputs
);

  reg [16:0] cnt;
  always @(posedge clk or negedge rstn)
    if(~rstn)
      cnt <= 0;
    else
      cnt <= cnt + 1;

  reg [NPorts-1:0] sel;
  always @(posedge clk or negedge rstn)
    if(~rstn)
      sel <= 0;
    else if(cnt == 0)
      sel <= sel == NPorts - 1 ? 0 : sel + 1;

  always @(sel, valid_i) begin
  	valid_o = {NPorts{1'b1}};
  	valid_o[sel] = ~valid_i[sel];
  end

  assign seg_o = ~seg_i[sel*8+:8];

endmodule
