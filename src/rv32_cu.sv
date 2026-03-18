module rv32_cu
    import rv32_pkg::*;
(
    input  logic[6:0]   opcode_i,
    input  logic[2:0]   funct3_i,
    input  logic[6:0]   funct7_i,

    input  logic rst_n_i;

    input  logic        misaligned_addr_i,
    input  logic        alu_zero_i,

    output imm_sel_e    imm_sel_o,
    output pc_sel_e     pc_sel_o,
    output wb_sel_e     wb_sel_o,
    output logic        wb_en_o,
    output alu_a_sel_e  alu_a_sel_o,
    output alu_b_sel_e  alu_b_sel_o,
    output alu_op_e     alu_op_o,
    output logic        lsu_en_o,
    output lsu_op_e     lsu_op_o,

    output logic        trap_o
);
    logic invalid_instruction;

    trap_o = rst_n_i == 0 ? 0 : (invalid_instruction | misaligned_addr_i);

    always_comb begin
        imm_sel_o   = IMM_R;
        pc_sel_o    = PC_PLUS_4;
        wb_sel_o    = WB_ALU;
        wb_en_o     = 0;
        alu_a_sel_o = ALU_A_REG;
        alu_b_sel_o = ALU_B_REG;
        alu_op_o    = ALU_ADD;
        lsu_en_o    = 0;
        lsu_op_o    = LSU_LB;
        trap_o      = 0;
        invalid_instruction = 0;


        unique case (opcode_i)
            
            7'b0110111: begin // U-type LUI
                imm_sel = IMM_I;
                wb_sel  = WB_IMM;
                wb_en   = 1;
            end

            7'b0010111: begin // U-type AUIPC
                imm_sel = IMM_I;
                alu_a_sel = ALU_A_PC;
                alu_b_sel = ALU_B_IMM;
                alu_op = ALU_ADD;
                pc_sel = PC_FROM_ALU;
            end

            7'b1101111: begin // J-type JAL
                wb_sel_o = WB_PC;
                wb_en_o = 1;
                imm_sel_o = IMM_J;
                pc_sel_o = PC_PLUS_IMM;
            end

            7'b1100111: begin // I-type JALR
                wb_sel_o = WB_PC;
                wb_en_o = 1;

                alu_a_sel_o = ALU_A_REG;
                alu_b_sel_o = ALU_B_IMM;
                alu_op_o  = ALU_ADD;

                imm_sel_o = IMM_I;
                pc_sel_o = PC_FROM_ALU;
            end

            7'b1100011: begin // B-type branch
                imm_sel_o = IMM_B;
                alu_a_sel = ALU_A_REG;
                alu_b_sel = ALU_B_REG;
                unique case (funct3_i)
                    3'b000, 3'b001: alu_op_o = ALU_SUB; // BEQ, BNE
                    3'b100, 3'b101: alu_op_o = ALU_SLT: // BLT, BGE
                    3'b110, 3'b111: alu_op_o = ALU_SLTU // BLTU, BGEU
                    default: invalid_instruction = 1;
                endcase

                if (!invalid_instruction && 
                    (
                        (funct3_i[2:1] == 2'b00 && (alu_zero_i ^ funct3_i[0])) ||
                        (funct3_i[2:1] != 2'b00 && (~alu_zero_i ^ funct3_i[0]))
                    )
                ) begin
                    pc_sel_o = PC_PLUS_IMM;
                end
            end

            
            7'b0000011: begin // I-type Load
                imm_sel_o = IMM_I;
                alu_a_sel_o = ALU_A_REG;
                alu_b_sel_o = ALU_B_IMM;
                alu_op_o = ALU_ADD;

                unique case(funct3_i)
                    3'b000: lsu_op_o = LSU_LB;
                    3'b001: lsu_op_o = LSU_LH;
                    3'b010: lsu_op_o = LSU_LW;
                    3'b100: lsu_op_o = LSU_LBU;
                    3'b101: lsu_op_o = LSU_LHU;
                    default: invalid_instruction = 1;
                endcase

                wb_sel_o = WB_LSU;

                if(!invalid_instruction) begin
                    wb_en_o = 1;
                    lsu_en_o = 1;
                end
            end

            7'b01000011: begin // S-type Store
                imm_sel_o = IMM_S;
                alu_a_sel_o = ALU_A_REG;
                alu_b_sel_o = ALU_B_IMM;
                alu_op_o = ALU_ADD;

                unique case(funct3_i)
                    3'b000: lsu_op_o = LSU_SB;
                    3'b001: lsu_op_o = LSU_SH;
                    3'b010: lsu_op_o = LSU_SW;
                    default: invalid_instruction = 1;
                endcase

                if(!invalid_instruction) begin
                    lsu_en_o;
                end
            end

            7'b0010011: begin // I-type ALU
                unique case (funct3_i)
                    3'b000: alu_op_o = funct7_i[5] == 1 ? ALU_SUB : ALU_ADD;
                    3'b001: alu_op_o = ALU_SLL;
                    3'b010: alu_op_o = ALU_SLT;
                    3'b011: alu_op_o = ALU_SLTU;
                    3'b100: alu_op_o = ALU_XOR;
                    3'b101: alu_op_o = funct7_i[5] == 1 ? ALU_SRA : ALU_SRL;
                    3'b110: alu_op_o = ALU_OR;
                    3'b111: alu_op_o = ALU_AND;
                endcase

                alu_a_sel_o = ALU_A_REG;
                alu_b_sel_o = ALU_B_IMM;
                wb_sel_o = WB_ALU;
                wb_en_o = 1;
            end
        
            7'b0110011: begin // R-type ALU
                unique case (funct3_i)
                    3'b000: alu_op_o = funct7_i[5] == 1 ? ALU_SUB : ALU_ADD;
                    3'b001: alu_op_o = ALU_SLL;
                    3'b010: alu_op_o = ALU_SLT;
                    3'b011: alu_op_o = ALU_SLTU;
                    3'b100: alu_op_o = ALU_XOR;
                    3'b101: alu_op_o = funct7_i[5] == 1 ? ALU_SRA : ALU_SRL;
                    3'b110: alu_op_o = ALU_OR;
                    3'b111: alu_op_o = ALU_AND;
                endcase

                alu_a_sel_o = ALU_A_REG;
                alu_b_sel_o = ALU_B_REG;
                wb_sel_o = WB_ALU;
                wb_en_o = 1;
            end

            default: invalid_instruction = 1;
        endcase
    end
endmodule
