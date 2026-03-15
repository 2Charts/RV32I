module rv32_lsu
    import rv32_pkg::*; 
(
    input  logic [31:0] lsu_addr_i,
    input  logic [31:0] lsu_data_i,
    output logic [31:0] lsu_data_o,

    output logic [31:0] mem_addr_o,
    input  logic [31:0] mem_rdata_i,
    output logic [31:0] mem_wdata_o,
    output logic [3:0]  mem_be_o,
    output logic        mem_wen_o,

    input  logic        lsu_en_i,
    input  lsu_op_e     lsu_op_i,
    output logic        lsu_misaligned_o
);
    logic sign_ext;
    assign sign_ext = lsu_op_i == LSU_LB || lsu_op_i == LSU_LH ? 1 : 0;

    assign mem_addr_o = {lsu_addr_i[31:2], 2'b00};

    always_comb begin
        lsu_data_o = 0;
        mem_wen_o = 0;
        mem_wdata_o = 0;
        mem_be_o = 0;
        lsu_misaligned_o = 0;

        if (lsu_en_i) begin
            unique case (lsu_op_i)
                LSU_LB, LSU_LBU: begin
                    unique case (lsu_addr_i[1:0])
                        2'b00: lsu_data_o = {{24{sign_ext & mem_rdata_i[7]}},  mem_rdata_i[7:0]};
                        2'b01: lsu_data_o = {{24{sign_ext & mem_rdata_i[15]}}, mem_rdata_i[15:8]};
                        2'b10: lsu_data_o = {{24{sign_ext & mem_rdata_i[23]}}, mem_rdata_i[23:16]};
                        2'b11: lsu_data_o = {{24{sign_ext & mem_rdata_i[31]}}, mem_rdata_i[31:24]};
                    endcase
                end
                LSU_LH, LSU_LHU: begin
                    unique case (lsu_addr_i[1:0])
                        2'b00: lsu_data_o = {{16{sign_ext & mem_rdata_i[15]}}, mem_rdata_i[15:0]};
                        2'b01: lsu_data_o = {{16{sign_ext & mem_rdata_i[23]}}, mem_rdata_i[23:8]};
                        2'b10: lsu_data_o = {{16{sign_ext & mem_rdata_i[31]}}, mem_rdata_i[31:16]};
                        2'b11: lsu_misaligned_o = 1; 
                    endcase
                end
                LSU_LW: begin
                    if (lsu_addr_i[1:0] == 0) begin
                        lsu_data_o = mem_rdata_i;
                    end else begin
                        lsu_misaligned_o = 1;
                    end
                end
                LSU_SB: begin
                    mem_wen_o = 1;
                    unique case (lsu_addr_i[1:0])
                        2'b00: begin
                            mem_wdata_o = {24'd0, lsu_data_i[7:0]};
                            mem_be_o = 4'b0001;
                        end
                        2'b01: begin
                            mem_wdata_o = {16'd0, lsu_data_i[7:0], 8'd0};
                            mem_be_o = 4'b0010;
                        end
                        2'b10:begin
                            mem_wdata_o = {8'd0, lsu_data_i[7:0], 16'd0};
                            mem_be_o = 4'b0100;
                        end
                        2'b11: begin
                            mem_wdata_o = {lsu_data_i[7:0], 24'd0};
                            mem_be_o = 4'b1000;
                        end
                    endcase
                end
                LSU_SH: begin
                    unique case (lsu_addr_i[1:0])
                        2'b00: begin
                            mem_wen_o = 1;
                            mem_wdata_o = {16'd0, lsu_data_i[15:0]};
                            mem_be_o = 4'b0011;
                        end
                        2'b01: begin
                            mem_wen_o = 1;
                            mem_wdata_o = {8'd0, lsu_data_i[15:0], 8'd0};
                            mem_be_o = 4'b0110;
                        end
                        2'b10: begin
                            mem_wen_o = 1;
                            mem_wdata_o = {lsu_data_i[15:0], 16'd0};
                            mem_be_o = 4'b1100;
                        end
                        2'b11: lsu_misaligned_o = 1;
                    endcase
                end
                LSU_SW: begin
                    if (lsu_addr_i[1:0] == 0) begin
                        mem_wdata_o = lsu_data_i;
                    end else begin
                        lsu_misaligned_o = 1;
                    end
                end
            endcase
        end
    end

endmodule
