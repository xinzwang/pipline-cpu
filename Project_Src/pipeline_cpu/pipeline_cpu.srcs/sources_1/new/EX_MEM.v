`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:18:18
// Design Name: 
// Module Name: EX_MEM
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
//讲执行阶段取得的预算结果，在下一个时钟周期传递到流水线的访存阶段

module EX_MEM(
    input clk,
    input rst,
    input wire EX_wreg,//执行阶段指令执行后是否要写入目的寄存器
    input wire [4:0] EX_wreg_addr,//执行阶段指令执行后要写入目的寄存器的地址
    input wire [31:0] EX_wreg_data,//执行阶段指令执行后要写入目的寄存器的值
    output reg MEM_wreg,//访存阶段指令执行后是否要写入目的寄存器
    output reg [4:0] MEM_wreg_addr,//访存阶段指令执行后要写入目的寄存器的地址
    output reg [31:0] MEM_wreg_data//访存阶段指令执行后要写入目的寄存器的值
    );
    //时序控制部分，每个时钟上升沿信号传送到锁存器另一端
always @(posedge clk) begin
    if(rst==1'b0) begin
        MEM_wreg<=1'b0;
        MEM_wreg_addr<=5'b0;
        MEM_wreg_data<=32'b0;
    end else begin
        MEM_wreg<=EX_wreg;
        MEM_wreg_addr<=EX_wreg_addr;
        MEM_wreg_data<=EX_wreg_data;
    end
end
endmodule
