module test();
  bit GAMEOVER;
  bit [1:0] WHO;
  bit [1:0] control;
  bit INIT;
  bit [3:0] initial_value;
  bit clk;
  bit reset;
  
  initial begin
    INIT = 0;
    initial_value  = 4'b0001;
    control = 2'b00;
    clk = 0;
    forever #10 clk = ~clk;
  end
  
  initial begin
    #45 INIT = 1;
    #5 INIT = 0;
    #20 initial_value = 15;
    INIT = 1;
    #10 INIT = 0;
    #20 reset = 1;
    #15 reset = 0;
    #55 control = 2'b01;
    #2510 INIT = 1;
    initial_value = 4;
    control = 2'b10;
    #5 INIT = 0;
    #4625 INIT = 1;
    initial_value = 9;
    control = 2'b11;
    #5 INIT = 0;
    #20 reset = 1;
    #60 reset = 0;
    
  end
  counter c(GAMEOVER, WHO, control, INIT, initial_value, clk, reset);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #10000 $finish;
  end
  
endmodule