module pc (
	input logic clk,
	input logic rst,
	input logic pc_en,
	input logic [31:0] pc_next,
	
	output logic [31:0] pc_out
);

always_ff @(posedge clk) begin
	if (rst)
		pc_out <= 32'd0;
	else if (pc_en)
		pc_out <= pc_next;
end

endmodule