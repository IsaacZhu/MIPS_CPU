`timescale 1ns / 1ps

module cpu(
	input clk,
	input rst_n,
	input [7:0] dladdr,
	input reading,
	output [31:0] inst,
	output [31:0] data
    );
/*****if*************/	 
wire pcsrc;
wire [7:0] addresult;
wire [7:0] pcadd;
/*****ifid**********/
wire [7:0] npcadd;
wire [31:0] ninst;
wire [4:0] rs;
wire [4:0] rt;
wire stall;
/****id*************/
wire [31:0] r3_din;
wire mwregwrite;
wire [4:0] r3_addr;
wire [31:0] r1_dout;
wire [31:0] r2_dout;
wire memtoreg;
wire memwrite;
wire [4:0] alu_op;
wire alusrc;
wire regdst;
wire regwrite;
wire jump;
wire jr;
wire freeze;
wire ld;
wire pcwrite;
wire ifidwrite;
wire [7:0] idpcadd;
wire [31:0] signimm;
wire [4:0] rd1;
wire [4:0] rd2;
/****idex***********/
wire idexregwrite;
wire idexmemtoreg;
wire idexbranch;
wire idexmemwrite;
wire idexregdst;
wire [4:0] idexalu_op;
wire idexalusrc;
wire idexjump;
wire idexld;
wire [7:0] idexpcadd;
wire [31:0] idexr1_dout;
wire [31:0] idexr2_dout;
wire [31:0] idexsignimm;
wire [4:0] idexrd1;
wire [4:0] idexrd2;
wire [4:0] idexrs;
wire [4:0] idexrt;
/*******ex*************/
wire [7:0] addout;
wire [31:0] aluresult;
wire [4:0] idrd;
wire zero;
wire flush;
wire [31:0] exr2_dout;
/*****extomem**********/
wire exmregwrite;
wire exmmemtoreg;
wire exmbranch;
wire exmmemwrite;
wire [31:0] exmaluresult;	
wire [31:0] exmr2_dout;
wire [4:0] exmrd;
wire exmbgtz;
/*****mem**************/
//wire [31:0] data;
/*****memtowb**********/
wire mwmemtoreg;
wire [31:0] mwdata;
wire [31:0] mwaluresult;
/*****wb***************/

instf u_if(//取指
	.clk(clk),
	.rst_n(rst_n),
	.pcsrc(pcsrc),
	.pcwrite(pcwrite),
	.freeze(stall),
	.addresult(addresult),//be used when branch or jump happenes
	.pcadd(pcadd),
	.inst(inst)
);

stallctrl u_stall(
	.clk(clk),
	.rst_n(rst_n),
	.idstall(freeze),
	.stall(stall)
);

iftoid u_iftoid(
	.clk(clk),
	.rst_n(rst_n),
	.pcadd(pcadd),
	.inst(inst),
	.npcadd(npcadd),
	.ninst(ninst),
	.rs(rs),
	.rt(rt),
	.stall(stall),
	.idstall(freeze),
	.flush(flush),
	.ifidwrite(ifidwrite)
);

id u_id(
	.clk(clk),
	.rst_n(rst_n),
	.npcadd(npcadd),
	.ninst(ninst),
	.idexld(idexld),
	.idexrd1(idexrd1),
	
	.r3_din(r3_din),
	.mwregwrite(mwregwrite),//mem/wb阶段输出的Regwrite
	.r3_addr(r3_addr),
	.r1_dout(r1_dout),
	.r2_dout(r2_dout),
	
 	.memtoreg(memtoreg),
	.memwrite(memwrite),
	.branch(branch),
	.alu_op(alu_op),
	.alusrc(alusrc),
	.regdst(regdst),
	.regwrite(regwrite),
	.jump(jump),
	.jr(jr),
	.freeze(freeze),
	.pcwrite(pcwrite),
	.ifidwrite(ifidwrite),
	.ld(ld),
	.flush(flush),
	.idexbranch(idexbranch),
	
	.idpcadd(idpcadd),
	.signimm(signimm),
	.rd1(rd1),
	.rd2(rd2)
);

idtoex u_idtoex(
	.clk(clk),
	.rst_n(rst_n),
	.regwrite(regwrite),
	.branch(branch),
	.memwrite(memwrite),
	.memtoreg(memtoreg),
	.alu_op(alu_op),
	.alusrc(alusrc),
	.regdst(regdst),
	.jump(jump),
	.jr(jr),
	.ld(ld),
	.idpcadd(idpcadd),
	.r1_dout(r1_dout),
	.r2_dout(r2_dout),
	.signimm(signimm),
	.rd1(rd1),
	.rd2(rd2),
	.rs(rs),
	.rt(rt),
	
	.idexregwrite(idexregwrite),
	.idexmemtoreg(idexmemtoreg),
	.idexbranch(idexbranch),
	.idexmemwrite(idexmemwrite),
	.idexregdst(idexregdst),
	.idexalu_op(idexalu_op),
	.idexalusrc(idexalusrc),
	.idexjump(idexjump),
	.idexjr(idexjr),
	.idexld(idexld),
	
	.idexpcadd(idexpcadd),
	.idexr1_dout(idexr1_dout),
	.idexr2_dout(idexr2_dout),
	.idexsignimm(idexsignimm),
	.idexrd1(idexrd1),
	.idexrd2(idexrd2),
	.idexrs(idexrs),
	.idexrt(idexrt)
);

ex u_ex(
	.rst_n(rst_n),
	.idexregdst(idexregdst),
	.idexalu_op(idexalu_op),
	.idexalusrc(idexalusrc),
	.idexjump(idexjump),
	.idexjr(idexjr),
	.idexpcadd(idexpcadd),
	.idexr1_dout(idexr1_dout),
	.idexr2_dout(idexr2_dout),
	.idexsignimm(idexsignimm),
	.idexrd1(idexrd1),
	.idexrd2(idexrd2),
	.idexrs(idexrs),
	.idexrt(idexrt),
	.exmrd(exmrd),
	.exmregwrite(exmregwrite),
	.r3_addr(r3_addr),
	.mwregwrite(mwregwrite),
	.exmaluresult(exmaluresult),
	.r3_din(r3_din),
	
	.addout(addout),
	.aluresult(aluresult),
	.idrd(idrd),
	.zero(zero),
	
	.exr2_dout(exr2_dout)
);

extomem u_extomem(
	.clk(clk),
	.rst_n(rst_n),
	.idexregwrite(idexregwrite),
	.idexmemtoreg(idexmemtoreg),
	.idexbranch(idexbranch),
	.idexmemwrite(idexmemwrite),
	.addout(addout),
	.aluresult(aluresult),
	.idrd(idrd),
	.zero(zero),
	.exr2_dout(exr2_dout),
	.flush(flush),
	
	.addresult(addresult),
	.exmregwrite(exmregwrite),
	.exmmemtoreg(exmmemtoreg),
	.exmbranch(exmbranch),
	.exmmemwrite(exmmemwrite),
	.exmaluresult(exmaluresult),
	.exmr2_dout(exmr2_dout),
	.exmrd(exmrd),
	.exmbgtz(exmbgtz)
);

umem u_mymem(
	.clk(clk),
	.exmbranch(exmbranch),
	.exmmemwrite(exmmemwrite),
	.exmaluresult(exmaluresult),
	.exmr2_dout(exmr2_dout),
	.exmbgtz(exmbgtz),
	.dladdr(dladdr),
	.reading(reading),
	.data(data),
	.pcsrc(pcsrc),
	.flush(flush),
	.stall(stall)
);

memtowb u_memtowb(
	.clk(clk),
	.rst_n(rst_n),
	.exmregwrite(exmregwrite),
	.exmmemtoreg(exmmemtoreg),
	.exmaluresult(exmaluresult),
	.data(data),
	.exmrd(exmrd),
	.r3_addr(r3_addr),
	.mwregwrite(mwregwrite),
	.mwmemtoreg(mwmemtoreg),
	.mwdata(mwdata),
	.mwaluresult(mwaluresult)
);

wb u_wb(
	.rst_n(rst_n),
	.mwmemtoreg(mwmemtoreg),
	.mwdata(mwdata),
	.mwaluresult(mwaluresult),
	.r3_din(r3_din)
);

endmodule
