module register_file (
    input logic reset,id2rf_rd_wr_req_i,clk,
    input logic [4:0] id2rf_rs1_addr_i,id2rf_rs2_addr_i,id2rf_rd_addr_i,
    input logic [32-1:0] id2rf_rd_data_i,
    output logic [32-1:0] rf2id_rs1_data_o,rf2id_rs2_data_o
    );
logic [31:0] register_file [32];
assign rs1_addr_valid = |id2rf_rs1_addr_i; // or of all bits of rs1 address to see if its non zero
assign rs2_addr_valid = |id2rf_rs2_addr_i; // or of all bits of rs2 address to see if its non zero
assign rf_wr_valid = |id2rf_rd_addr_i & id2rf_rd_wr_req_i; // or of all bits of rd address to see if its non zero and write request is high

assign rf2id_rs1_data_o= (rs1_addr_valid)
                        ? register_file[id2rf_rs1_addr_i]
                        : '0;
                    
assign rf2id_rs2_data_o= (rs2_addr_valid)
                        ? register_file[id2rf_rs2_addr_i]
                        : '0;
always_ff @(posedge clk) begin
    if (reset)
    begin
        register_file <= '{default: '0};
    end
    else
    begin
        if (rf_wr_valid)
        begin
            register_file[id2rf_rd_addr_i] <= id2rf_rd_data_i;
        end
    end
end


endmodule