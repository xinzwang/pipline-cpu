`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 10:52:24
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    input clk,
    input rst,
    input wire [5:0] I_FromCL_stall,//用于乘除法多周期流水延迟的信号量
    input wire [31:0] I_FromCL_newpc,//用于异常处理后的新地址，现阶段不用管
    input wire I_FromID_branchflag,//跳转指令对应的信号，与下述跳转地址绑定
    input wire [31:0] I_FromID_branch_taraddr,//跳转地址
    output reg [31:0] O_ToIM_IFID_pc//输出的指令地址
    //output reg ce//pc使能信号
);
//code here,notice comment
endmodule
