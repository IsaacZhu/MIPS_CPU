`timescale 1ns / 1ps

module interlock(
	input clk,
	input rst_n,
	input ld,
	input [4:0] idexrd1,
	input [4:0] rs,
	input [4:0] rt,
	output reg pcwrite,
	output reg ifidwrite
    );
always@(*)
begin
	if (~rst_n) begin
		pcwrite=0;
		ifidwrite=0;
	end
	else begin
		if (ld&&(idexrd1==rs||idexrd1==rt)) begin //发生了load相关
			pcwrite=1;
			ifidwrite=1;
		end
		else begin
			pcwrite=1;
			ifidwrite=1;
		end
	end
end
endmodule
