module top_test(); 
  logic       clk, reset_n;
  logic       operation_done;

  logic       recv_valid;
  logic [7:0] recv_data;

  logic [7:0] C;
  logic [7:0] A, B, operand;

  logic       ALU_valid;
  logic [7:0] send_data;
  logic       send_valid; 

  top dut(.*); 
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  initial begin
    $monitor($time,, "%d, operand: %b, %d = %d", A, operand, B, C);
    reset_n= 0;
    recv_valid = 0; recv_data = 0; 

    @(negedge clk); @(negedge clk); 

    reset_n = 1; 
    recv_data = 8'b001;
    recv_valid = 1; 

    @(negedge clk); recv_data = 8'b001;

    @(negedge clk); recv_data = 8'b100;
    
    @(negedge clk); recv_valid = 0; 
    @(negedge clk); @(negedge clk);

    @(negedge clk); @(negedge clk);

    @(negedge clk); @(negedge clk); 

    reset_n = 0; 

    @(negedge clk); @(negedge clk); 

    reset_n = 1;
    recv_valid = 1; 
    recv_data = 8'b100; 

    @(negedge clk); recv_data= 8'b100; 

    @(negedge clk); recv_data = 8'b010;
    @(negedge clk); recv_valid = 0; 

    @(negedge clk); @(negedge clk); 
    @(negedge clk); @(negedge clk); 

    @(negedge clk); @(negedge clk); 
    @(negedge clk); $finish;

  end
endmodule: top_test

