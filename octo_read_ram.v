module octo_read_ram(
	input [5:0] addr0,
	input [5:0] addr1,
	input [5:0] addr2,
	input [5:0] addr3,
	input [5:0] addr4,
	input [5:0] addr5,
	input [5:0] addr6,
	input [5:0] addr7,
	output signed [7:0] val0,
	output signed [7:0] val1,
	output signed [7:0] val2,
	output signed [7:0] val3,
	output signed [7:0] val4,
	output signed [7:0] val5,
	output signed [7:0] val6,
	output signed [7:0] val7
);
	
	reg signed [7:0] mem [0:63];
	
	assign val0=mem[addr0];
	assign val1=mem[addr1];
	assign val2=mem[addr2];
	assign val3=mem[addr3];
	assign val4=mem[addr4];
	assign val5=mem[addr5];
	assign val6=mem[addr6];
	assign val7=mem[addr7];
	
	initial begin
		$readmemb("ram_a_init.txt",mem);
	end
	
endmodule 