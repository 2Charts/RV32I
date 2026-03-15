module rv32_core (
    output logic [31:0] instr_addr,
    input  logic [31:0] instr_data,

    output logic [31:0] mem_addr,
    input  logic [31:0] mem_r_data,
    output logic [31:0] mem_w_data,
    output logic [3:0]  mem_w_be,
    output logic        mem_w_en,

    input logic         rst_n,
    input logic         clk
);
    import rv32_pkg::*;

    logic [31:0] pc;
    logic [31:0] pc_next;

    assign pc_next = pc + 4;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            pc <= 0;
        end else begin
            pc <= pc_next;
        end
    end

    // todo: jump & branch
    assign instr_addr = pc;

    logic [31:0] reg_in;
    logic [31:0] reg_out_a;
    logic [31:0] reg_out_b;
    logic        reg_write;
    reg_in_sel_t reg_in_sel;

    logic [31:0] alu_in_b;
    logic [31:0] alu_out;
    alu_op_t     alu_op;

    logic [31:0] lsu_out;
    lsu_op_t     lsu_op;
    logic        lsu_en;

    // todo: immediate value
    assign reg_in = reg_in_sel == REG_IN_ALU ? alu_out : lsu_out;

    register_file reg_file(
        .r_addr_a(instr_data[19:15]),
        .r_data_a(reg_out_a),

        .r_addr_b(instr_data[24:20]),
        .r_data_b(reg_out_b),

        .w_addr(instr_data[11:7]),
        .w_data(reg_in),
        .w_en(reg_write),

        .rst_n(rst_n),
        .clk(clk)
    );

    // todo: immediate value
    assign alu_in_b = reg_out_b;

    rv32_alu alu(
        .opr_a(reg_out_a),
        .opr_b(alu_in_b),

        .result(alu_out),

        .alu_op(alu_op)
    );

    rv32_lsu lsu (
        .addr_in(alu_out),
        .data_in(reg_out_b),
        .data_out(lsu_out),

        .rw_addr(mem_addr),
        .r_data(mem_r_data),
        .w_data(mem_w_data),
        .w_be(mem_w_be),
        .w_en(mem_w_en),

        .lsu_en(lsu_en),
        .lsu_op(lsu_op)
    );

    rv32_cu cu(
        .opcode(instr_data[6:0]),
        .funct3(instr_data[14:12]),
        .funct7(instr_data[31:25]),

        .reg_write(reg_write),
        .reg_in_sel(reg_in_sel),
        .alu_op(alu_op),
        .lsu_op(lsu_op),
        .lsu_en(lsu_en)
    );

endmodule
