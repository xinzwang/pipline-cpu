`include "defines.v"

module regfile(
	input	wire		clk,//��λ�źţ��ߵ�ƽ��Ч
	input wire			rst,//ʱ���ź�

	//д�˿�
	input wire							we,//дʹ���ź�
	input wire[`RegAddrBus]				waddr,//Ҫд��ļĴ�����ַ
	input wire[`RegBus]					wdata,//Ҫд�������
	
	//���˿�1
	input wire						re1,//��һ�����Ĵ����˿ڶ�ʹ���ź�
	input wire[`RegAddrBus]		    raddr1,//��һ�����Ĵ����˿�Ҫ��ȡ�ļĴ����ĵ�ַ
	output reg[`RegBus]            rdata1,//��һ�����Ĵ����˿�����ļĴ���ֵ
	
	//���˿�2
	input wire						  re2,//�ڶ������Ĵ����˿ڶ�ʹ���ź�
	input wire[`RegAddrBus]			  raddr2,////�ڶ������Ĵ����˿�Ҫ��ȡ�ļĴ����ĵ�ַ
	output reg[`RegBus]               rdata2//�ڶ������Ĵ����˿�����ļĴ���ֵ
);

	reg[`RegBus]  regs[0:`RegNum-1];//����32��32λ�Ĵ���
/* ������һ����ά��������Ԫ�ظ�����RegNum��������defines.v�е�һ���궨�壬Ϊ32��
ÿ��Ԫ�صĿ����RegBus����Ҳ���� defines.v�е�һ���궨�壬ҲΪ32�����Դ˴�����ľ���32��32λ�Ĵ�����	*/


//д����
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end
/* ʵ����д�Ĵ�������������λ�ź���Чʱ��rstΪRstDisable)����дʹ���ź�we��Ч(weΪWriteEnable)��
��д����Ŀ�ļĴ���������0������£����Խ�д�������ݱ��浽Ŀ�ļĴ�����
֮����Ҫ�ж�Ŀ�ļĴ�����Ϊ0������ΪMIPS32�ܹ��涨S0��ֵֻ��Ϊ0�����Բ�Ҫд�롣
WriteEnable��defines.v�ж���ĺ꣬��ʾдʹ���ź���Ч��*/
	
//���˿�1����
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;
	  end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;
	  end else if((raddr1 == waddr) && (we == `WriteEnable) 
	  	            && (re1 == `ReadEnable)) begin
	  	  rdata1 <= wdata;//�ڶ���������һ���жϣ����Ҫ��ȡ�ļĴ���������һ��ʱ��������Ҫд��ļĴ�������ô�ͽ�Ҫд�������ֱ����Ϊ����������˾ͽ�������2��ָ�����������ص������
	  end else if(re1 == `ReadEnable) begin
	      rdata1 <= regs[raddr1];
	  end else begin
	      rdata1 <= `ZeroWord;
	  end
	end
/* ʵ���˵�һ�����Ĵ����˿ڣ������¼��������ж�:
����λ�ź���Чʱ����һ�����Ĵ����˿ڵ����ʼ��Ϊ0;����λ�ź���Чʱ�������ȡ����$0����ôֱ�Ӹ���0;
�����һ�����Ĵ����˿�Ҫ��ȡ��Ŀ��Ĵ�����Ҫд���Ŀ�ļĴ�����ͬһ���Ĵ�������ôֱ�ӽ�Ҫд���ֵ��Ϊ��һ�����Ĵ����˿ڵ����;
������������������,��ô������һ�����Ĵ����˿�Ҫ��ȡ��Ŀ��Ĵ�����ַ��Ӧ�Ĵ�����ֵ;
��һ�����Ĵ����˿ڲ���ʹ��ʱ��ֱ�����0��*/

//���˿�2����
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  end else if((raddr2 == waddr) && (we == `WriteEnable) 
	  	            && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `ZeroWord;
	  end
	end
/* ʵ���˵ڶ������Ĵ����˿ڣ�����������ơ�
ע��һ��:���Ĵ�������������߼���·,Ҳ����һ�������Ҫ��ȡ�ļĴ�����ַraddr1����raddr2�����仯��
��ô�����������µ�ַ��Ӧ�ļĴ�����ֵ���������Ա�֤������׶�ȡ��Ҫ��ȡ�ļĴ�����ֵ��
��д�Ĵ���������ʱ���߼���·��д����������ʱ���źŵ������ء�*/

endmodule