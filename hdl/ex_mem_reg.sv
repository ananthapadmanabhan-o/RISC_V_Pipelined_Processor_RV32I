module ex_mem_reg (
    input logic clk,
    input logic rst,

    input logic [31:0] alu_result,
    input logic [4:0] id_ex_rd,
    input logic [31:0] id_ex_rs2_data,
    input logic id_ex_reg_write,

    output logic [31:0] ex_mem_alu_result,
    output logic [4:0] ex_mem_rd,
    output logic [31:0] ex_mem_rs2_data,
    output logic ex_mem_reg_write
);

always_ff @(posedge clk) begin
    if (rst) begin
        ex_mem_alu_result <= '0;
        ex_mem_rd         <= '0;
        ex_mem_rs2_data   <= '0;
        ex_mem_reg_write  <= '0;
    end
    else begin
        ex_mem_alu_result <= alu_result;
        ex_mem_rd         <= id_ex_rd;
        ex_mem_rs2_data   <= id_ex_rs2_data;
        ex_mem_reg_write  <= id_ex_reg_write;
    end
end

endmodule