module rv32_cu(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
);
// logic invalid_instr;
always_comb begin
    // invalid_instr = 0;
    case (opcode)
        // LOAD
        7'b0000011:

        // STORE
        7'b0100011:

        // ALU REG
        7'b0110011:

        
        default: // invalid_instr = 1
    endcase
end
endmodule