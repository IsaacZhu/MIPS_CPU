`timescale 1ns / 1ps

module umem(
	input clk,
	input exmbranch,
	input exmmemwrite,
	input [31:0] exmaluresult,
	input [31:0] exmr2_dout,
	input exmbgtz,
	input [7:0] dladdr,
	input reading,
	
	input stall,
	output reg flush,

	output [31:0] data,
	output reg pcsrc
    );
	 
always@ (*)
begin
	pcsrc=exmbranch&exmbgtz;
end

initial flush=0;
/*********branch*flush************/
always@(*)
begin
	if ((~stall)&&pcsrc) //没有freeze，且分支发生，此时需要清空流水线
		flush=1;
	else
		flush=0;
end

reg [7:0] memaddr=0;
always@ (*)
begin
	if (reading)
		memaddr=dladdr;
	else
		memaddr={exmaluresult[9:2]};
end

datamemory u_dm(
	.a(memaddr),
	.d(exmr2_dout),
	.spo(data),
	.clk(clk),
	.we(exmmemwrite)
);

endmodule
