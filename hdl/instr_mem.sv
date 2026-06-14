module instr_mem (
	input logic [31:0] addr,
	
	output logic [31:0] instr
);


logic [31:0] memory [0:127];


assign instr = memory[addr[9:2]];

initial begin
    memory[0]  = 32'h00A00093; // addi x1, x0, 10
    memory[1]  = 32'h01400113; // addi x2, x0, 20
    
    memory[2]  = 32'h00000013;
    memory[3]  = 32'h00000013;
    memory[4]  = 32'h00000013;
    memory[5]  = 32'h00000013;
    
    memory[6]  = 32'h002081B3; // add x3, x1, x2
    
    memory[7]  = 32'h00000013;
    memory[8]  = 32'h00000013;
    memory[9]  = 32'h00000013;
    memory[10] = 32'h00000013;
    
    memory[11] = 32'h40110233; // sub x4, x2, x1
    
    memory[12] = 32'h00000013;
    memory[13] = 32'h00000013;
    memory[14] = 32'h00000013;
    memory[15] = 32'h00000013;
    
    memory[16] = 32'h00F20293; // addi x5, x4, 15
end



endmodule
