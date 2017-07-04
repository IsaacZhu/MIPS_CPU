`timescale 1ns / 1ps

module instf(
	input clk,
	input rst_n,
	input pcsrc,
	input pcwrite,//����ld���
	input freeze,//������ˮ��
	
	input [7:0] addresult,//branch �� jump ����ʱʹ��
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
	else //��ת
		npc=addresult[7:0];
end
*/

/******pcsrc*****************************/
always@(*)
begin
	if (pcsrc==1)//��ת
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
	else if (pcwrite&&pcsrc) begin //���ܷ�֧��غ�ld��ػ��ͻ
		pc<=addresult[7:0];//tc
	end
	else if (pcwrite&&freeze) begin//����
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
