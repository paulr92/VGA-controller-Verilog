module tb_display_timing_controller();

//Stimulus signals
reg clk, rst;
//DUT output signals
wire hs, vs, active_video_area;
wire [9:0] x, y;
//Instantiate DUT
dispaly_timing_controller DUT( .clk(clk), .rst(rst), .hs(hs), .vs(vs), .active_video_area(active_video_area), .x(x), .y(y));

endmodule