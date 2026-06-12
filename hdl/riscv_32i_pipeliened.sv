module riscv_32i_pipelined (
	input logic clk,
	input logic rst
);

/////////////////////////////////////////////////////////////////////////////
// program counter
/////////////////////////////////////////////////////////////////////////////
logic [31:0] pc_next;
logic [31:0] pc_out;

pc pc_inst (
	.clk(clk),
	.rst(rst),
	.pc_next(pc_next),
	
	.pc_out(pc_out)
);


/////////////////////////////////////////////////////////////////////////////
// instruction fetch
/////////////////////////////////////////////////////////////////////////////
logic [31:0] instr;

instr_mem instr_mem_inst (
	.addr(pc_out),
	
	.instr(instr)
);

//////////////////////////////////////////////////////////////////////////////
// IFID stage
//////////////////////////////////////////////////////////////////////////////
logic [31:0] pc4;
logic [31:0] if_id_pc;
logic [31:0] if_id_pc4;
logic [31:0] if_id_instr;

assign pc4 = pc_out + 32'd4;
assign pc_next = pc4;

if_id_reg if_id_reg_inst (
	.clk(clk),
	.rst(rst),
	
	.pc(pc_out),
	.pc4(pc4),
	.instr(instr),
	
	.if_id_pc(if_id_pc),
	.if_id_pc4(if_id_pc4),
	.if_id_instr(if_id_instr)
);

/////////////////////////////////////////////////////////////////////////////
// instruction decode
/////////////////////////////////////////////////////////////////////////////

logic [6:0] opcode;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;


instr_decode instr_decode_inst (
	.instr(if_id_instr),
	
	.opcode(opcode),
	.rd(rd),
	.funct3(funct3),
	.rs1(rs1),
	.rs2(rs2),
	.funct7(funct7)
);

/////////////////////////////////////////////////////////////////////////////
// immediate generator
/////////////////////////////////////////////////////////////////////////////
logic [31:0] imm_out;

imm_gen imm_gen_inst (
	.opcode(opcode),
	.instr(if_id_instr),
	
	.imm_out(imm_out)
);

/////////////////////////////////////////////////////////////////////////////
// data memory operations
/////////////////////////////////////////////////////////////////////////////
logic mem_write;
logic mem_read;
logic [31:0] read_data;

/*
data_mem data_mem_inst (
	.clk(clk),
	.mem_write(mem_write),
	.mem_read(mem_read),
	.addr(alu_result),
	.write_data(rs2_data),
	
	.read_data(read_data)
);

*/

/////////////////////////////////////////////////////////////////////////////
// register file controlling
/////////////////////////////////////////////////////////////////////////////
logic [31:0] rs1_data;
logic [31:0] rs2_data;
logic [31:0] writeback_data;

logic reg_write;

reg_file reg_file_inst (
	.clk(clk),
	.rs1_addr(rs1),
	.rs2_addr(rs2),
	.rd_addr(id_ex_rd),
	.rd_data(writeback_data),
	.reg_write(id_ex_reg_write),
	
	.rs1_data(rs1_data),
	.rs2_data(rs2_data)
);


/////////////////////////////////////////////////////////////////////////////
// IDEX stage
/////////////////////////////////////////////////////////////////////////////
logic alu_src;
logic [3:0] alu_op;
logic jump;
logic branch;

logic [31:0] id_ex_rs1_data;
logic [31:0] id_ex_rs2_data;
logic [31:0] id_ex_imm;
logic [4:0] id_ex_rd;
logic id_ex_reg_write;
logic id_ex_alu_src;
logic [3:0] id_ex_alu_op;

id_ex_reg id_ex_reg_inst (
	.clk(clk),
	.rst(rst),
	
	.rs1_data(rs1_data),
	.rs2_data(rs2_data),

	.imm(imm_out),
	.rd(rd),
	
	.reg_write(reg_write),
	.alu_src(alu_src),
	.alu_op(alu_op),


	.id_ex_rs1_data(id_ex_rs1_data),
	.id_ex_rs2_data(id_ex_rs2_data),
	.id_ex_imm(id_ex_imm),
	.id_ex_rd(id_ex_rd),
	.id_ex_reg_write(id_ex_reg_write),
	.id_ex_alu_src(id_ex_alu_src),
	.id_ex_alu_op(id_ex_alu_op)
);




/////////////////////////////////////////////////////////////////////////////
// control unit operations
/////////////////////////////////////////////////////////////////////////////


control_unit control_unit_inst (	
	.opcode(opcode),
	.funct3(funct3),
	.funct7(funct7),
	
	.alu_op(alu_op),
	.alu_src(alu_src),
	.mem_write(mem_write),
	.mem_read(mem_read),
	.reg_write(reg_write),
	.jump(jump),
	.branch(branch)
);




/////////////////////////////////////////////////////////////////////////////
// ALU operations
/////////////////////////////////////////////////////////////////////////////
logic [31:0] alu_a;
logic [31:0] alu_b;
logic [31:0] alu_result;


assign alu_a = id_ex_rs1_data;
assign alu_b = (id_ex_alu_src) ? id_ex_imm: id_ex_rs2_data;

alu alu_inst (
	.a(alu_a),
	.b(alu_b),
	.alu_op(id_ex_alu_op),
	
	.alu_result(alu_result)
);



assign writeback_data = alu_result;



endmodule
