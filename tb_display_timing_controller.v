`timescale 1ns/1ps

module tb_display_timing_controller();
	//Stimulus parameters
	parameter real CLK_PERIOD = 40.0; // 25MHZ clock -> 40ns period
	//Stimulus signals declarations
	reg clk, rst;
	//DUT output signals
	wire hs, vs, active_video_area;
	wire [9:0] x, y;
	//Instantiate DUT
	dispaly_timing_controller DUT( .clk(clk), .rst(rst), .hs(hs), .vs(vs), .active_video_area(active_video_area), .x(x), .y(y));

	//Stimulus signals generation
	//Reset generation
	initial begin
		rst = 1;
		repeat (2) #CLK_PERIOD;
		rst = 0;
	end

	//Clock generation
	initial begin
		clk = 0;
		forever begin
			#(CLK_PERIOD/2);
			clk = 1;
			#(CLK_PERIOD/2);
			clk = 0;
		end
	end
endmodule