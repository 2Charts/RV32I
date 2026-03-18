module rv32_core (
    output logic [31:0] instr_addr_o,
    input  logic [31:0] instr_data_i,

    output logic [31:0] mem_addr_o,
    input  logic [31:0] mem_rdata_i,
    output logic [31:0] mem_wdata_o,
    output logic [3:0]  mem_be_o,
    output logic        mem_wen_o,

    input logic         rst_n,
    input logic         clk
);
    import rv32_pkg::*;

////////////////////////////////////
//          Sign Extend           //
////////////////////////////////////

    logic[31:0] imm_data;

    imm_sel_e   imm_sel;

    rv32_imm_ext imm_ext (
        .imm_i(instr_data_i[31:7]),
        .imm_o(imm_data),
        .imm_sel_i(imm_sel)
    );


////////////////////////////////////
//        Program Counter         //
////////////////////////////////////

    logic [31:0] pc;
    logic [31:0] pc_next;
    logic [31:0] pc_plus_4;
    logic [31:0] pc_plus_imm;

    pc_sel_e     pc_sel;

    logic        pc_misaligned;

    assign pc_plus_4 = pc + 4;
    assign pc_plus_imm = pc + imm_data;

    always_comb begin
        unique case (pc_sel)
            // normal
            PC_PLUS_4  : pc_next = pc + 4;
            // Branch, JAL
            PC_PLUS_IMM: pc_next = pc_plus_imm;
            // JALR
            PC_FROM_ALU: pc_next = alu_result & ~32'd1; // align to two bytes
            default    : pc_next = pc + 4; // defaults to +4
        endcase
    end

    assign pc_misaligned = pc_next[1] | pc_next[0];

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            pc <= 0;
        end else if (!trap) begin
            pc <= pc_next;
        end
    end

    assign instr_addr_o = pc;


////////////////////////////////////
//          Write Back            //
////////////////////////////////////

    logic [31:0] wb_data;

    wb_sel_e     wb_sel;
    logic        wb_en;

    always_comb begin
        unique case (wb_sel)
            WB_ALU: wb_data = alu_result;
            WB_LSU: wb_data = lsu_data_out;
            WB_IMM: wb_data = imm_data;
            WB_PC : wb_data = pc_plus_4;
        endcase
    end


////////////////////////////////////
//         Register File          //
////////////////////////////////////

    logic [31:0] regfile_rdata_a;
    logic [31:0] regfile_rdata_b;

    register_file regfile(
        .raddr_a_i(instr_data_i[19:15]), // rs1
        .rdata_a_o(regfile_rdata_a),

        .raddr_b_i(instr_data_i[24:20]), // rs2
        .rdata_b_o(regfile_rdata_b),

        .waddr_i(instr_data_i[11:7]), // rd
        .wdata_i(wb_data),
        .wen_i(wb_en),

        .rst_n(rst_n),
        .clk(clk)
    );


////////////////////////////////////
//     Arithmetic Logic Unit      //
////////////////////////////////////

    logic [31:0] alu_result;
    logic [31:0] alu_opr_a;
    logic [31:0] alu_opr_b;

    alu_a_sel_e  alu_a_sel;
    alu_b_sel_e  alu_b_sel;
    alu_op_e     alu_op;

    logic        alu_zero;

    assign alu_opr_a = alu_a_sel == ALU_A_REG ? regfile_rdata_a : pc;
    assign alu_opr_b = alu_b_sel == ALU_B_REG ? regfile_rdata_b : imm_data;

    rv32_alu alu (
        .opr_a_i(alu_opr_a),
        .opr_b_i(alu_opr_b),
        .result_o(alu_result),
        .alu_op_i(alu_op)
    );

    assign alu_zero = ~&alu_result;


////////////////////////////////////
//        Load Store Unit         //
////////////////////////////////////

    logic [31:0] lsu_data_out;

    logic lsu_en;
    lsu_op_e lsu_op;

    logic lsu_misaligned;

    rv32_lsu lsu(
        .lsu_addr_i(alu_result),
        .lsu_data_i(regfile_rdata_b),
        .lsu_data_o(lsu_data_out),

        .mem_addr_o(mem_addr_o),
        .mem_rdata_i(mem_rdata_i),
        .mem_wdata_o(mem_wdata_o),
        .mem_be_o(mem_be_o),
        .mem_wen_o(mem_wen_o),

        .lsu_en_i(lsu_en),
        .lsu_op_i(lsu_op),
        .lsu_misaligned_o(lsu_misaligned)
    );


////////////////////////////////////
//         Control Unit           //
////////////////////////////////////

    logic misaligned_addr = lsu_misaligned | pc_misaligned;
    logic trap;

    rv32_cu cu(
        .opcode_i(instr_data_i[6:0]),
        .funct3_i(instr_data_i[14:12]),
        .funct7_i(instr_data_i[31:25]),

        .rst_n_i(rst_n),

        .misaligned_addr_i(misaligned_addr),
        .alu_zero_i(alu_zero),

        .imm_sel_o(imm_sel),
        .pc_sel_o(pc_sel),
        .wb_sel_o(wb_sel),
        .wb_en_o(wb_en),
        .alu_a_sel_o(alu_a_sel),
        .alu_b_sel_o(alu_b_sel),
        .alu_op_o(alu_op),
        .lsu_en_o(lsu_en),
        .lsu_op_o(lsu_op),

        .trap_o(trap)
    );

endmodule
