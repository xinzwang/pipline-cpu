//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2014 leishangwen@163.com                       ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
// Module:  data_ram
// File:    data_ram.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: ���ݴ洢��
// Revision: 1.0
//////////////////////////////////////////////////////////////////////
//�������������ӿڣ��ұ�������ӿڵķ�ʽ���ơ�
module data_ram(

	input	wire										clk,
	input wire										I_FROMMEM_ce,
	input wire										I_FROMMEM_we,
	input wire[31:0]			I_FROMMEM_addr,//��ַ���߿��
	input wire[3:0]								I_FROMMEM_sel,
	input wire[31:0]						I_FROMMEM_data,//�������߿��
	output reg[31:0]					O_TOMEM_data
	
);
//�����ĸ��ֽ�����
	reg[7:0]  data_mem0[0:131071-1];//RAM�Ĵ�С����λ���֣��Գ���128K WORD
	reg[7:0]  data_mem1[0:131071-1];
	reg[7:0]  data_mem2[0:131071-1];
	reg[7:0]  data_mem3[0:131071-1];//һ���ֽڵĿ����8bit
//д����
	always @ (posedge clk) begin
		if (I_FROMMEM_ce == 1'b0) begin
			//O_TOMEM_data <= ZeroWord;
		end else if(I_FROMMEM_we == 1'b1) begin
			  if (I_FROMMEM_sel[3] == 1'b1) begin
		      data_mem3[I_FROMMEM_addr[17+1:2]] <= I_FROMMEM_data[31:24];//ʵ��ʹ�õĵ�ַ���
		    end
			  if (I_FROMMEM_sel[2] == 1'b1) begin
		      data_mem2[I_FROMMEM_addr[17+1:2]] <= I_FROMMEM_data[23:16];
		    end
		    if (I_FROMMEM_sel[1] == 1'b1) begin
		      data_mem1[I_FROMMEM_addr[17+1:2]] <= I_FROMMEM_data[15:8];
		    end
			  if (I_FROMMEM_sel[0] == 1'b1) begin
		      data_mem0[I_FROMMEM_addr[17+1:2]] <= I_FROMMEM_data[7:0];
		    end			   	    
		end
	end
//������	
	always @ (*) begin
		if (I_FROMMEM_ce == 1'b0) begin
			O_TOMEM_data <= 32'h00000000;
	  end else if(I_FROMMEM_we == 1'b0) begin
		    O_TOMEM_data <= {data_mem3[I_FROMMEM_addr[17+1:2]],
		               data_mem2[I_FROMMEM_addr[17+1:2]],
		               data_mem1[I_FROMMEM_addr[17+1:2]],
		               data_mem0[I_FROMMEM_addr[17+1:2]]};
		end else begin
				O_TOMEM_data <= 32'h00000000;
		end
	end		

endmodule