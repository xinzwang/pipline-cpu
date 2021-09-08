`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:16:50
// Design Name: 
// Module Name: ID_EX
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
//将译码阶段取得的运算类型，源操作数，要写的目的寄存器地址等结果，在下一个时钟周期传到流水线的执行阶段

module ID_EX(
    input clk,
    input rst,
    input wire [5:0] CL_stall,//
    input wire CL_flush,//
    input wire [2:0] ID_alusel,//译码阶段要进行运算的类型
    input wire [7:0] ID_aluop,//译码阶段指令要进行运算的子类型
    input wire [31:0] ID_reg1,//译码阶段指令要进行运算的源操作数一
    input wire [31:0] ID_reg2,//译码阶段指令要进行运算的源操作数二
    input wire ID_wreg,//译码阶段指令是否要写入目的寄存器
    input wire [4:0] ID_wreg_addr,//译码阶段指令要写入的目的寄存器地址
    input wire [31:0] ID_ins,//来自ID的具体指令值
    input wire [31:0] ID_ins_addr,//来自ID的具体指令地址
    input wire  ID_isindelayslot,//延迟槽
    input wire ID_next_ins_isindelayslot,
    
    output reg [2:0] EX_alusel,//执行阶段要进行运算的类型
    output reg [7:0] EX_aluop,//执行阶段要进行运算的子类型
    output reg [31:0] EX_reg1,//执行阶段指令要进行运算的源操作数一
    output reg [31:0] EX_reg2,//执行阶段指令要进行运算的源操作数二
    output reg [4:0] EX_wreg_addr,//执行阶段指令要写入的目的寄存器地址
    output reg EX_wreg,//执行阶段指令是否要写入目的寄存器
    output reg [31:0] EX_ins,//给ex的具体指令值
    output reg [31:0] EX_ins_addr,//给EX的具体指令地址
    output reg EX_isindelayslot,
    output reg IDEX_ID_isindelayslot
    );
    
//时序控制部分，每个时钟上升沿信号传送到锁存器另一端
always @(posedge clk) begin
    if(rst==1'b0) begin
        EX_aluop<=8'b0;
        EX_alusel<=3'b0;
        EX_reg1<=32'b0;
        EX_reg2<=32'b0;
        EX_wreg_addr<=5'b0;
        EX_wreg<=1'b0;
        EX_ins<=32'b0;
        EX_ins_addr<=32'b0;
        EX_isindelayslot<=1'b0;
        IDEX_ID_isindelayslot<=1'b0;
    end else if (CL_flush==1'b1) begin
        EX_aluop<=8'b0;
        EX_alusel<=3'b0;
        EX_reg1<=32'b0;
        EX_reg2<=32'b0;
        EX_wreg_addr<=5'b0;
        EX_wreg<=1'b0;
        EX_ins<=32'b0;
        EX_ins_addr<=32'b0;
        EX_isindelayslot<=1'b0;
        IDEX_ID_isindelayslot<=1'b0;
    end else if(CL_stall[2]==1'b1 && CL_stall[3]==1'b0) begin
        EX_aluop<=8'b0;
        EX_alusel<=3'b0;
        EX_reg1<=32'b0;
        EX_reg2<=32'b0;
        EX_wreg_addr<=5'b0;
        EX_wreg<=1'b0;
        EX_ins<=32'b0;
        EX_ins_addr<=32'b0;
        EX_isindelayslot<=1'b0;
        IDEX_ID_isindelayslot<=1'b0;
    end else if(CL_stall[2]==1'b0) begin
        EX_aluop<=ID_aluop;
        EX_alusel<=ID_alusel;
        EX_reg1<=ID_reg1;
        EX_reg2<=ID_reg2;
        EX_wreg_addr<=ID_wreg_addr;
        EX_wreg<=ID_wreg;
        EX_ins<=ID_ins;
        EX_ins_addr<=ID_ins_addr;
        EX_isindelayslot<=ID_isindelayslot;
        IDEX_ID_isindelayslot<=ID_next_ins_isindelayslot;
    end
end
    
endmodule
