`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 10:52:24
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    input clk,
    input rst,
    input wire [5:0] I_FromCL_stall,//���ڳ˳�����������ˮ�ӳٵ��ź���
    input wire [31:0] I_FromCL_newpc,//�����쳣�������µ�ַ���ֽ׶β��ù�
    input wire I_FromID_branchflag,//��תָ���Ӧ���źţ���������ת��ַ��
    input wire [31:0] I_FromID_branch_taraddr,//��ת��ַ
    output reg [31:0] O_ToIM_IFID_pc//�����ָ���ַ
    //output reg ce//pcʹ���ź�
);
//code here,notice comment
endmodule
