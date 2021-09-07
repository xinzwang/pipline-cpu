`timescale 1ns / 1ps

module Register_File(
	input	wire		clk,
	input   wire	    rst,

	
	input wire			I_FromMEM_WB_we,
	input wire[4:0]		I_FromMEM_WB_waddr,
	input wire[31:0]	I_FromMEM_WB_wdata,
	
	
	input wire			I_FromID_re1,
	input wire[4:0]		I_FromID_raddr1,
	output reg[31:0]    O_ToID_rdata1,
	
	
	input wire			I_FromID_re2,
	input wire[4:0]	    I_FromID_raddr2,
	output reg[31:0]    O_ToID_rdata2
);

	reg[31:0]  RF_regs_local[0:31];
	
	always @(negedge rst) begin
	   if(!rst)
	       for(integer i=0;i<32;i=i+1)
	           RF_regs_local[i]<=32'b0;
	end

	always @ (posedge clk) begin
		if (rst == 1'b1) begin
			if((I_FromMEM_WB_we == 1'b1) && (I_FromMEM_WB_waddr != 5'h0)) begin
				RF_regs_local[I_FromMEM_WB_waddr] <= I_FromMEM_WB_wdata;
			end
		end
	end

	always @ (*) begin
		if(rst == 1'b0) begin
			  O_ToID_rdata1 <= 32'h00000000;
	  end else if(I_FromID_raddr1 == 5'h0) begin
	  		O_ToID_rdata1 <= 32'h00000000;
	  end else if((I_FromID_raddr1 == I_FromMEM_WB_waddr) && (I_FromMEM_WB_we == 1'b1) 
	  	            && (I_FromID_re1 == 1'b1)) begin
	  	  O_ToID_rdata1 <= I_FromMEM_WB_wdata;
	  end else if(I_FromID_re1 == 1'b1) begin
	      O_ToID_rdata1 <= RF_regs_local[I_FromID_raddr1];
	  end else begin
	      O_ToID_rdata1 <= 32'h00000000;
	  end
	end



	always @ (*) begin
		if(rst == 1'b0) begin
			  O_ToID_rdata2 <= 32'h00000000;
	  end else if(I_FromID_raddr2 == 5'h0) begin
	  		O_ToID_rdata2 <= 32'h00000000;
	  end else if((I_FromID_raddr2 == I_FromMEM_WB_waddr) && (I_FromMEM_WB_we == 1'b1) 
	  	            && (I_FromID_re2 == 1'b1)) begin
	  	  O_ToID_rdata2 <= I_FromMEM_WB_wdata;
	  end else if(I_FromID_re2 == 1'b1) begin
	      O_ToID_rdata2 <= RF_regs_local[I_FromID_raddr2];
	  end else begin
	      O_ToID_rdata2 <= 32'h00000000;
	  end
	end

endmodule

