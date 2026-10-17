module FSM_tester(); 
  logic clk, reset_n; 
  logic recv_valid; 
  logic [7:0] recv_data; 
  logic [7:0] A, B, operand; 
  logic ALU_valid; 
  logic operation_done; 
  logic [7:0] C; 
  logic [7:0] send_data; 
  logic send_valid; 

  FSM tb(.*); 

  initial begin 
    clk = 0; 
    forever #5 clk = ~clk; 
  end

  initial begin 
    $monitor($time,, "recv_data: %d, A: %d, B: %d, operand: %d, ALU_valid: %d, send_data: %d, send_valid: %d, currState: %s", 
             recv_data, A, B, operand, ALU_valid, send_data, send_valid, tb.currState); 

    reset_n = 0; 

    operation_done = 0; 

    @(posedge clk); 

    reset_n = 1; 

    recv_valid = 1; 
    recv_data = 3'b001; 

    @(posedge clk); 

    recv_data = 3'b010; 

    @(posedge clk); 

    recv_data = 3'b100; 

    @(posedge clk); 

    operation_done = 1; 

    @(posedge clk); 

    $finish; 

  end

endmodule: fsm_tb


