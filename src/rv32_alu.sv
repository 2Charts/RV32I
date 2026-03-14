module rv32_alu
    import rv32_pkg::*; 
(
    input  logic [31:0] opr_a,
    input  logic [31:0] opr_b,

    output logic [31:0] result,

    input alu_mode_t    alu_mode,
    input logic         alu_alt,
);
    always_comb begin
        unique case (alu_mode)
            ALU_ARTH: result = opr_a + (opr_b ^ {32{mode[3]}}) + alu_alt;
            ALU_SHL : result = opr_a << opr_b[4:0];
            ALU_SLT : result = $signed(opr_a) < $signed(opr_b) ? 1 : 0;
            ALU_SLTU: result = opr_a < opr_b ? 1 : 0;
            ALU_XOR : result = opr_a ^ opr_b;
            ALU_SHR : result = alu_alt ? $signed($signed(opr_a) >>> $signed(opr_b[4:0]))
                                       : opr_a >> opr_b[4:0];
            ALU_OR  : result = opr_a | opr_b;
            ALU_AND : result = opr_a & opr_b;
        endcase
    end
endmodule
