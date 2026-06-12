module riscv_32i_pipelined (
	input logic clk,
	input logic rst
);



pc pc_inst (
	input logic clk,
	input logic rst,
	input logic [31:0] pc_next,
	
	output logic [31:0] pc_out
);

instr_decode instr_decode_inst (
	input logic [31:0] instr,
	
	output logic [6:0] opcode,
	output logic [4:0] rd,
	output logic [2:0] funct3,
	output logic [4:0] rs1,
	output logic [4:0] rs2,
	output logic [6:0] funct7
);

imm_gen imm_gen_inst (
	input logic [6:0] opcode,
	input logic [31:0] instr,
	
	output logic [31:0] imm_out
);


data_mem data_mem_inst (
	input logic clk,
	input logic mem_write,
	input logic mem_read,
	input logic [31:0] addr,
	input logic [31:0] write_data,
	
	output logic [31:0] read_data
);

instr_mem instr_mem_inst (
	input logic [31:0] addr,
	
	output logic [31:0] instr
);


reg_file reg_file_inst (
	input logic clk,
	input logic [4:0] rs1_addr,
	input logic [4:0] rs2_addr,
	input logic [4:0] rd_addr,
	input logic [31:0] rd_data,
	input logic reg_write,
	
	output logic [31:0] rs1_data,
	output logic [31:0] rs2_data
);

control_unit control_unit_inst (	
	input logic [6:0] opcode,
	input logic [2:0] funct3,
	input logic [6:0] funct7,
	
	output logic [3:0] alu_op,
	output logic alu_src,
	output logic mem_write,
	output logic mem_read,
	output logic reg_write,
	output logic jump,
	output logic branch
);

alu alu_inst (
	input logic [31:0] a,
	input logic [31:0] b,
	input logic [3:0] alu_op,
	
	output logic [31:0] alu_result
);


endmodule
