module rv32_alu
    import rv32_pkg::*; 
(
    input  logic [31:0] opr_a,
    input  logic [31:0] opr_b,

    output logic [31:0] result,

    input alu_op_e      alu_op
);
    always_comb begin
        unique case (alu_mode) 
            ALU_ADD: result = opr_a + opr_b;
            ALU_SUB: result = opr_a - opr_b;
            ALU_SLT: result = signed'(opr_a) < signed'(opr_b) ? 1 : 0;
            ALU_SLTU:result = opr_a < opr_b ? 1 : 0;
            ALU_SRL: result = opr_a >> opr_b[4:0];
            ALU_SRA: result = signed'(signed'(opr_a) >>> signed'(opr_b[4:0]));
            ALU_XOR: result = opr_a ^ opr_b;
            ALU_SLL: result = opr_a << opr_b[4:0];
            ALU_OR:  result = opr_a | opr_b;
            ALU_AND: result = opr_a & opr_b;
            default: result = 0;
        endcase
    end
endmodule
