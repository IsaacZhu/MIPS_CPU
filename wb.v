`timescale 1ns / 1ps

module wb(
	input rst_n,
	input mwmemtoreg,
	input [31:0] mwaluresult,
	input [31:0] mwdata,
	output reg [31:0] r3_din
    );

initial r3_din=0;

always@(*)
begin
	if (~rst_n)
		r3_din=0;
	else if (mwmemtoreg)
		r3_din=mwdata;
	else
		r3_din=mwaluresult;
end

endmodule
