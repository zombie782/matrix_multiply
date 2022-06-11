module ram_out(
	input clk,
	input signed [18:0] val,
	input [5:0] loc
);

	reg signed [18:0] mem [0:63];
	
	always @(posedge clk) begin
		mem[loc]=val;
	end

endmodule 