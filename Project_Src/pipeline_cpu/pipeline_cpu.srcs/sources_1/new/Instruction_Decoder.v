`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:15:34
// Design Name: 
// Module Name: Instruction_Decoder
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
//ָ�����������е������ڿ��Ƶ�Ԫcu

module Instruction_Decoder(
    input clk,
    input rst,
    input wire [31:0] I_FromIFID_pc,//����׶�ָ���Ӧ�ĵ�ַ
    input wire [31:0] I_FromIFID_ins,//����׶ε�ָ��
//��Ĵ�����ջ��ز���
    input wire [31:0] I_FromRF_reg1_data,//�ӼĴ�����ջ�����ĵ�һ���˿�����
    input wire [31:0] I_FromRF_reg2_data,//�ӼĴ�����ջ�����ĵڶ����˿�����
    output reg O_ToRF_reg1,//�Ĵ�����ջ��һ�����˿�ʹ���ź�
    output reg O_ToRF_reg2,//�Ĵ�����ջ�ڶ������˿�ʹ���ź�
    output reg [4:0] O_ToRF_reg1_addr,//�Ĵ�����ջ��һ�����˿ڵ�ַ
    output reg [4:0] O_ToRF_reg2_addr,//�Ĵ�����ջ�ڶ������˿ڵ�ַ
    output reg O_ToRF_wreg,//�Ĵ�����ջд�˿�ʹ���ź�
    output reg [4:0] O_ToRF_wreg_addr,//�Ĵ�����ջд�˿ڵ�ַ
    output reg [7:0] O_ToIDEX_aluop,//����׶�Ҫ���е�����������
    output reg [2:0] O_ToIDEX_alusel,//����׶�Ҫ���е����������
    output reg [2:0] O_ToIDEX_reg1,//����׶�Ҫ���е������ԭ������һ
    output reg [2:0] O_ToIDEX_reg2,//����׶�Ҫ���е������ԭ��������
//���½ӿ���ҪΪ���������ؽ�������ϸ�Ķ�P113�������
    input wire I_FromEX_wreg,//����ִ�н׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
    input wire I_FromEX_wreg_addr,//����ִ�н׶ε�ָ��ҪдĿ�ļĴ�����ַ
    input wire I_FromEX_wreg_data,//����ִ�н׶ε�ָ��дĿ�ļĴ�������
    input wire I_FromMEM_wreg,//���ڷô�׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
    input wire I_FromMEM_wreg_addr,//���ڷô�׶ε�ָ��ҪдĿ�ļĴ�����ַ
    input wire I_FromMEM_wreg_data,//���ڷô�׶ε�ָ��дĿ�ļĴ�������
//��תָ���ӳٲ��ź�
    input wire I_FromIFID_isindelayslot,//��ǰ����ָ���Ƿ����ӳٲ�
    output wire O_ToIDEX_isindelayslot,//��ǰ����ָ���Ƿ����ӳٲ�
    output reg O_ToPC_branchflag,//��ת�ź�
    output reg [31:0] O_ToPC_branch_taraddr,//��תĿ�ĵ�ַ
//������ָ����ˮֹͣ�����ź�
    output reg stallreq  
);
endmodule
