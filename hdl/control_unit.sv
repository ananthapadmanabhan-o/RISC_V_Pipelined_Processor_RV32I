module control_unit (	
	input logic [6:0] opcode,
	input logic [2:0] funct3,
	input logic [6:0] funct7,
	
	output logic [3:0] alu_op,
	output logic alu_src,
	output logic mem_write,
	output logic mem_read,
	output logic reg_write,
	output logic jump,
	output logic branch,
	output logic mem_to_reg
);

localparam OPCODE_R		= 7'b0110011;
localparam OPCODE_I 	= 7'b0010011;
localparam OPCODE_L		= 7'b0000011;
localparam OPCODE_S		= 7'b0100011;
localparam OPCODE_B		= 7'b1100011; 
localparam OPCODE_J 	= 7'b1101111;
localparam OPCODE_JLR 	= 7'b1100111; 

localparam ALU_ADD	= 4'd0;
localparam ALU_SUB 	= 4'd1;
localparam ALU_XOR 	= 4'd2;
localparam ALU_OR  	= 4'd3;
localparam ALU_AND 	= 4'd4;
localparam ALU_SLL 	= 4'd5;
localparam ALU_SRL 	= 4'd6;
localparam ALU_SRA 	= 4'd7;
localparam ALU_SLT 	= 4'd8;
localparam ALU_SLU 	= 4'd9;




always_comb begin
	alu_src		= 1'b0;
	mem_write 	= 1'b0;
	mem_read	= 1'b0;
	reg_write	= 1'b0;
	jump 		= 1'b0;
	branch		= 1'b0;
	mem_to_reg	= 1'b0;
	alu_op		= ALU_ADD;
	case(opcode)
		OPCODE_R: begin
			reg_write = 1'b1;
			case({funct7,funct3})
				10'b0000000_000: alu_op = ALU_ADD;
				10'b0100000_000: alu_op = ALU_SUB;
				10'b0000000_100: alu_op = ALU_XOR;
				10'b0000000_110: alu_op = ALU_OR;
				10'b0000000_111: alu_op = ALU_AND;
				10'b0000000_001: alu_op = ALU_SLL;
				10'b0000000_101: alu_op = ALU_SRL;
				10'b0100000_101: alu_op = ALU_SRA;
				10'b0000000_010: alu_op = ALU_SLT;
				10'b0000000_011: alu_op = ALU_SLU;
				default 	   : alu_op = ALU_ADD;
			endcase
		end
		
		OPCODE_I: begin
			reg_write	= 1'b1;
			alu_src 	= 1'b1;
			case(funct3) 
				3'd0:  alu_op = ALU_ADD;
				3'd4:  alu_op = ALU_XOR;
				3'd6:  alu_op = ALU_OR;
				3'd7:  alu_op = ALU_AND;
				3'd1:  alu_op = ALU_SLL;
				3'd5:  alu_op = (funct7 == 7'b0000000) ? ALU_SRL: (funct7 == 7'b0100000) ? ALU_SRA: ALU_ADD;
				3'd2:  alu_op = ALU_SLT;
				3'd3:  alu_op = ALU_SLU;
			endcase
		end
		
		OPCODE_L: begin
			mem_read 	= 1'b1;
			alu_src  	= 1'b1;
			reg_write 	= 1'b1;
			mem_to_reg 	= 1'b1;
			alu_op 		= ALU_ADD;
		end
		
		OPCODE_S: begin
			mem_write	= 1'b1;
			alu_src		= 1'b1;
			alu_op	 	= ALU_ADD;
		end
		
		OPCODE_B: begin
			branch = 1'b1;
		end
		
		OPCODE_J: begin
			jump 		= 1'b1;
			reg_write 	= 1'b1;
		end
		
		OPCODE_JLR: begin
			jump	= 1'b1;
			alu_src = 1'b1;
		end
		
	endcase
end




endmodule
