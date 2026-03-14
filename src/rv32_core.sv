module rv32_core (
    output logic [31:0] instr_addr
    input  logic [31:0] instr_data,

    output logic [31:0] r_addr;
    input  logic [31:0] r_data;

    output logic [31:0] w_addr;
    output logic [31:0] w_data;
    output logic [4:0]  w_be;
    output logic        w_en

    input logic         rst_n,
    input logic         clk
);
    logic [31:0] pc;

    always_ff @( posedge clk ) begin
        if(!rst_n) begin
            pc <= 0;
        end else begin
            pc <= pc + 4;
        end
    end

    logic [31:0] reg_out_a;
    logic [31:0] reg_out_b;
    logic [31:0] reg_in;
    logic        reg_write;

    register_file reg_file(
        .r_addr_a(instr_data[15:19]),
        .r_data_a(reg_out_a),

        .r_addr_b(instr_data[20:24]),
        .r_data_b(reg_out_b),

        .w_addr(instr_data[7:11]),
        .w_data(reg_in),
        .w_en(reg_write),

        .rst_n(rst_n),
        .clk(clk)
    );

endmodule