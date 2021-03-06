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
    input wire [2:0] I_FromIDEX_alusel,//执行阶段要运算指令的类型
    input wire [7:0] I_FromIDEX_aluop,//执行阶段要运算指令的子类型
    input wire [31:0] I_FromIDEX_reg1,//参与运算的源操作数一
    input wire [31:0] I_FromIDEX_reg2,//参与运算的源操作数二
    input wire I_FromIDEX_wreg,//指令执行是否 要写入目的寄存器
    input wire [4:0]I_FromIDEX_wreg_addr,//指令执行要写入的目的寄存器地址
    input wire [31:0] I_FromIDEX_ins,//执行阶段指令
    input wire [31:0] I_FromIDEX_ins_addr,//执行阶段指令地址
    output reg [31:0] O_ToEXMEM_reg2,//存储指令要存储的数据，或者lwr指令要写入的目的寄存器原始值
//    output reg O_ToEXMEM_wreg,//执行阶段指令是否最终要写入目的寄存器
//    output reg [31:0] O_ToEXMEM_wreg_addr,//执行阶段指令最终要写入目的寄存器地址
//    output reg [31:0] O_ToEXMEM_wreg_data,//执行阶段指令最终要写入目的寄存器的值
//HILO模块量
    input wire [31:0] I_FromHILO_hi,//hilo中hi的值
    input wire [31:0] I_FromHILO_lo,//hilo中lo的值
//mem阶段与hilo的交互变量
    input wire I_FromMEM_whilo,//访存阶段指令是否需要写HILO寄存器
    input wire [31:0] I_FromMEM_wb_hi,//访存阶段写回HILO的hi的值
    input wire [31:0] I_FromMEM_wb_lo,//访存阶段写回HILO的lo的值
//memwb阶段与hilo的交互变量
    input wire I_FromMEMWB_whilo,//回写阶段指令是否需要写HILO寄存器
    input wire [31:0] I_FromMEMWB_wb_hi,//回写阶段写回HILO的hi的值
    input wire [31:0] I_FromMEMWB_wb_lo,//回写阶段写回HILO的lo的值
//涉及乘法计算的量
    input wire [63:0] I_FromEXMEM_hilo_temp,//第一个执行周期得到的乘法结果
    input wire [1:0] I_FromEXMEM_cnt,//D当前处于执行阶段的第几个周期
    output wire [63:0] O_ToEXMEM_hilo_temp,//第一个执行周期得到的乘法结果
    output wire [1:0] O_ToEXMEM_cnt,//下一个时钟周期处于执行阶段的第几个始终周期
//涉及除法计算的量
    input wire I_FromDIV_divready,//除法运算是否结束
    input wire [63:0] I_FromDIV_divres,//除法运算结果
    output reg O_ToDIV_signediv,//是否为有符号除法1-->有符号，0->无符号
    output reg O_ToDIV_opdata1,//被除数
    output reg O_ToDIV_opdata2,//除数
    output reg O_ToDIV_divstart,//除法是否开始
//延迟槽相关变量
    input wire I_FromIDEX_isindelayslot,//延迟槽标记
    output wire O_TOEXMEM_isindelayslot,//延迟槽标记
//与访存，ID相关的接口
    output reg [31:0]O_To_EXMEM_mem_addr,//加载存储指令对应的存储器地址
    output reg O_To_ID_EXMEM_wreg,//执行阶段指令最终是否有要写入目的寄存器
    output reg [7:0] O_To_ID_EXMEM_aluop,//执行阶段指令进行的运算子类型
    output reg [4:0] O_To_ID_EXMEM_wreg_addr,//加载存储指令对应的存储器地址
    output reg [31:0] O_To_ID_EXMEM_wreg_data,//存储指令要存储的数据，以及加载到目的寄存器的原始值

//流水暂停请求
    output reg stallreq//请求流水暂停
);

	/** 计算层 **/

	// logic  TODO: ori andi xori
	reg[31:0] logic_out;
	always @(*) begin
		if(rst == 1'b0) begin
			logic_out <= 32'h00000000;
		end else begin
			case (I_FromIDEX_aluop)
				8'b00100101: begin 	//or
					logic_out <= I_FromIDEX_reg1 | I_FromIDEX_reg2;
				end
				8'b00100100: begin  //and
					logic_out <= I_FromIDEX_reg1 & I_FromIDEX_reg2;
				end
				8'b00100110: begin  //xor
					logic_out <= I_FromIDEX_reg1 ^ I_FromIDEX_reg2;
				end
				8'b00100111: begin  //nor
					logic_out <= ~(I_FromIDEX_reg1 | I_FromIDEX_reg2);
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
		if(rst == 1'b0) begin
			shift_out <= 32'h00000000;
		end else begin
			case (I_FromIDEX_aluop)
				8'b01111100: begin  //sll
					shift_out <=  I_FromIDEX_reg2 << I_FromIDEX_reg1[4:0];
				end
				8'b00000010: begin //srl
					shift_out <=  I_FromIDEX_reg2 >> I_FromIDEX_reg1[4:0];
				end
				8'b00000011: begin //sra,srav
					shift_out <= ({32{I_FromIDEX_reg2[31]}} << (6'd32-{1'b0,I_FromIDEX_reg1[4:0]}))| I_FromIDEX_reg2 >> I_FromIDEX_reg1[4:0];
				end

				default: begin
					shift_out <= 32'h00000000;
				end
			endcase
		end
	end

	// exe arithmetic 
	reg [31:0]arithmetic_out;
	wire [31:0]switch_complement_reg2;	//根据符号取补码
	wire [31:0]mux_sum;
	wire [31:0]mux_lt;
	assign switch_complement_reg2 = (I_FromIDEX_aluop == 8'b00100010) || 
								 (I_FromIDEX_aluop == 8'b00100011) ?
								  ~(I_FromIDEX_reg2)+1 :I_FromIDEX_reg2;
	assign mux_sum = I_FromIDEX_reg1 + switch_complement_reg2;
	// assign mux_lt = ((I_FromIDEX_aluop == 8'b00101010)) ?
	// 				((I_FromIDEX_reg1[31] && !I_FromIDEX_reg2[31]) ||
	// 				(!I_FromIDEX_reg1[31] && !I_FromIDEX_reg2[31] && mux_sum[31]) ||
	// 				(I_FromIDEX_reg1[31] && I_FromIDEX_reg2[31] && mux_sum[31]))
	// 				: (I_FromIDEX_reg1 < I_FromIDEX_reg2);
	assign mux_lt = I_FromIDEX_reg1 < I_FromIDEX_reg2;
	always @ (*) begin
		if(rst == 1'b0) begin
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
				8'b00101010,8'b00101011,8'b00101010,8'b00101011: begin //slt,sltu,slti,sltiu
					arithmetic_out <= mux_lt;
				end
				// 8'b00101011: begin //sltu
				// 	arithmetic_out <= mux_slt;
				// end
				default: begin
					arithmetic_out <= 32'h00000000;
				end
			endcase
		end
	end
	
	// mul
	reg[31:0] mul_out;
	wire switch_mult_reg1;	//处理负数
	wire switch_mult_reg2;	//处理负数
	wire mux_mul;
	assign switch_mult_reg1 = (((I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011001)) &&
							  ( I_FromIDEX_reg1[31] == 1'b1)) ? 
							  (~I_FromIDEX_reg1+1) : I_FromIDEX_reg1;
	assign switch_mult_reg2 = (((I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011000) || 
							  (I_FromIDEX_aluop == 8'b00011001)) &&
							  ( I_FromIDEX_reg2[31] == 1'b1)) ? 
							  (~I_FromIDEX_reg2+1) : I_FromIDEX_reg2;
	assign mux_mul = I_FromIDEX_reg1 * I_FromIDEX_reg2;
	always @ (*) begin
		if(rst==1'b1) begin
			mul_out <= 32'h00000000;
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
	// TODO: 除法的实现，需要其它模块的支持？！
	// reg [31:0]div_out;
	// always @ (*) begin
	// 	// TODO: 流水线暂停
	// 	if(rst == 1'b0) begin
	// 		div_out <= 32'h00000000;
	// 	end else begin
	// 		case(I_FromIDEX_aluop)
	// 			8'b00011010: begin //div		
	// 			end
	// 			8'b00011011: begin //divu
	// 			end
	// 	end
	// end

	//movn movz
	reg[31:0] movers;
	always @ (*) begin
		if(rst == 1'b0) begin
			movers <= 32'h00000000;
		end else begin
			case (I_FromIDEX_aluop)
			8'b00001011: begin //movn
				movers <= I_FromIDEX_reg1;
			end
			8'b00001010: begin //movz
				movers <= I_FromIDEX_reg1;
			end
			default : begin
				movers <= 32'h00000000;
			end
			endcase
		end
	end

	//j jal jr

	/** 输出层 **/
	assign O_ToEXMEM_hilo_temp = mux_mul;		//第一个执行周期的乘法结果
	assign O_ToEXMEM_cnt = 2'b00;				//下一个时钟周期处于执行阶段的第几个始终周期
	assign O_TOEXMEM_isindelayslot = I_FromIDEX_isindelayslot;	//延迟槽标记
	always @ (*) begin
		O_ToEXMEM_reg2 <= I_FromIDEX_reg2;	//lw、sw存取的数据
		O_To_EXMEM_mem_addr <= I_FromIDEX_reg1 + {{16{I_FromIDEX_ins[15]}},I_FromIDEX_ins[15:0]};	//加载存储指令对应的存储器地址
		O_To_ID_EXMEM_wreg <= I_FromIDEX_wreg;		//执行阶段指令最终是否有要写入目的寄存器
		O_To_ID_EXMEM_aluop <= I_FromIDEX_aluop;		//执行的指令类型
		O_To_ID_EXMEM_wreg_addr <= I_FromIDEX_wreg_addr;//目的寄存器地址

		case (I_FromIDEX_alusel)
			3'b001: begin //logic
				O_To_ID_EXMEM_wreg_data <= logic_out;
			end
			3'b010: begin //shift
				O_To_ID_EXMEM_wreg_data <= shift_out;
			end
			3'b100: begin //arithmetic
				O_To_ID_EXMEM_wreg_data <= arithmetic_out;
			end
			3'b101: begin //mul
				O_To_ID_EXMEM_wreg_data <= mul_out;
			end
			3'b011: begin //movn
				O_To_ID_EXMEM_wreg_data <= movers;
			end
			3'b110: begin //j jal jr
				O_To_ID_EXMEM_wreg_data <= 32'h00000000;
			end
		endcase
	end
	

endmodule
