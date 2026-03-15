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
} alu_op_t;

typedef enum logic[2:0] {
    LSU_LB,
    LSU_LBU,
    LSU_LH,
    LSU_LHU,
    LSU_LW,
    LSU_SB,
    LSU_SW,
    LSU_SH
} lsu_op_t;

typedef enum logic {
    REG_IN_ALU,
    REG_IN_LSU
} reg_in_sel_t;

endpackage
