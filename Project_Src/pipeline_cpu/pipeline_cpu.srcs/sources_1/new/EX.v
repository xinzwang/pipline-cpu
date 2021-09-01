`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:17:20
// Design Name: 
// Module Name: EX
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


module EX(
    input clk,
    input rst,
    input wire [2:0] I_FromIDEX_alusel,//执行阶段要运算指令的类型
    input wire [7:0] I_FromIDEX_aluop,//执行阶段要运算指令的子类型
    input wire [31:0] I_FromIDEX_reg1,//参与运算的源操作数一
    input wire [31:0] I_FromIDEX_reg2,//参与运算的源操作数二
    input wire I_FromIDEX_wreg,//指令执行是否 要写入目的寄存器
    input wire I_FromIDEX_wreg_addr,//指令执行要写入的目的寄存器地址
    output reg [31:0] O_ToEXMEM_reg2,//存储指令要存储的数据，或者lwr指令要写入的目的寄存器原始值
//    output reg O_ToEXMEM_wreg,//执行阶段指令是否最终要写入目的寄存器
//    output reg [31:0] O_ToEXMEM_wreg_addr,//执行阶段指令最终要写入目的寄存器地址
//    output reg [31:0] O_ToEXMEM_wreg_data,//执行阶段指令最终要写入目的寄存器的值
//HILO模块量
    input wire [31:0] I_FromHILO_hi,//hilo中hi的值
    input wire [31:0] I_FromHILO_lo,//hilo中lo的值
//mem阶段与hilo的交互变量
    input wire I_FromMEM_whilo,//访存阶段指令是否需要写HILO寄存器
    input wire [31:0] I_FromMEM_wb_hi,//访存阶段写回HILO的hi的值
    input wire [31:0] I_FromMEM_wb_lo,//访存阶段写回HILO的lo的值
//memwb阶段与hilo的交互变量
    input wire I_FromMEMWB_whilo,//回写阶段指令是否需要写HILO寄存器
    input wire [31:0] I_FromMEMWB_wb_hi,//回写阶段写回HILO的hi的值
    input wire [31:0] I_FromMEMWB_wb_lo,//回写阶段写回HILO的lo的值
//涉及乘法计算的量
    input wire [63:0] I_FromEXMEM_hilo_temp,//第一个执行周期得到的乘法结果
    input wire [1:0] I_FromEXMEM_cnt,//D当前处于执行阶段的第几个周期
    output wire [63:0] O_ToEXMEM_hilo_temp,//第一个执行周期得到的乘法结果
    output wire [1:0] O_ToEXMEM_cnt,//下一个时钟周期处于执行阶段的第几个始终周期
//涉及除法计算的量
    input wire I_FromDIV_divready,//除法运算是否结束
    input wire [63:0] I_FromDIV_divres,//除法运算结果
    output reg O_ToDIV_signediv,//是否为有符号除法1-->有符号，0->无符号
    output reg O_ToDIV_opdata1,//被除数
    output reg O_ToDIV_opdata2,//除数
    output reg O_ToDIV_divstart,//除法是否开始
//延迟槽相关变量
    input wire I_FromIDEX_isindelayslot,//延迟槽标记
    output wire O_TOEXMEM_isindelayslot,//延迟槽标记
//与访存，ID相关的接口
    output reg O_To_EXMEM_mem_addr,//加载存储指令对应的存储器地址
    output reg O_To_ID_EXMEM_wreg,//执行阶段指令最终是否有要写入目的寄存器
    output reg [7:0] O_To_ID_EXMEM_aluop,//执行阶段指令进行的运算子类型
    output reg [31:0] O_To_ID_EXMEM_wreg_addr,//加载存储指令对应的存储器地址
    output reg [31:0] O_To_ID_EXMEM_wreg_data,//存储指令要存储的数据，以及加载到目的寄存器的原始值

//流水暂停请求
    output reg stallreq//请求流水暂停
    );
endmodule
