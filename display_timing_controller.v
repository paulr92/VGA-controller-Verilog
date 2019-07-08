module dispaly_timing_controller(
	input clk, rst, 			//Controller pixel clock and reset
	output hs, vs,  			//Output timings to VGA port
	output active_video_area, 	//Enabled when the next clock cycle pixel is in the active video area
	output [9:0] x, y			//Pixel position inside the active area, valid only when active_video_area is asserted
);

//General params
localparam RESET_VALUE = 0;
localparam COUNTER_WIDTH = 10;
//Display timings params -- all parameters are time durations expressed in terms of pixel clocks for Horizontal and lines in Vertical
localparam HS_POLARITY_POSITIVE = 0;
localparam VS_POLARITY_POSITIVE = 0;
//Horizontal timings - clock cycles
localparam H_TOTAL    = 800;
localparam H_SYNC     = 96;
localparam H_BP       = 40;
localparam H_L_BORDER = 8;
localparam H_ADDR_DUR = 640;
localparam H_R_BORDER = 8;
localparam H_FP       = 8;
//Vertical timings - lines
localparam V_TOTAL      = 525;
localparam V_SYNC       = 2;
localparam V_BP         = 25;
localparam V_TOP_BORDER = 8;
localparam V_ADDR_DUR   = 480;
localparam V_BT_BORDER  = 8;
localparam V_FP         = 2;

wire vert_tick, hor_act, vert_act;
wire [10-1:0] hor_ctr_q, vert_ctr_q;

assign vert_tick = 1'b1 ? (hor_ctr_q == H_TOTAL) : 1'b0;

assign hs = (hor_ctr_q < H_SYNC) ? (HS_POLARITY_POSITIVE) : (!HS_POLARITY_POSITIVE);
assign hor_act = (hor_ctr_q > (H_SYNC + H_BP + H_L_BORDER - 1)) && (hor_ctr_q < H_SYNC + H_BP + H_L_BORDER - 1 + H_ADDR_DUR) ;

assign vs = (vert_ctr_q < V_SYNC) ? (VS_POLARITY_POSITIVE) : (!VS_POLARITY_POSITIVE);
assign vert_act = (vert_ctr_q > (V_SYNC + V_BP + V_TOP_BORDER)) && (vert_ctr_q < V_SYNC + V_BP + V_TOP_BORDER + V_ADDR_DUR) ;

px_counter  #(.COUNTER_WIDTH(COUNTER_WIDTH), .TERMINAL_COUNT_VAL(H_TOTAL), .RESET_VALUE(RESET_VALUE)) hor_counter  (.clk(clk), .rst(rst), .en(1'b1), .q(hor_ctr_q));
px_counter  #(.COUNTER_WIDTH(COUNTER_WIDTH), .TERMINAL_COUNT_VAL(V_TOTAL), .RESET_VALUE(RESET_VALUE)) vert_counter (.clk(clk), .rst(rst), .en(vert_tick), .q(vert_ctr_q));

assign active_video_area = hor_act & vert_act;

endmodule