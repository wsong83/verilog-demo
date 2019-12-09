module clock(
  input clk, rstn,
  output reg [6:0] ms,
  output reg [6:0] sec,
  output reg [6:0] min,
  output tick_s
);

  reg [19:0] cnt;
  wire tick;

  always @(posedge clk)
  	if(cnt == 1000_000 - 1)
  	  cnt <= 0;
  	else
  	  cnt <= cnt + 1;

  assign tick = cnt == 0;

  always @(posedge clk or negedge rstn) begin
  	if(~rstn)
  		ms <= 0;
  	else if(tick) begin
  	  if(ms == 99) ms <= 0;
  	  else         ms <= ms + 1;
  	end
  end

  always @(posedge clk or negedge rstn) begin
  	if(~rstn)
  	  sec <= 0;
  	else if(ms == 99 && tick) begin
  	  if(sec == 59) sec <= 0;
  	  else          sec <= sec + 1;
  	end
  end

  always @(posedge clk or negedge rstn) begin
  	if(~rstn)
  	  min <= 0;
  	else if(ms == 99 && sec == 59 && tick) begin
  	  if(min == 59) min <= 0;
  	  else          min <= min + 1;
  	end
  end

  assign tick_s = tick && ms == 99;

endmodule