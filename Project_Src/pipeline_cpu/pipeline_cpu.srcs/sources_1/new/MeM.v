`timescale 1ns / 1ps

`include "defines.v"

module mem(

	input wire										rst,//时钟信号
	
	//来自执行阶段的信息	
	input wire[4:0]       I_FROMEX_MEM_wd,//访存阶段的指令要写入目的寄存器地址
	input wire                    I_FROMEX_MEM_wreg,//访存阶段的指令是否要写入目的寄存器
	input wire[31:0]					  I_FROMEX_MEM_wdata,//访存阶段的指令要写入目的寄存器的值
	
	//送到回写阶段的信息
	output reg[4:0]      O_TOMEM_WB_wd,//访存阶段的指令最重要写入的目的寄存器地址
	output reg                   O_TOMEM_WB_wreg,//访存阶段的指令最终是否有要写入目的寄存器
	output reg[31:0]					 O_TOMEM_WB_wdata//访存阶段的指令最终要写入目的寄存器的值
	
);

	//MEM模块中只有一个组合逻辑电路，将输入的执行阶段的结果直接作为输出，随后MEM模块的输出连接到MEM\WB模块
	//实现了将输入信号传递到对应的输出端口
	always @ (*) begin
		if(rst == 1'b1) begin
			O_TOMEM_WB_wd <= 5'b00000;
			O_TOMEM_WB_wreg <= 1'b0;
		  O_TOMEM_WB_wdata <= 32'h00000000;
		end else begin
		  O_TOMEM_WB_wd <= I_FROMEX_MEM_wd;
			O_TOMEM_WB_wreg <= I_FROMEX_MEM_wreg;
			O_TOMEM_WB_wdata <= I_FROMEX_MEM_wdata;
		end    //if
	end      //always
			
endmodule
