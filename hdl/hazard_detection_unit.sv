module hazard_detection_unit(
    input logic id_ex_mem_read,
    input logic [4:0] id_ex_rd,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    
    output logic stall
);



always_comb begin
    stall = 1'b0;
    
    if (id_ex_mem_read && (id_ex_rd != 5'd0) && ((id_ex_rd == rs1) || (id_ex_rd == rs2))) begin
        stall = 1'b1;
    end
end 


endmodule
