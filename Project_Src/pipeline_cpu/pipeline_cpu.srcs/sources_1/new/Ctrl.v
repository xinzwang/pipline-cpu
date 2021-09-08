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
    input wire I_FromID_stallreq,//��������׶�ָ���Ƿ�������ˮ����ͣ
    input wire I_FromEX_stallreq,//����ִ�н׶�ָ���Ƿ�������ˮ����ͣ
    output reg [5:0] stall,//������ˮ����ͣ�ź�
    output reg [1:0] flush,//������ˮ����ͣ�ź�
    output reg [31:0] O_ToPC_new_pc
);
always @(*) begin
    if(rst==1'b0) begin
        stall<=6'b0;
        flush<=1'b0;
        O_ToPC_new_pc<=32'b0;
    end else if(I_FromID_stallreq==1'b1) begin
        stall<=6'b001111;
        flush<=1'b0;
    end else if(I_FromEX_stallreq==1'b1) begin
        stall<=6'b000111;
        flush<=1'b0;
    end else begin
        stall<=6'b000000;
        flush<=1'b0;
        O_ToPC_new_pc<=32'b0;
    end
end
endmodule
