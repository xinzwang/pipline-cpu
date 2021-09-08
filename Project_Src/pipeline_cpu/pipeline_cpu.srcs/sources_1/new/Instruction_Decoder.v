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
//指令译码器，有点类似于控制单元cu

module Instruction_Decoder(
    input clk,
    input rst,
    input wire [31:0] I_FromIFID_pc,//译码阶段指令对应的地址
    input wire [31:0] I_FromIFID_ins,//译码阶段的指令
//与寄存器堆栈相关操作
    input wire [31:0] I_FromRF_reg1_data,//从寄存器堆栈读到的第一个端口输入
    input wire [31:0] I_FromRF_reg2_data,//从寄存器堆栈读到的第二个端口输入
    output reg O_ToRF_reg1,//寄存器堆栈第一个读端口使能信号
    output reg O_ToRF_reg2,//寄存器堆栈第二个读端口使能信号
    output reg [4:0] O_ToRF_reg1_addr,//寄存器堆栈第一个读端口地址
    output reg [4:0] O_ToRF_reg2_addr,//寄存器堆栈第二个读端口地址
    output reg O_ToIDEX_wreg,//寄存器堆栈写端口使能信号
    output reg [4:0] O_ToIDEX_wreg_addr,//寄存器堆栈写端口地址
    output reg [7:0] O_ToIDEX_aluop,//译码阶段要进行的运算子类型
    output reg [2:0] O_ToIDEX_alusel,//译码阶段要进行的运算的类型
    output reg [31:0] O_ToIDEX_reg1,//译码阶段要进行的运算的原操作数一
    output reg [31:0] O_ToIDEX_reg2,//译码阶段要进行的运算的原操作数二
//以下接口主要为解决数据相关建立，详细阅读P113相关内容
    input wire I_FromEX_wreg,//处于执行阶段的指令是否要写目的寄存器
    input wire [31:0] I_FromEX_wreg_addr,//处于执行阶段的指令要写目的寄存器地址
    input wire [31:0] I_FromEX_wreg_data,//处于执行阶段的指令写目的寄存器数据
    input wire [7:0] I_FromEX_aluop, //处于执行阶段指令的运算子类型
    input wire I_FromMEM_wreg,//处于访存阶段的指令是否要写目的寄存器
    input wire [31:0] I_FromMEM_wreg_addr,//处于访存阶段的指令要写目的寄存器地址
    input wire [31:0] I_FromMEM_wreg_data,//处于访存阶段的指令写目的寄存器数据
//跳转指令延迟槽信号
    input wire I_FromIDEX_isindelayslot,//当前译码指令是否处于延迟槽
    output reg O_ToIDEX_isindelayslot,//当前译码指令是否处于延迟槽  修改为reg类型
    output reg O_ToPC_branchflag,//跳转信号
    output reg [31:0] O_ToPC_branch_taraddr,//跳转目的地址
//多周期指令流水停止请求信号
    output wire stallreq, //修改为wire类型
    output wire [31:0] O_ToIDEX_ins_addr,//指令地址
    output reg O_ToIDEX_next_isindelayslot,
//新增变量
    output wire[31:0] O_ToIDEX_ins,//当前处于译码阶段的指令
    output wire[31:0] O_ToIDEX_current_inst_address //译码阶段指令的地址
);


//取得指令的指令码，功能码
  wire[5:0] ID_op_local = I_FromIFID_ins[31:26];
  wire[4:0] ID_op2_local = I_FromIFID_ins[10:6];
  wire[5:0] ID_op3_local = I_FromIFID_ins[5:0];
  wire[4:0] ID_op4_local = I_FromIFID_ins[20:16];
  
  //保存指令执行需要的立即数
  reg[31:0]	ID_imm_local;
  
  //指令是否有效
  reg ID_instvalid_local;
  wire[31:0] ID_pc_plus_8_local;
  wire[31:0] ID_pc_plus_4_local;
  wire[31:0] ID_imm_sll2_signedext_local;  

  reg ID_stallreq_for_reg1_loadrelate_local;
  reg ID_stallreq_for_reg2_loadrelate_local;
  wire ID_pre_inst_is_load_local;
  reg ID_excepttype_is_syscall_local;
  reg ID_excepttype_is_eret_local;
  
  assign ID_pc_plus_8_local = I_FromIFID_pc + 2;//保存当前译码阶段指令后面第二条指令的地址
  assign ID_pc_plus_4_local = I_FromIFID_pc +1;//保存当前译码阶段指令后面紧接着指令的地址
  assign ID_imm_sll2_signedext_local = {{14{I_FromIFID_ins[15]}}, I_FromIFID_ins[15:0], 2'b00 };  
  assign stallreq = ID_stallreq_for_reg1_loadrelate_local | ID_stallreq_for_reg2_loadrelate_local;
  //根据输入信号的值，判断上一条指令是不是加载指令，如果是，至ID_pre_inst_is_load_local为1
  assign ID_pre_inst_is_load_local = ((I_FromEX_aluop ==  8'b11100000) || (I_FromEX_aluop == 8'b11100100)||(I_FromEX_aluop == 8'b11100001) ||(I_FromEX_aluop == 8'b11100101)||(I_FromEX_aluop == 8'b11100011) ||(I_FromEX_aluop == 8'b11100110)||(I_FromEX_aluop == 8'b11100010)||(I_FromEX_aluop == 8'b11110000) ||(I_FromEX_aluop == 8'b11111000)) ? 1'b1 : 1'b0;
  assign O_ToIDEX_ins = I_FromIFID_ins;

  //exceptiontype的低8bit留给外部中断，第9bit表示是否是syscall指令
  //第10bit表示是否是无效指令，第11bit表示是否是trap指令
  //assign O_ToIDEX_excepttype = {19'b0,ID_excepttype_is_eret_local,2'b0,ID_instvalid_local, ID_excepttype_is_syscall_local,8'b0};
  
  //输入信号pci就是当前处于译码阶段的指令的地址
  assign O_ToIDEX_current_inst_address = I_FromIFID_pc;
    
    //对指令进行译码
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
			O_ToIDEX_wreg_addr<= I_FromIFID_ins[15:11];//默认目的寄存器
			O_ToIDEX_wreg <= 1'b0;
			ID_instvalid_local <= 1'b1;	   
			O_ToRF_reg1 <= 1'b0;
			O_ToRF_reg2 <= 1'b0;
			O_ToRF_reg1_addr <= I_FromIFID_ins[25:21];//regfile读端口1读取的寄存器地址
			O_ToRF_reg2_addr <= I_FromIFID_ins[20:16];//regfile读端口2读取的寄存器地址
			ID_imm_local <= 32'h00000000;
			//O_ToIDEX_link_addr <= 32'h00000000;
			O_ToPC_branch_taraddr <= 32'h00000000;
			O_ToPC_branchflag <= 1'b0;	
			O_ToIDEX_next_isindelayslot <= 1'b0;
			ID_excepttype_is_syscall_local <= 1'b0;	
			ID_excepttype_is_eret_local <= 1'b0;		
			
		//判断指令			 			
		  case (ID_op_local)
		    6'b000000:		begin
		    	case (ID_op2_local)
		    		5'b00000:			begin
		    			case (ID_op3_local)
		    				6'b100101:	begin//or
		    					O_ToIDEX_wreg <= 1'b1;		//将结果写入目的寄存器
		    					O_ToIDEX_aluop <= 8'b00100101;   //运算子类型
		  						O_ToIDEX_alusel <= 3'b001; 	//运算类型
		  						O_ToRF_reg1 <= 1'b1;	//通过regfile的读端口1读寄存器
		  						O_ToRF_reg2 <= 1'b1;    //通过regfile的读端口2读寄存器
		  						ID_instvalid_local <= 1'b0;	//是否有效
								end  
								//以下和上述类似不再赘述
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
	
	
	
//确定进行运算的源操作数1
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
			O_ToIDEX_reg1 <= I_FromRF_reg1_data; //regfile读端口1的值
		end else if(O_ToRF_reg1 == 1'b0) begin
			O_ToIDEX_reg1 <= ID_imm_local;//立即数
		end else begin
			O_ToIDEX_reg1 <= 32'h00000000;
		end
	end
	
	
//确定进行运算的源操作数2(同上操作)
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

    //是否延迟槽指令
	always @ (*) begin
		if(rst == 1'b0) begin     O_ToIDEX_isindelayslot <= 1'b0;
		end else begin            O_ToIDEX_isindelayslot <= I_FromIDEX_isindelayslot;		
	  end
	end

endmodule
