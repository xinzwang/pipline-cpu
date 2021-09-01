`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/01 09:40:06
// Design Name: 
// Module Name: TOP_CPU
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
//��ˮ�߶���ģ��
//����ģ�鶨��淶��[�źŷ���ģ����]_[�źŽ���ģ����]_[�ź�����]

module TOP_CPU(
    input clk,
    input rst
);
//pc�������
wire CL_PC_stall;//ctrl���ص���ͣ�ź�
wire [31:0] CL_PC_newpc;//Ctrll�����쳣����pc���ź�
wire ID_PC_branchflag;//ID��������ת�ź�
wire [31:0] ID_PC_branch_taraddr;//Id��ת��Ŀ�ĵ�ַ
//IM�������
wire [31:0] PC_IM_addr;//pc�����ȡָ��ַ
//IFID�������
wire CL_IFID_stall;//ctrl���ص���ͣ�ź�
wire [31:0] PC_IFID_pc;//pc�еĵ�ַ
wire [31:0] IM_IFID_ins;//im�е�ָ��
//ID�������
wire [31:0] IFID_ID_pc;//����id��pcֵ
wire [31:0] IFID_ID_ins;//����pc��insֵ
wire [7:0] EX_ID_aluop;//����׶�Ҫ���е�����������
wire EX_ID_wreg;//ִ�н׶�ָ���Ƿ�����ҪдĿ�ļĴ���
wire [31:0] EX_ID_wreg_addr;//���ش洢ָ���Ӧ�Ĵ洢����ַ
wire [31:0] EX_ID_wreg_data;//ִ�н׶�ָ������Ҫд��Ŀ�ļĴ�����ֵ
wire MEM_ID_wreg;//ִ�н׶�ָ���Ƿ�ҪдĿ�ļĴ���
wire [31:0] MEM_ID_wreg_addr;//ִ�н׶�ָ��ҪдĿ�ļĴ�����ַ
wire [31:0] MEM_ID_wreg_data;//ִ�н׶�ָ��ҪдĿ�ļĴ�������
wire IDEX_ID_isindelayslot;//�����ӳٲ���
wire [31:0] RF_ID_reg1_data;//�Ĵ�������ֵһ
wire [31:0] RF_ID_reg2_data;//�Ĵ�������ֵ��
//�Ĵ�����ջ�������
wire [4:0] ID_RF_reg1_addr;//����ַ
wire [4:0] ID_RF_reg2_addr;//����ַ
wire ID_RF_reg1;//��ʹ��
wire ID_RF_reg2;//��ʹ��
wire MEMWB_RF_wreg;//дʹ��
wire [4:0] MEMWB_RF_wreg_addr;//д��ַ
wire [31:0] MEMWB_RF_wreg_data;//д����
//IDEX�������










endmodule
