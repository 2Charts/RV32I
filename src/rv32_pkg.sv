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

typedef enum logic {
    WB_ALU,
    WB_LSU
} wb_sel_e;

endpackage
