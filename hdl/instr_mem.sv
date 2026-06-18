module instr_mem (
	input logic [31:0] addr,
	
	output logic [31:0] instr
);


logic [31:0] memory [0:127];


assign instr = memory[addr[9:2]];

initial begin
  
  
memory[0] = 32'h00A00093; // addi x1,x0,10
memory[1] = 32'h01400113; // addi x2,x0,20
memory[2] = 32'h002081B3; // add x3,x1,x2
memory[3] = 32'h00118233; // add x4,x3,x1








end



endmodule
