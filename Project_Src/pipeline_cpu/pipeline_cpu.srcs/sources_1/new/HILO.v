`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:20:05
// Design Name: 
// Module Name: HILO
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
//辅助移位指操作的寄存器单元，回写阶段写入，与寄存器堆栈相区分

module HILO(
    input clk,
    input rst,
    input wire I_FromMEMWB_wreg,//HILO寄存器写使能信号
    input wire [31:0] I_FromMEMWB_hi,//写入hi的值
    input wire [31:0] I_FromMEMWB_lo,//写入lo的值
    output reg [31:0] O_ToEX_hi,//读出到EX的hi的值
    output reg [31:0] O_ToEX_lo//读出到EX的lo的值
);
//HILO的写逻辑
always @(posedge clk) begin
    if(rst==1'b0) begin
        O_ToEX_hi<=32'b0;
        O_ToEX_lo<=32'b0;
    end else if (I_FromMEMWB_wreg==1'b1) begin
        O_ToEX_hi<=I_FromMEMWB_hi;
        O_ToEX_lo<=I_FromMEMWB_lo;
    end
end
    
endmodule
