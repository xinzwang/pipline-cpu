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
//��ʱ����ȡָ�׶�ȡ����ָ��Լ���Ӧ��ָ���ַ��������һ��ʱ�����ڴ��͵�����׶�
//rst==0,ϵͳ���ڸ�λ״̬��rst==��λ����

module IF_ID(
    input clk,
    input rst,
    //����ȡָ�׶ε��ź�
    input wire [31:0] IF_pc,//��ȡָ��ĵ�ַ
    input wire [31:0] IF_ins,//��ȡ��ָ��
    //ȥ������׶ε��ź�
    output reg [31:0] ID_pc,
    output reg [31:0] ID_ins
);
//ʱ����Ʋ��֣�ÿ��ʱ���������źŴ��͵���������һ��
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
