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




endmodule
