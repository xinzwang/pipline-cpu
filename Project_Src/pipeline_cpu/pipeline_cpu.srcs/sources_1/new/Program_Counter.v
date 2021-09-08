`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 10:52:24
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    input wire clk,
    input wire rst,
    input wire [5:0] I_FromCL_stall,//
    input wire I_FromCL_flush,//
    input wire [31:0] I_FromCL_newpc,//用于异常处理后的新地址，现阶段不用管
    input wire I_FromID_branchflag,//跳转指令对应的信号，与下述跳转地址绑定
    input wire [31:0] I_FromID_branch_taraddr,//跳转地址
    output reg [31:0] O_ToIM_IFID_pc//输出的指令地址
    //output reg ce//pc使能信号
);
//code here,notice comment
//always @(*) begin
//    O_ToIM_IFID_pc <=  32'b0;
//end

always @(posedge clk or negedge rst) begin
    if(rst == 1'b0)begin
        O_ToIM_IFID_pc = -32'h4;
    end else if(I_FromCL_flush == 1'b1) begin
        O_ToIM_IFID_pc <= I_FromCL_newpc;
    end else if(I_FromCL_stall[0] == 1'b0) begin
        if (I_FromID_branchflag == 1'b1) begin
            O_ToIM_IFID_pc <= I_FromID_branch_taraddr;
        end else begin
            O_ToIM_IFID_pc <= O_ToIM_IFID_pc  + 1;
        end
    end else begin
        // 流水线暂停  PC维持不变
        // pc <= pc + 4;
    end
end

endmodule
