module id_ex_reg (
	input logic clk,
	input logic rst,

	// operand data
	input logic [31:0] rs1_data,
	input logic [31:0] rs2_data,
	//operand address
	input logic [4:0] rs1,
	input logic [4:0] rs2,

	// immediate generator
	input logic [31:0] imm,
	input logic [4:0] rd,
	
	// control unit
	input logic reg_write,
	input logic alu_src,
	input logic [3:0] alu_op,
	
	input logic mem_read,
	input logic mem_write,
	input logic mem_to_reg,


	output logic [31:0] id_ex_rs1_data,
	output logic [31:0] id_ex_rs2_data,
	output logic [31:0] id_ex_imm,
	output logic [4:0] id_ex_rd,
	output logic id_ex_reg_write,
	output logic id_ex_alu_src,
	output logic [3:0] id_ex_alu_op,
	
	output logic id_ex_mem_read,
	output logic id_ex_mem_write,
	output logic id_ex_mem_to_reg,
	output logic [4:0] id_ex_rs1,
	output logic [4:0] id_ex_rs2
);



always_ff @(posedge clk) begin
	if (rst) begin
		id_ex_rs1_data 	  <= '0;
		id_ex_rs2_data 	  <= '0;
		id_ex_imm	 	  <= '0;
		id_ex_rd 		  <= '0;
		id_ex_reg_write   <= '0;
		id_ex_alu_src 	  <= '0;
		id_ex_alu_op  	  <= '0;
		id_ex_mem_read    <= '0;
        id_ex_mem_write   <= '0;
        id_ex_mem_to_reg  <= '0;
        id_ex_rs1         <= '0;
        id_ex_rs2         <= '0;
		
	end
	else begin
		id_ex_rs1_data 	<= rs1_data;
		id_ex_rs2_data 	<= rs2_data;
		id_ex_imm 	    <= imm;
		id_ex_rd 		<= rd;
		id_ex_reg_write <= reg_write;
		id_ex_alu_src 	<= alu_src;
		id_ex_alu_op  	<= alu_op;
		
		id_ex_mem_read  <= mem_read;
        id_ex_mem_write <= mem_write;
        id_ex_mem_to_reg <= mem_to_reg;
        id_ex_rs1       <= rs1;
        id_ex_rs2       <= rs2;
		
	end
end


endmodule
