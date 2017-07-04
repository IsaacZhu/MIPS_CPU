`timescale 1ns / 1ps

module iftoid(
	input clk,
	input rst_n,
	input [7:0] pcadd,
	input [31:0] inst,
	input idstall,
	input stall,
	input ifidwrite,
	input flush,//�ſ�
	output reg [7:0] npcadd,
	output reg [31:0] ninst,
	output [4:0] rs,
	output [4:0] rt
    );

initial begin
	npcadd=0;
	ninst=0;
end

assign rs=ninst[25:21];
assign rt=ninst[20:16];

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
		npcadd<=0;
		ninst<=0;
	end
	else begin
		npcadd<=pcadd;
		//if (idstall) ninst<=0;//����
		//else if (stall) ninst<=0; //����
		if (idstall||stall||flush) ninst<=0;//�������ſ�
		else if (~ifidwrite) ;//load���
		else ninst<=inst;
	end
end

endmodule
