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
    input wire [2:0] I_FromIDEX_alusel,//ִ�н׶�Ҫ����ָ�������
    input wire [7:0] I_FromIDEX_aluop,//ִ�н׶�Ҫ����ָ���������
    input wire [31:0] I_FromIDEX_reg1,//���������Դ������һ
    input wire [31:0] I_FromIDEX_reg2,//���������Դ��������
    input wire I_FromIDEX_wreg,//ָ��ִ���Ƿ� Ҫд��Ŀ�ļĴ���
    input wire I_FromIDEX_wreg_addr,//ָ��ִ��Ҫд���Ŀ�ļĴ�����ַ
    output reg [31:0] O_ToEXMEM_reg2,//�洢ָ��Ҫ�洢�����ݣ�����lwrָ��Ҫд���Ŀ�ļĴ���ԭʼֵ
//    output reg O_ToEXMEM_wreg,//ִ�н׶�ָ���Ƿ�����Ҫд��Ŀ�ļĴ���
//    output reg [31:0] O_ToEXMEM_wreg_addr,//ִ�н׶�ָ������Ҫд��Ŀ�ļĴ�����ַ
//    output reg [31:0] O_ToEXMEM_wreg_data,//ִ�н׶�ָ������Ҫд��Ŀ�ļĴ�����ֵ
//HILOģ����
    input wire [31:0] I_FromHILO_hi,//hilo��hi��ֵ
    input wire [31:0] I_FromHILO_lo,//hilo��lo��ֵ
//mem�׶���hilo�Ľ�������
    input wire I_FromMEM_whilo,//�ô�׶�ָ���Ƿ���ҪдHILO�Ĵ���
    input wire [31:0] I_FromMEM_wb_hi,//�ô�׶�д��HILO��hi��ֵ
    input wire [31:0] I_FromMEM_wb_lo,//�ô�׶�д��HILO��lo��ֵ
//memwb�׶���hilo�Ľ�������
    input wire I_FromMEMWB_whilo,//��д�׶�ָ���Ƿ���ҪдHILO�Ĵ���
    input wire [31:0] I_FromMEMWB_wb_hi,//��д�׶�д��HILO��hi��ֵ
    input wire [31:0] I_FromMEMWB_wb_lo,//��д�׶�д��HILO��lo��ֵ
//�漰�˷��������
    input wire [63:0] I_FromEXMEM_hilo_temp,//��һ��ִ�����ڵõ��ĳ˷����
    input wire [1:0] I_FromEXMEM_cnt,//D��ǰ����ִ�н׶εĵڼ�������
    output wire [63:0] O_ToEXMEM_hilo_temp,//��һ��ִ�����ڵõ��ĳ˷����
    output wire [1:0] O_ToEXMEM_cnt,//��һ��ʱ�����ڴ���ִ�н׶εĵڼ���ʼ������
//�漰�����������
    input wire I_FromDIV_divready,//���������Ƿ����
    input wire [63:0] I_FromDIV_divres,//����������
    output reg O_ToDIV_signediv,//�Ƿ�Ϊ�з��ų���1-->�з��ţ�0->�޷���
    output reg O_ToDIV_opdata1,//������
    output reg O_ToDIV_opdata2,//����
    output reg O_ToDIV_divstart,//�����Ƿ�ʼ
//�ӳٲ���ر���
    input wire I_FromIDEX_isindelayslot,//�ӳٲ۱��
    output wire O_TOEXMEM_isindelayslot,//�ӳٲ۱��
//��ô棬ID��صĽӿ�
    output reg O_To_EXMEM_mem_addr,//���ش洢ָ���Ӧ�Ĵ洢����ַ
    output reg O_To_ID_EXMEM_wreg,//ִ�н׶�ָ�������Ƿ���Ҫд��Ŀ�ļĴ���
    output reg [7:0] O_To_ID_EXMEM_aluop,//ִ�н׶�ָ����е�����������
    output reg [31:0] O_To_ID_EXMEM_wreg_addr,//���ش洢ָ���Ӧ�Ĵ洢����ַ
    output reg [31:0] O_To_ID_EXMEM_wreg_data,//�洢ָ��Ҫ�洢�����ݣ��Լ����ص�Ŀ�ļĴ�����ԭʼֵ

//��ˮ��ͣ����
    output reg stallreq//������ˮ��ͣ
    );
endmodule
