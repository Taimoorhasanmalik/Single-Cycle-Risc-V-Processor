module fetch (input logic clk,reset,branch_taken,
input logic [31:0] alu_out,
 output logic [31:0] instruction,address);
instr_mem imem(.pc(address),.inst(instruction));
always_ff @( posedge clk ) begin
    if (reset)
    address <= 0;
    else
    if (branch_taken)
    address <= alu_out;
    else
    address <= address + 4;
end
endmodule