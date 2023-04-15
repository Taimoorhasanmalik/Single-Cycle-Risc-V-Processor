module loadstore (
    input logic  clk,load_store,cs,
    input logic [2:0] load_ops, store_ops,
    input logic [31:0] addr,
    input logic [31:0] data_in,
    output logic [31:0] data_out);
    reg [31:0] mem [0:255];
    logic load,store;
    logic[3:0] mask;
    logic [7:0] data_byte;
    logic [15:0]data_hword;
    logic [31:0]data_word;
    logic [31:0] data_wr;

    assign load= ~(~load_store & ~cs);
    assign store= ~load_store & ~cs;
always_comb begin
    if (load) begin
    data_byte= '0;
    data_hword='0;
    data_word='0;
    case (load_ops)
    3'b000 , 3'b001:begin  // load byte, load byte unsigned
    case (addr[1:0])
    2'b00: data_byte= mem[addr] [7:0];
    2'b01: data_byte= mem[addr] [15:8];
    2'b10: data_byte= mem[addr] [23:16];
    2'b11: data_byte= mem[addr] [31:24];
    endcase
    end
    3'b010 , 3'b011:begin  // load byte, load byte unsigned
    case (addr[1])
    1'b0: data_hword= mem[addr] [15:0];
    1'b1: data_hword= mem[addr] [31:16];
    endcase
    end
    3'b100: begin
        data_word= mem[addr];
    end
    endcase
end
end
always_comb
begin
    case (load_ops)
       3'b000 :data_out= {{24{data_byte[7]}},data_byte}; // Byte signed
       3'b001 :data_out= {24'b0,data_byte};
       3'b010 :data_out= {{16{data_hword[15]}},data_hword};
       3'b011 :data_out= {16'b0,data_hword};
       3'b011 :data_out= {16'b0,data_word};
default: data_out= '0;
    endcase
end
always_comb
begin
    if (store) 
    begin
        data_wr = '0;
        mask= '0;
        case (store_ops)
            3'b000: begin // Store byte
                case (addr[1:0])
                    2'b00: begin data_wr[7:0] = data_in[7:0]; mask=4'b0001;  end
                    2'b01: begin data_wr[15:8] = data_in[15:8]; mask=4'b0010;end
                    2'b10: begin data_wr[23:16] = data_in[23:16]; mask=4'b0100;end
                    2'b11: begin data_wr[31:24] = data_in[31:24]; mask=4'b1000;end
                endcase
            end
            3'b001: begin // Store halfword
            case (addr[1])
            1'b0: begin data_wr[15:0] = data_in[15:0];mask= 4'b0011; end
            1'b1: begin data_wr[31:16] = data_in[31:16];mask= 4'b1100; end
            endcase
            end
            3'b010: begin // Store word
                data_wr = data_in;
                mask= 4'b1111;
            end
            default: begin
                data_wr = '0;
                mask= '0;
            end
        endcase
    end

end



always_ff @( negedge clk ) begin 
    if (~cs && ~load_store)
    begin
        if (mask[0])
        begin
            mem[addr][7:0] <= data_wr[7:0];
        end 
        if (mask[1])
        begin
            mem[addr][15:8] <= data_wr[15:8];
        end
        if (mask[2])
        begin
            mem[addr][23:16] <= data_wr[23:16];
        end
        if (mask[3])
        begin
            mem[addr][31:24] <= data_wr[31:24];
        end
    end
end
endmodule