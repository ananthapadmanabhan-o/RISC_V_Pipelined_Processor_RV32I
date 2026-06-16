module instr_mem (
	input logic [31:0] addr,
	
	output logic [31:0] instr
);


logic [31:0] memory [0:127];


assign instr = memory[addr[9:2]];

initial begin
    memory[0]  = 32'h06400093; // addi x1,x0,100
    memory[1]  = 32'h03700113; // addi x2,x0,55
    
    memory[2]  = 32'h00000013;
    memory[3]  = 32'h00000013;
    memory[4]  = 32'h00000013;
    memory[5]  = 32'h00000013;
    
    memory[6]  = 32'h0020A023; // sw x2,0(x1)
    
    memory[7]  = 32'h00000013;
    memory[8]  = 32'h00000013;
    memory[9]  = 32'h00000013;
    memory[10] = 32'h00000013;
    
    memory[11] = 32'h0000A183; // lw x3,0(x1)
end



endmodule
