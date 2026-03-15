module register_file #(
    parameter   XLEN=32,
    parameter   ADDR_WIDTH=5,
    localparam  REG_DEPTH=2**ADDR_WIDTH
) (
    input  logic [ADDR_WIDTH-1:0]   raddr_a_i,
    output logic [XLEN-1:0]         rdata_a_o,

    input  logic [ADDR_WIDTH-1:0]   raddr_b_i,
    output logic [XLEN-1:0]         rdata_b_o,

    input  logic [ADDR_WIDTH-1:0]   waddr_i,
    input  logic [XLEN-1:0]         wdata_i,
    input  logic                    wen_i,

    input  logic                    rst_n,
    input  logic                    clk
);
    // memory[0] is always 0
    logic [XLEN-1:0] memory [1:REG_DEPTH-1];

    always_ff @( posedge clk ) begin
        if(!rst_n) begin
            foreach(memory[i]) begin
                memory[i] <= 0;
            end
        end else if(wen_i && waddr_i != 0) begin
            memory[waddr_i] <= wdata_i;
        end
    end

    assign rdata_a_o = raddr_a_i == 0 ? 0 : memory[raddr_a_i];
    assign rdata_b_o = raddr_b_i == 0 ? 0 : memory[raddr_b_i];
endmodule
