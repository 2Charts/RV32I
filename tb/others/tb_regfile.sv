module tb_regfile;

/* verilator lint_off UNUSEDSIGNAL */
    logic [4:0]   r_addr_a = 0;
    logic [31:0]  r_data_a;

    logic [4:0]   r_addr_b = 0;
    logic [31:0]  r_data_b;

    logic [4:0]   w_addr = 0;
    logic [31:0]  w_data = 0;
    logic         w_en = 0;

    logic         rst_n = 1;
    logic         clk;
/* verilator lint_on UNUSEDSIGNAL */

    initial clk = 0;
    always #5 clk = ~clk;

    register_file regfile(.*);

    initial begin
        $dumpfile("wave.fst");
        $dumpvars;

        rst_n = 0;
        @(posedge clk);
        @(negedge clk);

        rst_n = 1;
        @(posedge clk);

        for(int i = 0; i < 32; i++) begin
            r_addr_a = 5'(i);
            @(posedge clk);
            assert(r_data_a == 0);
            @(negedge clk);
        end

        @(posedge clk);

        for(int i = 0; i < 32; i++) begin
            w_addr = 5'(i);
            w_data = 32'(i);
            w_en = 'b1;
            @(posedge clk);
            @(negedge clk);
        end;

        @(posedge clk);

        for(int i = 0; i < 32; i++) begin
            r_addr_b = 5'(i);
            @(posedge clk);
            assert(r_data_b == 32'(i));
            @(negedge clk);
        end

        $finish;
    end

endmodule
