`timescale 1ns / 1ps

module top(
	input initclk,
	input rst,
	input [7:0] saddr,//8位地址 用8个开关即可
	input  sread,
	input  traverse_read,
	output [7:0] light,
	output [3:0] sel,
	output [31:0] inst,//tc
	output reg [7:0] taddr 
    );

wire clk;
wire rst_n;
assign rst_n=~rst;

wire [31:0] outdata;

reg [7:0] dladdr=0;
//reg [7:0] taddr=0;//traverse addr
wire reading;
wire tread;
assign reading=traverse_read|sread;

always@(posedge tread or posedge rst)
begin
	if (rst)
		taddr<=0;
	else
		taddr<=taddr+1;
end

/********download mux*************/
always@(*)
begin
	if (rst)
		dladdr=0;
	else if (traverse_read)
		dladdr=taddr;
	else if (sread)
		dladdr=saddr;
	else ;
end

div u_div(
	.initclk(initclk),
	.clk(clk)
);

debounce u_debounce(
	.clk(clk),
	.rst_n(rst_n),
	.butt(traverse_read),
	.Op(tread)
);

cpu u_cpu(
	.clk(clk),
	.rst_n(rst_n),
	.dladdr(dladdr),
	.reading(reading),
	.inst(inst),
	.data(outdata)
    );

code u_code(
	.clk(clk),
	.rst_n(rst_n),
	.reg1(outdata[15:0]),
	.sel(sel),
	.light(light)
);



endmodule
