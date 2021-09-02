`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:17:20
// Design Name: 
// Module Name: EX
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


module EX(
    input clk,
    input rst,
    input wire [2:0] I_FromIDEX_alusel,//ִ�н׶�Ҫ����ָ�������
    input wire [7:0] I_FromIDEX_aluop,//ִ�н׶�Ҫ����ָ���������
    input wire [31:0] I_FromIDEX_reg1,//���������Դ������һ
    input wire [31:0] I_FromIDEX_reg2,//���������Դ��������
    input wire I_FromIDEX_wreg,//ָ��ִ���Ƿ� Ҫд��Ŀ�ļĴ���
    input wire I_FromIDEX_wreg_addr,//ָ��ִ��Ҫд���Ŀ�ļĴ�����ַ
    input wire [31:0] I_FromIDEX_ins,//ִ�н׶�ָ��
    input wire [31:0] I_FromIDEX_ins_addr,//ִ�н׶�ָ���ַ
    output reg [31:0] O_ToEXMEM_reg2,//�洢ָ��Ҫ�洢�����ݣ�����lwrָ��Ҫд���Ŀ�ļĴ���ԭʼֵ
//    output reg O_ToEXMEM_wreg,//ִ�н׶�ָ���Ƿ�����Ҫд��Ŀ�ļĴ���
//    output reg [31:0] O_ToEXMEM_wreg_addr,//ִ�н׶�ָ������Ҫд��Ŀ�ļĴ�����ַ
//    output reg [31:0] O_ToEXMEM_wreg_data,//ִ�н׶�ָ������Ҫд��Ŀ�ļĴ�����ֵ
//HILOģ����
    input wire [31:0] I_FromHILO_hi,//hilo��hi��ֵ
    input wire [31:0] I_FromHILO_lo,//hilo��lo��ֵ
//mem�׶���hilo�Ľ�������
    input wire I_FromMEM_whilo,//�ô�׶�ָ���Ƿ���ҪдHILO�Ĵ���
    input wire [31:0] I_FromMEM_wb_hi,//�ô�׶�д��HILO��hi��ֵ
    input wire [31:0] I_FromMEM_wb_lo,//�ô�׶�д��HILO��lo��ֵ
//memwb�׶���hilo�Ľ�������
    input wire I_FromMEMWB_whilo,//��д�׶�ָ���Ƿ���ҪдHILO�Ĵ���
    input wire [31:0] I_FromMEMWB_wb_hi,//��д�׶�д��HILO��hi��ֵ
    input wire [31:0] I_FromMEMWB_wb_lo,//��д�׶�д��HILO��lo��ֵ
//�漰�˷��������
    input wire [63:0] I_FromEXMEM_hilo_temp,//��һ��ִ�����ڵõ��ĳ˷����
    input wire [1:0] I_FromEXMEM_cnt,//D��ǰ����ִ�н׶εĵڼ�������
    output wire [63:0] O_ToEXMEM_hilo_temp,//��һ��ִ�����ڵõ��ĳ˷����
    output wire [1:0] O_ToEXMEM_cnt,//��һ��ʱ�����ڴ���ִ�н׶εĵڼ���ʼ������
//�漰�����������
    input wire I_FromDIV_divready,//���������Ƿ����
    input wire [63:0] I_FromDIV_divres,//����������
    output reg O_ToDIV_signediv,//�Ƿ�Ϊ�з��ų���1-->�з��ţ�0->�޷���
    output reg O_ToDIV_opdata1,//������
    output reg O_ToDIV_opdata2,//����
    output reg O_ToDIV_divstart,//�����Ƿ�ʼ
//�ӳٲ���ر���
    input wire I_FromIDEX_isindelayslot,//�ӳٲ۱��
    output wire O_TOEXMEM_isindelayslot,//�ӳٲ۱��
//��ô棬ID��صĽӿ�
    output reg O_To_EXMEM_mem_addr,//���ش洢ָ���Ӧ�Ĵ洢����ַ
    output reg O_To_ID_EXMEM_wreg,//ִ�н׶�ָ�������Ƿ���Ҫд��Ŀ�ļĴ���
    output reg [7:0] O_To_ID_EXMEM_aluop,//ִ�н׶�ָ����е�����������
    output reg [31:0] O_To_ID_EXMEM_wreg_addr,//���ش洢ָ���Ӧ�Ĵ洢����ַ
    output reg [31:0] O_To_ID_EXMEM_wreg_data,//�洢ָ��Ҫ�洢�����ݣ��Լ����ص�Ŀ�ļĴ�����ԭʼֵ

//��ˮ��ͣ����
    output reg stallreq//������ˮ��ͣ
    );


	/*** ��ʱ����� ***/
		// 8'b01111100: begin  //sllv
		// end
		// 8'b00000010: begin  //srlv
		// end
		// 8'b00001011: begin  //movn
		// exe logic

				// 8'b10101001: begin //mul
				// end
				// 8'b00011000: begin //mult
				// 	if((I_FromIDEX_reg1[31] ^I_FromIDEX_reg2[31]) == 1'b1) begin
				// 		arithmetic_out <= ~hilo_temp +1;
				// 	end
				// end
				// 8'b00011001: begin //multu
				// end
				// 8'b00011010: begin //div
				// end
				// 8'b00011011: begin //divu
				// end

	/** ����� **/

	// logic
	reg[31:0] logic_out
	always @(*) begin
		if(rst == 1'b1) begin
			logic_out <= 32'h00000000;
		end else begin
			case (I_FromIDEX_aluop)
				8'b0010010: begin 	//or
					logic_out <= I_FromIDEX_reg1 | I_FromIDEX_reg2;
				end
				8'b00100100: begin  //and
					logic_out <= I_FromIDEX_reg1 & I_FromIDEX_reg2;
				end
				8'b00100111: begin  //nor
					logic_out <= ~(I_FromIDEX_reg1 | I_FromIDEX_reg2);
				end
				8'b00100110: begin  //xor
					logic_out <= I_FromIDEX_reg1 ^ I_FromIDEX_reg2;
				end
				default: begin
					logic_out <= 32'h00000000;
				end
			endcase
		end
	end

	// exe shift
	reg[31:0] shift_out;
	always @ (*) begin
		if(rst == 1'b1) begin
			shift_out <= 32'h00000000;
		end else begin
		case (I_FromIDEX_aluop)
			8'b01111100: begin  //sll
				shift_out <= I_FromIDEX_reg1 << I_FromIDEX_reg2[4:0];
			end
			8'b00000010: begin //srl
				shift_out <= I_FromIDEX_reg1 >> I_FromIDEX_reg2[4:0];
			end
		 	8'b00000011: begin //sra
				shift_out <= ({32{I_FromIDEX_reg2[31]}} << (6'd32-{1'b0,I_FromIDEX_reg1[4:0]}))| I_FromIDEX_reg2 >> I_FromIDEX_reg1[4:0];
			end
			default: begin
				shift_out <= 32'h000000;
			end
		endcase
	end

	// exe arithmetic 
	reg[31:0] arithmetic_out;
	// add, sub
	wire switch_complement_reg2;	//���ݷ���ȡ����
	wire mux_sum;
	wire mux_lt;
	assign switch_complement_reg2 = (I_FromIDEX_aluop == 8'b00100010) || 
								 (I_FromIDEX_aluop == 8'b00100011) ?
								  ~(I_FromIDEX_reg2)+1 :I_FromIDEX_reg2;
	assign mux_sum = I_FromIDEX_reg1 + switch_complement_reg2;
	assign mux_lt = ((I_FromEX_aluop_i == 8'b00101010)) ?
					((I_FromIDEX_reg1[31] && !I_FromIDEX_reg2[31]) ||
					(!I_FromIDEX_reg1[31] && !I_FromIDEX_reg2[31] && mux_sum[31]) ||
					(I_FromIDEX_reg1[31] && I_FromIDEX_reg2[31] && mux_sum[31]))
					: (I_FromIDEX_reg1 < I_FromIDEX_reg2)
	always @ (*) begin
		if(rst == 1'b1) begin
			arithmetic_out <= 32'h00000000;
		end else begin
			case (I_FromIDEX_aluop)
				8'b00100000,8'b00100001,8'b01010101,8'b01010110: begin //add,addu,addi,addiu
					arithmetic_out <= mux_sum;
				end
				// 8'b00100001: begin //addu
				// 	arithmetic_out <= mux_sum;
				// end
				// 8'b01010101: begin //addi
				// 	arithmetic_out <= mux_sum;
				// end
				// 8'b01010110: begin //addiu
				// 	arithmetic_out <= mux_sum;
				// end
				8'b00100010,8'b00100011: begin //sub,subu
					arithmetic_out <= mux_sum;
				end
				// 8'b00100011: begin //subu
				// 	arithmetic_out <= mux_sum;
				// end
				8'b00101010,8'b00101011: begin //slt,sltu
					arithmetic_out <= mux_slt;
				end
				// 8'b00101011: begin //sltu
				// 	arithmetic_out <= mux_slt;
				// end
				default: begin
					arithmetic_out <= 32'h00000000;
				end
			endcase
		end

	// mul
	reg[31:0] mul_out;
	wire switch_mult_reg1;	//������
	wire switch_mult_reg2;	//������
	wire mux_mul;
	assign switch_mult_reg1 = (((I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011001)) &&
							  ( I_FROMIDEX_reg1[31] == 1'b1)) ? 
							  (~I_FromIDEX_reg1+1) : I_FromIDEX_reg1;
	assign switch_mult_reg2 = (((I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011001)) &&
							  ( I_FROMIDEX_reg2[31] == 1'b1)) ? 
							  (~I_FromIDEX_reg2+1) : I_FromIDEX_reg2;
	assign mux_mul = I_FromIDEX_reg1 * I_FromIDEX_reg2;
	always @ (*) begin
		if(rst==1'b1) begin
			mul_res <= 32'h00000000;
		end else if (I_FromIDEX_aluop == 8'b00011000 || 		//mult
			I_FromIDEX_aluop == 8'b10101001) begin		//mul
				if((I_FromIDEX_reg1[31] ^I_FromIDEX_reg2[31]) == 1'b1) begin
					mul_out <= ~mux_mul +1;
				end else begin
					mul_out <= mux_mul;
				end
		end else begin
			mul_out <= 32'h00000000;		
		end		
	end

	// div
	// TODO: ������ʵ�֣���Ҫ����ģ���֧�֣���
	// reg [31:0]div_out;
	// always @ (*) begin
	// 	// TODO: ��ˮ����ͣ
	// 	if(rst == 1'b1) begin
	// 		div_out <= 32'h00000000;
	// 	end else begin
	// 		case(I_FromIDEX_aluop)
	// 			8'b00011010: begin //div
					
	// 			end
	// 			8'b00011011: begin //divu
					
	// 			end
	// 	end
	// end

	//TODO:movn

	/** ����� **/
	//TODO: �������
	always @ (*) begin
		
	end

endmodule
