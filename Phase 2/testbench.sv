// ----------------- interface declaration --------------------------------- //
interface inter(input bit clk);
  bit GAMEOVER;
  bit [1:0] WHO;
  bit [1:0] control;
  bit INIT;
  bit [3:0] initial_value;
  bit reset;
  
  //defining internal signals
  bit WINNER, LOSER;
  bit [3:0] winner_count, loser_count;
  bit [3:0] counter;
  
  // -------- Assertion ------- //
  property reset_prop;
    @(reset) reset |-> (winner_count == 0);
  endproperty
  
  reset_check: assert property(reset_prop)
    $display("process is true as winner_count = 0 @ %0t", $time);
    /***************************/
  property WHO_prop;
    @(WHO) WHO |-> (GAMEOVER == 1);
  endproperty
    
  WHO_check: assert property(WHO_prop)
    $display("WHO implies GAMEOVER @ %0t", $time);
    /****************************/
  property INIT_prop;
    @(INIT) INIT |-> (counter == initial_value);
  endproperty
    
  INIT_check: assert property(INIT_prop)
    $display("INIT implies equaling counter of initial_value @ %0t", $time);
  // -------------------------------------
    
  // ---------------- clocking block -------------//
  clocking cb @(posedge clk);
    default input #10ns output #2ns;
    output control, initial_value, reset, INIT;
    input GAMEOVER, WHO, WINNER, LOSER, winner_count, loser_count, counter;
  endclocking
  
  modport dg(input control, INIT, initial_value, reset, clk, output GAMEOVER, WHO, WINNER, LOSER, winner_count, loser_count, counter);
  modport tb(clocking cb);
  
endinterface
// ------------------------------------------------------------------------------------//
    
   
// ----------------- test program declaration --------------------------------- //
program test(inter.tb t);
  
  initial begin
    t.cb.INIT <= 0;
    t.cb.initial_value  <= 4'b0001;
    t.cb.control <= 2'b00;
  end
    
  initial begin
    #45 t.cb.INIT <= 1;
    #5 t.cb.INIT <= 0;
    #20 t.cb.initial_value <= 15;
    t.cb.INIT <= 1;
    #10 t.cb.INIT <= 0;
    #20 t.cb.reset <= 1;
    #15 t.cb.reset <= 0;
    #55 t.cb.control <= 2'b01;
    #2510 t.cb.INIT <= 1;
    t.cb.initial_value <= 4;
    t.cb.control <= 2'b10;
    #5 t.cb.INIT <= 0;
    #4625 t.cb.INIT <= 1;
    t.cb.initial_value <= 9;
    t.cb.control <= 2'b11;
    #5 t.cb.INIT <= 0;
    #20 t.cb.reset <= 1;
    #60 t.cb.reset <= 0;
    
  end  
endprogram
// -------------------------------------------------------------------------------------//