module mem_wb_reg (
	input logic clk,
	input logic rst,
	
	input logic [31:0] ex_mem_alu_result,
	input logic [31:0] read_data,
	input logic [4:0] ex_mem_rd,
	input logic ex_mem_reg_write,
	input logic ex_mem_mem_to_reg,
	
	output logic [31:0] mem_wb_alu_result,
	output logic [31:0] mem_wb_read_data,
	output logic [4:0] mem_wb_rd,
	output logic mem_wb_reg_write,
	output logic mem_wb_mem_to_reg
);

always_ff @(posedge clk) begin
	if (rst) begin
		mem_wb_alu_result 	<= '0;
		mem_wb_rd			<= '0;
		mem_wb_reg_write	<= '0;
		mem_wb_read_data	<= '0;
		mem_wb_mem_to_reg	<= '0;
	end
	else begin
		mem_wb_alu_result 	<= ex_mem_alu_result;
		mem_wb_rd			<= ex_mem_rd;
		mem_wb_reg_write	<= ex_mem_reg_write;	
		mem_wb_read_data	<= read_data;	
		mem_wb_mem_to_reg	<= ex_mem_mem_to_reg;	
	end
end


endmodule