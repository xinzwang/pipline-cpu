`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:18:38
// Design Name: 
// Module Name: MEM
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
//访存部件

module MEM(
    input clk,
    input rst,
//
    input wire I_FromEXMEM_wreg,//访存阶段指令是否要写目的寄存器
    input wire [4:0] I_FromEXMEM_wreg_addr,//访存阶段指令要写目的寄存器的地址
    input wire [31:0] I_FromEXMEM_wreg_data,//访存阶段指令要写目的寄存器的值
    output reg O_ToMEMWB_wreg,//访存阶段指令是否最终要写目的寄存器
    output reg [4:0] O_ToMEMWB_wreg_addr,//访存阶段指令最终要写目的寄存器的地址
    output reg [31:0] O_ToMEMWB_wreg_data,//访存阶段指令最终要写目的寄存器的值
//移动操作指令相关
    input wire I_FromEXMEM_whilo,//访存阶段指令是否要写HILO
    input wire [31:0] I_FromEXMEM_hi,//访存阶段指令要写HI的值
    input wire [31:0] I_FromEXMEM_lo,//访存阶段指令要写LO的值
    output wire  O_TOMEMWB_whilo,//访存阶段指令是否最终要写hilo
    output reg [31:0] O_TOMEMWB_hi,//访存阶段指令是否最终写hi的值
    output reg [31:0] O_TOMEMWB_lo,//访存阶段指令是否最终写lo的值
//加载存储指令相关
    input wire [7:0] I_FromEXMEM_aluop,//访存阶段指令要进行的运算的子类型
    input wire [31:0] I_FromEXMEM_mem_addr,//访存阶段加载存储指令对应的存储器地址
    input wire [31:0] I_FromEXMEM_mem_data,//存储指令要存储的数据，以及加载到目的寄存器的原始值
//datamem related
    input wire [31:0] I_FromDM_data,//从数据存储器读取的值
    output reg [31:0] O_ToDM_data,//要访问数据存储器地址
    output reg [31:0] O_ToDM_we,//对数据存储器是否为写操作1--->写操作
    output reg [31:0] O_ToDM_we_data,//要写入数据存储器的数据
    output reg [3:0] O_ToDM_sel,//字节选择信号
//延迟槽相关
    input wire I_FromEXMEM_isindelayslot,//延迟槽标记
    output wire O_TOMEMWB_isindelayslot//延迟槽标记
);
endmodule
