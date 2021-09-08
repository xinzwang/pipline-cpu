`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:15:34
// Design Name: wsc
// Module Name: Instruction_Decoder
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
//ָ�����������е������ڿ��Ƶ�Ԫcu

module Instruction_Decoder(
    input clk,
    input rst,
    input wire [31:0] I_FromIFID_pc,//����׶�ָ���Ӧ�ĵ�ַ
    input wire [31:0] I_FromIFID_ins,//����׶ε�ָ��
//��Ĵ�����ջ��ز���
    input wire [31:0] I_FromRF_reg1_data,//�ӼĴ�����ջ�����ĵ�һ���˿�����
    input wire [31:0] I_FromRF_reg2_data,//�ӼĴ�����ջ�����ĵڶ����˿�����
    output reg O_ToRF_reg1,//�Ĵ�����ջ��һ�����˿�ʹ���ź�
    output reg O_ToRF_reg2,//�Ĵ�����ջ�ڶ������˿�ʹ���ź�
    output reg [4:0] O_ToRF_reg1_addr,//�Ĵ�����ջ��һ�����˿ڵ�ַ
    output reg [4:0] O_ToRF_reg2_addr,//�Ĵ�����ջ�ڶ������˿ڵ�ַ
    output reg O_ToIDEX_wreg,//�Ĵ�����ջд�˿�ʹ���ź�
    output reg [4:0] O_ToIDEX_wreg_addr,//�Ĵ�����ջд�˿ڵ�ַ
    output reg [7:0] O_ToIDEX_aluop,//����׶�Ҫ���е�����������
    output reg [2:0] O_ToIDEX_alusel,//����׶�Ҫ���е����������
    output reg [31:0] O_ToIDEX_reg1,//����׶�Ҫ���е������ԭ������һ
    output reg [31:0] O_ToIDEX_reg2,//����׶�Ҫ���е������ԭ��������
//���½ӿ���ҪΪ���������ؽ�������ϸ�Ķ�P113�������
    input wire I_FromEX_wreg,//����ִ�н׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
    input wire [31:0] I_FromEX_wreg_addr,//����ִ�н׶ε�ָ��ҪдĿ�ļĴ�����ַ
    input wire [31:0] I_FromEX_wreg_data,//����ִ�н׶ε�ָ��дĿ�ļĴ�������
    input wire [7:0] I_FromEX_aluop, //����ִ�н׶�ָ�������������
    input wire I_FromMEM_wreg,//���ڷô�׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
    input wire [31:0] I_FromMEM_wreg_addr,//���ڷô�׶ε�ָ��ҪдĿ�ļĴ�����ַ
    input wire [31:0] I_FromMEM_wreg_data,//���ڷô�׶ε�ָ��дĿ�ļĴ�������
//��תָ���ӳٲ��ź�
    input wire I_FromIDEX_isindelayslot,//��ǰ����ָ���Ƿ����ӳٲ�
    output reg O_ToIDEX_isindelayslot,//��ǰ����ָ���Ƿ����ӳٲ�  �޸�Ϊreg����
    output reg O_ToPC_branchflag,//��ת�ź�
    output reg [31:0] O_ToPC_branch_taraddr,//��תĿ�ĵ�ַ
//������ָ����ˮֹͣ�����ź�
    output wire stallreq, //�޸�Ϊwire����
    output wire [31:0] O_ToIDEX_ins_addr,//ָ���ַ
    output reg O_ToIDEX_next_isindelayslot,
//��������
    output wire[31:0] O_ToIDEX_ins,//��ǰ��������׶ε�ָ��
    output wire[31:0] O_ToIDEX_current_inst_address //����׶�ָ��ĵ�ַ
);


//ȡ��ָ���ָ���룬������
  wire[5:0] ID_op_local = I_FromIFID_ins[31:26];
  wire[4:0] ID_op2_local = I_FromIFID_ins[10:6];
  wire[5:0] ID_op3_local = I_FromIFID_ins[5:0];
  wire[4:0] ID_op4_local = I_FromIFID_ins[20:16];
  
  //����ָ��ִ����Ҫ��������
  reg[31:0]	ID_imm_local;
  
  //ָ���Ƿ���Ч
  reg ID_instvalid_local;
  wire[31:0] ID_pc_plus_8_local;
  wire[31:0] ID_pc_plus_4_local;
  wire[31:0] ID_imm_sll2_signedext_local;  

  reg ID_stallreq_for_reg1_loadrelate_local;
  reg ID_stallreq_for_reg2_loadrelate_local;
  wire ID_pre_inst_is_load_local;
  reg ID_excepttype_is_syscall_local;
  reg ID_excepttype_is_eret_local;
  
  assign ID_pc_plus_8_local = I_FromIFID_pc + 2;//���浱ǰ����׶�ָ�����ڶ���ָ��ĵ�ַ
  assign ID_pc_plus_4_local = I_FromIFID_pc +1;//���浱ǰ����׶�ָ����������ָ��ĵ�ַ
  assign ID_imm_sll2_signedext_local = {{14{I_FromIFID_ins[15]}}, I_FromIFID_ins[15:0], 2'b00 };  
  assign stallreq = ID_stallreq_for_reg1_loadrelate_local | ID_stallreq_for_reg2_loadrelate_local;
  //���������źŵ�ֵ���ж���һ��ָ���ǲ��Ǽ���ָ�����ǣ���ID_pre_inst_is_load_localΪ1
  assign ID_pre_inst_is_load_local = ((I_FromEX_aluop ==  8'b11100000) || (I_FromEX_aluop == 8'b11100100)||(I_FromEX_aluop == 8'b11100001) ||(I_FromEX_aluop == 8'b11100101)||(I_FromEX_aluop == 8'b11100011) ||(I_FromEX_aluop == 8'b11100110)||(I_FromEX_aluop == 8'b11100010)||(I_FromEX_aluop == 8'b11110000) ||(I_FromEX_aluop == 8'b11111000)) ? 1'b1 : 1'b0;
  assign O_ToIDEX_ins = I_FromIFID_ins;

  //exceptiontype�ĵ�8bit�����ⲿ�жϣ���9bit��ʾ�Ƿ���syscallָ��
  //��10bit��ʾ�Ƿ�����Чָ���11bit��ʾ�Ƿ���trapָ��
  //assign O_ToIDEX_excepttype = {19'b0,ID_excepttype_is_eret_local,2'b0,ID_instvalid_local, ID_excepttype_is_syscall_local,8'b0};
  
  //�����ź�pci���ǵ�ǰ��������׶ε�ָ��ĵ�ַ
  assign O_ToIDEX_current_inst_address = I_FromIFID_pc;
    
    //��ָ���������
	always @ (*) begin	
		if (rst == 1'b0) begin
			O_ToIDEX_aluop <= 8'b00000000;
			O_ToIDEX_alusel <= 3'b000;
			O_ToIDEX_wreg_addr<= 5'b00000;
			O_ToIDEX_wreg <= 1'b0;
			ID_instvalid_local <= 1'b0;
			O_ToRF_reg1 <= 1'b0;
			O_ToRF_reg2 <= 1'b0;
			O_ToRF_reg1_addr <= 5'b00000;
			O_ToRF_reg2_addr <= 5'b00000;
			ID_imm_local <= 32'h0;	
			//O_ToIDEX_link_addr <= 32'h00000000;
			O_ToPC_branch_taraddr <= 32'h00000000;
			O_ToPC_branchflag <= 1'b0;
			O_ToIDEX_next_isindelayslot <= 1'b0;
			ID_excepttype_is_syscall_local <= 1'b0;
			ID_excepttype_is_eret_local <= 1'b0;								
	  end else begin
			O_ToIDEX_aluop <= 8'b00000000;
			O_ToIDEX_alusel <= 3'b000;
			O_ToIDEX_wreg_addr<= I_FromIFID_ins[15:11];//Ĭ��Ŀ�ļĴ���
			O_ToIDEX_wreg <= 1'b0;
			ID_instvalid_local <= 1'b1;	   
			O_ToRF_reg1 <= 1'b0;
			O_ToRF_reg2 <= 1'b0;
			O_ToRF_reg1_addr <= I_FromIFID_ins[25:21];//regfile���˿�1��ȡ�ļĴ�����ַ
			O_ToRF_reg2_addr <= I_FromIFID_ins[20:16];//regfile���˿�2��ȡ�ļĴ�����ַ
			ID_imm_local <= 32'h00000000;
			//O_ToIDEX_link_addr <= 32'h00000000;
			O_ToPC_branch_taraddr <= 32'h00000000;
			O_ToPC_branchflag <= 1'b0;	
			O_ToIDEX_next_isindelayslot <= 1'b0;
			ID_excepttype_is_syscall_local <= 1'b0;	
			ID_excepttype_is_eret_local <= 1'b0;		
			
		//�ж�ָ��			 			
		  case (ID_op_local)
		    6'b000000:		begin
		    	case (ID_op2_local)
		    		5'b00000:			begin
		    			case (ID_op3_local)
		    				6'b100101:	begin//or
		    					O_ToIDEX_wreg <= 1'b1;		//�����д��Ŀ�ļĴ���
		    					O_ToIDEX_aluop <= 8'b00100101;   //����������
		  						O_ToIDEX_alusel <= 3'b001; 	//��������
		  						O_ToRF_reg1 <= 1'b1;	//ͨ��regfile�Ķ��˿�1���Ĵ���
		  						O_ToRF_reg2 <= 1'b1;    //ͨ��regfile�Ķ��˿�2���Ĵ���
		  						ID_instvalid_local <= 1'b0;	//�Ƿ���Ч
								end  
								//���º��������Ʋ���׸��
		    				6'b100100:	begin//and
		    					O_ToIDEX_wreg <= 1'b1;		
		    					O_ToIDEX_aluop <= 8'b00100100;
		  						O_ToIDEX_alusel <= 3'b001;	  
		  						O_ToRF_reg1 <= 1'b1;	
		  						O_ToRF_reg2 <= 1'b1;	
		  						ID_instvalid_local <= 1'b0;	
								end  	
		    				6'b100110:	begin//xor
		    					O_ToIDEX_wreg <= 1'b1;		
		    					O_ToIDEX_aluop <= 8'b00100110;
		  						O_ToIDEX_alusel <= 3'b001;		
		  						O_ToRF_reg1 <= 1'b1;	
		  						O_ToRF_reg2 <= 1'b1;	
		  						ID_instvalid_local <= 1'b0;	
								end  				
		    				6'b100111:	begin//nor
		    					O_ToIDEX_wreg <= 1'b1;		
		    					O_ToIDEX_aluop <= 8'b00100111;
		  						O_ToIDEX_alusel <= 3'b001;		
		  						O_ToRF_reg1 <= 1'b1;	
		  						O_ToRF_reg2 <= 1'b1;	
		  						ID_instvalid_local <= 1'b0;	
								end 
								6'b000100: begin//sllv
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b01111100;
		  						    O_ToIDEX_alusel <= 3'b010;		
		  						    O_ToRF_reg1 <= 1'b1;	O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end 
								6'b000110: begin//srlv
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b00000010;
		  						    O_ToIDEX_alusel <= 3'b010;		
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end 
								6'b000111: begin//srav
									O_ToIDEX_wreg <= 1'b1;
									O_ToIDEX_aluop <= 8'b00000011;
									O_ToIDEX_alusel <= 3'b010;	
									O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;		
		  					end		
								// 6'b010000: begin //mfhi
								// 	wreg_o <= 1'b1;		
								// 	aluop_o <= 6'b010000;
		  						// 	alusel_o <= 3'b011;   
								// 	reg1_read_o <= 1'b0;
								// 	reg2_read_o <= 1'b0;
		  						// 	instvalid <= 1'b0;	
								// end
								// 6'b010010: begin //mflo
								// 	wreg_o <= 1'b1;
								// 	aluop_o <= 6'b010010;
		  						// 	alusel_o <= 3'b011;
								// 	reg1_read_o <= 1'b0;
								// 	reg2_read_o <= 1'b0;
		  						// 	instvalid <= 1'b0;	
								// end
								// 6'b010001: begin //mthi
								// 	wreg_o <= 1'b0;		
								// 	aluop_o <= 6'b010001;
		  						// 	reg1_read_o <= 1'b1;	
								//   	reg2_read_o <= 1'b0; 
								//   	instvalid <= 1'b0;	
								// end
								// 6'b010011: begin 	//mlto
								// 	wreg_o <= 1'b0;	
								// 	aluop_o <= 6'b010011;
		  						// 	reg1_read_o <= 1'b1;	
								// 	reg2_read_o <= 1'b0; 
								// 	instvalid <= 1'b0;	
								// end			
								6'b001011: begin//movn
									O_ToIDEX_aluop <= 8'b00001011;
		  						    O_ToIDEX_alusel <= 3'b011;  
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;
								 	if(O_ToIDEX_reg2 != 32'h00000000) begin
	 									O_ToIDEX_wreg <= 1'b1;
	 								end else begin
	 									O_ToIDEX_wreg <= 1'b0;
	 								end
	 							end
								6'b001010: begin 	//movz
									O_ToIDEX_aluop <= 8'b00001010;
		  						    O_ToIDEX_alusel <= 3'b011;  
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;
								 	if(O_ToIDEX_reg2 == 32'h00000000) begin
	 									O_ToIDEX_wreg <= 1'b1;
	 								end else begin
	 									O_ToIDEX_wreg <= 1'b0;
	 								end  							
								end
								6'b101010: begin//slt
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b00101010;
		  						    O_ToIDEX_alusel <= 3'b100;		
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end
								6'b101011: begin//sltu
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b00101011;
		  						    O_ToIDEX_alusel <= 3'b100;		
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end	
								6'b100000: begin//add
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b00100000;
		  						    O_ToIDEX_alusel <= 3'b100;		
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end
								6'b100001: begin//addu
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b00100001;
		  						    O_ToIDEX_alusel <= 3'b100;		
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end
								6'b100010: begin//sub
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b00100010;
		  						    O_ToIDEX_alusel <= 3'b100;		
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end
								6'b100011: begin//subu
									O_ToIDEX_wreg <= 1'b1;		
									O_ToIDEX_aluop <= 8'b00100011;
		  						    O_ToIDEX_alusel <= 3'b100;		
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1;
		  						    ID_instvalid_local <= 1'b0;	
								end
								6'b011000: begin//mult
									O_ToIDEX_wreg <= 1'b0;		
									O_ToIDEX_aluop <= 8'b00011000;
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1; 
		  						    ID_instvalid_local <= 1'b0;	
								end
								6'b011001: begin//multu
									O_ToIDEX_wreg <= 1'b0;		
									O_ToIDEX_aluop <= 8'b00011001;
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1; 
		  						    ID_instvalid_local <= 1'b0;	
								end
								6'b011010: begin//div
									O_ToIDEX_wreg <= 1'b0;		
									O_ToIDEX_aluop <= 8'b00011010;
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1; 
		  						    ID_instvalid_local <= 1'b0;	
								end
								 6'b011011: begin//divu
									O_ToIDEX_wreg <= 1'b0;		
									O_ToIDEX_aluop <= 8'b00011011;
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b1; 
		  						    ID_instvalid_local <= 1'b0;	
								end			
								6'b001000: begin//jr
									O_ToIDEX_wreg <= 1'b0;		
									O_ToIDEX_aluop <= 8'b00001000;
		  						    O_ToIDEX_alusel <= 3'b110;   
		  						    O_ToRF_reg1 <= 1'b1;	
		  						    O_ToRF_reg2 <= 1'b0;
		  						    //O_ToIDEX_link_addr <= 32'h00000000;					
			            	        O_ToPC_branch_taraddr <= O_ToIDEX_reg1;
			            	        O_ToPC_branchflag <= 1'b1;
			                        O_ToIDEX_next_isindelayslot <= 1'b1;
			                        ID_instvalid_local <= 1'b0;	
								end							 											  											
						    default:	begin
						    end
						  endcase
						 end
						default: begin
						end
					endcase	
          case (ID_op3_local)																				
								default:	begin
								end	
					 endcase									
					end									  
		  	6'b001101:			begin  //ori
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00100101;
		  		O_ToIDEX_alusel <= 3'b001; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {16'h0, I_FromIFID_ins[15:0]};		
				O_ToIDEX_wreg_addr<= I_FromIFID_ins[20:16];
				ID_instvalid_local <= 1'b0;	
		  	end
		  	6'b001100:			begin//andi
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00100100;
		  		O_ToIDEX_alusel <= 3'b001;	
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {16'h0, I_FromIFID_ins[15:0]};		
				O_ToIDEX_wreg_addr<= I_FromIFID_ins[20:16];		  	
				ID_instvalid_local <= 1'b0;	
				end	 	
		  	6'b001110:			begin//xori
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00100110;
		  		O_ToIDEX_alusel <= 3'b001;
		  		O_ToRF_reg1 <= 1'b1;
		  		O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {16'h0, I_FromIFID_ins[15:0]};		
				O_ToIDEX_wreg_addr<= I_FromIFID_ins[20:16];		  	
				ID_instvalid_local <= 1'b0;	
				end	 		
		  	6'b001111:			begin//lui
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00100101;
		  		O_ToIDEX_alusel <= 3'b001; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {I_FromIFID_ins[15:0], 16'h0};		
				O_ToIDEX_wreg_addr<= I_FromIFID_ins[20:16];		  	
				ID_instvalid_local <= 1'b0;	
				end			
				6'b001010:			begin//slti
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00101010;
		  		O_ToIDEX_alusel <= 3'b100; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {{16{I_FromIFID_ins[15]}}, I_FromIFID_ins[15:0]};		
				O_ToIDEX_wreg_addr<= I_FromIFID_ins[20:16];		  	
				ID_instvalid_local <= 1'b0;	
				end
				6'b001011:			begin//sltiu
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00101011;
		  		O_ToIDEX_alusel <= 3'b100; O_ToRF_reg1 <= 1'b1;	O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {{16{I_FromIFID_ins[15]}}, I_FromIFID_ins[15:0]};		
				O_ToIDEX_wreg_addr<= I_FromIFID_ins[20:16];		  	
				ID_instvalid_local <= 1'b0;	
				end			
				6'b001000:			begin//addi
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b01010101;
		  		O_ToIDEX_alusel <= 3'b100; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {{16{I_FromIFID_ins[15]}}, I_FromIFID_ins[15:0]};		
				O_ToIDEX_wreg_addr<= I_FromIFID_ins[20:16];		  	
				ID_instvalid_local <= 1'b0;	
				end
				6'b001001:			begin//addiu
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b01010110;
		  		O_ToIDEX_alusel <= 3'b100;
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;	  	
				ID_imm_local <= {{16{I_FromIFID_ins[15]}}, I_FromIFID_ins[15:0]};		
				O_ToIDEX_wreg_addr <= I_FromIFID_ins[20:16];		  	
				ID_instvalid_local <= 1'b0;	
				end
				6'b000010:			begin//j
		  		O_ToIDEX_wreg <= 1'b0;		
		  		O_ToIDEX_aluop <= 8'b01001111;
		  		O_ToIDEX_alusel <= 3'b110; 
		  		O_ToRF_reg1 <= 1'b0;	
		  		O_ToRF_reg2 <= 1'b0;
		  		//O_ToIDEX_link_addr <= 32'h00000000;
			    O_ToPC_branch_taraddr <= {ID_pc_plus_4_local[31:26], I_FromIFID_ins[25:0]};
			    O_ToPC_branchflag <= 1'b1;
			    O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			    ID_instvalid_local <= 1'b0;	
				end
				6'b000011:			begin//jal
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b01010000;
		  		O_ToIDEX_alusel <= 3'b110; O_ToRF_reg1 <= 1'b0;	O_ToRF_reg2 <= 1'b0;
		  		O_ToIDEX_wreg_addr<= 5'b11111;	
		  		//O_ToIDEX_link_addr <= ID_pc_plus_8_local ;
			    O_ToPC_branch_taraddr <= {ID_pc_plus_4_local[31:28], I_FromIFID_ins[25:0], 2'b00};
			    O_ToPC_branchflag <= 1'b1;
			    O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			    ID_instvalid_local <= 1'b0;	
				end
				6'b000100:			begin//beq
		  		O_ToIDEX_wreg <= 1'b0;		
		  		O_ToIDEX_aluop <= 8'b01010001;
		  		O_ToIDEX_alusel <= 3'b110; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b1;
		  		ID_instvalid_local <= 1'b0;	
		  		if(O_ToIDEX_reg1 == O_ToIDEX_reg2) begin
			    	O_ToPC_branch_taraddr <= ID_pc_plus_4_local + ID_imm_sll2_signedext_local;
			    	O_ToPC_branchflag <= 1'b1;
			    	O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			    end
				end
				6'b000111:			begin//bgtz
		  		O_ToIDEX_wreg <= 1'b0;		
		  		O_ToIDEX_aluop <= 8'b01010100;
		  		O_ToIDEX_alusel <= 3'b110; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;
		  		ID_instvalid_local <= 1'b0;	
		  		if((O_ToIDEX_reg1[31] == 1'b0) && (O_ToIDEX_reg1 != 32'h00000000)) begin
			    	O_ToPC_branch_taraddr <= ID_pc_plus_4_local + ID_imm_sll2_signedext_local;
			    	O_ToPC_branchflag <= 1'b1;
			    	O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			    end
				end
				6'b000110:			begin//blez
		  		O_ToIDEX_wreg <= 1'b0;		
		  		O_ToIDEX_aluop <= 8'b01010011;
		  		O_ToIDEX_alusel <= 3'b110; 
		  		O_ToRF_reg1 <= 1'b1;	O_ToRF_reg2 <= 1'b0;
		  		ID_instvalid_local <= 1'b0;	
		  		if((O_ToIDEX_reg1[31] == 1'b1) || (O_ToIDEX_reg1 == 32'h00000000)) begin
			    	O_ToPC_branch_taraddr <= ID_pc_plus_4_local + ID_imm_sll2_signedext_local;
			    	O_ToPC_branchflag <= 1'b1;
			    	O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			    end
				end
				6'b000101:			begin//bne
		  		O_ToIDEX_wreg <= 1'b0;		
		  		O_ToIDEX_aluop <= 8'b01010011;
		  		O_ToIDEX_alusel <= 3'b110; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b1;
		  		ID_instvalid_local <= 1'b0;	
		  		if(O_ToIDEX_reg1 != O_ToIDEX_reg2) begin
			    	O_ToPC_branch_taraddr <= ID_pc_plus_4_local + ID_imm_sll2_signedext_local;
			    	O_ToPC_branchflag <= 1'b1;
			    	O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			    end
				end
				6'b100011:			begin//lw
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b11100011;
		  		O_ToIDEX_alusel <= 3'b111; 
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b0;	  	
				O_ToIDEX_wreg_addr <= I_FromIFID_ins[20:16]; 
				ID_instvalid_local <= 1'b0;	
				end
				6'b101011:			begin//sw
		  		O_ToIDEX_wreg <= 1'b0;		
		  		O_ToIDEX_aluop <= 8'b11101011;
		  		O_ToRF_reg1 <= 1'b1;	
		  		O_ToRF_reg2 <= 1'b1; 
		  		ID_instvalid_local <= 1'b0;	
		  		O_ToIDEX_alusel <= 3'b111; 
				end		
				6'b000001:		begin
					case (ID_op4_local)
						5'b00001:	begin//bgez
							O_ToIDEX_wreg <= 1'b0;		
							O_ToIDEX_aluop <= 8'b01000001;
		  				    O_ToIDEX_alusel <= 3'b110; 
		  				    O_ToRF_reg1 <= 1'b1;	
		  				    O_ToRF_reg2 <= 1'b0;
		  				    ID_instvalid_local <= 1'b0;	
		  				if(O_ToIDEX_reg1[31] == 1'b0) begin
			    			O_ToPC_branch_taraddr <= ID_pc_plus_4_local + ID_imm_sll2_signedext_local;
			    			O_ToPC_branchflag <= 1'b1;
			    			O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			   			end
						end
						5'b00000:		begin//bltz
						  O_ToIDEX_wreg <= 1'b0;		
						  O_ToIDEX_aluop <= 8'b01001011;
		  				  O_ToIDEX_alusel <= 3'b110; 
		  				  O_ToRF_reg1 <= 1'b1;	O_ToRF_reg2 <= 1'b0;
		  				  ID_instvalid_local <= 1'b0;	
		  				if(O_ToIDEX_reg1[31] == 1'b1) begin
			    			O_ToPC_branch_taraddr <= ID_pc_plus_4_local + ID_imm_sll2_signedext_local;
			    			O_ToPC_branchflag <= 1'b1;
			    			O_ToIDEX_next_isindelayslot <= 1'b1;		  	
			   			end
						end
						default:	begin
						end
					endcase
				end								
				6'b011100:		begin
					case ( ID_op3_local )
						6'b000010:		begin//mul
							O_ToIDEX_wreg <= 1'b1;		
							O_ToIDEX_aluop <= 8'b10101001;
		  				    O_ToIDEX_alusel <= 3'b101;
		  				    O_ToRF_reg1 <= 1'b1;	
		  				    O_ToRF_reg2 <= 1'b1;	
		  				    ID_instvalid_local <= 1'b0;	  			
						end
						default:	begin
						end
					endcase      //EXE_SPECIAL_INST2 case
				end																		  	
		    default:			begin
		    end
		  endcase		  //case ID_op_local
		  
		  //sll srl sra
		  if (I_FromIFID_ins[31:21] == 11'b00000000000) begin
		  	if (ID_op3_local == 6'b000000) begin//sll
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b01111100;
		  		O_ToIDEX_alusel <= 3'b010; 
		  		O_ToRF_reg1 <= 1'b0;	O_ToRF_reg2 <= 1'b1;	  	
					ID_imm_local[4:0] <= I_FromIFID_ins[10:6];		
					O_ToIDEX_wreg_addr<= I_FromIFID_ins[15:11];
					ID_instvalid_local <= 1'b0;	
				end else if ( ID_op3_local == 6'b000010 ) begin//srl
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00000010;
		  		O_ToIDEX_alusel <= 3'b010; 
		  		O_ToRF_reg1 <= 1'b0;	O_ToRF_reg2 <= 1'b1;	  	
					ID_imm_local[4:0] <= I_FromIFID_ins[10:6];		
					O_ToIDEX_wreg_addr<= I_FromIFID_ins[15:11];
					ID_instvalid_local <= 1'b0;	
				end else if ( ID_op3_local == 6'b000011 ) begin//sra
		  		O_ToIDEX_wreg <= 1'b1;		
		  		O_ToIDEX_aluop <= 8'b00000011;
		  		O_ToIDEX_alusel <= 3'b010; 
		  		O_ToRF_reg1 <= 1'b0;	O_ToRF_reg2 <= 1'b1;	  	
					ID_imm_local[4:0] <= I_FromIFID_ins[10:6];		
					O_ToIDEX_wreg_addr <= I_FromIFID_ins[15:11];
					ID_instvalid_local <= 1'b0;	
				end
			end		  
		end       //if
	end         //always
	
	
	
//ȷ�����������Դ������1
	always @ (*) begin
			ID_stallreq_for_reg1_loadrelate_local <= 1'b0;	
		if(rst == 1'b0) begin
			O_ToIDEX_reg1 <= 32'h00000000;	
		end else if(ID_pre_inst_is_load_local == 1'b1 && I_FromEX_wreg_addr== O_ToRF_reg1_addr && O_ToRF_reg1 == 1'b1 ) begin
		  ID_stallreq_for_reg1_loadrelate_local <= 1'b1;							
		end else if((O_ToRF_reg1 == 1'b1) && (I_FromEX_wreg == 1'b1) && (I_FromEX_wreg_addr== O_ToRF_reg1_addr)) begin
			O_ToIDEX_reg1 <= I_FromEX_wreg_data; 
		end else if((O_ToRF_reg1 == 1'b1) && (I_FromMEM_wreg == 1'b1) && (I_FromMEM_wreg_addr == O_ToRF_reg1_addr)) begin
			O_ToIDEX_reg1 <= I_FromMEM_wreg_data; 		
		end else if(O_ToRF_reg1 == 1'b1) begin
			O_ToIDEX_reg1 <= I_FromRF_reg1_data; //regfile���˿�1��ֵ
		end else if(O_ToRF_reg1 == 1'b0) begin
			O_ToIDEX_reg1 <= ID_imm_local;//������
		end else begin
			O_ToIDEX_reg1 <= 32'h00000000;
		end
	end
	
	
//ȷ�����������Դ������2(ͬ�ϲ���)
	always @ (*) begin
			ID_stallreq_for_reg2_loadrelate_local <= 1'b0;
		if(rst == 1'b0) begin
			O_ToIDEX_reg2 <= 32'h00000000;
		end else if(ID_pre_inst_is_load_local == 1'b1 && I_FromEX_wreg_addr== O_ToRF_reg2_addr && O_ToRF_reg2 == 1'b1 ) begin
		  ID_stallreq_for_reg2_loadrelate_local <= 1'b1;			
		end else if((O_ToRF_reg2 == 1'b1) && (I_FromEX_wreg == 1'b1) && (I_FromEX_wreg_addr== O_ToRF_reg2_addr)) begin
			O_ToIDEX_reg2 <= I_FromEX_wreg_data; 
		end else if((O_ToRF_reg2 == 1'b1) && (I_FromMEM_wreg == 1'b1) && (I_FromMEM_wreg_addr == O_ToRF_reg2_addr)) begin
			O_ToIDEX_reg2 <= I_FromMEM_wreg_data;			
	    end else if(O_ToRF_reg2 == 1'b1) begin
	  	    O_ToIDEX_reg2 <= I_FromRF_reg2_data;
	    end else if(O_ToRF_reg2 == 1'b0) begin
	  	    O_ToIDEX_reg2 <= ID_imm_local;
	    end else begin
	    O_ToIDEX_reg2 <= 32'h00000000;
	  end
	end

    //�Ƿ��ӳٲ�ָ��
	always @ (*) begin
		if(rst == 1'b0) begin     O_ToIDEX_isindelayslot <= 1'b0;
		end else begin            O_ToIDEX_isindelayslot <= I_FromIDEX_isindelayslot;		
	  end
	end

endmodule
