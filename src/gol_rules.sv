module gol_rules #(
	parameter WIDTH,
	parameter HEIGHT
) (
	input wire clk,
	input wire rst_n,
	// previous game state around current cell - from shift register
	input wire [2:0] IN_ABOVE,
	input wire [2:0] IN_CURRENT,
	input wire [2:0] IN_BELOW,
	// output for next game state of current cell
	output reg       OUT
);

	reg [2:0] above;
	reg [2:0] current;
	reg [2:0] below;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			above <= 0;
			current <= 0;
			below <= 0;
			OUT <= 0;
		end else begin
			above <= IN_ABOVE;
			current <= IN_CURRENT;
			below <= IN_BELOW;

			// Count live neighbors
			integer live_neighbors = above[0] + above[1] + above[2] +
									 current[0] + current[2] +
									 below[0] + below[1] + below[2];

			// Apply Game of Life rules
			OUT <= ((live_neighbors == 2 && current[1]) || live_neighbors == 3) ? 1 : 0;
		end
	end


endmodule