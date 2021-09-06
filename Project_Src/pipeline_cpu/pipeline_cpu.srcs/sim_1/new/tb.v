`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/24 14:58:03
// Design Name: 
// Module Name: testbench
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


module testbench();
reg sys_clk;
reg sys_rst_n;
//时钟信号与复位信号初始化
    initial begin
    sys_clk=0;
    sys_rst_n=0;
    #10
    sys_rst_n=1'b1;
    end
always #10 sys_clk<=~sys_clk;


TOP_CPU pipeline_cpu(
.clk(sys_clk),
.rst(sys_rst_n)
);

endmodule
