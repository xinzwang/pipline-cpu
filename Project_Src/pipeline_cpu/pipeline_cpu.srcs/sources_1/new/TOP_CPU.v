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
//pc�������?
wire [5:0] CL_PC_stall;//ctrl���ص���ͣ�ź�
wire CL_PC_flush;//ctrl���ص���ͣ�ź�
wire [31:0] CL_PC_newpc;//Ctrll�����쳣����pc���ź�
wire ID_PC_branchflag;//ID��������ת�ź�
wire [31:0] ID_PC_branch_taraddr;//Id��ת��Ŀ�ĵ�ַ
wire [31:0] PC_OUT_1;//��·���߶���
//IM�������?
wire [31:0] PC_IM_addr;//pc�����ȡָ���?
//IFID�������?
wire [5:0] CL_IFID_stall;//ctrl���ص���ͣ�ź�
wire CL_IFID_flush;//ctrl���ص���ͣ�ź�
wire [31:0] PC_IFID_pc;//pc�еĵ�ַ
wire [31:0] IM_IFID_ins;//im�е�ָ��
//ID�������?
wire [31:0] IFID_ID_pc;//����id��pcֵ
wire [31:0] IFID_ID_ins;//����pc��insֵ
wire [7:0] EX_ID_aluop;//����׶��?���е�����������??
wire EX_ID_wreg;//ִ�н׶�ָ���Ƿ�����ҪдĿ�ļĴ���
wire [31:0] EX_ID_wreg_addr;//���ش洢ָ���Ӧ�Ĵ�?����??
wire [31:0] EX_ID_wreg_data;//ִ�н׶�ָ������Ҫд��Ŀ�ļĴ�����ֵ
wire MEM_ID_wreg;//ִ�н׶�ָ���Ƿ�ҪдĿ�ļĴ���
wire [31:0] MEM_ID_wreg_addr;//ִ�н׶�ָ��ҪдĿ�ļĴ�����ַ
wire [31:0] MEM_ID_wreg_data;//ִ�н׶�ָ��ҪдĿ�ļĴ�������
wire IDEX_ID_isindelayslot;//�����ӳٲ���
wire [31:0] RF_ID_reg1_data;//�Ĵ�������ֵһ
wire [31:0] RF_ID_reg2_data;//�Ĵ�������ֵ��
////�Ĵ�����ջ�������?
wire [4:0] ID_RF_reg1_addr;//����ַ
wire [4:0] ID_RF_reg2_addr;//����ַ
wire ID_RF_reg1;//��ʹ��
wire ID_RF_reg2;//��ʹ��
//wire MEMWB_RF_wreg;//дʹ��
//wire [4:0] MEMWB_RF_wreg_addr;//д��ַ
//wire [31:0] MEMWB_RF_wreg_data;//д����
//IDEX�������?
wire [5:0] CL_IDEX_stall;//��ͣ�ź�
wire CL_IDEX_flush;//��ͣ�ź�
wire [7:0] ID_IDEX_aluop;//���������������?
wire [2:0] ID_IDEX_alusel;//�������������?
wire [31:0] ID_IDEX_reg1;//����׶��?����������?������һ
wire [31:0] ID_IDEX_reg2;//����׶��?����������?��������
wire ID_IDEX_wreg;//����׶�ָ���Ƿ�дĿ�ļĴ������?
wire [4:0] ID_IDEX_wreg_addr;//����׶�ָ��дĿ�ļĴ������?
wire [31:0] ID_IDEX_ins;//����׶�ָ��?
wire [31:0] ID_IDEX_ins_addr;//ָ����?
wire ID_IDEX_isindelaysolt;//�ӳٲ۱�־
wire ID_IDEX_next_isindelaysolt;//�ӳٲ۱�־

//EX�������?
wire [7:0] IDEX_EX_aluop;//���������������?
wire [2:0] IDEX_EX_alusel;//�������������?
wire [31:0] IDEX_EX_reg1_data;//ԭ������һ
wire [31:0] IDEX_EX_reg2_data;//ԭ��������
wire IDEX_EX_wreg;//ָ��ִ���Ƿ�Ҫд��Ŀ�ļĴ���
wire [4:0] IDEX_EX_wreg_addr;//д��Ŀ�ļĴ�����ַ
wire [31:0] IDEX_EX_ins;//ִ�н׶�ָ��
wire [31:0] IDEX_EX_ins_addr;//ִ�н׶�ָ����?
wire IDEX_EX_isindelayslot;//ִ�н׶�ָ�����ӳٲ�
wire [31:0] HILO_EX_hi;
wire [31:0] HILO_EX_lo;
wire [31:0] MEMWB_EX_hi;
wire [31:0] MEMWB_EX_lo;
wire MEMWB_EX_whilo;//���ڻ�д�׶ε�ָ���Ƿ�ҪдHILO�Ĵ���
wire [31:0] MEM_EX_hi;
wire [31:0] MEM_EX_lo;
wire MEM_EX_whilo;//���ڷô�׶ε�ָ���Ƿ��?дHILO�Ĵ���
//EX��������ָ��
wire [63:0] EXMEM_EX_hilo_temp;
wire [1:0] EXMEM_EX_cnt;
wire DIV_EX_div_res;//�������?
wire DIV_EX_ready;//�������?
//EXMEMģ������
wire [5:0] CL_EXMEM_stall;//��ͣ
wire CL_EXMEM_flush;//���?
wire [31:0] EX_EXMEM_mem_addr;//ִ�н׶μ��أ��洢ָ���Ӧ�Ĵ�?����??
wire [31:0] EX_EXMEM_reg2;//ִ�н׶δ洢ָ��Ҫ�洢�����ݣ���lwlָ��Ҫд���Ŀ�ļĴ����?ʼ??
wire [31:0] EX_EXMEM_hi;//ִ�н׶�Ҫд��hi�Ĵ�����ֵ
wire [31:0] EX_EXMEM_lo;
wire EX_EXMEM_whilo;//ִ�н׶�ָ���Ƿ�Ҫдhilo�Ĵ���
wire [63:0] EX_EXMEM_hilo;//����˷��Ľ��
wire [1:0] EX_EXMEM_cnt;//��һ�׶�ʱ�����ڴ���ִ�н׶εڼ�����
wire EX_EXMEM_isindelaysolt;//�ô�׶��Ƿ����ӳٲ�ָ��?
wire [31:0] EX_EXMEM_ins_addr;//�ô�׶�ָ���ַ
wire [7:0] EX_EXMEM_aluop;//ִ�н׶�ָ��Ҫ���е������������?
wire EX_EXMEM_wreg;//ִ�н׶�ָ���Ƿ�ҪдĿ�ļĴ���
wire [4:0] EX_EXMEM_wreg_addr;//ִ�н׶�ָ��ҪдĿ�ļĴ�����ַ
wire [31:0] EX_EXMEM_wreg_data;//ִ�н׶�ָ��ҪдĿ�ļĴ���ֵ
//MEMģ������
wire EXMEM_MEM_wreg;//�ô�׶�ָ���Ƿ����?д��Ŀ�ļĴ���??
wire [31:0] EXMEM_MEM_wreg_addr;//�ô�׶��?д��Ŀ�ļĴ�����??
wire [31:0] EXMEM_MEM_wreg_data;//�ô�׶��?д��Ŀ�ļĴ�������??
wire [63:0] EXMEM_MEM_whilo;//�ô�׶�ָ���Ƿ��?дHILO�Ĵ���
wire [31:0] EXMEM_MEM_hi;
wire [31:0] EXMEM_MEM_lo;
wire [7:0] EXMEM_MEM_aluop;//�ô�׶�ָ���?���е�����������??
wire [31:0] EXMEM_MEM_mem_addr;//�������ݴ洢����ַ
wire [31:0] DM_MEM_mem_data;//�����ݴ洢����ȡ������
wire [31:0] EXMEM_MEM_reg2;//�ô�׶δ洢ָ���?�洢�����ݣ���lwlָ��Ҫд���Ŀ�ļĴ����?ʼ??
wire EXMEM_MEM_isindelayslot;//�ô�׶��Ƿ�ʱ�ӳٲ�ָ��?
wire [31:0] EXMEM_MEM_ins_addr;//�ô�׶�ָ���ַ
wire [31:0] DM_data;//���������ڴ�
//DM����
wire [31:0] MEM_DM_mem_addr;
wire MEM_DM_mem_we;
wire [31:0] MEM_DM_mem_data;

//MEMWBģ������
wire [5:0] CL_MEMWB_stall;
wire CL_MEMWB_flush;
wire MEM_MEMWB_mem_wreg;//�Ƿ�ҪдĿ�ļĴ���
wire [31:0] MEM_MEMWB_mem_wreg_addr;//дĿ�ļĴ�����ַ
wire [31:0] MEM_MEMWB_mem_wreg_data;//дĿ�ļĴ�������
wire [63:0] MEM_MEMWB_mem_whilo;//�ô�׶�ָ���Ƿ��?дHILO�Ĵ���
wire [31:0] MEM_MEMWB_mem_hi;//�ô�׶�ָ��дHI�Ĵ���ֵ
wire [31:0] MEM_MEMWB_mem_lo;//�ô�׶�ָ��дLO�Ĵ���ֵ
//HILOģ������
wire MEMWB_HILO_we;//HILOдʹ���ź�
wire [31:0] MEMWB_HILO_hi;//HILOдhi
wire [31:0] MEMWB_HILO_lo;//HILOдlo
//CLģ������
wire stallreq_from_EX;
wire stallreq_from_ID;
//RF
wire ID_RF_re1;
wire ID_RF_re2;
wire [31:0] ID_RF_re1_addr;
wire [31:0] ID_RF_re2_addr;
wire MEMWB_RF_wreg;//ʹ��
wire [31:0] MEMWB_RF_wreg_addr;//��ַ
wire [31:0] MEMWB_RF_wreg_data;//����
//���Ͼ��Ƕ�����?��ģ������������������ģ�鶨��??
Program_Counter PC_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromCL_stall(CL_PC_stall),//���ڳ˳�����������ˮ�ӳٵ��ź���
    .I_FromCL_flush(CL_PC_flush),//���ڳ˳�����������ˮ�ӳٵ��ź���
    .I_FromCL_newpc(CL_PC_newpc),//�����쳣��������µ�ַ���ֽ׶β��ù�?
    .I_FromID_branchflag(ID_PC_branchflag),//��תָ���Ӧ���źţ����������?��ַ��??
    .I_FromID_branch_taraddr(ID_PC_branch_taraddr),//��ת��ַ
    .O_ToIM_IFID_pc(PC_OUT_1)//�����ָ���ַ
    //output reg ce//pcʹ���ź�
);
    assign PC_IM_addr=PC_OUT_1;
    assign PC_IFID_pc=PC_OUT_1;
    
Instruction_Memory IM_cpu(
    .a(PC_IM_addr),
    .spo(IM_IFID_ins)
);

IF_ID IFID_cpu(
    .clk(clk),
    .rst(rst),
    .CL_stall(CL_IFID_stall),
    .CL_flush(CL_IFID_flush),
    .IF_pc(PC_IFID_pc),
    .IF_ins(IM_IFID_ins),
    .ID_pc(IFID_ID_pc),
    .ID_ins(IFID_ID_ins)
);

Instruction_Decoder ID_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromIFID_pc(IFID_ID_pc),//����׶�ָ���Ӧ�ĵ�ַ
    .I_FromIFID_ins(IFID_ID_ins),//����׶ε�ָ��?
//��Ĵ�����ջ��ز���
    .I_FromRF_reg1_data(RF_ID_reg1_data),//�ӼĴ�����ջ�����ĵ�һ���˿�����
    .I_FromRF_reg2_data(RF_ID_reg2_data),//�ӼĴ�����ջ�����ĵڶ����˿�����
    .O_ToRF_reg1(ID_RF_reg1),//�Ĵ�����ջ��һ�����˿�ʹ���ź�
    .O_ToRF_reg2(ID_RF_reg2),//�Ĵ�����ջ�ڶ������˿�ʹ���ź�
    .O_ToRF_reg1_addr(ID_RF_reg1_addr),//�Ĵ�����ջ��һ�����˿ڵ�ַ
    .O_ToRF_reg2_addr(ID_RF_reg2_addr),//�Ĵ�����ջ�ڶ������˿ڵ�ַ
    .O_ToIDEX_wreg(ID_IDEX_wreg),//�Ĵ�����ջд�˿�ʹ���ź�
    .O_ToIDEX_wreg_addr(ID_IDEX_wreg_addr),//�Ĵ�����ջд�˿ڵ�ַ
    .O_ToIDEX_aluop(ID_IDEX_aluop),//����׶��?���е�����������??
    .O_ToIDEX_alusel(ID_IDEX_alusel),//����׶��?���е����������?
    .O_ToIDEX_reg1(ID_IDEX_reg1),//����׶��?���е�������?������һ
    .O_ToIDEX_reg2(ID_IDEX_reg2),//����׶��?���е�������?��������
//���½ӿ���ҪΪ���������ؽ�������ϸ�Ķ�P113�������?
    .I_FromEX_wreg(EX_ID_wreg),//����ִ�н׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
    .I_FromEX_wreg_addr(EX_ID_wreg_addr),//����ִ�н׶ε�ָ��ҪдĿ�ļĴ�����ַ
    .I_FromEX_wreg_data(EX_ID_wreg_data),//����ִ�н׶ε�ָ��дĿ�ļĴ�������
    .I_FromEX_aluop(EX_ID_aluop),//����ִ�н׶ε�ָ��дĿ�ļĴ�������
    .I_FromMEM_wreg(MEM_ID_wreg),//���ڷô�׶ε�ָ���Ƿ��?дĿ�ļĴ���??
    .I_FromMEM_wreg_addr(MEM_ID_wreg_addr),//���ڷô�׶ε�ָ���?дĿ�ļĴ�����??
    .I_FromMEM_wreg_data(MEM_ID_wreg_data),//���ڷô�׶ε�ָ��дĿ�ļĴ�������?
//��תָ���ӳٲ��ź�
    .I_FromIDEX_isindelayslot(IDEX_ID_isindelayslot),//��ǰ����ָ���Ƿ����ӳٲ�
    .O_ToIDEX_isindelayslot(ID_IDEX_next_isindelaysolt),//��ǰ����ָ���Ƿ����ӳٲ�  �޸�Ϊreg����
    .O_ToPC_branchflag(ID_PC_branchflag),//��ת�ź�
    .O_ToPC_branch_taraddr(ID_PC_branch_taraddr),//��תĿ�ĵ�ַ
//������ָ����ˮֹͣ�����ź�
    .stallreq(stallreq_from_ID), //�޸�Ϊwire����
    .O_ToIDEX_ins_addr(ID_IDEX_ins_addr),
    .O_ToIDEX_ins(ID_IDEX_ins)
//��������Ŀǰ�ò���
//    .I_FromEX_aluop_i, //����ִ�н׶�ָ�������������?
//    .O_ToIDEX_wd, //����׶ε�ָ���?д���Ŀ�ļĴ������?
//    .O_ToIDEX_link_addr, //ת��ָ��Ҫ����ķ��ص��?
//    .O_ToIDEX_next_isindelayslot, //��һ����������׶ε�ָ���Ƿ�λ���ӳٲ�?
//    .O_ToIDEX_inst, //��ǰ��������׶ε�ָ��?
//    .O_ToIDEX_excepttype, //�ռ����쳣��Ϣ
//    .O_ToIDEX_current_inst_address //����׶�ָ��ĵ�ַ
);

wire ID_IDEX_next_ins_isindelayslot;
wire IDEX_ID_is_indelayslot;

ID_EX IDEX_cpu(
    .clk(clk),
    .rst(rst),
    .CL_stall(CL_IDEX_stall),
    .CL_flush(CL_IDEX_flush),
    .ID_alusel(ID_IDEX_alusel),//����׶��?�������������?
    .ID_aluop(ID_IDEX_aluop),//����׶�ָ���?���������������?
    .ID_reg1(ID_IDEX_reg1),//����׶�ָ���?���������Դ�������?
    .ID_reg2(ID_IDEX_reg2),//����׶�ָ���?���������Դ��������?
    .ID_wreg(ID_IDEX_wreg),//����׶�ָ���Ƿ��?д��Ŀ�ļĴ���??
    .ID_wreg_addr(ID_IDEX_wreg_addr),//����׶�ָ���?д���Ŀ�ļĴ������?
    .ID_ins(ID_IDEX_ins),//����ID�ľ���ָ��ֵ
    .ID_ins_addr(ID_IDEX_ins_addr),//����ID�ľ���ָ����?
    .ID_isindelayslot(ID_IDEX_isindelaysolt),//�ӳٲ�
    .ID_next_ins_isindelayslot(ID_IDEX_next_ins_isindelayslot),
    
    .EX_alusel(IDEX_EX_alusel),//ִ�н׶�Ҫ�������������?
    .EX_aluop(IDEX_EX_aluop),//ִ�н׶�Ҫ���������������?
    .EX_reg1(IDEX_EX_reg1_data),//ִ�н׶�ָ��Ҫ���������Դ�������?
    .EX_reg2(IDEX_EX_reg2_data),//ִ�н׶�ָ��Ҫ���������Դ��������?
    .EX_wreg_addr(IDEX_EX_wreg_addr),//ִ�н׶�ָ��Ҫд���Ŀ�ļĴ������?
    .EX_wreg(IDEX_EX_wreg),//ִ�н׶�ָ���Ƿ�Ҫд��Ŀ�ļĴ���
    .EX_ins(IDEX_EX_ins),//��ex�ľ���ָ��ֵ
    .EX_ins_addr(IDEX_EX_ins_addr),//��EX�ľ���ָ����?
    .EX_isindelayslot(IDEX_EX_isindelayslot),
    .IDEX_ID_isindelayslot(IDEX_ID_is_indelayslot)
);


wire EX_OUT_1;
wire [7:0] EX_OUT_2;
wire [4:0] EX_OUT_3;
wire [31:0] EX_OUT_4;

EX EX_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromIDEX_alusel(IDEX_EX_alusel),//ִ�н׶�Ҫ����ָ�������?
    .I_FromIDEX_aluop(IDEX_EX_aluop),//ִ�н׶�Ҫ����ָ���������?
    .I_FromIDEX_reg1(IDEX_EX_reg1_data),//���������Դ�������?
    .I_FromIDEX_reg2(IDEX_EX_reg2_data),//���������Դ��������?
    .I_FromIDEX_wreg(IDEX_EX_wreg),//ָ��ִ���Ƿ� Ҫд��Ŀ�ļĴ���
    .I_FromIDEX_wreg_addr(IDEX_EX_wreg_addr),//ָ��ִ��Ҫд���Ŀ�ļĴ������?
    .I_FromIDEX_ins(IDEX_EX_ins),
    .I_FromIDEX_ins_addr(IDEX_EX_ins_addr),//ִ�н׶�ָ����?
    .O_ToEXMEM_reg2(EX_EXMEM_reg2),//�洢ָ��Ҫ�洢�����ݣ�����lwrָ��Ҫд���Ŀ�ļĴ����?ʼ??
//HILOģ����
    .I_FromHILO_hi(HILO_EX_hi),//hilo��hi��ֵ
    .I_FromHILO_lo(HILO_EX_lo),//hilo��lo��ֵ
//mem�׶���hilo�Ľ�������
    .I_FromMEM_whilo(MEM_EX_whilo),//�ô�׶�ָ���Ƿ����?дHILO�Ĵ���
    .I_FromMEM_wb_hi(MEM_EX_hi),//�ô�׶�д��HILO��hi��ֵ
    .I_FromMEM_wb_lo(MEM_EX_lo),//�ô�׶�д��HILO��lo��ֵ
//memwb�׶���hilo�Ľ�������
    .I_FromMEMWB_whilo(MEMWB_EX_whilo),//��д�׶�ָ���Ƿ���ҪдHILO�Ĵ���
    .I_FromMEMWB_wb_hi(MEMWB_EX_hi),//��д�׶�д��HILO��hi��ֵ
    .I_FromMEMWB_wb_lo(MEMWB_EX_lo),//��д�׶�д��HILO��lo��ֵ
//�漰�˷��������?
    .I_FromEXMEM_hilo_temp(EXMEM_EX_hilo_temp),//��һ��ִ�����ڵõ��ĳ˷����?
    .I_FromEXMEM_cnt(EXMEM_EX_cnt),//D��ǰ����ִ�н׶εĵڼ�������
    .O_ToEXMEM_hilo_temp(EX_EXMEM_hilo),//��һ��ִ�����ڵõ��ĳ˷����?
    .O_ToEXMEM_cnt(EX_EXMEM_cnt),//��һ��ʱ�����ڴ���ִ�н׶εĵڼ���ʼ������
//�漰�����������?
    .I_FromDIV_divready(DIV_EX_ready),//���������Ƿ����?
    .I_FromDIV_divres(),//����������
    .O_ToDIV_signediv(),//�Ƿ�Ϊ�з��ų���1-->�з��ţ�0->�޷���
    .O_ToDIV_opdata1(),//������
    .O_ToDIV_opdata2(),//����
    .O_ToDIV_divstart(),//�����Ƿ�ʼ
//�ӳٲ���ر���?
    .I_FromIDEX_isindelayslot(IDEX_EX_isindelayslot),//�ӳٲ۱��?
    .O_TOEXMEM_isindelayslot(EX_EXMEM_isindelaysolt),//�ӳٲ۱��?
//��ô棬ID��صĽӿ�?
    .O_To_EXMEM_mem_addr(EX_EXMEM_mem_addr),//���ش洢ָ���Ӧ�Ĵ�?����??
    .O_To_ID_EXMEM_wreg(EX_OUT_1),//ִ�н׶�ָ�������Ƿ���Ҫд��Ŀ�ļĴ���
    .O_To_ID_EXMEM_aluop(EX_OUT_2),//ִ�н׶�ָ����е�����������?
    .O_To_ID_EXMEM_wreg_addr(EX_OUT_3),//���ش洢ָ���Ӧ�Ĵ�?����??
    .O_To_ID_EXMEM_wreg_data(EX_OUT_4),//�洢ָ��Ҫ�洢�����ݣ��Լ����ص�Ŀ�ļĴ�����ԭʼֵ
//��ˮ��ͣ����
    .stallreq(stallreq_from_EX)//������ˮ��ͣ
);

    assign EX_EXMEM_aluop=EX_OUT_2;
    assign EX_EXMEM_wreg=EX_OUT_1 ;
    assign EX_EXMEM_wreg_addr=EX_OUT_3 ;
    assign EX_EXMEM_wreg_data=EX_OUT_4 ;
    assign EX_ID_aluop=EX_OUT_2 ;
    assign EX_ID_wreg=EX_OUT_1 ;
    assign EX_ID_wreg_addr=EX_OUT_3 ;
    assign EX_ID_wreg_data=EX_OUT_4 ;
    
EX_MEM EXMEM_cpu(
    .clk(clk),
    .rst(rst),
    .CL_stall(CL_EXMEM_stall),
    .CL_flush(CL_EXMEM_flush),
    .EX_mem_addr(EX_EXMEM_mem_addr),//ִ�н׶�Ҫд���ڴ���?
    .EX_reg2(EX_EXMEM_reg2),
    .EX_whilo(EX_EXMEM_whilo),
    .EX_hi(EX_EXMEM_hi),
    .EX_lo(EX_EXMEM_lo),
    .EX_hilo(EX_EXMEM_hilo),
    .EX_cnt(EX_EXMEM_cnt),
    .EX_isindelayslot(EX_EXMEM_isindelaysolt),
    .EX_ins_addr(EX_EXMEM_ins_addr),
    .EX_aluop(EX_EXMEM_aluop),
    .EX_wreg(EX_EXMEM_wreg),//ִ�н׶�ָ��ִ�к��Ƿ�Ҫд��Ŀ�ļĴ���
    .EX_wreg_addr(EX_EXMEM_wreg_addr),//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ����ĵ�ַ
    .EX_wreg_data(EX_EXMEM_wreg_data),//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ
    .MEM_wreg(EXMEM_MEM_wreg),//�ô�׶�ָ��ִ�к��Ƿ��?д��Ŀ�ļĴ���??
    .MEM_wreg_addr(EXMEM_MEM_wreg_addr),//�ô�׶�ָ��ִ�к��?д��Ŀ�ļĴ����ĵ�??
    .MEM_wreg_data(EXMEM_MEM_wreg_data),//�ô�׶�ָ��ִ�к��?д��Ŀ�ļĴ�����??
    .MEM_hi(EXMEM_MEM_hi),
    .MEM_lo(EXMEM_MEM_lo),
    .MEM_whilo(EXMEM_MEM_whilo),
    .MEM_aluop(EXMEM_MEM_aluop),
    .MEM_mem_addr(EXMEM_MEM_mem_addr),//д�ڴ���?
    .MEM_reg2(EXMEM_MEM_reg2),
    .MEM_isindelayslot(EXMEM_MEM_isindelayslot),
    .MEM_ins_addr(EXMEM_MEM_ins_addr),
    .EXMEM_EX_hilo(EXMEM_EX_hilo_temp),
    .EXMEM_EX_cnt(EXMEM_EX_cnt) 
);

wire MEM_OUT_1;
wire [4:0] MEM_OUT_2;
wire [31:0] MEM_OUT_3;
wire MEM_OUT_4;
wire [31:0] MEM_OUT_5;
wire [31:0] MEM_OUT_6;

MEM MEM_cpu(
    .rst(rst),
    .I_FROMEX_MEM_wreg(EXMEM_MEM_wreg),
    .I_FROMEX_MEM_wd(EXMEM_MEM_wreg_addr),
    .I_FROMEX_MEM_wdata(EXMEM_MEM_wreg_data),
    .O_TOMEM_WB_ID_wreg(MEM_OUT_1),
    .O_TOMEM_WB_ID_wd(MEM_OUT_2),
    .O_TOMEM_WB_ID_wdata(MEM_OUT_3),
    .I_FROMEX_MEM_whilo(EXMEM_MEM_whilo),
    .I_FROMEX_MEM_hi(EXMEM_MEM_hi),
    .I_FROMEX_MEM_lo(EXMEM_MEM_lo),
    .O_TOMEM_WB_EX_whilo(MEM_OUT_4),
    .O_TOMEM_WB_EX_hi(MEM_OUT_5),
    .O_TOMEM_WB_EX_lo(MEM_OUT_6),
    .I_FROMEX_MEM_aloup(EXMEM_MEM_aluop),
    .I_FROMEX_MEM_mem_addr(EXMEM_MEM_mem_addr),
    .I_FROMEX_MEM_reg2(EXMEM_MEM_reg2),
    //.I_FROMEX_MEM_mem_data(EXMEM_MEM_mem_data),
    . I_FROMDATA_RAM_mem_data(DM_data),
	.O_TODATA_RAM_mem_addr(MEM_DM_mem_addr),//要�?�问的数�?存储器的地址
	.O_TODATA_RAM_mem_we(MEM_DM_mem_we),//�?否是写操作，�?1表示�?写操�?
	.O_TODATA_RAM_mem_sel(),//字节选择信号
	.O_TODATA_RAM_mem_data(MEM_DM_mem_data),//要写入数�?存储器的数�??
    .I_FROMEX_MEM_isindelayslot(EXMEM_MEM_isindelayslot),
    .O_TOMEM_WB_isindelayslot()
);

    assign MEM_MEMWB_mem_wreg=MEM_OUT_1;
    assign MEM_ID_wreg=MEM_OUT_1;
    assign MEM_MEMWB_mem_wreg_addr=MEM_OUT_2;
    assign MEM_ID_wreg_addr=MEM_OUT_2;
    assign MEM_MEMWB_mem_wreg_data=MEM_OUT_3;
    assign MEM_ID_wreg_data=MEM_OUT_3;
    assign MEM_MEMWB_mem_whilo=MEM_OUT_4;
    assign MEM_EX_whilo=MEM_OUT_4;
    assign MEM_MEMWB_mem_hi=MEM_OUT_5;
    assign MEM_EX_hi=MEM_OUT_5;
    assign MEM_MEMWB_mem_lo=MEM_OUT_6;
    assign MEM_EX_lo=MEM_OUT_6;


Data_Memory DM_cpu(
    .clk(clk),
    .a(MEM_DM_mem_addr[15:0]),
    .d(MEM_DM_mem_data),
    .we(MEM_DM_mem_we),
    .spo(DM_data)
);



MEM_WB MEMWB_cpu(
    .clk(clk),
    .rst(rst),
    .MEM_wreg(MEM_MEMWB_mem_wreg),//�ô�׶�ָ�������Ƿ���Ҫд���Ŀ�ļĴ���
    .MEM_wreg_addr(MEM_MEMWB_mem_wreg_addr),//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�����ַ
    .MEM_wreg_data(MEM_MEMWB_mem_wreg_data),//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�������
    .WB_wreg(MEMWB_RF_wreg),//�ô�׶�ָ�������Ƿ���Ҫд���Ŀ�ļĴ���
    .WB_wreg_addr(MEMWB_RF_wreg_addr),//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�����ַ
    .WB_wreg_data(MEMWB_RF_wreg_data),//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�������
    //λ��ָ���hilo��ؽӿ�
    .MEM_whilo(MEM_MEMWB_mem_whilo),//�Ƿ�Ҫдhilo
    .MEM_hi_data(MEM_MEMWB_mem_hi),//дhi��ֵ
    .MEM_lo_data(MEM_MEMWB_mem_lo),//дhi��ֵ
    .WB_whilo(MEMWB_OUT_1),//�Ƿ�Ҫдhilo
    .WB_hi_data(MEMWB_OUT_2),//дhi��ֵ
    .WB_lo_data(MEMWB_OUT_3),//дhi��ֵ
    .CL_stall(CL_MEMWB_stall),
    .CL_flush(CL_MEMWB_flush)
);
    assign MEMWB_HILO_we=MEMWB_OUT_1;
    assign MEMWB_EX_whilo=MEMWB_OUT_1;
    assign MEMWB_hi_data=MEMWB_OUT_2;
    assign MEMWB_EX_hi=MEMWB_OUT_2;
    assign MEMWB_lo_data=MEMWB_OUT_3;
    assign MEMWB_EX_lo=MEMWB_OUT_3;
    
HILO HILO_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromMEMWB_wreg(MEMWB_HILO_we),//HILO�Ĵ���дʹ���ź�
    .I_FromMEMWB_hi(MEMWB_hi_data),//д��hi��ֵ
    .I_FromMEMWB_lo(MEMWB_lo_data),//д��lo��ֵ
    .O_ToEX_hi(HILO_EX_hi),//������EX��hi��ֵ
    .O_ToEX_lo(HILO_EX_lo)//������EX��lo��ֵ
);

Ctrl CL_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromID_stallreq(stallreq_from_ID),//��������׶�ָ���Ƿ�������ˮ����ͣ
    .I_FromEX_stallreq(stallreq_from_EX),//����ִ�н׶�ָ���Ƿ�������ˮ����ͣ
    .stall(CL_OUT_1),//������ˮ����ͣ�ź�
    .flush(CL_OUT_2),
    .O_ToPC_new_pc(CL_PC_newpc)
);
    assign CL_PC_stall=CL_OUT_1;
    assign CL_IFID_stall=CL_OUT_1;
    assign CL_IDEX_stall=CL_OUT_1;
    assign CL_EXMEM_stall=CL_OUT_1;
    assign CL_MEMWB_stall=CL_OUT_1;
    assign CL_PC_flush=CL_OUT_2;
    assign CL_IFID_flush=CL_OUT_2;
    assign CL_IDEX_flush=CL_OUT_2;
    assign CL_EXMEM_flush=CL_OUT_2;
    assign CL_MEMWB_flush=CL_OUT_2;


Register_File RF_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromMEM_WB_we(MEMWB_RF_wreg),
    .I_FromMEM_WB_waddr(MEMWB_RF_wreg_addr),
    .I_FromMEM_WB_wdata(MEMWB_RF_wreg_data),
	.I_FromID_re1(ID_RF_reg1),
	.I_FromID_raddr1(ID_RF_reg1_addr),
	.O_ToID_rdata1(RF_ID_reg1_data),
    .I_FromID_re2(ID_RF_reg2),
    .I_FromID_raddr2(ID_RF_reg2_addr),
    .O_ToID_rdata2(RF_ID_reg2_data)
);

endmodule
