module gol_indexer #(
	parameter WIDTH,
	parameter HEIGHT
) (
	input wire clk,
	input wire rst_n,
	input wire [WIDTH*(HEIGHT+1)+1-1:0] shift_reg
	output wire left_rollover,
	output wire right_rollover,
	output wire top_rollover,
	output wire bottom_rollover
);

	reg [$clog2(WIDTH)-1:0]  x;
	reg [$clog2(HEIGHT)-1:0] y;

	wire x_max, y_max;

	always @(*) begin
		x_max = x == WIDTH - 1;
		y_max = y == HEIGHT - 1;
		left_rollover   = x == 0;
		right_rollover  = x_max;
		top_rollover    = y == 0;
		bottom_rollover = y_max;
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			x <= 0;
			y <= 0;
		end else begin
			if (x_max) begin
				x <= 0;
				if (y_max) begin
					y <= 0;
				end else begin
					y <= y + 1;
				end
			end else begin
				x <= x + 1;
			end
		end
	end


endmodule