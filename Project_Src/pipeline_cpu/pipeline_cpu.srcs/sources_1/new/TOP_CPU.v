`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/01 09:40:06
// Design Name: 
// Module Name: TOP_CPU
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
//流水线顶层模块
//顶层模块定义规范，[信号发出模块名]_[信号接收模块名]_[信号描述]

module TOP_CPU(
    input clk,
    input rst
);
//pc相关引线
wire CL_PC_stall;//ctrl发回的暂停信号
wire [31:0] CL_PC_newpc;//Ctrll用于异常后新pc的信号
wire ID_PC_branchflag;//ID发出的跳转信号
wire [31:0] ID_PC_branch_taraddr;//Id跳转的目的地址
//IM相关引线
wire [31:0] PC_IM_addr;//pc传入的取指地址
//IFID相关引线
wire CL_IFID_stall;//ctrl发回的暂停信号
wire [31:0] PC_IFID_pc;//pc中的地址
wire [31:0] IM_IFID_ins;//im中的指令
//ID相关引线
wire [31:0] IFID_ID_pc;//传入id的pc值
wire [31:0] IFID_ID_ins;//传入pc的ins值
wire [7:0] EX_ID_aluop;//译码阶段要进行的运算子类型
wire EX_ID_wreg;//执行阶段指令是否最终要写目的寄存器
wire [31:0] EX_ID_wreg_addr;//加载存储指令对应的存储器地址
wire [31:0] EX_ID_wreg_data;//执行阶段指令最终要写入目的寄存器的值
wire MEM_ID_wreg;//执行阶段指令是否要写目的寄存器
wire [31:0] MEM_ID_wreg_addr;//执行阶段指令要写目的寄存器地址
wire [31:0] MEM_ID_wreg_data;//执行阶段指令要写目的寄存器数据
wire IDEX_ID_isindelayslot;//处在延迟槽中
wire [31:0] RF_ID_reg1_data;//寄存器读出值一
wire [31:0] RF_ID_reg2_data;//寄存器读出值二
//寄存器堆栈相关引线
wire [4:0] ID_RF_reg1_addr;//读地址
wire [4:0] ID_RF_reg2_addr;//读地址
wire ID_RF_reg1;//读使能
wire ID_RF_reg2;//读使能
wire MEMWB_RF_wreg;//写使能
wire [4:0] MEMWB_RF_wreg_addr;//写地址
wire [31:0] MEMWB_RF_wreg_data;//写数据
//IDEX相关引线
wire CL_IDEX_stall;//暂停信号
wire [7:0] ID_IDEX_aluop;//译码操作符子类型
wire [2:0] ID_IDEX_alusel;//译码操作符类型
wire [31:0] ID_IDEX_reg1;//译码阶段要进行运算的原操作数一
wire [31:0] ID_IDEX_reg2;//译码阶段要进行运算的原操作数二
wire ID_IDEX_wreg;//译码阶段指令是否写目的寄存器地址
wire [4:0] ID_IDEX_wreg_addr;//译码阶段指令写目的寄存器地址
wire [31:0] ID_IDEX_ins;//译码阶段指令
wire ID_IDEX_isindelaysolt;//延迟槽标志
wire ID_IDEX_next_isindelaysolt;//延迟槽标志

//EX相关引线
wire [7:0] IDEX_EX_aluop;//译码操作符子类型
wire [2:0] IDEX_EX_alusel;//译码操作符类型
wire [31:0] IDEX_EX_reg1_data;//原操作数一
wire [31:0] IDEX_EX_reg2_data;//原操作数二
wire IDEX_EX_wreg;//指令执行是否要写入目的寄存器
wire [4:0] IDEX_EX_wreg_addr;//写入目的寄存器地址
wire [31:0] IDEX_EX_ins;//执行阶段指令
wire [31:0] IDEX_EX_ins_addr;//执行阶段指令地址
wire IDEX_EX_isindelayslot;//执行阶段指令在延迟槽














endmodule
