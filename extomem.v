`timescale 1ns / 1ps

module extomem(
	input clk,
	input rst_n,
	
	input idexregwrite,
	input idexmemtoreg,
	input idexbranch,
	input idexmemwrite,
	input [7:0] addout,
	input [31:0] aluresult,
	input [4:0] idrd,
	input zero,
	input [31:0] exr2_dout,
	input flush,//ÅÅ¿ÕÁ÷Ë®Ïß
	
	output reg [7:0] addresult,
	output reg exmregwrite,
	output reg exmmemtoreg,
	output reg exmbranch,
	output reg exmmemwrite,
	output reg [31:0] exmaluresult,
	output reg [31:0] exmr2_dout,
	output reg [4:0] exmrd,
	output reg exmbgtz
    );

initial begin
	addresult=0;
	exmregwrite=0;
	exmmemtoreg=0;
	exmbranch=0;
	exmmemwrite=0;
	exmaluresult=0;
	exmr2_dout=0;
	exmrd=0;
	exmbgtz=0;
end

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n||flush) begin
		addresult<=0;
		exmregwrite<=0;
		exmmemtoreg<=0;
		exmbranch<=0;
		exmmemwrite<=0;
		exmaluresult<=0;
		exmr2_dout<=0;
		exmrd<=0;
		exmbgtz<=0;
	end
	else begin
		addresult<=addout;
		exmregwrite<=idexregwrite;
		exmmemtoreg<=idexmemtoreg;
		exmbranch<=idexbranch;
		exmmemwrite<=idexmemwrite;
		exmaluresult<=aluresult;
		exmr2_dout<=exr2_dout;
		exmrd<=idrd;
		exmbgtz<=zero;
	end
end
endmodule
