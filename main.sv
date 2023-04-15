module main (input clk,reset);
logic id2rf_rd_wr_req_i,load_store, cs;
logic [31:0] instruction;
logic [4:0] id2rf_rs1_addr_i,id2rf_rs2_addr_i,id2rf_rd_addr_i;

logic [31:0] rf2id_rs1_data_o,rf2id_rs2_data_o,id2rf_rd_data_i,rf2id_rs1_data_i,rf2id_rs2_data_i;
logic [31:0] alu_result_o;
logic [31:0] imm_val,pc;
logic [4:0] alu_op_i;
logic rs2_sel;
logic branch_taken;
logic [31:0] pc_next,comp_out;
logic [1:0] mem_to_reg;
logic rs1_sel;
logic [31:0] lsu_addr_in,lsu_data_in,lsu_data_out;
logic [2:0] load_ops,store_ops;
logic [2:0] br_sel;

fetch fetch(.clk(clk),.address(pc),.branch_taken(branch_taken),.alu_out(alu_result_o),.reset(reset), .instruction(instruction));

register_file register(.clk(clk),.reset(reset), .id2rf_rd_wr_req_i(id2rf_rd_wr_req_i), .id2rf_rs1_addr_i(id2rf_rs1_addr_i), .id2rf_rs2_addr_i(id2rf_rs2_addr_i), .id2rf_rd_addr_i(id2rf_rd_addr_i), .id2rf_rd_data_i(id2rf_rd_data_i), .rf2id_rs1_data_o(rf2id_rs1_data_o), .rf2id_rs2_data_o(rf2id_rs2_data_o));

controller control(.mem_to_reg(mem_to_reg),.rs1_sel(rs1_sel),.br_sel(br_sel),.clk(clk),.reset(reset),.id2rf_rd_wr_req_i(id2rf_rd_wr_req_i),.instruction(instruction),.comp_out(comp_out),.alu_op(alu_op_i),.load_store(load_store),.cs(cs),.rs2_sel(rs2_sel),.load_ops(load_ops),.store_ops(store_ops));

alu alu( .rf2id_rs1_data_i(rf2id_rs1_data_i), .rf2id_rs2_data_i(rf2id_rs2_data_i),.alu_op_i(alu_op_i), .alu_result_o(alu_result_o));

imm_gen imm(.instruction(instruction),.imm(imm_val));

loadstore loadst(.clk(clk),.load_store(load_store),.cs(cs),.load_ops(load_ops),.store_ops(store_ops),.addr(lsu_addr_in),.data_in(lsu_data_in),.data_out(lsu_data_out));

comparator comp(.a(rf2id_rs1_data_o),.b(rf2id_rs2_data_o),.c(comp_out),.br_sel(br_sel),.branch_taken(branch_taken));

assign lsu_data_in= rf2id_rs2_data_o;
assign lsu_addr_in= alu_result_o;
assign id2rf_rs1_addr_i = instruction[19:15];
assign id2rf_rs2_addr_i = instruction[24:20];
assign id2rf_rd_addr_i = instruction[11:7];
 
always_comb begin
case(rs1_sel)
0: begin rf2id_rs1_data_i= rf2id_rs1_data_o; end
1: begin rf2id_rs1_data_i=pc ; end
default: begin rf2id_rs1_data_i= rf2id_rs1_data_o; end
endcase
case (rs2_sel)
0: begin rf2id_rs2_data_i= rf2id_rs2_data_o; end
1: begin rf2id_rs2_data_i= imm_val; end
default: begin rf2id_rs2_data_i= rf2id_rs2_data_o; end
endcase
case (mem_to_reg)
2'b00: begin id2rf_rd_data_i= alu_result_o; end
2'b01: begin id2rf_rd_data_i= lsu_data_out; end
2'b10: begin id2rf_rd_data_i= pc+4; end
default: begin id2rf_rd_data_i= alu_result_o; end
endcase


end


endmodule