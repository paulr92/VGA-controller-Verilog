///////////////////////////////////////////////
//Created on: 09.07.2019                     //
//Author: Paul Rusti -> rusti.paul@yahoo.com //
///////////////////////////////////////////////
module dispaly_timing_controller(
	input clk, rst, 			//Controller pixel clock and reset
	output hs, vs,  			//Output timings to VGA port
	output active_video_area, 	//Enabled according to the set PX_BUFFER_LATENCY parameter
	output [9:0] x, y			//Pixel position inside the active area, valid only when active_video_area is asserted
);

//General params
localparam RESET_VALUE = 0;
localparam COUNTER_WIDTH = 10;
localparam PX_BUFFER_LATENCY = 1;	//The active_video_area, x and y signals are asserted according to the required latency of the frame buffer driving the vga data
									//For single buffering set PX_BUFFER_LATENCY to 1, for double buffering set PX_BUFFER_LATENCY to 2(active_video_area, x and y signals are asserted 2 clock cycles earlier than the active area)
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
wire [COUNTER_WIDTH-1:0] hor_ctr_q, vert_ctr_q;

(* translate_off *)	//Simulation only code - not synthesizable
    enum integer { SYNC=0, BACK_PORCH=1, LEFT_TOP_BORDER=2, ADDRESSABLE_TIME=3, RIGHT_BOT_BORDER=4, FRONT_PORCH=5 } state_hor, state_vert;
	always@(*)begin
		if 	    (  hor_ctr_q < H_SYNC ) 									 state_hor = SYNC;
		else if ( (hor_ctr_q >= H_SYNC) && (hor_ctr_q < H_BP + H_SYNC)) state_hor = BACK_PORCH;
		else if ( (hor_ctr_q >= H_BP + H_SYNC) && (hor_ctr_q < H_BP + H_SYNC + H_L_BORDER)) state_hor = LEFT_TOP_BORDER;
		else if ( (hor_ctr_q >= H_BP + H_SYNC + H_L_BORDER) && (hor_ctr_q < H_BP + H_SYNC + H_L_BORDER + H_ADDR_DUR)) state_hor = ADDRESSABLE_TIME;
		else if ( (hor_ctr_q >= H_BP + H_SYNC + H_L_BORDER + H_ADDR_DUR) && (hor_ctr_q < H_BP + H_SYNC + H_L_BORDER + H_ADDR_DUR + H_R_BORDER)) state_hor = RIGHT_BOT_BORDER;
		else if ( (hor_ctr_q >= H_BP + H_SYNC + H_L_BORDER + H_ADDR_DUR + H_R_BORDER) && (hor_ctr_q < H_BP + H_SYNC + H_L_BORDER + H_ADDR_DUR + H_R_BORDER + H_FP)) state_hor = FRONT_PORCH;
	end
	always@(*)begin
		if 	    (  vert_ctr_q < V_SYNC ) 									 state_vert = SYNC;
		else if ( (vert_ctr_q >= V_SYNC) && (vert_ctr_q < V_BP + V_SYNC)) state_vert = BACK_PORCH;
		else if ( (vert_ctr_q >= V_BP + V_SYNC) && (vert_ctr_q < V_BP + V_SYNC + V_TOP_BORDER)) state_vert = LEFT_TOP_BORDER;
		else if ( (vert_ctr_q >= V_BP + V_SYNC + V_TOP_BORDER) && (vert_ctr_q < V_BP + V_SYNC + V_TOP_BORDER + V_ADDR_DUR)) state_vert = ADDRESSABLE_TIME;
		else if ( (vert_ctr_q >= V_BP + V_SYNC + V_TOP_BORDER + V_ADDR_DUR) && (vert_ctr_q < V_BP + V_SYNC + V_TOP_BORDER + V_ADDR_DUR + V_BT_BORDER)) state_vert = RIGHT_BOT_BORDER;
		else if ( (vert_ctr_q >= V_BP + V_SYNC + V_TOP_BORDER + V_ADDR_DUR + V_BT_BORDER) && (vert_ctr_q < V_BP + V_SYNC + V_TOP_BORDER + V_ADDR_DUR + V_BT_BORDER + V_FP)) state_vert = FRONT_PORCH;
	end
(* translate_on *) //END Simulation only code

assign vert_tick = (hor_ctr_q == H_TOTAL-1);

assign hs = (hor_ctr_q < H_SYNC) ? (HS_POLARITY_POSITIVE) : (!HS_POLARITY_POSITIVE);
assign hor_act = (hor_ctr_q >= (H_SYNC + H_BP + H_L_BORDER - PX_BUFFER_LATENCY)) && (hor_ctr_q < H_SYNC + H_BP + H_L_BORDER + H_ADDR_DUR - PX_BUFFER_LATENCY);
assign x = ((hor_ctr_q >= H_SYNC + H_BP + H_L_BORDER - PX_BUFFER_LATENCY) && (hor_ctr_q < H_SYNC + H_BP + H_L_BORDER + H_ADDR_DUR - PX_BUFFER_LATENCY)) ? (hor_ctr_q - H_SYNC - H_BP - H_L_BORDER + PX_BUFFER_LATENCY) : (0);

assign vs = (vert_ctr_q < V_SYNC) ? (VS_POLARITY_POSITIVE) : (!VS_POLARITY_POSITIVE);
assign vert_act = (vert_ctr_q >= (V_SYNC + V_BP + V_TOP_BORDER)) && (vert_ctr_q < V_SYNC + V_BP + V_TOP_BORDER + V_ADDR_DUR);
assign y = ((vert_ctr_q >= V_SYNC + V_BP + V_TOP_BORDER ) && (vert_ctr_q < V_SYNC + V_BP + V_TOP_BORDER + V_ADDR_DUR )) ? (vert_ctr_q - V_SYNC - V_BP - V_TOP_BORDER ) : (0);

px_counter  #(.COUNTER_WIDTH(COUNTER_WIDTH), .TERMINAL_COUNT_VAL(H_TOTAL-1), .RESET_VALUE(RESET_VALUE)) hor_counter  (.clk(clk), .rst(rst), .en(1'b1), .q(hor_ctr_q));
px_counter  #(.COUNTER_WIDTH(COUNTER_WIDTH), .TERMINAL_COUNT_VAL(V_TOTAL-1), .RESET_VALUE(RESET_VALUE)) vert_counter (.clk(clk), .rst(rst), .en(vert_tick), .q(vert_ctr_q));

assign active_video_area = hor_act & vert_act;

endmodule