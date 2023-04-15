module main_tb ();
    logic clk, reset;
    main main(clk, reset);
    initial begin
        clk = 0;
        reset = 0;
        forever begin
            #5 clk = ~clk;
        end
    end
    initial begin
         reset = 1;
        #10 reset = 0;
        
    end
endmodule