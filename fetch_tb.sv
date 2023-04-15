module fetch_tb ();
logic clk_i,reset;
logic [31:0] inst;
fetch f(.clk(clk_i),.reset(reset), .instruction(inst));

initial begin 
    	clk_i = 1'b1;
    	forever begin 
    		#10; clk_i = !clk_i;
    	end
    end
initial
begin
    reset=1; #10;
    reset=0; #10;
    reset=0;#10;
end
    
endmodule