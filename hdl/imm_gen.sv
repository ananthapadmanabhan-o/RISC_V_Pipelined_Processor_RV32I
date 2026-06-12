module imm_gen (
	input logic [6:0] opcode,
	input logic [31:0] instr,
	
	output logic [31:0] imm_out
);

localparam OPCODE_I 	= 7'b0010011;
localparam OPCODE_L		= 7'b0000011;
localparam OPCODE_S		= 7'b0100011;
localparam OPCODE_B		= 7'b1100011; 
localparam OPCODE_J 	= 7'b1101111;
localparam OPCODE_JLR 	= 7'b1100111;

always_comb begin
	case(opcode)
		OPCODE_I,OPCODE_L,OPCODE_JLR: imm_out <= {{21{instr[31]}}, instr[30:20]};
		OPCODE_S: imm_out <= {{21{instr[31]}}, instr[30:25], instr[11:7]};
		OPCODE_B: imm_out <= {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
//		OPCODE_U: imm_out <= {instr[31:12], 12'd0};
		OPCODE_J: imm_out <= {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
		default:  imm_out <= 32'd0;
	endcase
end

endmodule
