module instr_mem (
	input logic [31:0] addr,
	
	output logic [31:0] instr
);


logic [31:0] memory [0:127];


assign instr = memory[addr[9:2]];

initial begin
  
    memory[0] = 32'h00A00093;
    memory[1] = 32'h00102023;

    memory[2] = 32'h00002103;
    memory[3] = 32'h002101B3;

    memory[4] = 32'h00218233;
    memory[5] = 32'h003202B3;

    memory[6] = 32'h00000013;
    memory[7] = 32'h00000013;
    memory[8] = 32'h00000013;







end



endmodule
