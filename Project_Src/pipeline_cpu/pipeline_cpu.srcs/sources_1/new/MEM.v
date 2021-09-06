`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:18:38
// Design Name: 
// Module Name: MEM
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
//ռ???ռ??

module MEM(

	input wire										rst,//��λ�ź�
	
	//����ִ�н׶ε���Ϣ	
	input wire[4:0]       I_FROMEX_MEM_wreg,//�ô�׶ε�ָ���Ƿ���Ҫд��Ŀ�ļĴ���
	input wire                    I_FROMEX_MEM_wd,//�ô�׶ε�ָ��Ҫд���Ŀ�ļĴ�����ַ
	input wire[31:0]					  I_FROMEX_MEM_wdata,//�ô�׶ε�ָ��Ҫд��Ŀ�ļĴ�����ֵ
	input wire[31:0]           I_FROMEX_MEM_hi,//�ô�׶ε�ָ��Ҫд��HI�Ĵ�����ֵ
	input wire[31:0]           I_FROMEX_MEM_lo,//�ô�׶ε�ָ��Ҫд��LO�Ĵ�����ֵ
	input wire                    I_FROMEX_MEM_whilo,	//�ô�׶ε�ָ���Ƿ�ҪдHI��LO�Ĵ���

  input wire[7:0]        I_FROMEX_MEM_aloup,//�ô�׶ε�ָ��Ҫ���е������������
	input wire[31:0]          I_FROMEX_MEM_mem_addr,//�ô�׶εļ��ء��洢ָ���Ӧ�Ĵ洢����ַ
	input wire[31:0]          I_FROMEX_MEM_reg2,//�ô�׶εĴ洢ָ��Ҫ�洢�����ݣ�����lwl��lwrָ��Ҫд���Ŀ�ļĴ�����ԭʼֵ
	
	//�����ⲿ���ݴ洢��RAM����Ϣ
	input wire[31:0]          I_FROMDATA_RAM_mem_data,//�����ݴ洢����ȡ������

	//I_FROMLLbit_Llbit��LLbit�Ĵ�����ֵ
	input wire                  I_FROMLLbit_Llbit,//Llbitģ�������Llbit�Ĵ�����ֵ
	//����һ��������ֵ����д�׶ο���ҪдLLbit�����Ի�Ҫ��һ���ж�
	input wire                  I_FROMMEM_WB_wb_LLbit_we,//��д�׶ε�ָ���Ƿ�ҪдLlbit�Ĵ���
	input wire                  I_FROMMEM_WB_wb_LLbit_value,//��д�׶ε�Ҫд��Llbit�Ĵ�����ֵ
	
	//�͵���д�׶ε���Ϣ
	output reg[4:0]      O_TOMEM_WB_wd,//�ô�׶ε�ָ������Ҫд���Ŀ�ļĴ�����ַ
	output reg                   O_TOMEM_WB_wreg,//�ô�׶ε�ָ�������Ƿ���Ҫд���Ŀ�ļĴ���
	output reg[31:0]					 O_TOMEM_WB_wdata,//�ô�׶ε�ָ������Ҫд��Ŀ�ļĴ�����ֵ
	output reg[31:0]          O_TOMEM_WB_hi,//�ô�׶ε�ָ������Ҫд��HI�Ĵ�����ֵ
	output reg[31:0]          O_TOMEM_WB_lo,//�ô�׶ε�ָ������Ҫд��LO�Ĵ�����ֵ
	output reg                   O_TOMEM_WB_whilo,//�ô�׶ε�ָ�������Ƿ�ҪдHI��LO�Ĵ�����ֵ

	output reg                   O_TOMEM_WB_Llbit_we,//�ô�׶ε�ָ���Ƿ�ҪдLlbit�Ĵ���
	output reg                   O_TOMEM_WB_Llbit_value,//�ô�׶ε�ָ��Ҫд��Llbit�Ĵ�����ֵ
	
	//�͵����ⲿ���ݴ洢��RAM����Ϣ
	output reg[31:0]          O_TODATA_RAM_mem_addr,//Ҫ���ʵ����ݴ洢���ĵ�ַ
	output wire					O_TODATA_RAM_mem_we,//�Ƿ���д������Ϊ1��ʾ��д����
	output reg[3:0]              O_TODATA_RAM_mem_sel,//�ֽ�ѡ���ź�
	output reg[31:0]          O_TODATA_RAM_mem_data,//Ҫд�����ݴ洢��������
	output reg                   O_TODATA_RAM_mem_ce	//���ݴ洢��ʹ���ź�
	
);

    reg LLbit;
	wire[31:0] zero32;
	reg                   mem_we;

	assign O_TODATA_RAM_mem_we = mem_we ;//�ⲿ���ݴ洢��RAM�Ķ���д�ź�
	assign zero32 = 32'h00000000;

  //��ȡ���µ�LLbit��ֵ
	always @ (*) begin
		if(rst == 1'b1) begin
			LLbit <= 1'b0;
		end else begin
			if(I_FROMMEM_WB_wb_LLbit_we == 1'b1) begin
				LLbit <= I_FROMMEM_WB_wb_LLbit_value;
			end else begin
				LLbit <= I_FROMLLbit_Llbit;
			end
		end
	end
	
	always @ (*) begin
		if(rst == 1'b1) begin
			O_TOMEM_WB_wd <= 5'b00000;
			O_TOMEM_WB_wreg <= 1'b0;
		  O_TOMEM_WB_wdata <= 32'h00000000;
		  O_TOMEM_WB_hi <= 32'h00000000;
		  O_TOMEM_WB_lo <= 32'h00000000;
		  O_TOMEM_WB_whilo <= 1'b0;		
		  O_TODATA_RAM_mem_addr <= 32'h00000000;
		  mem_we <= 1'b0;
		  O_TODATA_RAM_mem_sel <= 4'b0000;
		  O_TODATA_RAM_mem_data <= 32'h00000000;
		  O_TODATA_RAM_mem_ce <= 1'b0;		
		  O_TOMEM_WB_Llbit_we <= 1'b0;
		  O_TOMEM_WB_Llbit_value <= 1'b0;		      
		end else begin
		  O_TOMEM_WB_wd <= I_FROMEX_MEM_wreg;
			O_TOMEM_WB_wreg <= I_FROMEX_MEM_wreg;
			O_TOMEM_WB_wdata <= I_FROMEX_MEM_wdata;
			O_TOMEM_WB_hi <= I_FROMEX_MEM_hi;
			O_TOMEM_WB_lo <= I_FROMEX_MEM_lo;
			O_TOMEM_WB_whilo <= I_FROMEX_MEM_whilo;		
			mem_we <= 1'b0;
			O_TODATA_RAM_mem_addr <= 32'h00000000;
			O_TODATA_RAM_mem_sel <= 4'b1111;
			O_TODATA_RAM_mem_ce <= 1'b0;
		  O_TOMEM_WB_Llbit_we <= 1'b0;
		  O_TOMEM_WB_Llbit_value <= 1'b0;			
			case (I_FROMEX_MEM_aloup)
				8'b11100000:		begin//lbָ��
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;//����Ҫ���ʵ����ݴ洢����ַ����ֵ����ִ�н׶μ�������ĵ�ַ
					mem_we <= 1'b0;//��Ϊ�Ǽ��ز�������������O_TODATA_RAM_mem_addr��ֵΪ1'b0
					O_TODATA_RAM_mem_ce <= 1'b1;//��ΪҪ�������ݴ洢������������O_TODATA_RAM_mem_ce <= 1'b1
					case (I_FROMEX_MEM_mem_addr[1:0])//����mem_arrd�����λ������ȷ��mem_sel��ֵ�����ݴ˴����ݴ洢������������I_FROMEX_MEM_mem_data�л��Ҫ��ȡ���ֽڣ����з�����չ
						2'b00:	begin
							O_TOMEM_WB_wdata <= {{24{I_FROMDATA_RAM_mem_data[31]}},I_FROMDATA_RAM_mem_data[31:24]};
							O_TODATA_RAM_mem_sel <= 4'b1000;
						end
						2'b01:	begin
							O_TOMEM_WB_wdata <= {{24{I_FROMDATA_RAM_mem_data[23]}},I_FROMDATA_RAM_mem_data[23:16]};
							O_TODATA_RAM_mem_sel <= 4'b0100;
						end
						2'b10:	begin
							O_TOMEM_WB_wdata <= {{24{I_FROMDATA_RAM_mem_data[15]}},I_FROMDATA_RAM_mem_data[15:8]};
							O_TODATA_RAM_mem_sel <= 4'b0010;
						end
						2'b11:	begin
							O_TOMEM_WB_wdata <= {{24{I_FROMDATA_RAM_mem_data[7]}},I_FROMDATA_RAM_mem_data[7:0]};
							O_TODATA_RAM_mem_sel <= 4'b0001;
						end
						default:	begin
							O_TOMEM_WB_wdata <= 32'h00000000;
						end
					endcase
				end
				8'b11100100:		begin//lbuָ��
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b0;
					O_TODATA_RAM_mem_ce <= 1'b1;
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin
							O_TOMEM_WB_wdata <= {{24{1'b0}},I_FROMDATA_RAM_mem_data[31:24]};
							O_TODATA_RAM_mem_sel <= 4'b1000;
						end
						2'b01:	begin
							O_TOMEM_WB_wdata <= {{24{1'b0}},I_FROMDATA_RAM_mem_data[23:16]};
							O_TODATA_RAM_mem_sel <= 4'b0100;
						end
						2'b10:	begin
							O_TOMEM_WB_wdata <= {{24{1'b0}},I_FROMDATA_RAM_mem_data[15:8]};
							O_TODATA_RAM_mem_sel <= 4'b0010;
						end
						2'b11:	begin
							O_TOMEM_WB_wdata <= {{24{1'b0}},I_FROMDATA_RAM_mem_data[7:0]};
							O_TODATA_RAM_mem_sel <= 4'b0001;
						end
						default:	begin
							O_TOMEM_WB_wdata <= 32'h00000000;
						end
					endcase				
				end
				8'b11100001:		begin//lhָ��
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b0;
					O_TODATA_RAM_mem_ce <= 1'b1;
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin
							O_TOMEM_WB_wdata <= {{16{I_FROMDATA_RAM_mem_data[31]}},I_FROMDATA_RAM_mem_data[31:16]};
							O_TODATA_RAM_mem_sel <= 4'b1100;
						end
						2'b10:	begin
							O_TOMEM_WB_wdata <= {{16{I_FROMDATA_RAM_mem_data[15]}},I_FROMDATA_RAM_mem_data[15:0]};
							O_TODATA_RAM_mem_sel <= 4'b0011;
						end
						default:	begin
							O_TOMEM_WB_wdata <= 32'h00000000;
						end
					endcase					
				end
				8'b11100101:		begin//lhuָ��
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b0;
					O_TODATA_RAM_mem_ce <= 1'b1;
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin
							O_TOMEM_WB_wdata <= {{16{1'b0}},I_FROMDATA_RAM_mem_data[31:16]};
							O_TODATA_RAM_mem_sel <= 4'b1100;
						end
						2'b10:	begin
							O_TOMEM_WB_wdata <= {{16{1'b0}},I_FROMDATA_RAM_mem_data[15:0]};
							O_TODATA_RAM_mem_sel <= 4'b0011;
						end
						default:	begin
							O_TOMEM_WB_wdata <= 32'h00000000;
						end
					endcase				
				end
				8'b11100011:		begin//lwָ��
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b0;
					O_TOMEM_WB_wdata <= I_FROMDATA_RAM_mem_data;
					O_TODATA_RAM_mem_sel <= 4'b1111;		
					O_TODATA_RAM_mem_ce <= 1'b1;
				end
				8'b11100010:		begin//lwlָ��
					O_TODATA_RAM_mem_addr <= {I_FROMEX_MEM_mem_addr[31:2], 2'b00};//����Ҫ���ʵ����ݴ洢����ַ����ֵ���Ǽ�������ĵ�ַ�����������λҪ����Ϊ0����Ϊlwlָ��Ҫ��RAM�ж���һ���֣�������Ҫ����ַ����
					mem_we <= 1'b0;//��Ϊ�Ǽ��ز�������������
					O_TODATA_RAM_mem_sel <= 4'b1111;
					O_TODATA_RAM_mem_ce <= 1'b1;//��ΪҪ�������ݴ洢������������
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin
							O_TOMEM_WB_wdata <= I_FROMDATA_RAM_mem_data[31:0];
						end
						2'b01:	begin
							O_TOMEM_WB_wdata <= {I_FROMDATA_RAM_mem_data[23:0],I_FROMEX_MEM_reg2[7:0]};
						end
						2'b10:	begin
							O_TOMEM_WB_wdata <= {I_FROMDATA_RAM_mem_data[15:0],I_FROMEX_MEM_reg2[15:0]};
						end
						2'b11:	begin
							O_TOMEM_WB_wdata <= {I_FROMDATA_RAM_mem_data[7:0],I_FROMEX_MEM_reg2[23:0]};	
						end//���������λ��ֵ���������ݴ洢����ȡ��������Ŀ�ļĴ�����ԭʼֵ������ϣ��õ�����Ҫд��Ŀ�ļĴ�����ֵ��
						default:	begin
							O_TOMEM_WB_wdata <= 32'h00000000;
						end
					endcase				
				end
				8'b11100110:		begin//lwrָ���lwlָ������
					O_TODATA_RAM_mem_addr <= {I_FROMEX_MEM_mem_addr[31:2], 2'b00};
					mem_we <= 1'b0;
					O_TODATA_RAM_mem_sel <= 4'b1111;
					O_TODATA_RAM_mem_ce <= 1'b1;
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin
							O_TOMEM_WB_wdata <= {I_FROMEX_MEM_reg2[31:8],I_FROMDATA_RAM_mem_data[31:24]};
						end
						2'b01:	begin
							O_TOMEM_WB_wdata <= {I_FROMEX_MEM_reg2[31:16],I_FROMDATA_RAM_mem_data[31:16]};
						end
						2'b10:	begin
							O_TOMEM_WB_wdata <= {I_FROMEX_MEM_reg2[31:24],I_FROMDATA_RAM_mem_data[31:8]};
						end
						2'b11:	begin
							O_TOMEM_WB_wdata <= I_FROMDATA_RAM_mem_data;	
						end
						default:	begin
							O_TOMEM_WB_wdata <= 32'h00000000;
						end
					endcase					
				end
				8'b11110000:		begin//
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b0;
					O_TOMEM_WB_wdata <= I_FROMDATA_RAM_mem_data;
		  		O_TOMEM_WB_Llbit_we <= 1'b1;
		  		O_TOMEM_WB_Llbit_value <= 1'b1;
		  		O_TODATA_RAM_mem_sel <= 4'b1111;			
		  		O_TODATA_RAM_mem_ce <= 1'b1;					
				end				
				8'b11101000:		begin//sbָ��
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;//���ʵ����ݴ洢����ַ����ִ�н׶μ�������ĵ�ַ	
					mem_we <= 1'b1;//��Ϊ�Ǵ洢���������������
					O_TODATA_RAM_mem_data <= {I_FROMEX_MEM_reg2[7:0],I_FROMEX_MEM_reg2[7:0],I_FROMEX_MEM_reg2[7:0],I_FROMEX_MEM_reg2[7:0]};
					O_TODATA_RAM_mem_ce <= 1'b1;//��ΪҪ�������ݴ洢�������������	
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin
							O_TODATA_RAM_mem_sel <= 4'b1000;
						end
						2'b01:	begin
							O_TODATA_RAM_mem_sel <= 4'b0100;
						end
						2'b10:	begin
							O_TODATA_RAM_mem_sel <= 4'b0010;
						end
						2'b11:	begin
							O_TODATA_RAM_mem_sel <= 4'b0001;	
						end
						default:	begin
							O_TODATA_RAM_mem_sel <= 4'b0000;
						end//sbָ��Ҫд��������ǼĴ���������ֽڣ������ֽڸ��Ƶ�mem_data�����ಿ�֣�Ȼ�����ݵ�ַд�������λ���Ӷ�ȷ��mem_sel��ֵ
					endcase				
				end
				8'b11101001:		begin//shָ������
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b1;
					O_TODATA_RAM_mem_data <= {I_FROMEX_MEM_reg2[15:0],I_FROMEX_MEM_reg2[15:0]};
					O_TODATA_RAM_mem_ce <= 1'b1;
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin
							O_TODATA_RAM_mem_sel <= 4'b1100;
						end
						2'b10:	begin
							O_TODATA_RAM_mem_sel <= 4'b0011;
						end
						default:	begin
							O_TODATA_RAM_mem_sel <= 4'b0000;
						end
					endcase						
				end
				8'b11101011:		begin//swָ����sb����
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b1;
					O_TODATA_RAM_mem_data <= I_FROMEX_MEM_reg2;
					O_TODATA_RAM_mem_sel <= 4'b1111;			
					O_TODATA_RAM_mem_ce <= 1'b1;
				end
				8'b11101010:		begin//swlָ��
					O_TODATA_RAM_mem_addr <= {I_FROMEX_MEM_mem_addr[31:2], 2'b00};//����Ҫ���ʵ����ݴ洢����ַ����ֵ����ִ�н׶μ�������ĵ�ַ���������λҪ����0����Ϊswlָ����������Ҫ�����ݴ洢��д��һ����
					mem_we <= 1'b1;//��Ϊ�Ǵ洢��������������
					O_TODATA_RAM_mem_ce <= 1'b1;//��Ϊ�ô���������
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin						  
							O_TODATA_RAM_mem_sel <= 4'b1111;
							O_TODATA_RAM_mem_data <= I_FROMEX_MEM_reg2;
						end
						2'b01:	begin
							O_TODATA_RAM_mem_sel <= 4'b0111;
							O_TODATA_RAM_mem_data <= {zero32[7:0],I_FROMEX_MEM_reg2[31:8]};
						end
						2'b10:	begin
							O_TODATA_RAM_mem_sel <= 4'b0011;
							O_TODATA_RAM_mem_data <= {zero32[15:0],I_FROMEX_MEM_reg2[31:16]};
						end
						2'b11:	begin
							O_TODATA_RAM_mem_sel <= 4'b0001;	
							O_TODATA_RAM_mem_data <= {zero32[23:0],I_FROMEX_MEM_reg2[31:24]};
						end
						default:	begin
							O_TODATA_RAM_mem_sel <= 4'b0000;
						end
					endcase							
				end
				8'b11101110:		begin//swrָ��
					O_TODATA_RAM_mem_addr <= {I_FROMEX_MEM_mem_addr[31:2], 2'b00};
					mem_we <= 1'b1;
					O_TODATA_RAM_mem_ce <= 1'b1;
					case (I_FROMEX_MEM_mem_addr[1:0])
						2'b00:	begin						  
							O_TODATA_RAM_mem_sel <= 4'b1000;
							O_TODATA_RAM_mem_data <= {I_FROMEX_MEM_reg2[7:0],zero32[23:0]};
						end
						2'b01:	begin
							O_TODATA_RAM_mem_sel <= 4'b1100;
							O_TODATA_RAM_mem_data <= {I_FROMEX_MEM_reg2[15:0],zero32[15:0]};
						end
						2'b10:	begin
							O_TODATA_RAM_mem_sel <= 4'b1110;
							O_TODATA_RAM_mem_data <= {I_FROMEX_MEM_reg2[23:0],zero32[7:0]};
						end
						2'b11:	begin
							O_TODATA_RAM_mem_sel <= 4'b1111;	
							O_TODATA_RAM_mem_data <= I_FROMEX_MEM_reg2[31:0];
						end
						default:	begin
							O_TODATA_RAM_mem_sel <= 4'b0000;
						end
					endcase											
				end 
				8'b11111000:		begin
					if(LLbit == 1'b1) begin
						O_TOMEM_WB_Llbit_we <= 1'b1;
						O_TOMEM_WB_Llbit_value <= 1'b0;
						O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
						mem_we <= 1'b1;
						O_TODATA_RAM_mem_data <= I_FROMEX_MEM_reg2;
						O_TOMEM_WB_wdata <= 32'b1;
						O_TODATA_RAM_mem_sel <= 4'b1111;	
						O_TODATA_RAM_mem_ce <= 1'b1;					
					end else begin
						O_TOMEM_WB_wdata <= 32'b0;
					end
				end				
				default:		begin
          //ʲôҲ����
				end
			endcase							
		end    //if
	end      //always
endmodule