`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:19:44
// Design Name: 
// Module Name: MEM_WB
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
//���ô�׶ε�������������һ��ʱ�Ӵ��ݵ���д�׶�

module MEM_WB(
    input clk,
    input rst,
    input wire MEM_wreg,//�ô�׶�ָ�������Ƿ���Ҫд���Ŀ�ļĴ���
    input wire [4:0] MEM_wreg_addr,//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�����ַ
    input wire [31:0] MEM_wreg_data,//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�������
    output reg WB_wreg,//�ô�׶�ָ�������Ƿ���Ҫд���Ŀ�ļĴ���
    output reg  [4:0] WB_wreg_addr,//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�����ַ
    output reg  [31:0] WB_wreg_data,//�ô�׶�ָ������Ҫд���Ŀ�ļĴ�������
    //λ��ָ���hilo��ؽӿ�
    input wire MEM_whilo,//�Ƿ�Ҫдhilo
    input wire [31:0] MEM_hi_data,//дhi��ֵ
    input wire [31:0] MEM_lo_data,//дhi��ֵ
    output reg WB_whilo,//�Ƿ�Ҫдhilo
    output reg [31:0] WB_hi_data,//дhi��ֵ
    output reg [31:0] WB_lo_data,//дhi��ֵ
    //����
    input wire [5:0] CL_stall,
    input wire CL_flush
    );
//ʱ����Ʋ��֣�ÿ��ʱ���������źŴ��͵���������һ��
always @(posedge clk) begin
    if(rst==1'b0) begin
        WB_wreg<=1'b0;
        WB_wreg_addr<=5'b0;
        WB_wreg_data<=32'b0;
        WB_whilo<=1'b0;
        WB_hi_data<=32'b0;
        WB_lo_data<=32'b0;
    end else if (CL_flush==1'b1) begin
        WB_wreg<=1'b0;
        WB_wreg_addr<=5'b0;
        WB_wreg_data<=32'b0;
        WB_whilo<=1'b0;
        WB_hi_data<=32'b0;
        WB_lo_data<=32'b0;
    end else if (CL_stall[4]==1'b1 && CL_stall[5]==1'b0) begin
        WB_wreg<=1'b0;
        WB_wreg_addr<=5'b0;
        WB_wreg_data<=32'b0;
        WB_whilo<=1'b0;
        WB_hi_data<=32'b0;
        WB_lo_data<=32'b0;
    end else if (CL_stall[4]==1'b0) begin
        WB_wreg<=MEM_wreg;
        WB_wreg_addr<=MEM_wreg_addr;
        WB_wreg_data<=MEM_wreg_data;
        WB_whilo<=MEM_whilo;
        WB_hi_data<=MEM_hi_data;
        WB_lo_data<=MEM_lo_data;
    end
end
endmodule
