`timescale 1ns / 1ps

module stallctrl(
	input clk,
	input rst_n,
	input idstall,
	output reg stall
    );

reg [1:0] state=0;
initial stall=0;
always@(posedge clk or negedge rst_n)
begin
	if (~rst_n)	begin
		stall<=0;
		state<=0;
	end
	else begin
		case (state)
			2'b00:	
				begin
					if (idstall) begin//检测到stall信号，则进入stall流程
						stall<=1;
						state<=2'b01;
					end
					else
					 state<=2'b00;
				end
			2'b01: state<=2'b10;
			2'b10: 
				begin
					stall<=0;
					state<=2'b00;
				end
			default:;
		endcase
	end
end

endmodule
