module mac(
	input clk,
	input macc_clear,
	input signed [7:0] x,
	input signed [7:0] y,
	output signed [18:0] s
);
	reg signed [18:0] stored;
	wire signed [18:0] product;
	
	assign product=x*y;
	assign s=stored;
	
	always @(posedge clk)
		stored<=(macc_clear==1'b1)?product:stored+product;
	
endmodule 