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

    logic [31:0] reg_in_mux;
    logic [31:0] reg_out_a;
    logic [31:0] reg_out_b;

    reg_in_mux_sel_t reg_in_mux_sel;
    logic            reg_write;

    logic [31:0] alu_result;

    alu_mode_t  alu_mode;
    logic       alu_alt;


    logic [31:0] lsu_out;

    logic       lsu_en;
    lsu_mode_t  lsu_mode;
    lsu_width_t lsu_width;
    logic       lsu_sign_ext;
    //logic       lsu_misaligned;

    always_ff @( posedge clk ) begin
        if(!rst_n) begin
            pc <= 0;
        end else begin
            pc <= pc + 4;
        end
    end

    assign instr_addr <= pc;

    always_comb begin
        switch(reg_in_mux_sel) {
            REG_IN_ALU: reg_in_mux = alu_result;
            REG_IN_LSU: reg_in_mux = lsu_out;
        }
    end

    register_file reg_file(
        .r_addr_a(instr_data[15:19]),
        .r_data_a(reg_out_a),

        .r_addr_b(instr_data[20:24]),
        .r_data_b(reg_out_b),

        .w_addr(instr_data[7:11]),
        .w_data(reg_in_mux),
        .w_en(reg_write),

        .rst_n(rst_n),
        .clk(clk)
    );

    rv32_alu alu(
        .opr_a(reg_out_a),
        .opr_b(reg_out_b),
        .result(alu_result),
        .alu_mode(alu_mode),
        .alu_alt(alu_alt)
    );

    rv32_lsu lsu(
        .addr_in(alu_result),
        .data_in(reg_out_b),
        .data_out(lsu_out),

        .rw_addr(mem_addr),
        .r_data(mem_r_data),
        .w_data(mem_w_data),
        .w_be(mem_w_be),
        .w_en(mem_w_en),

        .lsu_en(lsu_en),
        .lsu_mode(lsu_mode_t),
        .lsu_width(lsu_width),
        .lsu_sign_ext(lsu_sign_ext),
        //.lsu_misaligned(lsu_misaligned)
    );

endmodule
