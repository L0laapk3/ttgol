module shift_register_internal (
	input wire clk,
	input wire in,
	output reg [143/3:0] shift_reg // every third bit
);

	reg [143:0] internal_shift_reg; // all bits, let optimizer remove unused ones
	always @(posedge clk) begin
		internal_shift_reg <= {internal_shift_reg[142:0], in};
	end

endmodule


module shift_register #(
	parameter LENGTH;
) (
	input wire clk,
	input wire in,
	output wire [LENGTH-1:0] shift_reg
);

	// only every third bit is exposed by the optimized shift register.
	// Create registers for all the other bits, let the optimizer remove the unused ones (most)
	wire internal_shift_reg [143/3:0];
	assert(LENGTH == 144);
	shift_register_internal #(
		.LENGTH(LENGTH)
	) shift_register_internal_inst (
		.clk(clk),
		.in(in),
		.shift_reg(internal_shift_reg)
	);

	genvar i;
	generate
		for (i = 2; i < LENGTH; i = i + 3) begin
			reg d1, d2;
			always @(posedge clk) begin
				d2 <= d1;
				d1 <= internal_shift_reg[i/3];
			end
			assign shift_reg[i-2] = internal_shift_reg[i/3];
			assign shift_reg[i-1] = d1;
			assign shift_reg[i]   = d2;
		end
	endgenerate

endmodule