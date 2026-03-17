module rv32_cu
    import rv32_pkg::*;
(
    input  logic[6:0]   opcode_i,
    input  logic[2:0]   funct3_i,
    input  logic[6:0]   funct7_i,

    input  logic        misaligned_addr_i,
    input  logic        alu_zero_i,

    output imm_sel_e    imm_sel_o,
    output pc_sel_e     pc_sel_o,
    output wb_sel_e     wb_sel_o,
    output logic        wb_en_o,
    output alu_a_sel_e  alu_a_sel_o,
    output alu_b_sel_e  alu_b_sel_o,
    output alu_op_e     alu_op_o,
    output logic        lsu_en_o,
    output lsu_op_e     lsu_op_o,

    output logic        trap_o
);
    always_comb begin
        imm_sel_o   = IMM_R;
        pc_sel_o    = PC_PLUS_4;
        wb_sel_o    = WB_ALU;
        wb_en_o     = 0;
        alu_a_sel_o = ALU_A_REG;
        alu_b_sel_o = ALU_B_REG;
        alu_op_o    = ALU_ADD;
        lsu_en_o    = 0;
        lsu_op_o    = LSU_LB;
        trap_o      = 0;
    end
endmodule
