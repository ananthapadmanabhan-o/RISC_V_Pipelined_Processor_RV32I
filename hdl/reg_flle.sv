module reg_file (
	input logic clk,
	input logic [4:0] rs1_addr,
	input logic [4:0] rs2_addr,
	input logic [4:0] rd_addr,
	input logic [31:0] rd_data,
	input logic reg_write,
	
	output logic [31:0] rs1_data,
	output logic [31:0] rs2_data
);

logic [31:0] register [0:31];

always_ff @(posedge clk) begin
	if ((rd_addr != 0) && (reg_write)) 
		register[rd_addr] <= rd_data;
	register[0] <= 32'd0;
end

//assign rs1_data = (rs1_addr == 0) ? 32'd0: register[rs1_addr];
//assign rs2_data = (rs2_addr == 0) ? 32'd0: register[rs2_addr];
	
	
assign rs1_data =
    (rs1_addr == 0) ? 32'd0 :
    (reg_write && (rd_addr == rs1_addr) && (rd_addr != 0))
        ? rd_data
        : register[rs1_addr];

assign rs2_data =
    (rs2_addr == 0) ? 32'd0 :
    (reg_write && (rd_addr == rs2_addr) && (rd_addr != 0))
        ? rd_data
        : register[rs2_addr];	
	
endmodule
