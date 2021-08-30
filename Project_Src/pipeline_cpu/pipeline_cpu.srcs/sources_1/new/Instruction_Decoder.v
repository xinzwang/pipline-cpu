`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:15:34
// Design Name: 
// Module Name: Instruction_Decoder
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
//指令译码器，有点类似于控制单元cu

module Instruction_Decoder(
    input clk,
    input rst,
    input wire [31:0] I_FromIFID_pc,//译码阶段指令对应的地址
    input wire [31:0] I_FromIFID_ins,//译码阶段的指令
//与寄存器堆栈相关操作
    input wire [31:0] I_FromRF_reg1_data,//从寄存器堆栈读到的第一个端口输入
    input wire [31:0] I_FromRF_reg2_data,//从寄存器堆栈读到的第二个端口输入
    output reg O_ToRF_reg1,//寄存器堆栈第一个读端口使能信号
    output reg O_ToRF_reg2,//寄存器堆栈第二个读端口使能信号
    output reg [4:0] O_ToRF_reg1_addr,//寄存器堆栈第一个读端口地址
    output reg [4:0] O_ToRF_reg2_addr,//寄存器堆栈第二个读端口地址
    output reg O_ToRF_wreg,//寄存器堆栈写端口使能信号
    output reg [4:0] O_ToRF_wreg_addr,//寄存器堆栈写端口地址
    output reg [7:0] O_ToIDEX_aluop,//译码阶段要进行的运算子类型
    output reg [2:0] O_ToIDEX_alusel,//译码阶段要进行的运算的类型
    output reg [2:0] O_ToIDEX_reg1,//译码阶段要进行的运算的原操作数一
    output reg [2:0] O_ToIDEX_reg2,//译码阶段要进行的运算的原操作数二
//以下接口主要为解决数据相关建立，详细阅读P113相关内容
    input wire I_FromEX_wreg,//处于执行阶段的指令是否要写目的寄存器
    input wire I_FromEX_wreg_addr,//处于执行阶段的指令要写目的寄存器地址
    input wire I_FromEX_wreg_data,//处于执行阶段的指令写目的寄存器数据
    input wire I_FromMEM_wreg,//处于访存阶段的指令是否要写目的寄存器
    input wire I_FromMEM_wreg_addr,//处于访存阶段的指令要写目的寄存器地址
    input wire I_FromMEM_wreg_data,//处于访存阶段的指令写目的寄存器数据
//跳转指令延迟槽信号
    input wire I_FromIFID_isindelayslot,//当前译码指令是否处于延迟槽
    output wire O_ToIDEX_isindelayslot,//当前译码指令是否处于延迟槽
    output reg O_ToPC_branchflag,//跳转信号
    output reg [31:0] O_ToPC_branch_taraddr,//跳转目的地址
//多周期指令流水停止请求信号
    output reg stallreq  
);
endmodule
