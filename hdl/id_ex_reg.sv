module id_ex_reg (
	input logic clk,
	input logic rst,
	
	// instruction decoder
	input logic [6:0] opcode,
	input logic [2:0] funct3,
	input logic [6:0] funct7
	// register file
	input logic [4:0] rd,
	input logic [4:0] rs1,
	input logic [4:0] rs2,

	// immediate generator
	
	// control unit






	output logic [6:0] id_ex_opcode,
	output logic [4:0] id_ex_rd,
	output logic [2:0] id_ex_funct3,
	output logic [4:0] id_ex_rs1,
	output logic [4:0] id_ex_rs2,
	output logic [6:0] id_ex_funct7
	
);



always_ff @(posedge clk) begin
	if (rst) begin
		id_ex_opcode	<=	'0;
		id_ex_rd		<=	'0;
		id_ex_funct3	<= 	'0;
		id_ex_rs1 		<= 	'0;
		id_ex_rs2 		<= 	'0;
		id_ex_funct7 	<= 	'0;
	end
	else begin
		id_ex_opcode	<=	opcode;
		id_ex_rd		<=	rd;
		id_ex_funct3	<= 	funct3;
		id_ex_rs1 		<= 	rs1;
		id_ex_rs2 		<= 	rs2;
		id_ex_funct7 	<= 	funct7;
	end
end


endmodule
