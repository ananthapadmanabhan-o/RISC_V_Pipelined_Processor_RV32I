module if_id_reg (
	input logic clk,
	input logic rst,
	
	input logic [31:0] pc,
	input logic [31:0] pc4,
	input logic [31:0] instr,
	
	output logic [31:0] if_id_pc,
	output logic [31:0] if_id_pc4,
	output logic [31:0] if_id_instr
);

always_ff @(posedge clk) begin
	if (rst) begin
		if_id_pc 	<= 32'd0;
		if_id_pc4 	<= 32'd0;
		if_id_instr <= 32'd0;
	end	
	else begin
		if_id_pc 	<= pc;
		if_id_pc4 	<= pc4;
		if_id_instr <= instr;
	end
end


endmodule