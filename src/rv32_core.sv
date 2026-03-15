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

    // for now, errors will cause a halt
    logic trap;


////////////////////////////////////
//        Program Counter         //
////////////////////////////////////

    logic [31:0] pc;
    logic [31:0] pc_plus4;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            pc = 0;
        end else if(!trap) begin
            pc <= pc_plus4;
        end else begin
            pc <= pc;
        end
    end

    assign instr_addr_o = pc;
    assign pc_plus4 = pc + 4;


////////////////////////////////////
//          Sign Extend           //
////////////////////////////////////

    imm_sel_e   imm_sel;
    logic[31:0] imm_data;

    rv32_imm_ext imm_ext (
        .imm_i(instr_data_i[31:7]),
        .imm_o(imm_data),
        .imm_sel_i(imm_sel)
    );


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
            WB_PC : wb_data = pc_plus4;
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
    logic [31:0] alu_b;
    alu_b_sel_e  alu_b_sel;
    alu_op_e     alu_op;

    assign alu_b = alu_b_sel == ALU_B_REG ? regfile_rdata_b : imm_data;

    rv32_alu alu (
        .opr_a_i(regfile_rdata_a),
        .opr_b_i(alu_b),
        .result_o(alu_result),
        .alu_op_i(alu_op)
    );


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

endmodule
