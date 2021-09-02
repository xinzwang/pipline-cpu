`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/01 09:40:06
// Design Name: 
// Module Name: TOP_CPU
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
//流水线顶层模块
//顶层模块定义规范，[信号发出模块名]_[信号接收模块名]_[信号描述]

module TOP_CPU(
    input clk,
    input rst
);
//pc相关引线
wire CL_PC_stall;//ctrl发回的暂停信号
wire [31:0] CL_PC_newpc;//Ctrll用于异常后新pc的信号
wire ID_PC_branchflag;//ID发出的跳转信号
wire [31:0] ID_PC_branch_taraddr;//Id跳转的目的地址
wire [31:0] PC_OUT_1;//多路引线定义
//IM相关引线
wire [31:0] PC_IM_addr;//pc传入的取指地址
//IFID相关引线
wire CL_IFID_stall;//ctrl发回的暂停信号
wire [31:0] PC_IFID_pc;//pc中的地址
wire [31:0] IM_IFID_ins;//im中的指令
//ID相关引线
wire [31:0] IFID_ID_pc;//传入id的pc值
wire [31:0] IFID_ID_ins;//传入pc的ins值
wire [7:0] EX_ID_aluop;//译码阶段要进行的运算子类型
wire EX_ID_wreg;//执行阶段指令是否最终要写目的寄存器
wire [31:0] EX_ID_wreg_addr;//加载存储指令对应的存储器地址
wire [31:0] EX_ID_wreg_data;//执行阶段指令最终要写入目的寄存器的值
wire MEM_ID_wreg;//执行阶段指令是否要写目的寄存器
wire [31:0] MEM_ID_wreg_addr;//执行阶段指令要写目的寄存器地址
wire [31:0] MEM_ID_wreg_data;//执行阶段指令要写目的寄存器数据
wire IDEX_ID_isindelayslot;//处在延迟槽中
wire [31:0] RF_ID_reg1_data;//寄存器读出值一
wire [31:0] RF_ID_reg2_data;//寄存器读出值二
//寄存器堆栈相关引线
wire [4:0] ID_RF_reg1_addr;//读地址
wire [4:0] ID_RF_reg2_addr;//读地址
wire ID_RF_reg1;//读使能
wire ID_RF_reg2;//读使能
wire MEMWB_RF_wreg;//写使能
wire [4:0] MEMWB_RF_wreg_addr;//写地址
wire [31:0] MEMWB_RF_wreg_data;//写数据
//IDEX相关引线
wire CL_IDEX_stall;//暂停信号
wire [7:0] ID_IDEX_aluop;//译码操作符子类型
wire [2:0] ID_IDEX_alusel;//译码操作符类型
wire [31:0] ID_IDEX_reg1;//译码阶段要进行运算的原操作数一
wire [31:0] ID_IDEX_reg2;//译码阶段要进行运算的原操作数二
wire ID_IDEX_wreg;//译码阶段指令是否写目的寄存器地址
wire [4:0] ID_IDEX_wreg_addr;//译码阶段指令写目的寄存器地址
wire [31:0] ID_IDEX_ins;//译码阶段指令
wire [31:0] ID_IDEX_ins_addr;//指令地址
wire ID_IDEX_isindelaysolt;//延迟槽标志
wire ID_IDEX_next_isindelaysolt;//延迟槽标志

//EX相关引线
wire [7:0] IDEX_EX_aluop;//译码操作符子类型
wire [2:0] IDEX_EX_alusel;//译码操作符类型
wire [31:0] IDEX_EX_reg1_data;//原操作数一
wire [31:0] IDEX_EX_reg2_data;//原操作数二
wire IDEX_EX_wreg;//指令执行是否要写入目的寄存器
wire [4:0] IDEX_EX_wreg_addr;//写入目的寄存器地址
wire [31:0] IDEX_EX_ins;//执行阶段指令
wire [31:0] IDEX_EX_ins_addr;//执行阶段指令地址
wire IDEX_EX_isindelayslot;//执行阶段指令在延迟槽
wire [31:0] HILO_EX_hi;
wire [31:0] HILO_EX_lo;
wire [31:0] MEMWB_EX_hi;
wire [31:0] MEMWB_EX_lo;
wire MEMWB_EX_whilo;//处于回写阶段的指令是否要写HILO寄存器
wire [31:0] MEM_EX_hi;
wire [31:0] MEM_EX_lo;
wire MEM_EX_whilo;//处于访存阶段的指令是否要写HILO寄存器
//EX与除法相关指令
wire EXMEM_EX_hilo_temp;
wire EXMEM_EX_cnt;
wire EXMEM_EX_;
wire DIV_EX_div_res;//除法结果
wire DIV_EX_ready;//除法完成
//EXMEM模块引线
wire CL_EXMEM_stall;//暂停
wire CL_EXMEM_flush;//清除
wire EX_EXMEM_mem_addr;//执行阶段加载，存储指令对应的存储器地址
wire EX_EXMEM_reg2;//执行阶段存储指令要存储的数据，或lwl指令要写入的目的寄存器原始值
wire EX_EXMEM_hi;//执行阶段要写入hi寄存器的值
wire EX_EXMEM_lo;
wire EX_EXMEM_whilo;//执行阶段指令是否要写hilo寄存器
wire EX_EXMEM_hilo;//保存乘法的结果
wire EX_EXMEM_cnt;//下一阶段时钟周期处于执行阶段第几周期
wire EX_EXMEM_isindelaysolt;//访存阶段是否是延迟槽指令
wire EX_EXMEM_ins_addr;//访存阶段指令地址
wire EX_EXMEM_aluop;//执行阶段指令要进行的运算符子类型
wire EX_EXMEM_wreg;//执行阶段指令是否要写目的寄存器
wire EX_EXMEM_wreg_addr;//执行阶段指令要写目的寄存器地址
wire EX_EXMEM_wreg_data;//执行阶段指令要写目的寄存器值
//MEM模块引线
wire EXMEM_MEM_wreg;//访存阶段指令是否有要写入目的寄存器
wire EXMEM_MEM_wreg_addr;//访存阶段要写入目的寄存器地址
wire EXMEM_MEM_wreg_data;//访存阶段要写入目的寄存器数据
wire EXMEM_MEM_whilo;//访存阶段指令是否要写HILO寄存器
wire EXMEM_MEM_hi;
wire EXMEM_MEM_lo;
wire EXMEM_MEM_aluop;//访存阶段指令要进行的运算子类型
wire EXMEM_MEM_mem_addr;//访问数据存储器地址
wire DM_MEM_mem_data;//从数据存储器读取的数据
wire EXMEM_MEM_reg2;//访存阶段存储指令要存储的数据，或lwl指令要写入的目的寄存器原始值
wire EXMEM_MEM_isindelayslot;//访存阶段是否时延迟槽指令
wire EXMEM_MEM_ins_addr;//访存阶段指令地址
//MEMWB模块引线
wire CL_MEMWB_stall;
wire CL_MEMWB_flush;
wire MEM_MEMWB_mem_wreg;//是否要写目的寄存器
wire MEM_MEMWB_mem_wreg_addr;//写目的寄存器地址
wire MEM_MEMWB_mem_wreg_data;//写目的寄存器数据
wire MEM_MEMWB_mem_whilo;//访存阶段指令是否要写HILO寄存器
wire MEM_MEMWB_mem_hi;//访存阶段指令写HI寄存器值
wire MEM_MEMWB_mem_lo;//访存阶段指令写LO寄存器值
//HILO模块引线
wire MEMWB_HILO_we;//HILO写使能信号
wire MEMWB_HILO_hi;//HILO写hi
wire MEMWB_HILO_lo;//HILO写lo
//CL模块引线
wire stallreq_from_EX;
wire stallreq_from_ID;
//以上就是定义的全部模块输入的引线下面进行模块定义
Program_Counter PC_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromCL_stall(CL_PC_stall),//用于乘除法多周期流水延迟的信号量
    .I_FromCL_newpc(CL_PC_newpc),//用于异常处理后的新地址，现阶段不用管
    .I_FromID_branchflag(ID_PC_branchflag),//跳转指令对应的信号，与下述跳转地址绑定
    .I_FromID_branch_taraddr(ID_PC_branch_taraddr),//跳转地址
    .O_ToIM_IFID_pc(PC_OUT_1)//输出的指令地址
    //output reg ce//pc使能信号
);
    assign PC_IM_addr=PC_OUT_1;
    assign PC_IFID_pc=PC_OUT_1;
    
Data_Memory DM_cpu(
    .a(PC_IM_addr),
    .spo(IM_IFID_ins)
);

IF_ID IFID_cpu(
    .clk(clk),
    .rst(rst),
    .IF_pc(PC_IFID_pc),
    .IF_ins(IM_IFID_ins),
    .ID_pc(IFID_ID_pc),
    .ID_ins(IFID_ID_ins)
);

Instruction_Decoder ID_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromIFID_pc(IFID_ID_pc),//译码阶段指令对应的地址
    .I_FromIFID_ins(IFID_ID_ins),//译码阶段的指令
//与寄存器堆栈相关操作
    .I_FromRF_reg1_data(RF_ID_reg1_data),//从寄存器堆栈读到的第一个端口输入
    .I_FromRF_reg2_data(RF_ID_reg2_data),//从寄存器堆栈读到的第二个端口输入
    .O_ToRF_reg1(ID_RF_reg1),//寄存器堆栈第一个读端口使能信号
    .O_ToRF_reg2(ID_RF_reg2),//寄存器堆栈第二个读端口使能信号
    .O_ToRF_reg1_addr(ID_RF_reg1_addr),//寄存器堆栈第一个读端口地址
    .O_ToRF_reg2_addr(ID_RF_reg2_addr),//寄存器堆栈第二个读端口地址
    .O_ToIDEX_wreg(ID_IDEX_wreg),//寄存器堆栈写端口使能信号
    .O_ToRF_wreg_addr(ID_IDEX_wreg_addr),//寄存器堆栈写端口地址
    .O_ToIDEX_aluop(ID_IDEX_aluop),//译码阶段要进行的运算子类型
    .O_ToIDEX_alusel(ID_IDEX_alusel),//译码阶段要进行的运算的类型
    .O_ToIDEX_reg1(ID_IDEX_reg1),//译码阶段要进行的运算的原操作数一
    .O_ToIDEX_reg2(ID_IDEX_reg2),//译码阶段要进行的运算的原操作数二
//以下接口主要为解决数据相关建立，详细阅读P113相关内容
    .I_FromEX_wreg(EX_ID_wreg),//处于执行阶段的指令是否要写目的寄存器
    .I_FromEX_wreg_addr(EX_ID_wreg_addr),//处于执行阶段的指令要写目的寄存器地址
    .I_FromEX_wreg_data(EX_ID_wreg_data),//处于执行阶段的指令写目的寄存器数据
    .I_FromMEM_wreg(MEM_ID_wreg),//处于访存阶段的指令是否要写目的寄存器
    .I_FromMEM_wreg_addr(MEM_ID_wreg_addr),//处于访存阶段的指令要写目的寄存器地址
    .I_FromMEM_wreg_data(MEM_ID_wreg_data),//处于访存阶段的指令写目的寄存器数据
//跳转指令延迟槽信号
    .I_FromIDEX_isindelayslot(IDEX_ID_isindelayslot),//当前译码指令是否处于延迟槽
    .O_ToIDEX_isindelayslot(ID_IDEX_next_isindelaysolt),//当前译码指令是否处于延迟槽  修改为reg类型
    .O_ToPC_branchflag(ID_PC_branchflag),//跳转信号
    .O_ToPC_branch_taraddr(ID_PC_branch_taraddr),//跳转目的地址
//多周期指令流水停止请求信号
    .stallreq(stallreq_from_ID), //修改为wire类型
    .O_ToIDEX_ins_addr(ID_IDEX_ins_addr)
//新增变量目前用不到
//    .I_FromEX_aluop_i, //处于执行阶段指令的运算子类型
//    .O_ToIDEX_wd, //译码阶段的指令要写入的目的寄存器地址
//    .O_ToIDEX_link_addr, //转移指令要保存的返回地址
//    .O_ToIDEX_next_isindelayslot, //下一条进入译码阶段的指令是否位于延迟槽
//    .O_ToIDEX_inst, //当前处于译码阶段的指令
//    .O_ToIDEX_excepttype, //收集的异常信息
//    .O_ToIDEX_current_inst_address //译码阶段指令的地址
);

ID_EX IDEX_cpu(
    .clk(clk),
    .rst(rst),
    .ID_alusel(ID_IDEX_alusel),//译码阶段要进行运算的类型
    .ID_aluop(ID_IDEX_aluop),//译码阶段指令要进行运算的子类型
    .ID_reg1(ID_IDEX_reg1),//译码阶段指令要进行运算的源操作数一
    .ID_reg2(ID_IDEX_reg2),//译码阶段指令要进行运算的源操作数二
    .ID_wreg(ID_IDEX_wreg),//译码阶段指令是否要写入目的寄存器
    .ID_wreg_addr(ID_IDEX_wreg_addr),//译码阶段指令要写入的目的寄存器地址
    .ID_ins(ID_IDEX_ins),//来自ID的具体指令值
    .ID_ins_addr(ID_IDEX_ins_addr),//来自ID的具体指令地址
    .ID_isindelayslot(ID_IDEX_isindelaysolt),//延迟槽
    .EX_alusel(IDEX_EX_alusel),//执行阶段要进行运算的类型
    .EX_aluop(IDEX_EX_aluop),//执行阶段要进行运算的子类型
    .EX_reg1(IDEX_EX_reg1_data),//执行阶段指令要进行运算的源操作数一
    .EX_reg2(IDEX_EX_reg2_data),//执行阶段指令要进行运算的源操作数二
    .EX_wreg_addr(IDEX_EX_wreg_addr),//执行阶段指令要写入的目的寄存器地址
    .EX_wreg(IDEX_EX_wreg),//执行阶段指令是否要写入目的寄存器
    .EX_ins(IDEX_EX_wreg_ins),//给ex的具体指令值
    .EX_ins_addr(IDEX_EX_ins_addr),//给EX的具体指令地址
    .EX_isindelayslot(IDEX_EX_isindelayslot)
);

EX EX_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromIDEX_alusel(IDEX_EX_alusel),//执行阶段要运算指令的类型
    .I_FromIDEX_aluop(IDEX_EX_alusel),//执行阶段要运算指令的子类型
    .I_FromIDEX_reg1(IDEX_EX_reg1_data),//参与运算的源操作数一
    .I_FromIDEX_reg2(IDEX_EX_reg2_data),//参与运算的源操作数二
    .I_FromIDEX_wreg(IDEX_EX_wreg),//指令执行是否 要写入目的寄存器
    .I_FromIDEX_wreg_addr(IDEX_EX_wreg_addr),//指令执行要写入的目的寄存器地址
    .I_FromIDEX_ins(IDEX_EX_ins),
    .I_FromIDEX_ins_addr(IDEX_EX_ins_addr),//执行阶段指令地址
    .O_ToEXMEM_reg2(EX_EXMEM_reg2),//存储指令要存储的数据，或者lwr指令要写入的目的寄存器原始值
//HILO模块量
    .I_FromHILO_hi(HILO_EX_hi),//hilo中hi的值
    .I_FromHILO_lo(HILO_EX_lo),//hilo中lo的值
//mem阶段与hilo的交互变量
    .I_FromMEM_whilo(MEM_EX_whilo),//访存阶段指令是否需要写HILO寄存器
    .I_FromMEM_wb_hi(MEM_EX_hi),//访存阶段写回HILO的hi的值
    .I_FromMEM_wb_lo(MEM_EX_lo),//访存阶段写回HILO的lo的值
//memwb阶段与hilo的交互变量
    .I_FromMEMWB_whilo(MEMWB_EX_whilo),//回写阶段指令是否需要写HILO寄存器
    .I_FromMEMWB_wb_hi(MEMWB_EX_hi),//回写阶段写回HILO的hi的值
    .I_FromMEMWB_wb_lo(MEMWB_EX_lo),//回写阶段写回HILO的lo的值
//涉及乘法计算的量
    .I_FromEXMEM_hilo_temp(EXMEM_EX_hilo_temp),//第一个执行周期得到的乘法结果
    .I_FromEXMEM_cnt(EXMEM_EX_cnt),//D当前处于执行阶段的第几个周期
    .O_ToEXMEM_hilo_temp(EX_EXMEM_hilo),//第一个执行周期得到的乘法结果
    .O_ToEXMEM_cnt(EX_EXMEM_cnt),//下一个时钟周期处于执行阶段的第几个始终周期
//涉及除法计算的量
    .I_FromDIV_divready(DIV_EX_ready),//除法运算是否结束
    .I_FromDIV_divres(),//除法运算结果
    .O_ToDIV_signediv(),//是否为有符号除法1-->有符号，0->无符号
    .O_ToDIV_opdata1(),//被除数
    .O_ToDIV_opdata2(),//除数
    .O_ToDIV_divstart(),//除法是否开始
//延迟槽相关变量
    .I_FromIDEX_isindelayslot(IDEX_EX_isindelayslot),//延迟槽标记
    .O_TOEXMEM_isindelayslot(EX_EXMEM_isindelaysolt),//延迟槽标记
//与访存，ID相关的接口
    .O_To_EXMEM_mem_addr(EX_EXMEM_mem_addr),//加载存储指令对应的存储器地址
    .O_To_ID_EXMEM_wreg(EX_OUT_1),//执行阶段指令最终是否有要写入目的寄存器
    .O_To_ID_EXMEM_aluop(EX_OUT_2),//执行阶段指令进行的运算子类型
    .O_To_ID_EXMEM_wreg_addr(EX_OUT_3),//加载存储指令对应的存储器地址
    .O_To_ID_EXMEM_wreg_data(EX_OUT_4),//存储指令要存储的数据，以及加载到目的寄存器的原始值
//流水暂停请求
    .stallreq(stallreq_from_EX)//请求流水暂停
);
    assign EX_EXMEM_aluop=EX_OUT_2;
    assign EX_EXMEM_wreg=EX_OUT_1 ;
    assign EX_EXMEM_wreg_addr=EX_OUT_3 ;
    assign EX_EXMEM_wreg_data=EX_OUT_4 ;
    assign EX_ID_aluop=EX_OUT_2 ;
    assign EX_ID_wreg=EX_OUT_1 ;
    assign EX_ID_wreg_addr=EX_OUT_3 ;
    assign EX_ID_wreg_data=EX_OUT_4 ;
    
EX_MEM EXMEM_cpu(
    .clk(clk),
    .rst(rst),
    .CL_stall(CL_EXMEM_stall),
    .CL_flush(CL_EXMEM_flush),
    .EX_mem_addr(EX_EXMEM_mem_addr),//执行阶段要写的内存地址
    .EX_reg2(EX_EXMEM_reg2),
    .EX_whilo(EX_EXMEM_whilo),
    .EX_hi(EX_EXMEM_hi),
    .EX_lo(EX_EXMEM_lo),
    .EX_hilo(EX_EXMEM_hilo),
    .EX_cnt(EX_EXMEM_cnt),
    .EX_isindelayslot(EX_EXMEM_isindelaysolt),
    .EX_ins_addr(EX_EXMEM_ins_addr),
    .Ex_aluop(EX_EXMEM_aluop),
    .EX_wreg(EX_EXMEM_wreg),//执行阶段指令执行后是否要写入目的寄存器
    .EX_wreg_addr(EX_EXMEM_wreg_addr),//执行阶段指令执行后要写入目的寄存器的地址
    .EX_wreg_data(EX_EXMEM_wreg_data),//执行阶段指令执行后要写入目的寄存器的值
    .MEM_wreg(EXMEM_MEM_wreg),//访存阶段指令执行后是否要写入目的寄存器
    .MEM_wreg_addr(EXMEM_MEM_wreg_addr),//访存阶段指令执行后要写入目的寄存器的地址
    .MEM_wreg_data(EXMEM_MEM_wreg_adta),//访存阶段指令执行后要写入目的寄存器的值
    .MEM_hi(EXMEM_MEM_hi),
    .MEM_lo(EXMEM_MEM_lo),
    .MEM_whilo(EXMEM_MEM_whilo),
    .MEM_aluop(EXMEM_MEM_aluop),
    .MEM_mem_addr(EXMEM_MEM_mem_addr),//写内存地址
    .MEM_reg2(EXMEM_MEM_reg2),
    .MEM_isindelayslot(EXMEM_MEM_isindelayslot),
    .MEM_ins_adddr(EXMEM_MEM_ins_addr),
    .MEM_hilo(EXMEM_EX_hilo_temp),
    .MEM_cnt(EXMEM_EX_cnt) 
);

MEM MEM_cpu(
    .clk(clk),
    .rst(rst),
    .I_FromEXMEM_wreg(EXMEM_MEM_wreg),
    .I_FromEXMEM_wreg_addr(EXMEM_MEM_wreg_addr),
    .I_FromEXMEM_wreg_data(EXMEM_MEM_wreg_data),
    .O_ToMEMWB_wreg(MEM_MEMWB_mem_wreg),
    .O_ToMEMWB_wreg_addr,
    .O_ToMEMWB_wreg_data,?
    .I_FromEXMEM_whilo,
    .I_FromEXMEM_hi,
    .I_FromEXMEM_lo,
    .O_TOMEMWB_whilo,
    .O_TOMEMWB_hi,
    .O_TOMEMWB_lo,
    .I_FromEXMEM_aluop,
    .I_FromEXMEM_mem_addr,
    .I_FromEXMEM_mem_data,
    .I_FromDM_data,
    .O_ToDM_data,
    .O_ToDM_we,
    .O_ToDM_we_data,
    .O_ToDM_sel,
    .I_FromEXMEM_isindelayslot,
    .O_TOMEMWB_isindelayslot

);


















endmodule
