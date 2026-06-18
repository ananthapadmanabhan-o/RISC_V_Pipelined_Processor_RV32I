module riscv_32i_pipelined (
    input logic clk,
    input logic rst,

    output logic [31:0] pc_out_debugg
);

/////////////////////////////////////////////////////////////////////////////
// GLOBAL SIGNALS
/////////////////////////////////////////////////////////////////////////////
logic [31:0] pc_out;
logic [31:0] pc_next;

assign pc_out_debugg = pc_out;

/////////////////////////////////////////////////////////////////////////////
// IF STAGE (Instruction Fetch)
/////////////////////////////////////////////////////////////////////////////

// IF stage signals
logic [31:0] instr;
logic [31:0] pc4;

// Program Counter
pc pc_inst (
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .pc_out(pc_out)
);

// Instruction Memory
instr_mem instr_mem_inst (
    .addr(pc_out),
    .instr(instr)
);

// Next PC logic
assign pc4    = pc_out + 32'd4;
assign pc_next = pc4;

/////////////////////////////////////////////////////////////////////////////
// IF/ID PIPELINE REGISTER
/////////////////////////////////////////////////////////////////////////////

logic [31:0] if_id_pc;
logic [31:0] if_id_pc4;
logic [31:0] if_id_instr;

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
// ID STAGE (Instruction Decode)
/////////////////////////////////////////////////////////////////////////////

// Decode signals
logic [6:0] opcode;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;

// Immediate
logic [31:0] imm_out;

// Register File
logic [31:0] rs1_data;
logic [31:0] rs2_data;
logic [31:0] writeback_data;

// Control signals
logic reg_write;
logic alu_src;
logic [3:0] alu_op;
logic mem_read;
logic mem_write;
logic jump;
logic branch;
logic mem_to_reg;

// Instruction Decode
instr_decode instr_decode_inst (
    .instr(if_id_instr),

    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
);

// Immediate Generator
imm_gen imm_gen_inst (
    .opcode(opcode),
    .instr(if_id_instr),

    .imm_out(imm_out)
);

// Control Unit
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
    .branch(branch),
    .mem_to_reg(mem_to_reg)

);

/////////////////////////////////////////////////////////////////////////////
// MEM/WB signals needed by Register File
/////////////////////////////////////////////////////////////////////////////

logic [4:0] mem_wb_rd;
logic mem_wb_reg_write;

// Register File
reg_file reg_file_inst (
    .clk(clk),
    .rs1_addr(rs1),
    .rs2_addr(rs2),

    .rd_addr(mem_wb_rd),
    .rd_data(writeback_data),
    .reg_write(mem_wb_reg_write),

    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

/////////////////////////////////////////////////////////////////////////////
// ID/EX PIPELINE REGISTER
/////////////////////////////////////////////////////////////////////////////

logic [31:0] id_ex_rs1_data;
logic [31:0] id_ex_rs2_data;
logic [31:0] id_ex_imm;

logic [4:0] id_ex_rd;
logic [4:0] id_ex_rs1;
logic [4:0] id_ex_rs2;

logic id_ex_reg_write;
logic id_ex_alu_src;
logic [3:0] id_ex_alu_op;

logic id_ex_mem_read;
logic id_ex_mem_write;
logic id_ex_mem_to_reg;

id_ex_reg id_ex_reg_inst (
    .clk(clk),
    .rst(rst),

    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .rs1(rs1),
    .rs2(rs2),

    .imm(imm_out),
    .rd(rd),

    .reg_write(reg_write),
    .alu_src(alu_src),
    .alu_op(alu_op),

    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),

    .id_ex_rs1_data(id_ex_rs1_data),
    .id_ex_rs2_data(id_ex_rs2_data),
    .id_ex_imm(id_ex_imm),

    .id_ex_rd(id_ex_rd),

    .id_ex_reg_write(id_ex_reg_write),
    .id_ex_alu_src(id_ex_alu_src),
    .id_ex_alu_op(id_ex_alu_op),

    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_mem_write(id_ex_mem_write),
    .id_ex_mem_to_reg(id_ex_mem_to_reg),
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2)
);



/////////////////////////////////////////////////////////////////////////////
// EX/MEM PIPELINE REGISTER
/////////////////////////////////////////////////////////////////////////////

logic [31:0] ex_mem_alu_result;
logic [31:0] ex_mem_rs2_data;

logic [4:0] ex_mem_rd;

logic ex_mem_reg_write;
logic ex_mem_mem_read;
logic ex_mem_mem_write;
logic ex_mem_mem_to_reg;
logic [31:0] alu_result;

ex_mem_reg ex_mem_reg_inst (
    .clk(clk),
    .rst(rst),

    .alu_result(alu_result),
    .id_ex_rd(id_ex_rd),
    .id_ex_rs2_data(id_ex_rs2_data),
    .id_ex_reg_write(id_ex_reg_write),
    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_mem_write(id_ex_mem_write),
    .id_ex_mem_to_reg(id_ex_mem_to_reg),

    .ex_mem_alu_result(ex_mem_alu_result),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_rs2_data(ex_mem_rs2_data),
    .ex_mem_reg_write(ex_mem_reg_write),
    .ex_mem_mem_read(ex_mem_mem_read),
    .ex_mem_mem_write(ex_mem_mem_write),
    .ex_mem_mem_to_reg(ex_mem_mem_to_reg)
);

/////////////////////////////////////////////////////////////////////////////
// MEM STAGE (Data Memory)
/////////////////////////////////////////////////////////////////////////////

logic [31:0] read_data;

data_mem data_mem_inst (
    .clk(clk),

    .mem_write(ex_mem_mem_write),
    .mem_read(ex_mem_mem_read),

    .addr(ex_mem_alu_result),
    .write_data(ex_mem_rs2_data),

    .read_data(read_data)
);

/////////////////////////////////////////////////////////////////////////////
// MEM/WB PIPELINE REGISTER
/////////////////////////////////////////////////////////////////////////////

logic [31:0] mem_wb_alu_result;
logic [31:0] mem_wb_read_data;
logic mem_wb_mem_to_reg;

mem_wb_reg mem_wb_reg_inst (
    .clk(clk),
    .rst(rst),

    .ex_mem_alu_result(ex_mem_alu_result),
    .read_data(read_data),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .ex_mem_mem_to_reg(ex_mem_mem_to_reg),

    .mem_wb_alu_result(mem_wb_alu_result),
    .mem_wb_read_data(mem_wb_read_data),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .mem_wb_mem_to_reg(mem_wb_mem_to_reg)
);

/////////////////////////////////////////////////////////////////////////////
// WB STAGE (Writeback)
/////////////////////////////////////////////////////////////////////////////

assign writeback_data = (mem_wb_mem_to_reg) ? mem_wb_read_data : 
                        mem_wb_alu_result;
                        
                        
                        
/////////////////////////////////////////////////////////////////////////////
// forwarding unit
/////////////////////////////////////////////////////////////////////////////
 
logic [1:0] forward_a;                      
logic [1:0] forward_b;                      
                        
forwarding_unit forwarding_unit_inst (
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rd(ex_mem_rd),
    .mem_wb_rd(mem_wb_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_reg_write(mem_wb_reg_write),
    
    .forward_a(forward_a),
    .forward_b(forward_b)
);
                    
                        

logic [31:0] forward_rs1;
logic [31:0] forward_rs2;


always_comb begin 
    case(forward_a)
        2'b00: forward_rs1 = id_ex_rs1_data;
        2'b01: forward_rs1 = ex_mem_alu_result;
        2'b10: forward_rs1 = writeback_data;
        default: forward_rs1 = id_ex_rs1_data;
    endcase
end                        
                        
                        
always_comb begin 
    case(forward_b)
        2'b00: forward_rs2 = id_ex_rs2_data;
        2'b01: forward_rs2 = ex_mem_alu_result;
        2'b10: forward_rs2 = writeback_data;
        default: forward_rs2 = id_ex_rs2_data;
    endcase
end                        
                                
/////////////////////////////////////////////////////////////////////////////
// EX STAGE (Execute)
/////////////////////////////////////////////////////////////////////////////




logic [31:0] alu_a;
logic [31:0] alu_b;

assign alu_a = forward_rs1;
assign alu_b = (id_ex_alu_src) ?
               id_ex_imm :
               forward_rs2;

alu alu_inst (
    .a(alu_a),
    .b(alu_b),
    .alu_op(id_ex_alu_op),

    .alu_result(alu_result)
);



                        
endmodule
