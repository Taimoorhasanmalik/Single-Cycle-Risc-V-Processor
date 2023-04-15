module comparator (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [2:0] br_sel,
    output logic [31:0] c,
    output logic branch_taken
    );
    
assign comp_out = (a - b);
always_comb begin
    branch_taken = 1'b0;
case (br_sel)
        3'b000: begin branch_taken= |comp_out? 0:1 ; end // branch equal
        3'b001: begin branch_taken= |comp_out ? 1:0; end // branch not equal
        3'b100: begin branch_taken= ($signed(a)<$signed(b))? 1:0;  end  // branch less than
        3'b101: begin branch_taken= ($signed(a)>=$signed(b))? 1:0;end  // branch greater than or equal
        3'b110: begin branch_taken = (a<b)? 1:0; end  // branch less than unsigned
        3'b011: begin branch_taken = (a>=b)? 1:0; end  // branch greater than or equal unsigned
        3'b010: begin branch_taken = 1'b1; end // branch always
        3'b111: begin branch_taken = 1'b0; end // branch never
        endcase
end

    
endmodule