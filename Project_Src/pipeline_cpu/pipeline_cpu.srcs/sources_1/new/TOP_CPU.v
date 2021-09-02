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
wire [31:0] PC_OUT_1;//��·���߶���
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
wire CL_IDEX_stall;//��ͣ�ź�
wire [7:0] ID_IDEX_aluop;//���������������
wire [2:0] ID_IDEX_alusel;//�������������
wire [31:0] ID_IDEX_reg1;//����׶�Ҫ���������ԭ������һ
wire [31:0] ID_IDEX_reg2;//����׶�Ҫ���������ԭ��������
wire ID_IDEX_wreg;//����׶�ָ���Ƿ�дĿ�ļĴ�����ַ
wire [4:0] ID_IDEX_wreg_addr;//����׶�ָ��дĿ�ļĴ�����ַ
wire [31:0] ID_IDEX_ins;//����׶�ָ��
wire [31:0] ID_IDEX_ins_addr;//ָ���ַ
wire ID_IDEX_isindelaysolt;//�ӳٲ۱�־
wire ID_IDEX_next_isindelaysolt;//�ӳٲ۱�־

//EX�������
wire [7:0] IDEX_EX_aluop;//���������������
wire [2:0] IDEX_EX_alusel;//�������������
wire [31:0] IDEX_EX_reg1_data;//ԭ������һ
wire [31:0] IDEX_EX_reg2_data;//ԭ��������
wire IDEX_EX_wreg;//ָ��ִ���Ƿ�Ҫд��Ŀ�ļĴ���
wire [4:0] IDEX_EX_wreg_addr;//д��Ŀ�ļĴ�����ַ
wire [31:0] IDEX_EX_ins;//ִ�н׶�ָ��
wire [31:0] IDEX_EX_ins_addr;//ִ�н׶�ָ���ַ
wire IDEX_EX_isindelayslot;//ִ�н׶�ָ�����ӳٲ�
wire [31:0] HILO_EX_hi;
wire [31:0] HILO_EX_lo;
wire [31:0] MEMWB_EX_hi;
wire [31:0] MEMWB_EX_lo;
wire MEMWB_EX_whilo;//���ڻ�д�׶ε�ָ���Ƿ�ҪдHILO�Ĵ���
wire [31:0] MEM_EX_hi;
wire [31:0] MEM_EX_lo;
wire MEM_EX_whilo;//���ڷô�׶ε�ָ���Ƿ�ҪдHILO�Ĵ���
//EX��������ָ��
wire EXMEM_EX_hilo_temp;
wire EXMEM_EX_cnt;
wire EXMEM_EX_;
wire DIV_EX_div_res;//�������
wire DIV_EX_ready;//�������
//EXMEMģ������
wire CL_EXMEM_stall;//��ͣ
wire CL_EXMEM_flush;//���
wire EX_EXMEM_mem_addr;//ִ�н׶μ��أ��洢ָ���Ӧ�Ĵ洢����ַ
wire EX_EXMEM_reg2;//ִ�н׶δ洢ָ��Ҫ�洢�����ݣ���lwlָ��Ҫд���Ŀ�ļĴ���ԭʼֵ
wire EX_EXMEM_hi;//ִ�н׶�Ҫд��hi�Ĵ�����ֵ
wire EX_EXMEM_lo;
wire EX_EXMEM_whilo;//ִ�н׶�ָ���Ƿ�Ҫдhilo�Ĵ���
wire EX_EXMEM_hilo;//����˷��Ľ��
wire EX_EXMEM_cnt;//��һ�׶�ʱ�����ڴ���ִ�н׶εڼ�����
wire EX_EXMEM_isindelaysolt;//�ô�׶��Ƿ����ӳٲ�ָ��
wire EX_EXMEM_ins_addr;//�ô�׶�ָ���ַ
wire EX_EXMEM_aluop;//ִ�н׶�ָ��Ҫ���е������������
wire EX_EXMEM_wreg;//ִ�н׶�ָ���Ƿ�ҪдĿ�ļĴ���
wire EX_EXMEM_wreg_addr;//ִ�н׶�ָ��ҪдĿ�ļĴ�����ַ
wire EX_EXMEM_wreg_data;//ִ�н׶�ָ��ҪдĿ�ļĴ���ֵ
//MEMģ������
wire EXMEM_MEM_wreg;//�ô�׶�ָ���Ƿ���Ҫд��Ŀ�ļĴ���
wire EXMEM_MEM_wreg_addr;//�ô�׶�Ҫд��Ŀ�ļĴ�����ַ
wire EXMEM_MEM_wreg_data;//�ô�׶�Ҫд��Ŀ�ļĴ�������
wire EXMEM_MEM_whilo;//�ô�׶�ָ���Ƿ�ҪдHILO�Ĵ���
wire EXMEM_MEM_hi;
wire EXMEM_MEM_lo;
wire EXMEM_MEM_aluop;//�ô�׶�ָ��Ҫ���е�����������
wire EXMEM_MEM_mem_addr;//�������ݴ洢����ַ
wire DM_MEM_mem_data;//�����ݴ洢����ȡ������
wire EXMEM_MEM_reg2;//�ô�׶δ洢ָ��Ҫ�洢�����ݣ���lwlָ��Ҫд���Ŀ�ļĴ���ԭʼֵ
wire EXMEM_MEM_isindelayslot;//�ô�׶��Ƿ�ʱ�ӳٲ�ָ��
wire EXMEM_MEM_ins_addr;//�ô�׶�ָ���ַ
//MEMWBģ������
wire CL_MEMWB_stall;
wire CL_MEMWB_flush;
wire MEM_MEMWB_mem_wreg;//�Ƿ�ҪдĿ�ļĴ���
wire MEM_MEMWB_mem_wreg_addr;//дĿ�ļĴ�����ַ
wire MEM_MEMWB_mem_wreg_data;//дĿ�ļĴ�������
wire MEM_MEMWB_mem_whilo;//�ô�׶�ָ���Ƿ�ҪдHILO�Ĵ���
wire MEM_MEMWB_mem_hi;//�ô�׶�ָ��дHI�Ĵ���ֵ
wire MEM_MEMWB_mem_lo;//�ô�׶�ָ��дLO�Ĵ���ֵ
//HILOģ������
wire MEMWB_HILO_we;//HILOдʹ���ź�
wire MEMWB_HILO_hi;//HILOдhi
wire MEMWB_HILO_lo;//HILOдlo
//CLģ������
wire stallreq_from_EX;
wire stallreq_from_ID;
//���Ͼ��Ƕ����ȫ��ģ������������������ģ�鶨��
Program_Counter PC_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromCL_stall(CL_PC_stall),//���ڳ˳�����������ˮ�ӳٵ��ź���
    .I_FromCL_newpc(CL_PC_newpc),//�����쳣��������µ�ַ���ֽ׶β��ù�
    .I_FromID_branchflag(ID_PC_branchflag),//��תָ���Ӧ���źţ���������ת��ַ��
    .I_FromID_branch_taraddr(ID_PC_branch_taraddr),//��ת��ַ
    .O_ToIM_IFID_pc(PC_OUT_1)//�����ָ���ַ
    //output reg ce//pcʹ���ź�
);
    assign PC_IM_addr=PC_OUT_1;
    assign PC_IFID_pc=PC_OUT_1;
    
Data_Memory DM_cpu(
    .a(PC_IM_addr),
    .spo(IM_IFID_ins)
);

IF_ID IFID_cpu(
    .clk(clk),
    .rst(rst),
    .IF_pc(PC_IFID_pc),
    .IF_ins(IM_IFID_ins),
    .ID_pc(IFID_ID_pc),
    .ID_ins(IFID_ID_ins)
);

Instruction_Decoder ID_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromIFID_pc(IFID_ID_pc),//����׶�ָ���Ӧ�ĵ�ַ
    .I_FromIFID_ins(IFID_ID_ins),//����׶ε�ָ��
//��Ĵ�����ջ��ز���
    .I_FromRF_reg1_data(RF_ID_reg1_data),//�ӼĴ�����ջ�����ĵ�һ���˿�����
    .I_FromRF_reg2_data(RF_ID_reg2_data),//�ӼĴ�����ջ�����ĵڶ����˿�����
    .O_ToRF_reg1(ID_RF_reg1),//�Ĵ�����ջ��һ�����˿�ʹ���ź�
    .O_ToRF_reg2(ID_RF_reg2),//�Ĵ�����ջ�ڶ������˿�ʹ���ź�
    .O_ToRF_reg1_addr(ID_RF_reg1_addr),//�Ĵ�����ջ��һ�����˿ڵ�ַ
    .O_ToRF_reg2_addr(ID_RF_reg2_addr),//�Ĵ�����ջ�ڶ������˿ڵ�ַ
    .O_ToIDEX_wreg(ID_IDEX_wreg),//�Ĵ�����ջд�˿�ʹ���ź�
    .O_ToRF_wreg_addr(ID_IDEX_wreg_addr),//�Ĵ�����ջд�˿ڵ�ַ
    .O_ToIDEX_aluop(ID_IDEX_aluop),//����׶�Ҫ���е�����������
    .O_ToIDEX_alusel(ID_IDEX_alusel),//����׶�Ҫ���е����������
    .O_ToIDEX_reg1(ID_IDEX_reg1),//����׶�Ҫ���е������ԭ������һ
    .O_ToIDEX_reg2(ID_IDEX_reg2),//����׶�Ҫ���е������ԭ��������
//���½ӿ���ҪΪ���������ؽ�������ϸ�Ķ�P113�������
    .I_FromEX_wreg(EX_ID_wreg),//����ִ�н׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
    .I_FromEX_wreg_addr(EX_ID_wreg_addr),//����ִ�н׶ε�ָ��ҪдĿ�ļĴ�����ַ
    .I_FromEX_wreg_data(EX_ID_wreg_data),//����ִ�н׶ε�ָ��дĿ�ļĴ�������
    .I_FromMEM_wreg(MEM_ID_wreg),//���ڷô�׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
    .I_FromMEM_wreg_addr(MEM_ID_wreg_addr),//���ڷô�׶ε�ָ��ҪдĿ�ļĴ�����ַ
    .I_FromMEM_wreg_data(MEM_ID_wreg_data),//���ڷô�׶ε�ָ��дĿ�ļĴ�������
//��תָ���ӳٲ��ź�
    .I_FromIDEX_isindelayslot(IDEX_ID_isindelayslot),//��ǰ����ָ���Ƿ����ӳٲ�
    .O_ToIDEX_isindelayslot(ID_IDEX_next_isindelaysolt),//��ǰ����ָ���Ƿ����ӳٲ�  �޸�Ϊreg����
    .O_ToPC_branchflag(ID_PC_branchflag),//��ת�ź�
    .O_ToPC_branch_taraddr(ID_PC_branch_taraddr),//��תĿ�ĵ�ַ
//������ָ����ˮֹͣ�����ź�
    .stallreq(stallreq_from_ID), //�޸�Ϊwire����
    .O_ToIDEX_ins_addr(ID_IDEX_ins_addr)
//��������Ŀǰ�ò���
//    .I_FromEX_aluop_i, //����ִ�н׶�ָ�������������
//    .O_ToIDEX_wd, //����׶ε�ָ��Ҫд���Ŀ�ļĴ�����ַ
//    .O_ToIDEX_link_addr, //ת��ָ��Ҫ����ķ��ص�ַ
//    .O_ToIDEX_next_isindelayslot, //��һ����������׶ε�ָ���Ƿ�λ���ӳٲ�
//    .O_ToIDEX_inst, //��ǰ��������׶ε�ָ��
//    .O_ToIDEX_excepttype, //�ռ����쳣��Ϣ
//    .O_ToIDEX_current_inst_address //����׶�ָ��ĵ�ַ
);

ID_EX IDEX_cpu(
    .clk(clk),
    .rst(rst),
    .ID_alusel(ID_IDEX_alusel),//����׶�Ҫ�������������
    .ID_aluop(ID_IDEX_aluop),//����׶�ָ��Ҫ���������������
    .ID_reg1(ID_IDEX_reg1),//����׶�ָ��Ҫ���������Դ������һ
    .ID_reg2(ID_IDEX_reg2),//����׶�ָ��Ҫ���������Դ��������
    .ID_wreg(ID_IDEX_wreg),//����׶�ָ���Ƿ�Ҫд��Ŀ�ļĴ���
    .ID_wreg_addr(ID_IDEX_wreg_addr),//����׶�ָ��Ҫд���Ŀ�ļĴ�����ַ
    .ID_ins(ID_IDEX_ins),//����ID�ľ���ָ��ֵ
    .ID_ins_addr(ID_IDEX_ins_addr),//����ID�ľ���ָ���ַ
    .ID_isindelayslot(ID_IDEX_isindelaysolt),//�ӳٲ�
    .EX_alusel(IDEX_EX_alusel),//ִ�н׶�Ҫ�������������
    .EX_aluop(IDEX_EX_aluop),//ִ�н׶�Ҫ���������������
    .EX_reg1(IDEX_EX_reg1_data),//ִ�н׶�ָ��Ҫ���������Դ������һ
    .EX_reg2(IDEX_EX_reg2_data),//ִ�н׶�ָ��Ҫ���������Դ��������
    .EX_wreg_addr(IDEX_EX_wreg_addr),//ִ�н׶�ָ��Ҫд���Ŀ�ļĴ�����ַ
    .EX_wreg(IDEX_EX_wreg),//ִ�н׶�ָ���Ƿ�Ҫд��Ŀ�ļĴ���
    .EX_ins(IDEX_EX_wreg_ins),//��ex�ľ���ָ��ֵ
    .EX_ins_addr(IDEX_EX_ins_addr),//��EX�ľ���ָ���ַ
    .EX_isindelayslot(IDEX_EX_isindelayslot)
);

EX EX_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromIDEX_alusel(IDEX_EX_alusel),//ִ�н׶�Ҫ����ָ�������
    .I_FromIDEX_aluop(IDEX_EX_alusel),//ִ�н׶�Ҫ����ָ���������
    .I_FromIDEX_reg1(IDEX_EX_reg1_data),//���������Դ������һ
    .I_FromIDEX_reg2(IDEX_EX_reg2_data),//���������Դ��������
    .I_FromIDEX_wreg(IDEX_EX_wreg),//ָ��ִ���Ƿ� Ҫд��Ŀ�ļĴ���
    .I_FromIDEX_wreg_addr(IDEX_EX_wreg_addr),//ָ��ִ��Ҫд���Ŀ�ļĴ�����ַ
    .I_FromIDEX_ins(IDEX_EX_ins),
    .I_FromIDEX_ins_addr(IDEX_EX_ins_addr),//ִ�н׶�ָ���ַ
    .O_ToEXMEM_reg2(EX_EXMEM_reg2),//�洢ָ��Ҫ�洢�����ݣ�����lwrָ��Ҫд���Ŀ�ļĴ���ԭʼֵ
//HILOģ����
    .I_FromHILO_hi(HILO_EX_hi),//hilo��hi��ֵ
    .I_FromHILO_lo(HILO_EX_lo),//hilo��lo��ֵ
//mem�׶���hilo�Ľ�������
    .I_FromMEM_whilo(MEM_EX_whilo),//�ô�׶�ָ���Ƿ���ҪдHILO�Ĵ���
    .I_FromMEM_wb_hi(MEM_EX_hi),//�ô�׶�д��HILO��hi��ֵ
    .I_FromMEM_wb_lo(MEM_EX_lo),//�ô�׶�д��HILO��lo��ֵ
//memwb�׶���hilo�Ľ�������
    .I_FromMEMWB_whilo(MEMWB_EX_whilo),//��д�׶�ָ���Ƿ���ҪдHILO�Ĵ���
    .I_FromMEMWB_wb_hi(MEMWB_EX_hi),//��д�׶�д��HILO��hi��ֵ
    .I_FromMEMWB_wb_lo(MEMWB_EX_lo),//��д�׶�д��HILO��lo��ֵ
//�漰�˷��������
    .I_FromEXMEM_hilo_temp(EXMEM_EX_hilo_temp),//��һ��ִ�����ڵõ��ĳ˷����
    .I_FromEXMEM_cnt(EXMEM_EX_cnt),//D��ǰ����ִ�н׶εĵڼ�������
    .O_ToEXMEM_hilo_temp(EX_EXMEM_hilo),//��һ��ִ�����ڵõ��ĳ˷����
    .O_ToEXMEM_cnt(EX_EXMEM_cnt),//��һ��ʱ�����ڴ���ִ�н׶εĵڼ���ʼ������
//�漰�����������
    .I_FromDIV_divready(DIV_EX_ready),//���������Ƿ����
    .I_FromDIV_divres(),//����������
    .O_ToDIV_signediv(),//�Ƿ�Ϊ�з��ų���1-->�з��ţ�0->�޷���
    .O_ToDIV_opdata1(),//������
    .O_ToDIV_opdata2(),//����
    .O_ToDIV_divstart(),//�����Ƿ�ʼ
//�ӳٲ���ر���
    .I_FromIDEX_isindelayslot(IDEX_EX_isindelayslot),//�ӳٲ۱��
    .O_TOEXMEM_isindelayslot(EX_EXMEM_isindelaysolt),//�ӳٲ۱��
//��ô棬ID��صĽӿ�
    .O_To_EXMEM_mem_addr(EX_EXMEM_mem_addr),//���ش洢ָ���Ӧ�Ĵ洢����ַ
    .O_To_ID_EXMEM_wreg(EX_OUT_1),//ִ�н׶�ָ�������Ƿ���Ҫд��Ŀ�ļĴ���
    .O_To_ID_EXMEM_aluop(EX_OUT_2),//ִ�н׶�ָ����е�����������
    .O_To_ID_EXMEM_wreg_addr(EX_OUT_3),//���ش洢ָ���Ӧ�Ĵ洢����ַ
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
    .EX_mem_addr(EX_EXMEM_mem_addr),//ִ�н׶�Ҫд���ڴ��ַ
    .EX_reg2(EX_EXMEM_reg2),
    .EX_whilo(EX_EXMEM_whilo),
    .EX_hi(EX_EXMEM_hi),
    .EX_lo(EX_EXMEM_lo),
    .EX_hilo(EX_EXMEM_hilo),
    .EX_cnt(EX_EXMEM_cnt),
    .EX_isindelayslot(EX_EXMEM_isindelaysolt),
    .EX_ins_addr(EX_EXMEM_ins_addr),
    .Ex_aluop(EX_EXMEM_aluop),
    .EX_wreg(EX_EXMEM_wreg),//ִ�н׶�ָ��ִ�к��Ƿ�Ҫд��Ŀ�ļĴ���
    .EX_wreg_addr(EX_EXMEM_wreg_addr),//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ����ĵ�ַ
    .EX_wreg_data(EX_EXMEM_wreg_data),//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ
    .MEM_wreg(EXMEM_MEM_wreg),//�ô�׶�ָ��ִ�к��Ƿ�Ҫд��Ŀ�ļĴ���
    .MEM_wreg_addr(EXMEM_MEM_wreg_addr),//�ô�׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ����ĵ�ַ
    .MEM_wreg_data(EXMEM_MEM_wreg_adta),//�ô�׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ
    .MEM_hi(EXMEM_MEM_hi),
    .MEM_lo(EXMEM_MEM_lo),
    .MEM_whilo(EXMEM_MEM_whilo),
    .MEM_aluop(EXMEM_MEM_aluop),
    .MEM_mem_addr(EXMEM_MEM_mem_addr),//д�ڴ��ַ
    .MEM_reg2(EXMEM_MEM_reg2),
    .MEM_isindelayslot(EXMEM_MEM_isindelayslot),
    .MEM_ins_adddr(EXMEM_MEM_ins_addr),
    .MEM_hilo(EXMEM_EX_hilo_temp),
    .MEM_cnt(EXMEM_EX_cnt) 
);

MEM MEM_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromEXMEM_wreg(EXMEM_MEM_wreg),
    .I_FromEXMEM_wreg_addr(EXMEM_MEM_wreg_addr),
    .I_FromEXMEM_wreg_data(EXMEM_MEM_wreg_data),
    .O_ToMEMWB_wreg(MEM_MEMWB_mem_wreg),
    .O_ToMEMWB_wreg_addr,
    .O_ToMEMWB_wreg_data,
    .I_FromEXMEM_whilo,
    .I_FromEXMEM_hi,
    .I_FromEXMEM_lo,
    .O_TOMEMWB_whilo,
    .O_TOMEMWB_hi,
    .O_TOMEMWB_lo,
    .I_FromEXMEM_aluop,
    .I_FromEXMEM_mem_addr,
    .I_FromEXMEM_mem_data,
    .I_FromDM_data,
    .O_ToDM_data,
    .O_ToDM_we,
    .O_ToDM_we_data,
    .O_ToDM_sel,
    .I_FromEXMEM_isindelayslot,
    .O_TOMEMWB_isindelayslot

);


















endmodule
