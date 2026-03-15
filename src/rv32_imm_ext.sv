module rv32_imm_ext 
    import rv32_pkg::*;
(
    input  logic [31:7] imm_i,
    output logic [31:0] imm_o,

    input  imm_sel_e    imm_sel_i
);
    always_comb begin
        unique case (imm_sel_i)
            IMM_R:   imm_o = 0;
            IMM_I:   imm_o = {{21{imm_i[31]}}, imm_i[30:25], imm_i[24:21], imm_i[20]};
            IMM_S:   imm_o = {{21{imm_i[31]}}, imm_i[30:25], imm_i[11:8], imm_i[7]};
            IMM_B:   imm_o = {{20{imm_i[31]}}, imm_i[7], imm_i[30:25], imm_i[11:8], 1'b0};
            IMM_U:   imm_o = {imm_i[31], imm_i[30:20], imm_i[19:12], 12'b0};
            IMM_J:   imm_o = {{12{imm_i[31]}}, imm_i[19:12], imm_i[20], imm_i[30:25], imm_i[24:21], 1'b0};
            default: imm_o = 0;
        endcase
    end
endmodule;
