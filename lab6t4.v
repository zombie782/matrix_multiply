module lab6t4(
	input clk,
	input start,
	input reset,
	output reg done,
	output reg [10:0] clock_count
);

	reg [3:0] state;

	reg signed [7:0] ram1 [0:63];
	
	reg signed [7:0] inx0;
	reg signed [7:0] inx1;
	reg signed [7:0] inx2;
	reg signed [7:0] inx3;
	reg signed [7:0] inx4;
	reg signed [7:0] inx5;
	reg signed [7:0] inx6;
	reg signed [7:0] inx7;
	reg signed [7:0] iny;
	
	wire [2:0] term;
	wire next;
	
	wire [5:0] a_index0;
	wire [5:0] a_index1;
	wire [5:0] a_index2;
	wire [5:0] a_index3;
	wire [5:0] a_index4;
	wire [5:0] a_index5;
	wire [5:0] a_index6;
	wire [5:0] a_index7;
	wire [5:0] b_index;
	
	wire signed [7:0] val0;
	wire signed [7:0] val1;
	wire signed [7:0] val2;
	wire signed [7:0] val3;
	wire signed [7:0] val4;
	wire signed [7:0] val5;
	wire signed [7:0] val6;
	wire signed [7:0] val7;
	
	reg [6:0] entry;
	
	wire keep_going;
	
	wire signed [18:0] mac_out0;
	wire signed [18:0] mac_out1;
	wire signed [18:0] mac_out2;
	wire signed [18:0] mac_out3;
	wire signed [18:0] mac_out4;
	wire signed [18:0] mac_out5;
	wire signed [18:0] mac_out6;
	wire signed [18:0] mac_out7;
	
	reg mac_reset;
	
	reg signed [18:0] out_val0;
	reg signed [18:0] out_val1;
	reg signed [18:0] out_val2;
	reg signed [18:0] out_val3;
	reg signed [18:0] out_val4;
	reg signed [18:0] out_val5;
	reg signed [18:0] out_val6;
	reg signed [18:0] out_val7;
	reg signed [18:0] out_val_mux;
	
	reg [5:0] out_loc;
	
	counter8 cnt(.clk(clk),.en(keep_going),.reset(reset),.count(term),.fin(next));
	
	mac m0(.clk(clk),.macc_clear(reset || mac_reset),.x(inx0),.y(iny),.s(mac_out0));
	mac m1(.clk(clk),.macc_clear(reset || mac_reset),.x(inx1),.y(iny),.s(mac_out1));
	mac m2(.clk(clk),.macc_clear(reset || mac_reset),.x(inx2),.y(iny),.s(mac_out2));
	mac m3(.clk(clk),.macc_clear(reset || mac_reset),.x(inx3),.y(iny),.s(mac_out3));
	mac m4(.clk(clk),.macc_clear(reset || mac_reset),.x(inx4),.y(iny),.s(mac_out4));
	mac m5(.clk(clk),.macc_clear(reset || mac_reset),.x(inx5),.y(iny),.s(mac_out5));
	mac m6(.clk(clk),.macc_clear(reset || mac_reset),.x(inx6),.y(iny),.s(mac_out6));
	mac m7(.clk(clk),.macc_clear(reset || mac_reset),.x(inx7),.y(iny),.s(mac_out7));
	
	octo_read_ram ram0(.addr0(a_index0),.addr1(a_index1),.addr2(a_index2),.addr3(a_index3),
							 .addr4(a_index4),.addr5(a_index5),.addr6(a_index6),.addr7(a_index7),
							 .val0(val0),.val1(val1),.val2(val2),.val3(val3),
							 .val4(val4),.val5(val5),.val6(val6),.val7(val7));
	
	ram_out RAMOUTPUT(.clk(clk),.val(out_val_mux),.loc(out_loc));
	
	assign keep_going=(state==3'b001 || state==3'b100)?1'b1:1'b0;
	
	assign a_index0=entry%7'd8+7'd8*term;
	assign a_index1=(entry+1)%7'd8+7'd8*term;
	assign a_index2=(entry+2)%7'd8+7'd8*term;
	assign a_index3=(entry+3)%7'd8+7'd8*term;
	assign a_index4=(entry+4)%7'd8+7'd8*term;
	assign a_index5=(entry+5)%7'd8+7'd8*term;
	assign a_index6=(entry+6)%7'd8+7'd8*term;
	assign a_index7=(entry+7)%7'd8+7'd8*term;
	
	assign b_index=entry-entry%7'd8+term;
	
	initial begin
		$readmemb("ram_b_init.txt",ram1);
	end
	
	always @(posedge clk) begin
		if(reset==1'b1) begin
			state<=4'b0000;
			clock_count<=11'd0;
			done<=1'd0;
		end
		else if(state==4'b0000) begin
			if(start==1'b1) begin
				clock_count<=clock_count+11'd1;
				state<=4'b0001;
			end
			done<=1'd0;
		end
		else if(state==4'b0001) begin
			clock_count<=clock_count+11'd1;
			if(next==1'b1)
				state<=4'b0010;
			done<=1'd0;
		end
		else if(state==4'b0010) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b0101;
			done<=1'd0;
		end
		else if(state==4'b0011) begin
			clock_count<=clock_count+11'd1;
			done<=1'd1;
		end
		else if(state==4'b0100) begin
			clock_count<=clock_count+11'd1;
			state<=4'b0001;
			done<=1'd0;
		end
		else if(state==4'b0101) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b0110;
			done<=1'd0;
		end
		else if(state==4'b0110) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b0111;
			done<=1'd0;
		end
		else if(state==4'b0111) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b1000;
			done<=1'd0;
		end
		else if(state==4'b1000) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b1001;
			done<=1'd0;
		end
		else if(state==4'b1001) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b1010;
			done<=1'd0;
		end
		else if(state==4'b1010) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b1011;
			done<=1'd0;
		end
		else if(state==4'b1011) begin
			clock_count<=clock_count+11'd1;
			state<=(entry==7'b100_0000)?4'b0011:4'b0100;
			done<=1'd0;
		end
	end
	
	always @(term,state,keep_going) begin
		case(state)
			4'b0000: begin
				mac_reset=1'b1;
				inx0=8'd0;
				inx1=8'd0;
				inx2=8'd0;
				inx3=8'd0;
				inx4=8'd0;
				inx5=8'd0;
				inx6=8'd0;
				inx7=8'd0;
				iny=8'd0;
				entry=7'd0;
			end
			4'b0001: begin
				mac_reset=1'b0;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
			end
			4'b0010: begin
				mac_reset=1'b1;
				out_val0=mac_out0;
				out_val1=mac_out1;
				out_val2=mac_out2;
				out_val3=mac_out3;
				out_val4=mac_out4;
				out_val5=mac_out5;
				out_val6=mac_out6;
				out_val7=mac_out7;
				out_val_mux=out_val0;
				out_loc=entry;
			end
			4'b0100: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
			end
			4'b0101: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
				out_val_mux=out_val1;
				out_loc=entry+7'd1;
			end
			4'b0110: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
				out_val_mux=out_val2;
				out_loc=entry+7'd2;
			end
			4'b0111: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
				out_val_mux=out_val3;
				out_loc=entry+7'd3;
			end
			4'b1000: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
				out_val_mux=out_val4;
				out_loc=entry+7'd4;
			end
			4'b1001: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
				out_val_mux=out_val5;
				out_loc=entry+7'd5;
			end
			4'b1010: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
				out_val_mux=out_val6;
				out_loc=entry+7'd6;
			end
			4'b1011: begin
				mac_reset=1'b1;
				inx0=val0;
				inx1=val1;
				inx2=val2;
				inx3=val3;
				inx4=val4;
				inx5=val5;
				inx6=val6;
				inx7=val7;
				iny=ram1[b_index];
				out_val_mux=out_val7;
				out_loc=entry+7'd7;
				entry=entry+7'd8;
			end
		endcase
	end
	
endmodule
