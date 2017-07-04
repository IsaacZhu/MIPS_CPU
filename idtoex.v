`timescale 1ns / 1ps

module idtoex(
	input clk,
	input rst_n,
	input regwrite,
	input branch,
	input memwrite,
	input memtoreg,
	input regdst,
	input alusrc,
	input [4:0] alu_op,
	input jump,
	input jr,
	input ld,
	input [7:0] idpcadd,
	input [31:0] r1_dout,
	input [31:0] r2_dout,
	input	[31:0] signimm,
	input [4:0] rd1,
	input [4:0] rd2,
	
	input [4:0] rs,
	input [4:0] rt,
	
	output reg idexregwrite,
	output reg idexmemtoreg,
	output reg idexbranch,
	output reg idexmemwrite,
	output reg idexregdst,
	output reg [4:0] idexalu_op,
	output reg idexalusrc,
	output reg idexjump,
	output reg idexjr,
	output reg idexld,
	
	output reg [7:0] idexpcadd,
	output reg [31:0] idexr1_dout,
	output reg [31:0] idexr2_dout,
	output reg [31:0] idexsignimm,
	output reg [4:0] idexrd1,
	output reg [4:0] idexrd2,
	output reg [4:0] idexrs,
	output reg [4:0] idexrt
    );
	 
initial begin
	idexregwrite=0;
	idexmemtoreg=0;
	idexbranch=0;
	idexmemwrite=0;
	idexregdst=0;
	idexalu_op=0;
	idexalusrc=0;
	idexjump=0;
	idexpcadd=0;
	idexr1_dout=0;
	idexr2_dout=0;
	idexsignimm=0;
	idexrd1=0;
	idexrd2=0;
	idexrs=0;
	idexrt=0;
	idexjr=0;
	idexld=0;
end

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) begin
		idexregwrite<=0;
		idexmemtoreg<=0;
		idexbranch<=0;
		idexmemwrite<=0;
		idexregdst<=0;
		idexalu_op<=0;
		idexalusrc<=0;
		idexjump<=0;
		idexjr<=0;
		idexpcadd<=0;
		idexr1_dout<=0;
		idexr2_dout<=0;
		idexsignimm<=0;
		idexrd1<=0;
		idexrd2<=0;
		idexrs<=0;
		idexrt<=0;
		idexld<=0;
	end
	else begin
		idexregwrite<=regwrite;
		idexmemtoreg<=memtoreg;
		idexbranch<=branch;
		idexmemwrite<=memwrite;
		
		idexregdst<=regdst;
		idexalu_op<=alu_op;
		idexalusrc<=alusrc;
		idexjump<=jump;
		idexjr<=jr;
		idexld<=ld;
		
		idexpcadd<=idpcadd;
		idexr1_dout<=r1_dout;
		idexr2_dout<=r2_dout;
		idexsignimm<=signimm;
		idexrd1<=rd1;
		idexrd2<=rd2;
		idexrs<=rs;
		idexrt<=rt;
	end
end

endmodule
