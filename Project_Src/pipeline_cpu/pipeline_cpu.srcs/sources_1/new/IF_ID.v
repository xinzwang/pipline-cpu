`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:14:30
// Design Name: 
// Module Name: IF_ID
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
//暂时保存取指阶段取到的指令，以及对应的指令地址，并在像一个时钟周期传送到译码阶段
//rst==0,系统处于复位状态，rst==复位结束

module IF_ID(
    input clk,
    input rst,
    //来自取指阶段的信号
    input wire [31:0] IF_pc,//所取指令的地址
    input wire [31:0] IF_ins,//所取的指令
    //去向译码阶段的信号
    output reg [31:0] ID_pc,
    output reg [31:0] ID_ins
);
//时序控制部分，每个时钟上升沿信号传送到锁存器另一端
always @(posedge clk) begin
    if(rst==1'b0) begin
        ID_pc<=32'b0;
        ID_ins<=32'b0;
    end else begin
        ID_pc<=IF_pc;
        ID_ins<=IF_ins;
    end
end
endmodule
