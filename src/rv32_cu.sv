module rv32_cu
    import rv32_pkg::*;
(
    input logic[6:0] opcode,
    input logic[2:0] funct3,
    input logic[6:0] funct7,

    output logic        wb_en,
    output wb_sel_e     wb_sel,
    output alu_op_e     alu_op,
    output lsu_op_e     lsu_op,
    output logic        lsu_en
);
    
endmodule
