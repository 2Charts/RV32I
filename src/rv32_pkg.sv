package rv32_pkg;

typedef enum logic[3:0] {
    ALU_ADD,
    ALU_SUB,
    ALU_SLT,
    ALU_SLTU,
    ALU_SRL,
    ALU_SRA,
    ALU_XOR,
    ALU_SLL,
    ALU_OR,
    ALU_AND,
    ALU_UNDEF[6]
} alu_op_e;

typedef enum logic[2:0] {
    LSU_LB,
    LSU_LBU,
    LSU_LH,
    LSU_LHU,
    LSU_LW,
    LSU_SB,
    LSU_SW,
    LSU_SH
} lsu_op_e;

typedef enum logic[1:0] {
    WB_ALU,
    WB_LSU,
    WB_IMM,
    WB_PC 
} wb_sel_e;

typedef enum logic[2:0] {
    IMM_R,
    IMM_I,
    IMM_S,
    IMM_B,
    IMM_U,
    IMM_J,
    IMM_UNDEF[2]
} imm_sel_e;

typedef enum logic {
    ALU_B_REG,
    ALU_B_IMM
} alu_b_sel_e;

typedef enum logic[1:0] {
    PC_PLUS_4,
    PC_PLUS_IMM,
    PC_FROM_ALU,
    PC_UNDEF
} pc_sel_e;

endpackage
