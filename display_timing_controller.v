module dispaly_timing_controller(
	input clk, rst, 			//Controller pixel clock and reset
	output hs, vs,  			//Output timings to VGA port
	output active_video_area, 	//Enabled when the next pixel is in the active video area
	output [9:0] x, y			//Pixel position inside the active area, valid only when active_video_area is asserted
);

endmodule