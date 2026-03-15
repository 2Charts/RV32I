module rv32_lsu
    import rv32_pkg::*; 
(
    input  logic [31:0] addr_in,
    input  logic [31:0] data_in,
    output logic [31:0] data_out,

    output logic [31:0] rw_addr,
    input  logic [31:0] r_data,
    output logic [31:0] w_data,
    output logic [3:0]  w_be,
    output logic        w_en,

    input  logic        lsu_en,
    input  lsu_op_t     lsu_op,
);

logic sign_ext;
assign sign_ext = lsu_mode == LSU_LB or lsu_mode == LSU_LH ? 1 : 0;

assign rw_addr = {addr_in[31:2], 2'b00};

always_comb begin
    data_out = 0;
    w_en = 0;
    w_data = 0;
    w_be = 0;

    if (lsu_en) begin
        unique case (lsu_op)
            LSU_LB, LSU_LBU: begin
                unique case (addr_in[1:0])
                    2'b00: data_out = {{24{sign_ext & r_data[7]}},  r_data[7:0]};
                    2'b01: data_out = {{24{sign_ext & r_data[15]}}, r_data[15:8]};
                    2'b10: data_out = {{24{sign_ext & r_data[23]}}, r_data[23:16]};
                    2'b11: data_out = {{24{sign_ext & r_data[31]}}, r_data[31:24]};
                endcase
            end
            LSU_LH, LSU_LHU: begin
                unique case (addr_in[1:0])
                    2'b00: data_out = {{16{sign_ext & r_data[15]}}, r_data[15:0]};
                    2'b01: data_out = {{16{sign_ext & r_data[23]}}, r_data[23:8]};
                    2'b10: data_out = {{16{sign_ext & r_data[31]}}, r_data[31:16]};
                    2'b11: ; // misaligned load
                endcase
            end
            LSU_LW: begin
                if (addr_in[1:0] == 0) begin
                    data_out = r_data;
                end 
                // else, misaligned load
            end
            LSU_SB: begin
                w_en = 1;
                unique case (addr_in[1:0])
                    2'b00: begin
                        w_data = {24'd0, data_in[7:0]};
                        w_be = 4'b0001;
                    end
                    2'b01: begin
                        w_data = {16'd0, data_in[7:0], 8'd0};
                        w_be = 4'b0010;
                    end
                    2'b10:begin
                        w_data = {8'd0, data_in[7:0], 16'd0};
                        w_be = 4'b0100;
                    end
                    2'b11: begin
                        w_data = {data_in[7:0], 24'd0};
                        w_be = 4'b1000;
                    end
                endcase
            end
            LSU_SH: begin
                unique case (addr_in[1:0])
                    2'b00: begin
                        w_en = 1;
                        w_data = {16'd0, data_in[15:0]};
                        w_be = 4'b0011;
                    end
                    2'b01: begin
                        w_en = 1;
                        w_data = {8'd0, data_in[15:0], 8'd0};
                        w_be = 4'b0110;
                    end
                    2'b10: begin
                        w_en = 1;
                        w_data = {data_in[15:0], 16'd0};
                        w_be = 4'b1100;
                    end
                    2'b11: // misaligned_store = 1;
                endcase
            end
            LSU_SW:  begin
                if (addr_in[1:0] == 0) begin
                    w_data = data_in;
                end 
                // else, misaligned store
            end
        endcase
    end
end

endmodule
