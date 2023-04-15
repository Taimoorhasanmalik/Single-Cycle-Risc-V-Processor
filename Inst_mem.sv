module instr_mem (input logic [31:0] pc,
                  output logic [32-1:0] inst);

logic [7:0] inst_memory [256];
initial 
begin
    $readmemh("/mnt/c/Users/Dell/Desktop/EE2020_Semester_6/Computer_Architecture_Lab/lab4Rtype/main.txt", inst_memory);
end
assign   inst = {inst_memory[pc],inst_memory[pc+1],inst_memory[pc+2],inst_memory[pc+3]};

endmodule