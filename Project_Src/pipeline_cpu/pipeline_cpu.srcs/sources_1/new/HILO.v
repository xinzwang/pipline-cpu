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
//������λָ�����ļĴ�����Ԫ����д�׶�д�룬��Ĵ�����ջ������

module HILO(
    input clk,
    input rst,
    input wire I_FromMEMWB_wreg,//HILO�Ĵ���дʹ���ź�
    input wire [31:0] I_FromMEMWB_hi,//д��hi��ֵ
    input wire [31:0] I_FromMEMWB_lo,//д��lo��ֵ
    output reg [31:0] O_ToEX_hi,//������EX��hi��ֵ
    output reg [31:0] O_ToEX_lo//������EX��lo��ֵ
);
//HILO��д�߼�
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
