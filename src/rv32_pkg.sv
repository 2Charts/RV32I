package rv32_pkg;

typedef enum logic[2:0] { 
    ALU_ARTH,
    ALU_SHL,
    ALU_SLT,
    ALU_SLTU,
    ALU_XOR,
    ALU_SHR,
    ALU_OR,
    ALU_AND
} alu_mode_t;

typedef enum logic [1:0] {
    LSU_BYTE,
    LSU_HALFWORD,
    LSU_WORD,
    LSU_WORD_2
} lsu_width_t;

typedef enum logic {
    LSU_LOAD,
    LSU_STORE
} lsu_mode_t;

typedef enum logic {
    REG_IN_ALU,
    REG_IN_LSU
} reg_in_mux_sel_t;

typedef enum logic {

} lsu_addr_mux_sel;

typedef enum logic {
    LSU_DATA_ALU,
    LSU_DATA_REG_A
} lsu_data_mux_sel;

endpackage