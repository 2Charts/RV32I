module tb_alu;

    logic [31:0] opr_a;
    logic [31:0] opr_b;
    logic [3:0]  mode;
    /* verilator lint_off UNUSEDSIGNAL */
    logic [31:0] result;
    /* verilator lint_on UNUSEDSIGNAL */

    rv32_alu alu(.*);

    `define ALU_ADD     4'b0000
    `define ALU_SUB     4'b1000
    `define ALU_SLL     4'b0001
    `define ALU_SLT     4'b0010
    `define ALU_SLTU    4'b0011
    `define ALU_XOR     4'b0100
    `define ALU_SRL     4'b0101
    `define ALU_SRA     4'b1101
    `define ALU_OR      4'b0110
    `define ALU_AND     4'b0111

    initial begin
        $dumpfile("wave.fst");
        $dumpvars;

        opr_a = 0;
        opr_b = 0;
        mode  = 0;
        #1;

        opr_a = 32'd12;
        opr_b = 32'd12;
        mode  = `ALU_ADD;
        #1;
        
        assert(result == 32'd24);
    
        mode = `ALU_SUB;
        #1;
    
        assert(result == 0);
    
        opr_a = 32'd25;
        opr_b = 32'd31;
        mode = `ALU_SLL;
        #1

        assert(result == 32'h8000_0000);

        opr_a = $unsigned(-1);
        opr_b = 1;
        mode = `ALU_SLT;
        #1;
    
        assert(result == 1);

        mode = `ALU_SLTU;
        #1;

        assert(result == 0);

        opr_a = 32'h0000_FFFF;
        opr_b = 32'hFFFF_FFFF;
        mode = `ALU_XOR;
        #1;

        assert(result == 32'hFFFF_0000);

        opr_a = 32'h0000_FFFF;
        opr_b = 32'd16;
        mode = `ALU_SRL;
        #1;

        assert(result == 0);

        opr_a = 32'h8000_0000;
        opr_b = 32'd3;
        mode = `ALU_SRA;
        #1;

        assert(result == 32'hF000_0000);

        opr_a = 32'hFFFF_FF00;
        opr_b = 32'h0000_FF00;
        mode = `ALU_OR;
        #1;

        assert(result == 32'hFFFF_FF00);

        mode = `ALU_AND;
        #1;

        assert(result == 32'h0000_FF00);

        $finish;
    end
    
endmodule
