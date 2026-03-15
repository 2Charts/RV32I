module rv32_cu
    import rv32_pkg::*;
(
    input logic[6:0] opcode,
    input logic[2:0] funct3,
    input logic[6:0] funct7,

    output logic        reg_write,
    output reg_in_sel_t reg_in_sel,
    output alu_op_t     alu_op,
    output lsu_op_t     lsu_op,
    output logic        lsu_en
);
    
endmodule
