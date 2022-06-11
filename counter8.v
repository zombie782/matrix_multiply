module counter8(
	input clk,
	input en,
	input reset,
	output reg [2:0] count,
	output fin
);

	assign fin=(count==3'd7)?1'b1:1'b0;

	always @(posedge clk) begin
		count<=(reset==1'b1)?3'd0:(en==1'b1)?count+3'd1:count;
	end

endmodule 