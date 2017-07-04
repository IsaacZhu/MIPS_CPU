`timescale 1ns / 1ps

module id(
	input clk,
	input rst_n,
	input [7:0] npcadd,
	input [31:0] ninst,
	
	input [31:0] r3_din,
	input mwregwrite,//mem/wb阶段输出的Regwrite
	input [4:0] r3_addr,
	input idexld,
	input [4:0] idexrd1,
	
	input flush,//排空
	
	input idexbranch, //检测前面是否有分支指令，如果有，则不允许冻结流水线
//	input exmbranch,
	
	output [31:0] r1_dout,
	output [31:0] r2_dout,
	
 	output reg memtoreg,
	output reg memwrite,
	output reg branch,
	output reg [4:0] alu_op,
	output reg alusrc,
	output reg regdst,
	output reg regwrite,
	output reg jump,
	output reg jr,
	output reg freeze,
	output reg ld,
	output reg pcwrite,
	output reg ifidwrite,
	
	output [7:0] idpcadd,
	output reg [31:0] signimm,
	output [4:0] rd1,
	output [4:0] rd2
	);

reg idwrite=1;
reg idstall=0;

initial
begin 
	memtoreg=0;
	memwrite=0;
	branch=0;
	alu_op=5'h0;
	alusrc=0;
	regdst=0;
	regwrite=0;
	jump=0;
	signimm=0;
	jr=0;
	ld=0;
	pcwrite=1;
	ifidwrite=1;
end

assign rd1=ninst[20:16];
assign rd2=ninst[15:11];
assign idpcadd=npcadd;

/*********interlock*****************************/
always@(*)
begin
	if (~rst_n) begin
		pcwrite=1;
		ifidwrite=1;
		idwrite=1;
	end
	else begin
		if (idexld&&(idexrd1==ninst[25:21]||idexrd1==ninst[20:16])) begin //发生了load相关
			pcwrite=0;
			ifidwrite=0;
			idwrite=0;
		end
		else begin
			pcwrite=1;
			ifidwrite=1;
			idwrite=1;
		end
	end
end

/**********control**************/
always@(*)
begin
	if (~rst_n) begin
		;
	end
	else if ((~idwrite)||flush) begin
		memtoreg=0;
		memwrite=0;
		branch=0;
		alu_op=5'h0;
		alusrc=0;
		regdst=1;
		regwrite=0;
		jump=0;
		jr=0;
		idstall=0;
		ld=0;
	end
	else begin
		case (ninst[31:26])
			6'b000000:
			begin
				case (ninst[5:0])//funct
					6'h0: //nop 或 sll
						begin
							if (ninst[10:6]==0) begin //nop
								memtoreg=0;
								memwrite=0;
								branch=0;
								alu_op=5'h0;
								alusrc=0;
								regdst=1;
								regwrite=0;
								jump=0;
								jr=0;
								idstall=0;
								ld=0;
							end
							else begin //sll
								memtoreg=0;
								memwrite=0;
								branch=0;
								alu_op=5'h9;
								alusrc=1;
								regdst=1;
								regwrite=1;
								jump=0;
								jr=0;
								idstall=0;
								ld=0;
							end
						end
					6'h2: //srl
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h14;
							alusrc=1;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h4: //sllv
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h13;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h6: //srlv
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h15;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h8: //jr
						begin
							memtoreg=0;
							memwrite=0;
							branch=1;
							alu_op=5'h10;
							alusrc=0;
							regdst=1;
							regwrite=0;
							jump=0;
							jr=1;
							idstall=1;
							ld=0;
						end
					6'h20://add
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h1;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h21://addu
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h1;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h22: //sub
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h2;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h23: //subu
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h2;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h24://and
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h3;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h25: //or
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h4;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h26: //xor
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h5;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					6'h27: //nor
						begin
							memtoreg=0;
							memwrite=0;
							branch=0;
							alu_op=5'h6;
							alusrc=0;
							regdst=1;
							regwrite=1;
							jump=0;
							jr=0;
							idstall=0;
							ld=0;
						end
					default:;
				endcase
			end
			6'b000001://bltz or bgez
			begin
				memtoreg=0;
				memwrite=0;
				branch=1;
				alusrc=0;
				regdst=0;
				regwrite=0;
				jump=0;
				jr=0;
				idstall=1;
				ld=0;
				case(ninst[20:16])
					5'h0: alu_op=5'h16; //bltz
					5'h1: alu_op=5'h17; //bgez
					default: ;
				endcase
			end
			6'b000010://j
			begin
				memtoreg=0;
				memwrite=0;
				branch=1;
				alu_op=5'h10;
				alusrc=0;
				regdst=0;
				regwrite=0;
				jump=1;
				jr=0;
				idstall=1;
				ld=0;
			end
			6'b000100://beq
			begin
				memtoreg=0;
				memwrite=0;
				branch=1;
				alu_op=5'h12;
				alusrc=0;
				regdst=0;
				regwrite=0;
				jump=0;
				jr=0;
				idstall=1;
				ld=0;
			end
			6'b000101://bne
			begin
				memtoreg=0;
				memwrite=0;
				branch=1;
				alu_op=5'h11;
				alusrc=0;
				regdst=0;
				regwrite=0;
				jump=0;
				jr=0;
				idstall=1;
				ld=0;
			end
			6'b000111://bgtz
			begin
				memtoreg=0;
				memwrite=0;
				branch=1;
				alu_op=5'h7;
				alusrc=0;
				regdst=0;
				regwrite=0;
				jump=0;
				jr=0;
				idstall=1;
				ld=0;
			end
			6'b001000://addi or la
			begin
				memtoreg=0;
				memwrite=0;
				branch=0;
				alu_op=5'h1;
				alusrc=1;
				regdst=0;
				regwrite=1;
				jump=0;
				jr=0;
				idstall=0;
				ld=0;
			end
			6'b001100://andi
			begin
				memtoreg=0;
				memwrite=0;
				branch=0;
				alu_op=5'h3;
				alusrc=1;
				regdst=0;
				regwrite=1;
				jump=0;
				jr=0;
				idstall=0;
				ld=0;
			end
			6'b001101://ori
			begin
				memtoreg=0;
				memwrite=0;
				branch=0;
				alu_op=5'h4;
				alusrc=1;
				regdst=0;
				regwrite=1;
				jump=0;
				jr=0;
				idstall=0;
				ld=0;
			end
			6'b001110://xori
			begin
				memtoreg=0;
				memwrite=0;
				branch=0;
				alu_op=5'h5;
				alusrc=1;
				regdst=0;
				regwrite=1;
				jump=0;
				jr=0;
				idstall=0;
				ld=0;
			end
			6'b001111://lui
			begin
				memtoreg=0;
				memwrite=0;
				branch=0;
				alu_op=5'h8;
				alusrc=1;
				regdst=0;
				regwrite=1;
				jump=0;
				jr=0;
				idstall=0;
				ld=0;
			end
			6'b100011://lw
			begin
				memtoreg=1;
				memwrite=0;
				branch=0;
				alu_op=5'h1;
				alusrc=1;
				regdst=0;
				regwrite=1;
				jump=0;
				jr=0;
				idstall=0;
				ld=1;
			end
			6'b101011://sw
			begin
				memtoreg=0;
				memwrite=1;
				branch=0;
				alu_op=5'h1;
				alusrc=1;
				regdst=0;
				regwrite=0;
				jump=0;
				jr=0;
				idstall=0;
				ld=0;
			end
			default:;
		endcase
	end
end

/********freeze***************/
always@(*)
begin
	if (~rst_n||idexbranch) begin //前面若有分支指令，禁止冻结流水线
		freeze=0;
	end
	else if (branch&&~jump&&~jr) begin //出现branch 需要进行分支预测
		if (ninst[15:15]==1) //向后转移，预测发生
			freeze=1;
		else //向前转移，预测不发生
			freeze=0;
	end
	else if (idstall) //出现j类指令
		freeze=1;
	else freeze=0;
end

/*********reg*****************/
REG_FILE u_reg2(
	.clk(clk),
	.rst_n(rst_n),
	.r3_wr(mwregwrite),
	.r3_addr(r3_addr),
	.r3_din(r3_din),//写入reg
	.r1_addr(ninst[25:21]),//第一个读地址
	.r2_addr(ninst[20:16]),//第二个读地址
	.r1_dout(r1_dout),//第一个输出
	.r2_dout(r2_dout)//第二个输出
);

/*********signextend**************/
always@(*)//将Inst的低16位扩展成32位
begin
	if (ninst[15:15]==0)
		signimm={16'd0,ninst[15:0]};
	else if (alu_op==5'h1|alu_op==5'h2)
		signimm={16'b1111_1111_1111_1111,ninst[15:0]};
	else
		signimm={16'd0,ninst[15:0]};
end
endmodule
