`timescale 1ns / 1ps

module ALU(
	input signed [31:0] alu_a,
	input signed [31:0] alu_b,
	input [4:0] alu_op,
	output reg [31:0] alu_out,
	output reg zero
    );

parameter A_NOP = 5'h00; //空运算  
parameter A_ADD = 5'h01; //符号加
parameter A_SUB = 5'h02; //符号减
parameter A_AND = 5'h03; //与
parameter A_OR  = 5'h04; //或
parameter A_XOR = 5'h05; //异或
parameter A_NOR = 5'h06; //或非
parameter A_BGTZ = 5'h7;//判断bgtz是否成立
parameter A_LUI = 5'h8;//用于lui指令 
parameter A_SLL =5'h9;//左移
parameter A_JUMP = 5'h10;//jump 或 jr
parameter A_BNE = 5'h11;//bne 不等则跳转
parameter A_BEQ =5'h12;//beq 相等则跳转
parameter A_SLLV =5'h13;//sllv r-type左移
parameter A_SRL =5'h14;//右移
parameter A_SRLV =5'h15;//srlv r-type右移
parameter A_BLTZ = 5'h16;//判断bltz是否成立
parameter A_BGEZ = 5'h17;//判断bgez是否成立

initial zero=1;

always @(*)
begin
	case (alu_op)
	A_NOP:alu_out = 32'h0;
	A_ADD:alu_out = alu_a + alu_b;
	A_SUB:alu_out = alu_a - alu_b;
	A_AND:alu_out = alu_a & alu_b;
	A_OR: alu_out = alu_a | alu_b;
	A_XOR:alu_out = alu_a ^ alu_b;
	A_NOR:alu_out = ~(alu_a | alu_b);
	A_BGTZ: 
		begin
			if (alu_a[31:31]==0&&alu_a!=31'd0)//alu_a>0
				zero=1;
			else
				zero=0;
		end
	A_LUI:alu_out = {alu_b[15:0],16'd0};
	A_SLL:alu_out = alu_a<<alu_b[10:6];
	A_JUMP:zero=1;
	A_BNE:
		begin
			if (alu_a==alu_b)
				zero=0;
			else
				zero=1;
		end
	A_BEQ:
		begin
			if (alu_a==alu_b)
				zero=1;
			else
				zero=0;
		end
	A_SLLV:alu_out = alu_b<<alu_a[4:0];
	A_SRL:alu_out = alu_a>>alu_b[10:6];
	A_SRLV: alu_out = alu_b>>alu_a[4:0];
	A_BLTZ: 
		begin
			if (alu_a[31:31]==1)//alu_a<0
				zero=1;
			else
				zero=0;
		end
	A_BGEZ: 
		begin
			if (alu_a[31:31]==0)//alu_a>=0
				zero=1;
			else
				zero=0;
		end
	default: alu_out = 32'h0;
	endcase
end


endmodule
