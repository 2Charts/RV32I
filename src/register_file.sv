module register_file #(
    parameter   XLEN=32,
    parameter   ADDR_WIDTH=5,
    localparam  REG_DEPTH=2**ADDR_WIDTH
) (
    input  logic [ADDR_WIDTH-1:0]   r_addr_a,
    output logic [XLEN-1:0]         r_data_a,

    input  logic [ADDR_WIDTH-1:0]   r_addr_b,
    output logic [XLEN-1:0]         r_data_b,

    input  logic [ADDR_WIDTH-1:0]   w_addr,
    input  logic [XLEN-1:0]         w_data,
    input  logic                    w_en,

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
        end else if(w_en && w_addr != 0) begin
            memory[w_addr] <= w_data;
        end
    end

    assign r_data_a = r_addr_a == 0 ? 0 : memory[r_addr_a];
    assign r_data_b = r_addr_b == 0 ? 0 : memory[r_addr_b];
endmodule
