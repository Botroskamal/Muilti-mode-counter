// --------------------------------- design module ----------------------------//
module counter(inter.dg dc);
  
  //initializing internal and output signals
  initial begin
    dc.winner_count = 0;
    dc.loser_count = 0;
    dc.GAMEOVER = 0;
    dc.WINNER = 0;
    dc.LOSER = 0;
    dc.WHO = 0;
    if(dc.INIT)
      dc.counter = dc.initial_value;
    else
      dc.counter = 0;
  end
  
  //Synchronous RESET
  always@(posedge dc.clk) begin
    if(dc.reset) begin
      dc.GAMEOVER = 0;
      dc.WHO = 0;
      dc.counter = 0;
      dc.WINNER = 0;
      dc.LOSER = 0;
      dc.winner_count = 0;
      dc.loser_count = 0;
    end
  end
  
  always@(posedge dc.INIT) begin
    dc.counter = dc.initial_value;
  end
  
  //counter changes with positive edge clock
  always@(posedge dc.clk) begin
    
    if(dc.INIT) begin
      dc.counter = dc.initial_value;
    end
    else begin
      
      //determine counter mode
      if(dc.control == 2'b00) //up by 1's
        dc.counter = dc.counter + 1;
      else if(dc.control == 2'b01) //up by 2's
        dc.counter = dc.counter + 2;
      else if(dc.control == 2'b10) //down by 1's
        dc.counter = dc.counter - 1;
      else // down by 2's
        dc.counter = dc.counter - 2;
    end
    
    //setting LOSER or WINNER signals
    if(dc.counter == 4'b1111) begin //counter is all ones
      dc.WINNER = 1;
      #20 dc.WINNER = 0; //WINNER remain high for 1 cycle
    end
    if(dc.counter == 1'h0) begin //counter is all zeros
      dc.LOSER = 1;
      #20 dc.LOSER = 0; //LOSER remain high for 1 cycle
    end
  end
  
  //counting number of winner or loser signals with negative edge clock 
    //  to ensure that WINNER or LOSER signals is high
  always@(posedge dc.clk) begin
    if(dc.WINNER == 1)
      dc.winner_count = dc.winner_count + 1;
    if(dc.LOSER == 1)
      dc.loser_count = dc.loser_count + 1;
  end
  
  always@(posedge dc.clk) begin
    //Handling the number of WINNER or LOSER signals
    if(dc.winner_count == 4'b1111 || dc.loser_count == 4'b1111) begin
      dc.GAMEOVER = 1; //setting GAMEOVER high in each case
      if(dc.winner_count == 4'b1111) //check number of winner signals
        dc.WHO = 2'b10; //indicates that winner number is 15
      if(dc.loser_count == 4'b1111) //check number of loser signals
        dc.WHO = 2'b01; //indicates that loser number is 15
      
      //counter = INIT ? initial_value : 0; //counter starts again either from 0 or initial value
      #10 dc.winner_count = 0;
      dc.loser_count = 0;
      dc.GAMEOVER = 0;
      dc.WHO = 0;
    end
  end
  
endmodule
// ----------------------------------------------------------------------------------------------------------//


// ------------------------------------- top module --------------------------------------//
module top(output bit clk);
  initial begin
    forever #10 clk = ~clk;
  end
  
  inter in(clk);
  counter cn(in.dg);
  test t(in.tb);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
  end
  
endmodule

// ------------------------------------------------------------------------------------------//