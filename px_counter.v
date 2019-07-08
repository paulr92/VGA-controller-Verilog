module px_counter
  #(
	parameter COUNTER_WIDTH = 8,
	parameter TERMINAL_COUNT_VAL = 1024,
	parameter RESET_VALUE = 0
   )
   (
    input clk, rst, en,
	output [COUNTER_WIDTH-1:0] q
);



reg [COUNTER_WIDTH-1:0] count_ff, count_d;

assign q = count_ff;

//Combinational Logic
always @(*) begin
	count_d = count_ff;
	if (en) begin
		if (count_ff == TERMINAL_COUNT_VAL)
			count_d = RESET_VALUE;
		else
			count_d = count_ff + 1;
	end
end
//Sequential Logic
always @(posedge clk) begin
	if (rst) begin
		count_ff <= RESET_VALUE;
	end
	else begin
		count_ff <= count_d;
	end
end

endmodule