`timescale 1ns / 1ps

module REG_FILE(
	input	clk,
	input	rst_n,
	input	[4:0]	r1_addr,//读地址1
	input	[4:0]	r2_addr,//读地址2
	input	[4:0]	r3_addr,//写地址
	input	[31:0]	r3_din,
	input	r3_wr,//写有效
	output reg [31:0]	r1_dout,   //tc
	output reg [31:0]	r2_dout   //tc
);

reg [31:0] reg1 [31:0];//例化reg,32x2^32
initial 
begin
		reg1[0]<=32'h0;  reg1[1]<=32'h0;  reg1[2]<=32'h0;  reg1[3]<=32'h0;  
		reg1[4]<=32'h0;  reg1[5]<=32'h0;  reg1[6]<=32'h0;  reg1[7]<=32'h0;  
		reg1[8]<=32'h0;  reg1[9]<=32'h0;  reg1[10]<=32'h0; reg1[11]<=32'h0; 
		reg1[12]<=32'h0; reg1[13]<=32'h0; reg1[14]<=32'h0; reg1[15]<=32'h0; 
		reg1[16]<=32'h0; reg1[17]<=32'h0; reg1[18]<=32'h0; reg1[19]<=32'h0; 
		reg1[20]<=32'h0; reg1[21]<=32'h0; reg1[22]<=32'h0; reg1[23]<=32'h0; 
		reg1[24]<=32'h0; reg1[25]<=32'h0; reg1[26]<=32'h0; reg1[27]<=32'h0; 
		reg1[28]<=32'h0; reg1[29]<=32'h0; reg1[30]<=32'h0; reg1[31]<=32'h0; 
end
always@ (posedge clk or negedge rst_n)
begin
	if (~rst_n)
	begin
		reg1[1]<=32'h0;  reg1[2]<=32'h0;  reg1[3]<=32'h0;  reg1[4]<=32'h0;  
		reg1[5]<=32'h0;  reg1[6]<=32'h0;  reg1[7]<=32'h0;  reg1[8]<=32'h0;  
		reg1[9]<=32'h0;  reg1[10]<=32'h0; reg1[11]<=32'h0; reg1[12]<=32'h0; 
		reg1[13]<=32'h0; reg1[14]<=32'h0; reg1[15]<=32'h0; reg1[16]<=32'h0; 
		reg1[17]<=32'h0; reg1[18]<=32'h0; reg1[19]<=32'h0; reg1[20]<=32'h0; 
		reg1[21]<=32'h0; reg1[22]<=32'h0; reg1[23]<=32'h0; reg1[24]<=32'h0; 
		reg1[25]<=32'h0; reg1[26]<=32'h0; reg1[27]<=32'h0; reg1[28]<=32'h0; 
		reg1[29]<=32'h0; reg1[30]<=32'h0; reg1[31]<=32'h0; reg1[0]<=32'h0;  
	end
	else 
	begin
		if (r3_wr)
			reg1[r3_addr]<=r3_din;
		else ;
	end
end

always @(*)
begin
	if (r1_addr==r3_addr&&r3_wr==1)
		r1_dout=r3_din;
	else
		r1_dout=reg1[r1_addr];//读第一个数
end

always @(*)
begin
	if (r2_addr==r3_addr&&r3_wr==1)
		r2_dout=r3_din;
	else
		r2_dout=reg1[r2_addr];//读第一个数
end

//assign r2_dout=reg1[r2_addr];//读第二个数  //tc
endmodule
