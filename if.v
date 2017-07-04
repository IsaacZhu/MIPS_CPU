`timescale 1ns / 1ps

module instf(
	input clk,
	input rst_n,
	input pcsrc,
	input pcwrite,//处理ld相关
	input freeze,//冻结流水线
	
	input [7:0] addresult,//branch 或 jump 发生时使用
	output reg [7:0] pcadd,
	output [31:0] inst
    );
	 
reg [7:0] pc=0;
reg [7:0] npc=0;
initial begin
	pcadd=0;
end

im u_im(
.a(pc),
.spo(inst)
);

/*****pc+1******************************/
always@(*)
begin
	if (pc==8'd255) ;
	else	pcadd=pc+1;
end

/*****pcsrc*****************************
always@(*)
begin
	if (~pcsrc) 
		npc=pcadd;
	else //跳转
		npc=addresult[7:0];
end
*/

/******pcsrc*****************************/
always@(*)
begin
	if (pcsrc==1)//跳转
		npc=addresult[7:0];
	else if (freeze) ;
	else
		npc=pcadd;
end

reg flag=0;

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n)
		pc<=0;
	else if (pcwrite&&pcsrc) begin //可能分支相关和ld相关会冲突
		pc<=addresult[7:0];//tc
	end
	else if (pcwrite&&freeze) begin//冻结
		if (flag==0) begin
			pc<=pc-1;
			flag<=1;
		end
		else flag<=0;
	end
	else if (pcwrite)
		pc<=npc;
	else ;
end

endmodule
