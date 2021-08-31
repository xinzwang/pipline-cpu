`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:48:02
// Design Name: 
// Module Name: Ctrl
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

module Ctrl(
    input clk,
    input rst,
    input wire I_FromID_stallreq,//处于译码阶段指令是否请求流水线暂停
    input wire I_FromEX_stallreq,//处于执行阶段指令是否请求流水线暂停
    output reg [5:0] stall//控制流水线暂停信号
);
always @(*) begin
    if(rst==1'b0) begin
        stall<=6'b0;
    end else if(I_FromID_stallreq==1'b1) begin
        stall<=6'b001111;
    end else if(I_FromEX_stallreq==1'b1) begin
        stall<=6'b000111;
    end else begin
        stall<=6'b0;
    end
end
endmodule
