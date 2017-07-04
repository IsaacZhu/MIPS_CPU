`timescale 1ns / 1ps

module control(
	input clk,
	input rst_n,
	input [5:0] op,//imem的输出
	input [5:0] funct,
	
	output reg memtoreg,
	output reg regdst,
	output reg iord,//for pcmux
	output reg pcsrc,//pc source
	output reg alusrca,
	output reg [1:0] alusrcb,
	
	output reg irwrite,
	output reg memwrite,
	output reg pcwrite,
	output reg branch,
	output reg regwrite,
	
	output reg [2:0] alucontrol,
	
	output reg jump
    );

/********信号初始化部分*************************/
initial
begin 
memtoreg=0;
memwrite=0;
branch=0;
alusrca=0;
regdst=0;
regwrite=0;
jump=0;
iord=0;
pcsrc=0;
alusrcb=0;
irwrite=0;
pcwrite=0;
end

reg [4:0] state=0;
parameter [4:0] INIT=5'd0;
parameter [4:0] IF=5'd1;//instruction fetch
parameter [4:0] DC=5'd2;//decode

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n)
	begin
		state<=0;
	end
	else 
	begin
		case (state)
			INIT:
				begin
					state<=IF;//空状态，等mem加载
				end
			IF://取指，更新PC值,pc'<=pc+1
				begin
					iord<=0;
					alusrca<=0;
					alusrcb<=2'b01;
					alucontrol<=1;
					pcsrc<=0;
					
					irwrite<=1;
					pcwrite<=1;
					
					memtoreg<=0;//更新一下信号，防止出错
					memwrite<=0;
					regwrite<=0;
					branch<=0;
					jump<=0;
					state<=DC;
				end
			DC://译码
				begin
					pcwrite<=0;
					irwrite<=0;
					case (op)
					6'b000000://add
					begin
						memtoreg<=0;
						memwrite<=0;
						branch<=0;
						regdst<=1;
						jump<=0;
						state<=5'd3;//r ex
					end
					6'b000010://j
					begin
						memtoreg<=0;
						memwrite<=0;
						branch<=0;
						alucontrol<=0;
						alusrca<=0;
						alusrcb<=0;
						regdst<=0;
						regwrite<=0;
						jump<=1;
						state<=5'd18;
					end
					6'b001000://addi or la
					begin
						memtoreg<=0;
						branch<=0;
						jump<=0;
						state<=5'd6;
					end
					6'b100011://lw
					begin
						memtoreg<=1;
						memwrite<=0;
						branch<=0;
						jump<=0;
						state<=5'd9;
					end
					6'b000111://bgtz
					begin
						memtoreg<=0;
						memwrite<=0;
						
						regdst<=0;
						regwrite<=0;
						jump<=0;
						state<=5'd12;
					end
					6'b101011://sw
					begin
						memtoreg<=0;
					
						branch<=0;
						regdst<=0;
						regwrite<=0;
						jump<=0;
						
						alucontrol<=1;
						alusrca<=1;
						alusrcb<=2'b10;
						
						state<=5'd15;
					end
					default: ;
				endcase
				end
			
			5'd3://add ex
				begin
					alusrca<=1;
					alusrcb<=2'b00;
					alucontrol<=3'h1;
					state<=5'd4;//add mem
				end
			5'd4://add mem
				begin
					regwrite<=1;
					state<=5'd5;
				end
			5'd5: state<=IF;//add wb

			5'd6://addi ex
				begin
					alucontrol<=1;
					alusrca<=1;
					alusrcb<=2'b10;
					state<=5'd7;
				end
			5'd7://addi mem
				begin
					memwrite<=0;
					regdst<=0;
					regwrite<=1;
					state<=5'd8;
				end
			5'd8://addi wb
				begin
					regwrite<=0;//避免误写入
					state<=IF;
				end

			5'd9://lw ex  算出取数地址
				begin
					alucontrol<=1;
					alusrca<=1;
					alusrcb<=2'b10;
					state<=5'd10;
				end
			5'd10://lw mem   地址要不要处理？
				begin
					regdst<=0;
					regwrite<=1;
					iord<=1;
					state<=5'd11;
				end
			5'd11://lw wb
				begin
					regwrite<=0;
					memtoreg<=0;
					state<=IF;
				end
			
			5'd12://bgtz ex  计算跳转的地址
				begin
					alusrca<=0;//pc' 17
					alusrcb<=2'b10;//imm -6
					alucontrol<=1;//+
					
					state<=5'd13;
				end
			5'd13://bgtz mem reg的值已经是正确值，在此处计算是否跳转
				begin
					alucontrol<=3'b111;
					alusrca<=1;
					alusrcb<=0;
					branch<=1;
					
					state<=5'd14;
				end
			5'd14://bgtz wb 在上升沿处，已经更新pc
				begin
					branch<=0;//避免继续刷新pc，造成错误
					state<=IF;
				end
				
			5'd15://sw ex
				begin
					iord<=1;
					memwrite<=1;
					state<=5'd16;
				end
			5'd16://sw mem
				begin
					iord<=0;
					memwrite<=0;
					state<=5'd17;
				end
			5'd17://sw wb
				begin
					memwrite<=0;
					state<=IF;
				end
				
			5'd18://j
				begin
					jump<=0;
					state<=IF;//j wb
				end
				
			default:state<=0;
		endcase
	end
end

/*******fetch instruction******************
always@(*)
begin
	case (op)//对指令操作数进行判断
	6'b000000://add
		begin
			memtoreg=0;
			memwrite=0;
			branch=0;
			alu_op=5'h1;
			alusrc=0;
			regdst=1;
			regwrite=1;
			jump=0;
		end
	6'b000010://j
		begin
			memtoreg=0;
			memwrite=0;
			branch=1;
			alu_op=5'h1;
			alusrc=0;
			regdst=0;
			regwrite=0;
			jump=1;
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
		end
	6'b000111://bgtz
		begin
			memtoreg=0;
			memwrite=0;
			branch=1;
			alu_op=5'h1;
			alusrc=0;
			regdst=0;
			regwrite=0;
			jump=0;
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
		end
	default: ;
	endcase
end
*******************************************/

endmodule
