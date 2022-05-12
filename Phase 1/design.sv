module counter(GAMEOVER, WHO, control, INIT, initial_value, clk, reset);
  //defining inputs
  input control, INIT, initial_value, clk, reset;
  bit INIT, clk, reset;
  bit [3:0] initial_value;
  bit [1:0] control;
  
  //defining outputs
  output reg GAMEOVER;
  output reg [1:0] WHO;
  
  //defining internal signals
  bit WINNER, LOSER;
  bit [3:0] winner_count, loser_count; //bit [3:0] winner_count, loser_count;
  bit [3:0] counter;
  
  //initializing internal and output signals
  initial begin
    winner_count = 0;
    loser_count = 0;
    GAMEOVER = 0;
    WINNER = 0;
    LOSER = 0;
    WHO = 0;
    if(INIT)
      counter = initial_value;
    else
      counter = 0;
  end
  
  //Synchronous RESET
  always@(posedge clk) begin
    if(reset) begin
      GAMEOVER = 0;
      WHO = 0;
      counter = 0;
      WINNER = 0;
      LOSER = 0;
      winner_count = 0;
      loser_count = 0;
    end
  end
  
  always@(posedge INIT) begin
    counter = initial_value;
  end
  
  //counter changes with positive edge clock
  always@(posedge clk) begin
    
    if(INIT) begin
      counter = initial_value;
    end
    else begin
      
      //determine counter mode
    if(control == 2'b00) //up by 1's
      counter = counter + 1;
    else if(control == 2'b01) //up by 2's
      counter = counter + 2;
    else if(control == 2'b10) //down by 1's
      counter = counter - 1;
    else // down by 2's
      counter = counter - 2;
      
    end
    
    //setting LOSER or WINNER signals
    if(counter == 4'b1111) begin //counter is all ones
      WINNER = 1;
      #20 WINNER = 0; //WINNER remain high for 1 cycle
    end
    if(counter == 1'h0) begin //counter is all zeros
      LOSER = 1;
      #20 LOSER = 0; //LOSER remain high for 1 cycle
    end
  end
  
  //counting number of winner or loser signals with negative edge clock to ensure that WINNER or LOSER signals is high
  always@(posedge clk) begin
    if(WINNER == 1)
      winner_count = winner_count + 1;
    if(LOSER == 1)
      loser_count = loser_count + 1;
  end
  
  always@(posedge clk) begin
    //Handling the number of WINNER or LOSER signals
    if(winner_count == 4'b1111 || loser_count == 4'b1111) begin
      GAMEOVER = 1; //setting GAMEOVER high in each case
      if(winner_count == 4'b1111) //check number of winner signals
        WHO = 2'b10; //indicates that winner number is 15
      if(loser_count == 4'b1111) //check number of loser signals
        WHO = 2'b01; //indicates that loser number is 15
      
//       counter = INIT ? initial_value : 0; //counter starts again either from 0 or initial value
      #10 winner_count = 0;
      loser_count = 0;
      GAMEOVER = 0;
      WHO = 0;
    end
  end
  
endmodule