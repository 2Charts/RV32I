module rv32_alu
    import rv32_pkg::*; 
(
    input  logic [31:0] opr_a_i,
    input  logic [31:0] opr_b_i,

    output logic [31:0] result_o,

    input alu_op_e      alu_op_i
);
    always_comb begin
        unique case (alu_op_i) 
            ALU_ADD: result_o = opr_a_i + opr_b_i;
            ALU_SUB: result_o = opr_a_i - opr_b_i;
            ALU_SLT: result_o = signed'(opr_a_i) < signed'(opr_b_i) ? 1 : 0;
            ALU_SLTU:result_o = opr_a_i < opr_b_i ? 1 : 0;
            ALU_SRL: result_o = opr_a_i >> opr_b_i[4:0];
            ALU_SRA: result_o = signed'(signed'(opr_a_i) >>> signed'(opr_b_i[4:0]));
            ALU_XOR: result_o = opr_a_i ^ opr_b_i;
            ALU_SLL: result_o = opr_a_i << opr_b_i[4:0];
            ALU_OR:  result_o = opr_a_i | opr_b_i;
            ALU_AND: result_o = opr_a_i & opr_b_i;
            default: result_o = 0;
        endcase
    end
endmodule
