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
//占시닸꼬占쏙옙

module MEM(

	input wire										rst,//复位信号
	
	//来自执行阶段的信息	
	input wire[4:0]       I_FROMEX_MEM_wreg,//访存阶段的指令是否有要写入目的寄存器
	input wire                    I_FROMEX_MEM_wd,//访存阶段的指令要写入的目的寄存器地址
	input wire[31:0]					  I_FROMEX_MEM_wdata,//访存阶段的指令要写入目的寄存器的值
	input wire[31:0]           I_FROMEX_MEM_hi,//访存阶段的指令要写入HI寄存器的值
	input wire[31:0]           I_FROMEX_MEM_lo,//访存阶段的指令要写入LO寄存器的值
	input wire                    I_FROMEX_MEM_whilo,	//访存阶段的指令是否要写HI、LO寄存器

  input wire[7:0]        I_FROMEX_MEM_aloup,//访存阶段的指令要进行的运算的子类型
	input wire[31:0]          I_FROMEX_MEM_mem_addr,//访存阶段的加载、存储指令对应的存储器地址
	input wire[31:0]          I_FROMEX_MEM_reg2,//访存阶段的存储指令要存储的数据，或者lwl、lwr指令要写入的目的寄存器的原始值
	
	//来自外部数据存储器RAM的信息
	input wire[31:0]          I_FROMDATA_RAM_mem_data,//从数据存储器读取的数据

	//I_FROMLLbit_Llbit是LLbit寄存器的值
	input wire                  I_FROMLLbit_Llbit,//Llbit模块给出的Llbit寄存器的值
	//但不一定是最新值，回写阶段可能要写LLbit，所以还要进一步判断
	input wire                  I_FROMMEM_WB_wb_LLbit_we,//回写阶段的指令是否要写Llbit寄存器
	input wire                  I_FROMMEM_WB_wb_LLbit_value,//回写阶段的要写入Llbit寄存器的值
	
	//送到回写阶段的信息
	output reg[4:0]      O_TOMEM_WB_wd,//访存阶段的指令最终要写入的目的寄存器地址
	output reg                   O_TOMEM_WB_wreg,//访存阶段的指令最终是否有要写入的目的寄存器
	output reg[31:0]					 O_TOMEM_WB_wdata,//访存阶段的指令最终要写入目的寄存器的值
	output reg[31:0]          O_TOMEM_WB_hi,//访存阶段的指令最终要写入HI寄存器的值
	output reg[31:0]          O_TOMEM_WB_lo,//访存阶段的指令最终要写入LO寄存器的值
	output reg                   O_TOMEM_WB_whilo,//访存阶段的指令最终是否要写HI、LO寄存器的值

	output reg                   O_TOMEM_WB_Llbit_we,//访存阶段的指令是否要写Llbit寄存器
	output reg                   O_TOMEM_WB_Llbit_value,//访存阶段的指令要写入Llbit寄存器的值
	
	//送到回外部数据存储器RAM的信息
	output reg[31:0]          O_TODATA_RAM_mem_addr,//要访问的数据存储器的地址
	output wire					O_TODATA_RAM_mem_we,//是否是写操作，为1表示是写操作
	output reg[3:0]              O_TODATA_RAM_mem_sel,//字节选择信号
	output reg[31:0]          O_TODATA_RAM_mem_data,//要写入数据存储器的数据
	output reg                   O_TODATA_RAM_mem_ce	//数据存储器使能信号
	
);

    reg LLbit;
	wire[31:0] zero32;
	reg                   mem_we;

	assign O_TODATA_RAM_mem_we = mem_we ;//外部数据存储器RAM的读、写信号
	assign zero32 = 32'h00000000;

  //获取最新的LLbit的值
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
				8'b11100000:		begin//lb指令
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;//给出要访问的数据存储器地址，其值就是执行阶段计算出来的地址
					mem_we <= 1'b0;//因为是加载操作，所以设置O_TODATA_RAM_mem_addr的值为1'b0
					O_TODATA_RAM_mem_ce <= 1'b1;//因为要访问数据存储器，所以设置O_TODATA_RAM_mem_ce <= 1'b1
					case (I_FROMEX_MEM_mem_addr[1:0])//根据mem_arrd最后两位，可以确定mem_sel的值，并据此从数据存储器的输入数据I_FROMEX_MEM_mem_data中获得要读取的字节，进行符号扩展
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
				8'b11100100:		begin//lbu指令
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
				8'b11100001:		begin//lh指令
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
				8'b11100101:		begin//lhu指令
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
				8'b11100011:		begin//lw指令
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b0;
					O_TOMEM_WB_wdata <= I_FROMDATA_RAM_mem_data;
					O_TODATA_RAM_mem_sel <= 4'b1111;		
					O_TODATA_RAM_mem_ce <= 1'b1;
				end
				8'b11100010:		begin//lwl指令
					O_TODATA_RAM_mem_addr <= {I_FROMEX_MEM_mem_addr[31:2], 2'b00};//给出要访问的数据存储器地址，其值就是计算出来的地址，但是最后两位要设置为0，因为lwl指令要从RAM中读出一个字，所以需要将地址对齐
					mem_we <= 1'b0;//因为是加载操作，所以设置
					O_TODATA_RAM_mem_sel <= 4'b1111;
					O_TODATA_RAM_mem_ce <= 1'b1;//因为要访问数据存储器，所以设置
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
						end//依据最后两位的值，将从数据存储器读取的数据与目的寄存器的原始值进行组合，得到最终要写入目的寄存器的值。
						default:	begin
							O_TOMEM_WB_wdata <= 32'h00000000;
						end
					endcase				
				end
				8'b11100110:		begin//lwr指令和lwl指令类似
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
				8'b11101000:		begin//sb指令
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;//访问的数据存储器地址就是执行阶段计算出来的地址	
					mem_we <= 1'b1;//因为是存储操作所以设置如此
					O_TODATA_RAM_mem_data <= {I_FROMEX_MEM_reg2[7:0],I_FROMEX_MEM_reg2[7:0],I_FROMEX_MEM_reg2[7:0],I_FROMEX_MEM_reg2[7:0]};
					O_TODATA_RAM_mem_ce <= 1'b1;//因为要访问数据存储器所以设置如此	
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
						end//sb指令要写入的数据是寄存器的最低字节，将该字节复制到mem_data的其余部分，然后依据地址写出最后两位，从而确定mem_sel的值
					endcase				
				end
				8'b11101001:		begin//sh指令类似
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
				8'b11101011:		begin//sw指令与sb类似
					O_TODATA_RAM_mem_addr <= I_FROMEX_MEM_mem_addr;
					mem_we <= 1'b1;
					O_TODATA_RAM_mem_data <= I_FROMEX_MEM_reg2;
					O_TODATA_RAM_mem_sel <= 4'b1111;			
					O_TODATA_RAM_mem_ce <= 1'b1;
				end
				8'b11101010:		begin//swl指令
					O_TODATA_RAM_mem_addr <= {I_FROMEX_MEM_mem_addr[31:2], 2'b00};//给出要访问的数据存储器地址，其值就是执行阶段计算出来的地址。但最后两位要设置0，因为swl指令最多可能需要向数据存储器写入一个字
					mem_we <= 1'b1;//因为是存储操作，所以设置
					O_TODATA_RAM_mem_ce <= 1'b1;//因为访存所以设置
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
				8'b11101110:		begin//swr指令
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
          //什么也不做
				end
			endcase							
		end    //if
	end      //always
endmodule