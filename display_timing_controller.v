module dispaly_timing_controller(
	input clk, rst, 			//Controller pixel clock and reset
	output hs, vs,  			//Output timings to VGA port
	output active_video_area, 	//Enabled when the next pixel is in the active video area
	output [9:0] x, y			//Pixel position inside the active area, valid only when active_video_area is asserted
);

wire [10-1:0] hor_ctr_q, vert_ctr_q;

px_counter  #(.COUNTER_WIDTH(10), .TERMINAL_COUNT_VAL(799), .RESET_VALUE(0)) hor_counter  (.clk(clk), .rst(rst), .en(1'b1), .q(hor_ctr_q));
px_counter  #(.COUNTER_WIDTH(10), .TERMINAL_COUNT_VAL(524), .RESET_VALUE(0)) vert_counter (.clk(clk), .rst(rst), .en(1'b1), .q(vert_ctr_q));

endmodule