`timescale 1ns / 1ps

module ex(
	input rst_n,
	input  idexregdst,
	input  [4:0] idexalu_op,
	input  idexalusrc,
	input  idexjump,
	input  idexjr,
	
	input  [7:0] idexpcadd,
	input  [31:0] idexr1_dout,
	input  [31:0] idexr2_dout,
	input  [31:0] idexsignimm,
	input  [4:0] idexrd1,
	input  [4:0] idexrd2,
	
	input  [4:0] idexrs,
	input  [4:0] idexrt,
	input  [4:0] exmrd,
	input  exmregwrite,
	input  [4:0] r3_addr,
	input  mwregwrite,
	input  [31:0] exmaluresult,
	input  [31:0] r3_din,
		
	output reg [7:0] addout,
	output [31:0] aluresult,
	output reg [4:0] idrd,
	output reg [31:0] exr2_dout,
	output zero
    );

reg [31:0] srca=0;
reg [31:0] srcb=0;
reg [1:0] alusrca=0;
reg [1:0] alusrcb=0;


initial begin
	addout=0;
	idrd=0;
end
/***********forwarding unit******/  // output [1:0] alusrca and [1:0] alusrcb
/*
always@(*)
begin
	if ((exmrd==idexrs||exmrd==idexrt)&&exmregwrite==1)  begin//相邻指令相关
		if (exmrd==idexrs) begin//第一个操作数是上一指令的结果 
			alusrca=2'b01;
			if (r3_addr==idexrt&&mwregwrite==1)//第二个操作数是上上条指令结果
				alusrcb=2'b10;
			else
				alusrcb=2'b00;
		end
		else begin										//exmrd==idexrt 第二个操作数是上一指令结果
			alusrcb=2'b01;
			if (r3_addr==idexrs&&mwregwrite==1)//第一个操作数是上上条指令结果
				alusrca=2'b10;
			else										  //第一个操作数不是上上条指令结果
				alusrca=2'b00;
		end
	end
	else begin//相邻指令未相关
		if ((r3_addr==idexrs||r3_addr==idexrt)&&mwregwrite==1) begin//与上上条指令相关
			if (r3_addr==idexrs) begin        //第一个操作数与上上条指令相关
				alusrca=2'b10;
				alusrcb=2'b00;
			end
			else begin
				alusrca=2'b00;
				alusrcb=2'b10;
			end
		end
		else begin            //未发生RAW
			alusrca=2'b00;
			alusrcb=2'b00;
		end
	end	
end
*/

always@(*)
begin
	if (exmrd==idexrs&&exmregwrite==1)//第一个操作数是上一指令的结果
		alusrca=2'b01;
	else if (r3_addr==idexrs&&mwregwrite==1)//第一个操作数是上上条指令结果
		alusrca=2'b10;
	else 
		alusrca=2'b00;
end

always@(*)
begin
	if (exmrd==idexrt&&exmregwrite==1)//第二个操作数是上一指令的结果
		alusrcb=2'b01;
	else if (r3_addr==idexrt&&mwregwrite==1)//第二个操作数是上上条指令结果
		alusrcb=2'b10;
	else 
		alusrcb=2'b00;
end


/************pcadd*addrmux********/
reg [7:0] initaddout=0;
always@(*)
begin
	initaddout=idexpcadd+idexsignimm[7:0];
end

reg [31:0] jrreg=0;
always@(*)
begin
	case (alusrca)
			2'b00: jrreg=idexr1_dout;
			2'b01: jrreg=exmaluresult;
			2'b10: jrreg=r3_din;
			default:jrreg=idexr1_dout;
	endcase 
end

always@(*)
begin
	case({idexjump,idexjr})
		2'b00:addout=initaddout; //branch 
		2'b01:addout=jrreg[7:0];//jr
		2'b10:addout=idexsignimm[7:0];//jump
		default:addout=0;
	endcase
end

/***********alumuxa**************/
always@(*)
begin
	if (~rst_n)
		srca=0;
	else begin//from reg
		case (alusrca)
			2'b00: 
				begin
					if (idexalu_op==5'h9||idexalu_op==5'h14) begin//sll or srl
						case (alusrcb) //相关
							2'b00: srca=idexr2_dout;
							2'b01: srca=exmaluresult;
							2'b10: srca=r3_din;
						default:srca=idexr2_dout;
						endcase 
					end
					else
					srca=idexr1_dout;
				end
			2'b01: srca=exmaluresult;
			2'b10: srca=r3_din;
			default:srca=idexr1_dout;
		endcase 
	end
end

/***********alumuxb**************/
always@(*)
begin
	if (~rst_n)
		srcb=0;
	else if (idexalusrc)//imm
		srcb=idexsignimm;
	else begin//from reg
		case (alusrcb)
			2'b00: srcb=idexr2_dout;
			2'b01: srcb=exmaluresult;
			2'b10: srcb=r3_din;
			default:srcb=idexr2_dout;
		endcase 
	end
end

/***********exr2_dout*********/
always@(*)
begin
	case (alusrcb)
		2'b00: exr2_dout=idexr2_dout;
		2'b01: exr2_dout=exmaluresult;
		2'b10: exr2_dout=r3_din;
		default:exr2_dout=idexr2_dout;
	endcase
end		
/***********alu******************/
ALU ALU2(
	.alu_a(srca),
	.alu_b(srcb),
	.alu_op(idexalu_op),
	.alu_out(aluresult),
	.zero(zero)
);

/**********regmux****************/
always@(*)
begin
	if (idexregdst)
		idrd=idexrd2;
	else
		idrd=idexrd1;
end

endmodule
