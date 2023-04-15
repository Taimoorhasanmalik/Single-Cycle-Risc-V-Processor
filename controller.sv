module controller (
    input logic clk,reset,
    input logic[31:0] instruction, 
    input logic [31:0]comp_out,
    output logic load_store,
    output logic cs,id2rf_rd_wr_req_i,
    output logic rs2_sel,
    output logic [4:0]alu_op,
    output logic [2:0] load_ops, store_ops,
    output logic [2:0] br_sel,
    output logic rs1_sel,
    output logic [1:0] mem_to_reg
    );
logic [6:0]op_code;
logic[2:0] funct3;
logic[6:0] funct7;
assign op_code = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
always_comb 
begin 
    cs = 1;
    rs2_sel=0;
    rs1_sel=0;
    load_store=0;
    id2rf_rd_wr_req_i=0;
    alu_op=5'b00000;
    br_sel=3'b111;
    case (op_code)
        7'b0110011:begin // rtype
        rs1_sel=0;
        rs2_sel=0;
        mem_to_reg=0;
        id2rf_rd_wr_req_i=1;
        case (funct3)
        3'b000:begin
            case (funct7)
            7'b0000000: alu_op= 5'b00000;
            7'b0100000: alu_op= 5'b00001;
            default: alu_op= 5'b00000;
            endcase
            end
        3'b001: alu_op= 5'b00111;
        3'b010: alu_op= 5'b00010;
        3'b011: alu_op= 5'b00011;
        3'b100: alu_op= 5'b00100;
        3'b101:begin
            case (funct7)
            7'b0000000: alu_op= 5'b01000;
            7'b0100000: alu_op= 5'b01001;
            default: alu_op= 5'b00000;
            endcase
            end
        3'b110: alu_op= 5'b00110;
        3'b111: alu_op= 5'b00101;
        endcase
    end 
    7'b0000011: begin // load
    rs2_sel=1;
    alu_op= 5'b00000;
    mem_to_reg=1;
    id2rf_rd_wr_req_i=1;
        case (funct3)
        3'b000: begin load_store= 1; cs= 0; load_ops= 3'b000; end // load byte
        3'b001: begin load_store= 1; cs= 0; load_ops=3'b001; end // load byte unsigned
        3'b010: begin load_store= 1; cs= 0;load_ops= 3'b010; end // load half word
        3'b011: begin load_store= 1; cs= 0;load_ops= 3'b011; end // load half unsigned word
        3'b100: begin load_store= 1; cs= 0;load_ops= 3'b100; end // load word

        endcase
    end
    7'b0100011: // store
        begin
        rs2_sel=1;
        case (funct3)
        3'b000: begin load_store= 0; cs=0; store_ops=3'b000; end// store byte
        3'b001: begin load_store= 0; cs=0; store_ops=3'b001; end// store half word
        3'b010: begin load_store= 0; cs=0; store_ops = 3'b010; end// store word
        endcase
        end
    7'b0010011: begin // I type
    rs2_sel=1;
    id2rf_rd_wr_req_i=1;
        case (funct3)
        3'b000: alu_op= 5'b00000;
        3'b001: alu_op= 5'b00111;
        3'b010: case(funct7)
            7'b0000000: alu_op= 5'b00010;
            7'b0100000: alu_op= 5'b00011;
            endcase
        3'b011: alu_op= 5'b00011;
        3'b100: alu_op= 5'b00100;
        3'b101: alu_op= 5'b00101;
        3'b110: alu_op= 5'b00110;
        3'b111: alu_op= 5'b00101;
        endcase
    end
    7'b1100011: begin // branch
    rs2_sel=1;
    rs1_sel=1;
    alu_op = 5'b00000;
        case (funct3)
        3'b000: begin br_sel =3'b000; end // branch equal
        3'b001: begin br_sel =3'b001; end // branch not equal
        3'b100: begin br_sel =3'b100; end  // branch less than
        3'b101: begin br_sel =3'b101; end  // branch greater than or equal
        3'b110: begin br_sel =3'b110; end  // branch less than unsigned
        3'b111: begin br_sel =3'b011;  end  // branch greater than or equal unsigned
        default:begin  end // branch none
        endcase
    end
    7'b1100111: begin // jalr
        alu_op= 5'b00000;
        rs2_sel=1;
        rs1_sel=0;
        br_sel=3'b010;
         end
    7'b1101111: begin // jal
        alu_op= 5'b00000;
        rs2_sel=1;
        rs1_sel=1;
        br_sel=3'b010;


    end
    default: begin
        alu_op= 5'b00000;
        load_store= 0;
        rs2_sel=0;
        end

    endcase 
    end

endmodule