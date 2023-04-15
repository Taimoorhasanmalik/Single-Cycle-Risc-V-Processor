module imm_gen (input logic[31:0] instruction,
output logic [31:0] imm);

    logic [31:0] imm_u;
    logic [31:0] imm_j;
    logic [31:0] imm_b;
    logic [31:0] imm_i;
    logic [31:0] imm_s;
    logic [2:0]sel;
    logic [6:0]op_code;
    assign op_code = instruction[6:0];
    
    always_comb begin
        case(op_code)
        7'b0110111: sel = 3'b000;
        7'b0010111: sel = 3'b000;
        7'b1101111: sel = 3'b001;
        7'b1100111: sel = 3'b001;
        7'b1100011: sel = 3'b010;
        7'b0000011: sel = 3'b011;
        7'b0100011: sel = 3'b100;
        7'b0010011: sel = 3'b011;
        7'b0110011: sel = 3'b011;
        7'b0000011: sel = 3'b100;
        7'b0100011: sel = 3'b100;
        default: sel = 3'b111;
    endcase
    imm_u = { {12{instruction[31]}}, instruction[31:12], 12'b0 };
    imm_j = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
    imm_b = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
    imm_i = { {20{instruction[31]}}, instruction[31:20] };
    imm_s = { {20{instruction[31]}}, instruction[31], instruction[30:25], instruction[11:7]};

    case (sel)
        3'b000: imm = imm_u;
        3'b001: imm = imm_j;
        3'b010: imm = imm_b;
        3'b011: imm = imm_i;
        3'b100: imm = imm_s;
        default: imm = 32'b0;
    endcase
    
    
    end
    
endmodule