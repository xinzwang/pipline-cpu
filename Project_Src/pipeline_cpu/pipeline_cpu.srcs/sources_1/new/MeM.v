`timescale 1ns / 1ps

`include "defines.v"

module mem(

	input wire										rst,//ʱ���ź�
	
	//����ִ�н׶ε���Ϣ	
	input wire[4:0]       I_FROMEX_MEM_wd,//�ô�׶ε�ָ��Ҫд��Ŀ�ļĴ�����ַ
	input wire                    I_FROMEX_MEM_wreg,//�ô�׶ε�ָ���Ƿ�Ҫд��Ŀ�ļĴ���
	input wire[31:0]					  I_FROMEX_MEM_wdata,//�ô�׶ε�ָ��Ҫд��Ŀ�ļĴ�����ֵ
	
	//�͵���д�׶ε���Ϣ
	output reg[4:0]      O_TOMEM_WB_wd,//�ô�׶ε�ָ������Ҫд���Ŀ�ļĴ�����ַ
	output reg                   O_TOMEM_WB_wreg,//�ô�׶ε�ָ�������Ƿ���Ҫд��Ŀ�ļĴ���
	output reg[31:0]					 O_TOMEM_WB_wdata//�ô�׶ε�ָ������Ҫд��Ŀ�ļĴ�����ֵ
	
);

	//MEMģ����ֻ��һ������߼���·���������ִ�н׶εĽ��ֱ����Ϊ��������MEMģ���������ӵ�MEM\WBģ��
	//ʵ���˽������źŴ��ݵ���Ӧ������˿�
	always @ (*) begin
		if(rst == 1'b1) begin
			O_TOMEM_WB_wd <= 5'b00000;
			O_TOMEM_WB_wreg <= 1'b0;
		  O_TOMEM_WB_wdata <= 32'h00000000;
		end else begin
		  O_TOMEM_WB_wd <= I_FROMEX_MEM_wd;
			O_TOMEM_WB_wreg <= I_FROMEX_MEM_wreg;
			O_TOMEM_WB_wdata <= I_FROMEX_MEM_wdata;
		end    //if
	end      //always
			
endmodule
