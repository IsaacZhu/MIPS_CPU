`timescale 1ns / 1ps

module div(
	input initclk,
	output reg clk
    );

reg [1:0] count=0;
initial clk=0;
always@(posedge initclk)
begin
	if (count==2'b11) begin
		clk<=~clk;
		count<=count+1;
	end
	else count<=count+1;
end

endmodule
