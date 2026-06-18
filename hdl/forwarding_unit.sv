module forwarding_unit (
    input logic [4:0] id_ex_rs1,
    input logic [4:0] id_ex_rs2,
    input logic [4:0] ex_mem_rd,
    input logic [4:0] mem_wb_rd,
    input logic ex_mem_reg_write,
    input logic mem_wb_reg_write,
    
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);





logic idex_exmem_forward_a;
logic idex_exmem_forward_b;
logic exmem_memwb_forward_a;
logic exmem_memwb_forward_b;


assign idex_exmem_forward_a = ((ex_mem_rd != '0) && ex_mem_reg_write && (ex_mem_rd == id_ex_rs1)); 
assign idex_exmem_forward_b = ((ex_mem_rd != '0) && ex_mem_reg_write && (ex_mem_rd == id_ex_rs2)); 

assign exmem_memwb_forward_a = ((mem_wb_rd != '0) && mem_wb_reg_write && (mem_wb_rd == id_ex_rs1));
assign exmem_memwb_forward_b = ((mem_wb_rd != '0) && mem_wb_reg_write && (mem_wb_rd == id_ex_rs2));



always_comb begin 
    forward_a = 2'b00;
    forward_b = 2'b00;
    
    if (idex_exmem_forward_a) begin
        forward_a = 2'b01;
    end
    
    if (idex_exmem_forward_b) begin
        forward_b = 2'b01;
    end
    
    if (exmem_memwb_forward_a && !idex_exmem_forward_a) begin
        forward_a = 2'b10;
    end
    
    if (exmem_memwb_forward_b && !idex_exmem_forward_b) begin
        forward_b = 2'b10;
    end    

end




endmodule