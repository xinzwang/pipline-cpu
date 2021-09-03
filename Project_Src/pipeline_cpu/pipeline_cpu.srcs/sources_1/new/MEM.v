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
//�ô沿��

module MEM(
    input clk,
    input rst,
//
    input wire I_FromEXMEM_wreg,//�ô�׶�ָ���Ƿ�ҪдĿ�ļĴ���?
    input wire [4:0] I_FromEXMEM_wreg_addr,//�ô�׶�ָ��ҪдĿ�ļĴ����ĵ��?
    input wire [31:0] I_FromEXMEM_wreg_data,//�ô�׶�ָ��ҪдĿ�ļĴ������?
    output reg O_ToMEMWB_ID_wreg,//�ô�׶�ָ���Ƿ�����ҪдĿ�ļĴ���?
    output reg [4:0] O_ToMEMWB_ID_wreg_addr,//�ô�׶�ָ������ҪдĿ�ļĴ����ĵ��?
    output reg [31:0] O_ToMEMWB_ID_wreg_data,//�ô�׶�ָ������ҪдĿ�ļĴ������?
//�ƶ�����ָ�����?
    input wire I_FromEXMEM_whilo,//�ô�׶�ָ���Ƿ�ҪдHILO
    input wire [31:0] I_FromEXMEM_hi,//�ô�׶�ָ��ҪдHI��ֵ
    input wire [31:0] I_FromEXMEM_lo,//�ô�׶�ָ��ҪдLO��ֵ
    output wire  O_TOMEMWB_whilo,//�ô�׶�ָ���Ƿ�����Ҫдhilo
    output reg [31:0] O_TOMEMWB_hi,//�ô�׶�ָ���Ƿ�����дhi��ֵ
    output reg [31:0] O_TOMEMWB_lo,//�ô�׶�ָ���Ƿ�����дlo��ֵ
//���ش洢ָ�����?
    input wire [7:0] I_FromEXMEM_aluop,//�ô�׶�ָ��Ҫ���е������������
    input wire [31:0] I_FromEXMEM_mem_addr,//�ô�׶μ��ش洢ָ���Ӧ�Ĵ洢����ַ
    input wire [31:0] I_FromEXMEM_mem_data,//�洢ָ��Ҫ�洢�����ݣ��Լ����ص�Ŀ�ļĴ�����ԭʼֵ
//datamem related
    input wire [31:0] I_FromDM_data,//�����ݴ洢����ȡ��ֵ
    output reg [31:0] O_ToDM_data,//Ҫ�������ݴ洢����ַ
    output reg [31:0] O_ToDM_we,//�����ݴ洢���Ƿ�Ϊд����1--->д����
    output reg [31:0] O_ToDM_we_data,//Ҫд�����ݴ洢��������
    output reg [3:0] O_ToDM_sel,//�ֽ�ѡ���ź�
//�ӳٲ����?
    input wire I_FromEXMEM_isindelayslot,//�ӳٲ۱��?
    output wire O_TOMEMWB_isindelayslot//�ӳٲ۱��?
);
endmodule
