module register_tb (
    );
  logic  clk,reset,id2rf_rd_wr_req_i;
  logic   [5:0] id2rf_rs1_addr_i,id2rf_rs2_addr_i,id2rf_rd_addr_i;
   logic  [32-1:0] id2rf_rd_data_i;
    logic [32-1:0] rf2id_rs1_data_o,rf2id_rs2_data_o;

register_file regi( clk,reset,id2rf_rd_wr_req_i,
      id2rf_rs1_addr_i,id2rf_rs2_addr_i,id2rf_rd_addr_i,
      id2rf_rd_data_i,
     rf2id_rs1_data_o,rf2id_rs2_data_o );

    initial begin
      clk=0;
    forever begin
      #10 clk = ~clk;
    end
    end
    initial
    begin
    reset = 1;
    #20 reset = 0;
    #10 id2rf_rs1_addr_i= 5'b10101;
    #10 id2rf_rs2_addr_i= 5'b10010;
    #10 id2rf_rd_addr_i= 5'b10001;
    #10 id2rf_rd_wr_req_i= 1'b1;
    #10 id2rf_rd_data_i= 32'b10101010101010101010101010101010;
    #10 id2rf_rd_wr_req_i= 1'b0;

    end




endmodule