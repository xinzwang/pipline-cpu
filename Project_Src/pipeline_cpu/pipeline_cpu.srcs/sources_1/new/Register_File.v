`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:16:21
// Design Name: wsc
// Module Name: Register_File
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Register_File(
	input	wire		clk,//复位信号，高电平有效
	input   wire	    rst,//时钟信号

	//写端口
	input wire			I_FromMEM_WB_we,//写使能信号
	input wire[4:0]		I_FromMEM_WB_waddr,//要写入的寄存器地址
	input wire[31:0]	I_FromMEM_WB_wdata,//要写入的数据
	
	//读端口1
	input wire			I_FromID_re1,//第一个读寄存器端口读使能信号
	input wire[4:0]		I_FromID_raddr1,//第一个读寄存器端口要读取的寄存器的地址
	output reg[31:0]    O_ToID_rdata1,//第一个读寄存器端口输出的寄存器值
	
	//读端口2
	input wire			I_FromID_re2,//第二个读寄存器端口读使能信号
	input wire[4:0]	    I_FromID_raddr2,////第二个读寄存器端口要读取的寄存器的地址
	output reg[31:0]    O_ToID_rdata2//第二个读寄存器端口输出的寄存器值
);

	reg[31:0]  RF_regs_local[0:31];//定义32个32位寄存器


//写操作
	always @ (posedge clk) begin
		if (rst == 1'b0) begin
			if((I_FromMEM_WB_we == 1'b1) && (I_FromMEM_WB_waddr != 5'h0)) begin
				RF_regs_local[I_FromMEM_WB_waddr] <= I_FromMEM_WB_wdata;
			end
		end
	end
/* 实现了写寄存器操作，当复位信号无效时，在写使能信号i_frommem_wb_we有效，
且写操作目的寄存器不等于0的情况下，可以将写输入数据保存到目的寄存器。
之所以要判断目的寄存器不为0，是因为MIPS32架构规定S0的值只能为0，所以不要写入。*/
	
//读端口1操作
	always @ (*) begin
		if(rst == 1'b1) begin
			  O_ToID_rdata1 <= 32'h00000000;
	  end else if(I_FromID_raddr1 == 5'h0) begin
	  		O_ToID_rdata1 <= 32'h00000000;
	  end else if((I_FromID_raddr1 == I_FromMEM_WB_waddr) && (I_FromMEM_WB_we == 1'b1) 
	  	            && (I_FromID_re1 == 1'b1)) begin
	  	  O_ToID_rdata1 <= I_FromMEM_WB_wdata;//在读操作中有一个判断，如果要读取的寄存器是在下一个时钟上升沿要写入的寄存器，那么就将要写入的数据直接作为结果输出。如此就解决了相隔2条指令存在数据相关的情况。
	  end else if(I_FromID_re1 == 1'b1) begin
	      O_ToID_rdata1 <= RF_regs_local[I_FromID_raddr1];
	  end else begin
	      O_ToID_rdata1 <= 32'h00000000;
	  end
	end
/* 实现了第一个读寄存器端口，分以下几步依次判断:
当复位信号有效时，第一个读寄存器端口的输出始终为0;当复位信号无效时，如果读取的是$0，那么直接给出0;
如果第一个读寄存器端口要读取的目标寄存器与要写入的目的寄存器是同一个寄存器，那么直接将要写入的值作为第一个读寄存器端口的输出;
如果上述情况都不满足,那么给出第一个读寄存器端口要读取的目标寄存器地址对应寄存器的值;
第一个读寄存器端口不能使用时，直接输出0。*/

//读端口2操作
	always @ (*) begin
		if(rst == 1'b1) begin
			  O_ToID_rdata2 <= 32'h00000000;
	  end else if(I_FromID_raddr2 == 5'h0) begin
	  		O_ToID_rdata2 <= 32'h00000000;
	  end else if((I_FromID_raddr2 == I_FromMEM_WB_waddr) && (I_FromMEM_WB_we == 1'b1) 
	  	            && (I_FromID_re2 == 1'b1)) begin
	  	  O_ToID_rdata2 <= I_FromMEM_WB_wdata;
	  end else if(I_FromID_re2 == 1'b1) begin
	      O_ToID_rdata2 <= RF_regs_local[I_FromID_raddr2];
	  end else begin
	      O_ToID_rdata2 <= 32'h00000000;
	  end
	end
/* 实现了第二个读寄存器端口，与第三段相似。
注意一点:读寄存器操作是组合逻辑电路,也就是一旦输入的要读取的寄存器地址raddr1或者raddr2发生变化，
那么会立即给出新地址对应的寄存器的值，这样可以保证在译码阶段取得要读取的寄存器的值，
而写寄存器操作是时序逻辑电路，写操作发生在时钟信号的上升沿。*/

endmodule

