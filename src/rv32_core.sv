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


endmodule
