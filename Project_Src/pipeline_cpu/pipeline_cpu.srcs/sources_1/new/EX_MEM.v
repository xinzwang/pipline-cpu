`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:18:18
// Design Name: 
// Module Name: EX_MEM
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
//��ִ�н׶�ȡ�õ�Ԥ����������һ��ʱ�����ڴ��ݵ���ˮ�ߵķô�׶�

module EX_MEM(
    input clk,
    input rst,
    input wire [5:0] CL_stall,
    input wire CL_flush,
    input wire [31:0] EX_mem_addr,//ִ�н׶�Ҫд���ڴ��ַ
    input wire [31:0] EX_reg2,
    input wire EX_whilo,
    input wire [31:0] EX_hi,
    input wire [31:0] EX_lo,
    input wire [63:0] EX_hilo,
    input wire [1:0] EX_cnt,
    input wire EX_isindelayslot,
    input wire [31:0] EX_ins_addr,
    input wire [7:0] EX_aluop,
    input wire EX_wreg,//ִ�н׶�ָ��ִ�к��Ƿ�Ҫд��Ŀ�ļĴ���
    input wire [4:0] EX_wreg_addr,//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ����ĵ�ַ
    input wire [31:0] EX_wreg_data,//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ
    output reg MEM_wreg,//�ô�׶�ָ��ִ�к��Ƿ�Ҫд��Ŀ�ļĴ���
    output reg [4:0] MEM_wreg_addr,//�ô�׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ����ĵ�ַ
    output reg [31:0] MEM_wreg_data,//�ô�׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ
    output reg [31:0] MEM_hi,
    output reg [31:0] MEM_lo,
    output reg MEM_whilo,
    output reg [7:0] MEM_aluop ,
    output reg [31:0] MEM_mem_addr,//д�ڴ��ַ
    output reg [31:0] MEM_reg2 ,
    output reg MEM_isindelayslot,
    output reg [31:0] MEM_ins_addr ,
    output reg [63:0] EXMEM_EX_hilo ,
    output reg [1:0] EXMEM_EX_cnt 
    );
    //ʱ����Ʋ��֣�ÿ��ʱ���������źŴ��͵���������һ��
always @(posedge clk) begin
    if(rst==1'b0) begin
        MEM_wreg<=1'b0;
        MEM_wreg_addr<=5'b0;
        MEM_wreg_data<=32'b0;
		MEM_hi <= 32'b0;
		MEM_lo <= 32'b0;
		MEM_whilo <= 1'b0;
		MEM_aluop <= 8'b0;
		MEM_mem_addr <= 32'b0;
		MEM_reg2 <= 32'b0;
		MEM_isindelayslot <= 1'b0;
		MEM_ins_addr <= 32'b0;
		EXMEM_EX_hilo <= 64'b0;
		EXMEM_EX_cnt <= 2'b0;
    end else if(CL_flush==1'b1) begin
        MEM_wreg<=1'b0;
        MEM_wreg_addr<=5'b0;
        MEM_wreg_data<=32'b0;
		MEM_hi <= 32'b0;
		MEM_lo <= 32'b0;
		MEM_whilo <= 1'b0;
		MEM_aluop <= 8'b0;
		MEM_mem_addr <= 32'b0;
		MEM_reg2 <= 32'b0;
		MEM_isindelayslot <= 1'b0;
		MEM_ins_addr <= 32'b0;
		EXMEM_EX_hilo <= 64'b0;
		EXMEM_EX_cnt <= 2'b0;
    end else if(CL_stall[3] == 1'b1 && CL_stall[4] == 1'b0) begin 
        MEM_wreg<=1'b0;
        MEM_wreg_addr<=5'b0;
        MEM_wreg_data<=32'b0;
		MEM_hi <= 32'b0;
		MEM_lo <= 32'b0;
		MEM_whilo <= 1'b0;
		MEM_aluop <= 8'b0;
		MEM_mem_addr <= 32'b0;
		MEM_reg2 <= 32'b0;
		MEM_isindelayslot <= 1'b0;
		MEM_ins_addr <= 32'b0;
		EXMEM_EX_hilo <= EX_hilo;
		EXMEM_EX_cnt <=  EX_cnt;
    end else if(CL_stall[3]==1'b0) begin
        MEM_wreg<=EX_wreg;
        MEM_wreg_addr <= EX_wreg_addr;
        MEM_wreg_data <= EX_wreg_data;
		MEM_hi <= EX_hi;
		MEM_lo <= EX_lo;
		MEM_whilo <= EX_whilo;
		MEM_aluop <= EX_aluop;
		MEM_mem_addr <= EX_mem_addr;
		MEM_reg2 <= EX_reg2;
		MEM_isindelayslot <= EX_isindelayslot;
		MEM_ins_addr <= EX_ins_addr;
		EXMEM_EX_hilo <= EX_hilo;
		EXMEM_EX_cnt <= 2'b0;
    end
end
endmodule
