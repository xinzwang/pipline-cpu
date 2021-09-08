`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:19:44
// Design Name: 
// Module Name: MEM_WB
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
//将访存阶段的运算结果，在下一个时钟传递到回写阶段

module MEM_WB(
    input clk,
    input rst,
    input wire MEM_wreg,//访存阶段指令最终是否有要写入的目的寄存器
    input wire [4:0] MEM_wreg_addr,//访存阶段指令最终要写入的目的寄存器地址
    input wire [31:0] MEM_wreg_data,//访存阶段指令最终要写入的目的寄存器数据
    output reg WB_wreg,//访存阶段指令最终是否有要写入的目的寄存器
    output reg  [4:0] WB_wreg_addr,//访存阶段指令最终要写入的目的寄存器地址
    output reg  [31:0] WB_wreg_data,//访存阶段指令最终要写入的目的寄存器数据
    //位移指令的hilo相关接口
    input wire MEM_whilo,//是否要写hilo
    input wire [31:0] MEM_hi_data,//写hi的值
    input wire [31:0] MEM_lo_data,//写hi的值
    output reg WB_whilo,//是否要写hilo
    output reg [31:0] WB_hi_data,//写hi的值
    output reg [31:0] WB_lo_data,//写hi的值
    //控制
    input wire [5:0] CL_stall,
    input wire CL_flush
    );
//时序控制部分，每个时钟上升沿信号传送到锁存器另一端
always @(posedge clk) begin
    if(rst==1'b0) begin
        WB_wreg<=1'b0;
        WB_wreg_addr<=5'b0;
        WB_wreg_data<=32'b0;
        WB_whilo<=1'b0;
        WB_hi_data<=32'b0;
        WB_lo_data<=32'b0;
    end else if (CL_flush==1'b1) begin
        WB_wreg<=1'b0;
        WB_wreg_addr<=5'b0;
        WB_wreg_data<=32'b0;
        WB_whilo<=1'b0;
        WB_hi_data<=32'b0;
        WB_lo_data<=32'b0;
    end else if (CL_stall[4]==1'b1 && CL_stall[5]==1'b0) begin
        WB_wreg<=1'b0;
        WB_wreg_addr<=5'b0;
        WB_wreg_data<=32'b0;
        WB_whilo<=1'b0;
        WB_hi_data<=32'b0;
        WB_lo_data<=32'b0;
    end else if (CL_stall[4]==1'b0) begin
        WB_wreg<=MEM_wreg;
        WB_wreg_addr<=MEM_wreg_addr;
        WB_wreg_data<=MEM_wreg_data;
        WB_whilo<=MEM_whilo;
        WB_hi_data<=MEM_hi_data;
        WB_lo_data<=MEM_lo_data;
    end
end
endmodule
