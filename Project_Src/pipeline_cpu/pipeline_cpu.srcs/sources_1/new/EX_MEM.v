`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 14:18:18
// Design Name: 
// Module Name: EX_MEM
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
//��ִ�н׶�ȡ�õ�Ԥ����������һ��ʱ�����ڴ��ݵ���ˮ�ߵķô�׶�

module EX_MEM(
    input clk,
    input rst,
    input wire EX_wreg,//ִ�н׶�ָ��ִ�к��Ƿ�Ҫд��Ŀ�ļĴ���
    input wire [4:0] EX_wreg_addr,//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ����ĵ�ַ
    input wire [31:0] EX_wreg_data,//ִ�н׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ
    output reg MEM_wreg,//�ô�׶�ָ��ִ�к��Ƿ�Ҫд��Ŀ�ļĴ���
    output reg [4:0] MEM_wreg_addr,//�ô�׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ����ĵ�ַ
    output reg [31:0] MEM_wreg_data//�ô�׶�ָ��ִ�к�Ҫд��Ŀ�ļĴ�����ֵ
    );
    //ʱ����Ʋ��֣�ÿ��ʱ���������źŴ��͵���������һ��
always @(posedge clk) begin
    if(rst==1'b0) begin
        MEM_wreg<=1'b0;
        MEM_wreg_addr<=5'b0;
        MEM_wreg_data<=32'b0;
    end else begin
        MEM_wreg<=EX_wreg;
        MEM_wreg_addr<=EX_wreg_addr;
        MEM_wreg_data<=EX_wreg_data;
    end
end
endmodule
