module ex_mem_reg (
    input logic clk,
    input logic rst,

    input logic [31:0] alu_result,
    input logic [4:0] id_ex_rd,
    input logic [31:0] id_ex_rs2_data,
    input logic id_ex_reg_write,
    input logic id_ex_mem_read,
    input logic id_ex_mem_write,
    input logic id_ex_mem_to_reg,

    output logic [31:0] ex_mem_alu_result,
    output logic [4:0] ex_mem_rd,
    output logic [31:0] ex_mem_rs2_data,
    output logic ex_mem_reg_write,
    output logic ex_mem_mem_read, 
    output logic ex_mem_mem_write,
    output logic ex_mem_mem_to_reg
    
    
);

always_ff @(posedge clk) begin
    if (rst) begin
        ex_mem_alu_result <= '0;
        ex_mem_rd         <= '0;
        ex_mem_rs2_data   <= '0;
        ex_mem_reg_write  <= '0;
        ex_mem_mem_read   <= '0;  
        ex_mem_mem_write  <= '0;
        ex_mem_mem_to_reg  <= '0;
        
        
    end
    else begin
        ex_mem_alu_result <= alu_result;
        ex_mem_rd         <= id_ex_rd;
        ex_mem_rs2_data   <= id_ex_rs2_data;
        ex_mem_reg_write  <= id_ex_reg_write;
        ex_mem_mem_read   <= id_ex_mem_read;
        ex_mem_mem_write  <= id_ex_mem_write;
        ex_mem_mem_to_reg  <= id_ex_mem_to_reg;
        
    end
end

endmodule