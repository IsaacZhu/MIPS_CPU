`timescale 1ns / 1ps

module code(
	input rst_n,
	input clk,
	input [15:0] reg1,
	output reg [3:0] sel,
	output reg [7:0] light
);

reg [1:0] flag = 2'b00;
reg [16:0] cnt_div=17'h0;
reg [7:0] out_num = 8'h0;

always@(posedge  clk or negedge rst_n)
begin
	if (~rst_n)
		cnt_div <= 17'h0;
	else begin
		if(cnt_div == 17'd99_99)//99_999
		begin
			cnt_div <= 17'h0;
			if (flag == 2'b11)
				flag <= 2'b00;
			else 
				flag <= flag + 2'b01;
		end
		else
			cnt_div <= cnt_div + 17'h1;
	end
end

always @(posedge clk) 
begin
	case(flag)
		2'b00: 
			begin
				out_num <= reg1[15:12];
				//sel <= 4'b1110;
				sel<=4'b0111;
			end
		2'b01: 
			begin
			out_num <= reg1[11:8];
			//sel <= 4'b1101;
			sel<=4'b1011;
			end
		2'b10: 
			begin
			out_num <= reg1[7:4];
			//sel <= 4'b1011;
			sel<=4'b1101;
			end
		2'b11: 
			begin
			out_num <= reg1[3:0];
			//sel <= 4'b0111;
			sel<=4'b1110;
			end
		default:
			begin
			out_num <= reg1[15:12];
			sel <= 4'b1110;
			end
	endcase
end

always @(posedge clk or negedge rst_n) 
begin
	if (~rst_n)//Êä³öÎª1
		light <= 8'b1111_1111;
	else begin
		case (out_num)
		4'h0: light<=8'b0000_0011;
		4'h1: light<=8'b1001_1111;
		4'h2: light<=8'b0010_0101;
		4'h3: light<=8'b0000_1101;
		4'h4: light<=8'b1001_1001;
		4'h5: light<=8'b0100_1001;
		4'h6: light<=8'b0100_0001;	
		4'h7: light<=8'b0001_1111;
		4'h8: light<=8'b0000_0001;
		4'h9: light<=8'b0000_1001;
/*10*/4'b1010: light<=8'b0001_0001;
/*11*/4'b1011: light<=8'b1100_0001;
/*12*/4'b1100: light<=8'b0110_0011;
/*13*/4'b1101: light<=8'b1000_0101;
/*14*/4'b1110: light<=8'b0110_0001;
/*15*/4'b1111: light<=8'b0111_0001;
		default: light<=8'b1111_1111;
	endcase
	end	
end

endmodule
