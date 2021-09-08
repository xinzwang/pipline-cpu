`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:16:50
// Design Name: 
// Module Name: ID_EX
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
//������׶�ȡ�õ��������ͣ�Դ��������Ҫд��Ŀ�ļĴ�����ַ�Ƚ��������һ��ʱ�����ڴ�����ˮ�ߵ�ִ�н׶�

module ID_EX(
    input clk,
    input rst,
    input wire [5:0] CL_stall,//
    input wire CL_flush,//
    input wire [2:0] ID_alusel,//����׶�Ҫ�������������
    input wire [7:0] ID_aluop,//����׶�ָ��Ҫ���������������
    input wire [31:0] ID_reg1,//����׶�ָ��Ҫ���������Դ������һ
    input wire [31:0] ID_reg2,//����׶�ָ��Ҫ���������Դ��������
    input wire ID_wreg,//����׶�ָ���Ƿ�Ҫд��Ŀ�ļĴ���
    input wire [4:0] ID_wreg_addr,//����׶�ָ��Ҫд���Ŀ�ļĴ�����ַ
    input wire [31:0] ID_ins,//����ID�ľ���ָ��ֵ
    input wire [31:0] ID_ins_addr,//����ID�ľ���ָ���ַ
    input wire  ID_isindelayslot,//�ӳٲ�
    input wire ID_next_ins_isindelayslot,
    
    output reg [2:0] EX_alusel,//ִ�н׶�Ҫ�������������
    output reg [7:0] EX_aluop,//ִ�н׶�Ҫ���������������
    output reg [31:0] EX_reg1,//ִ�н׶�ָ��Ҫ���������Դ������һ
    output reg [31:0] EX_reg2,//ִ�н׶�ָ��Ҫ���������Դ��������
    output reg [4:0] EX_wreg_addr,//ִ�н׶�ָ��Ҫд���Ŀ�ļĴ�����ַ
    output reg EX_wreg,//ִ�н׶�ָ���Ƿ�Ҫд��Ŀ�ļĴ���
    output reg [31:0] EX_ins,//��ex�ľ���ָ��ֵ
    output reg [31:0] EX_ins_addr,//��EX�ľ���ָ���ַ
    output reg EX_isindelayslot,
    output reg IDEX_ID_isindelayslot
    );
    
//ʱ����Ʋ��֣�ÿ��ʱ���������źŴ��͵���������һ��
always @(posedge clk) begin
    if(rst==1'b0) begin
        EX_aluop<=8'b0;
        EX_alusel<=3'b0;
        EX_reg1<=32'b0;
        EX_reg2<=32'b0;
        EX_wreg_addr<=5'b0;
        EX_wreg<=1'b0;
        EX_ins<=32'b0;
        EX_ins_addr<=32'b0;
        EX_isindelayslot<=1'b0;
        IDEX_ID_isindelayslot<=1'b0;
    end else if (CL_flush==1'b1) begin
        EX_aluop<=8'b0;
        EX_alusel<=3'b0;
        EX_reg1<=32'b0;
        EX_reg2<=32'b0;
        EX_wreg_addr<=5'b0;
        EX_wreg<=1'b0;
        EX_ins<=32'b0;
        EX_ins_addr<=32'b0;
        EX_isindelayslot<=1'b0;
        IDEX_ID_isindelayslot<=1'b0;
    end else if(CL_stall[2]==1'b1 && CL_stall[3]==1'b0) begin
        EX_aluop<=8'b0;
        EX_alusel<=3'b0;
        EX_reg1<=32'b0;
        EX_reg2<=32'b0;
        EX_wreg_addr<=5'b0;
        EX_wreg<=1'b0;
        EX_ins<=32'b0;
        EX_ins_addr<=32'b0;
        EX_isindelayslot<=1'b0;
        IDEX_ID_isindelayslot<=1'b0;
    end else if(CL_stall[2]==1'b0) begin
        EX_aluop<=ID_aluop;
        EX_alusel<=ID_alusel;
        EX_reg1<=ID_reg1;
        EX_reg2<=ID_reg2;
        EX_wreg_addr<=ID_wreg_addr;
        EX_wreg<=ID_wreg;
        EX_ins<=ID_ins;
        EX_ins_addr<=ID_ins_addr;
        EX_isindelayslot<=ID_isindelayslot;
        IDEX_ID_isindelayslot<=ID_next_ins_isindelayslot;
    end
end
    
endmodule
