module alu (
	input logic [31:0] a,
	input logic [31:0] b,
	input logic [3:0] alu_op,
	
	output logic [31:0] alu_result
);

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
	case(alu_op)
		ALU_ADD: 	alu_result 	= a + b;
		ALU_SUB:	alu_result	= a - b;
		ALU_XOR: 	alu_result 	= a ^ b;
		ALU_OR :	alu_result	= a | b;
		ALU_AND: 	alu_result 	= a & b;
		ALU_SLL:	alu_result	= a << b[4:0];
		ALU_SRL: 	alu_result 	= a >> b[4:0];
		ALU_SRA:	alu_result	= $signed(a) >> b[4:0];
		ALU_SLT: 	alu_result 	= ($signed(a) < $signed(b)) ? 32'd1: 32'd0;
		ALU_SLU:	alu_result	= (a < b) ? 32'd1: 32'd0;
		default:	alu_result 	= 32'd0;
	endcase
end



endmodule
