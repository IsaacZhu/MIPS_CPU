`timescale 1ns / 1ps

module memtowb(
	input clk,
	input rst_n,
	input exmregwrite,
	input exmmemtoreg,
	input [31:0] exmaluresult,
	input [31:0] data,
	input [4:0] exmrd,
	
	output reg [4:0] r3_addr,
	output reg mwregwrite,
	output reg mwmemtoreg,
	output reg [31:0] mwdata,
	output reg [31:0] mwaluresult
    );

initial begin
	r3_addr=0;
	mwregwrite=0;
	mwmemtoreg=0;
	mwdata=0;
	mwaluresult=0;
end

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n)begin
		r3_addr<=0;
		mwregwrite<=0;
		mwmemtoreg<=0;
		mwdata<=0;
		mwaluresult<=0;
	end
	else begin
		r3_addr<=exmrd;
		mwregwrite<=exmregwrite;
		mwmemtoreg<=exmmemtoreg;
		mwdata<=data;
		mwaluresult<=exmaluresult;
	end
end
endmodule
