module rv32_alu(
    input  logic [31:0] opr_a,
    input  logic [31:0] opr_b,

    output logic [31:0] result,

    input  logic [3:0]  mode
);
    always_comb begin
        unique case (mode[2:0])
            3'b000: result = opr_a + (opr_b ^ {32{mode[3]}}) + mode[3];
            3'b001: result = opr_a << opr_b[4:0];
            3'b010: result = $signed(opr_a) < $signed(opr_b) ? 1 : 0;
            3'b011: result = opr_a < opr_b ? 1 : 0;
            3'b100: result = opr_a ^ opr_b;
            3'b101: result = mode[3] ? $signed($signed(opr_a) >>> $signed(opr_b[4:0]))
                                     : opr_a >> opr_b[4:0];
            3'b110: result = opr_a | opr_b;
            3'b111: result = opr_a & opr_b;
        endcase
    end
endmodule
