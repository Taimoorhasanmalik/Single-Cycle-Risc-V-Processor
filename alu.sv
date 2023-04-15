module alu (
    input logic [31:0] rf2id_rs1_data_i, rf2id_rs2_data_i,
    input logic [4:0] alu_op_i,
    output logic [31:0] alu_result_o
);

always_comb begin
    case (alu_op_i)
        5'b00000: alu_result_o = rf2id_rs1_data_i + rf2id_rs2_data_i;
        5'b00001: alu_result_o = rf2id_rs1_data_i - rf2id_rs2_data_i;
        5'b00010: alu_result_o = $signed(rf2id_rs1_data_i) < $signed(rf2id_rs2_data_i);
        5'b00011: alu_result_o = rf2id_rs1_data_i < rf2id_rs2_data_i;
        5'b00100: alu_result_o = rf2id_rs1_data_i ^ rf2id_rs2_data_i;
        5'b00101: alu_result_o = rf2id_rs1_data_i & rf2id_rs2_data_i;
        5'b00110: alu_result_o = rf2id_rs1_data_i | rf2id_rs2_data_i;
        5'b01000: alu_result_o = rf2id_rs1_data_i >> rf2id_rs2_data_i[4:0];
        5'b00111: alu_result_o = rf2id_rs1_data_i << rf2id_rs2_data_i[4:0];
        5'b01001: alu_result_o = rf2id_rs1_data_i >>> rf2id_rs2_data_i[4:0];
        5'b01001: alu_result_o = rf2id_rs2_data_i;

endcase
end
endmodule