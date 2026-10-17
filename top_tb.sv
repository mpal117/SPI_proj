module top_test(); 
  logic clk, reset_n; 
  logic sclk, cs_n; 
  logic mosi, miso; 

  top dut(.clk(clk), .reset_n(reset_n), 
          .sclk(sclk), .cs_n(cs_n), 
          .mosi(mosi), .miso(miso)); 

  initial begin 
    clk = 0; 
    forever #5 clk = ~clk; 
  end


  logic [7:0] operation, A, B, out; 

  assign operation = 7'd1; 
  assign  A = 7'd1; 
  assign  B = 7'd2;


  task write_spi (input [7:0] value); 
      for (int i = 0; i < 8; i++) begin 
        @(posedge clk); 
        mosi = value[i]; 
      end
  endtask 

  task read_spi(output [7:0] value); 
      for (int i = 0; i < 8; i++) begin 
        @(posedge clk); 
        value[i] = miso; 
      end
    endtask 

    initial begin 
    $monitor($time,, "mosi: %d, miso:%d, out:%d", mosi, miso, out); 

    reset_n = 0; 
    
    @(posedge clk); @(posedge clk); 

    reset_n = 1; 

    cs_n = 0; 
    write_spi(operation); 
    cs_n = 1; 

    @(posedge clk); @(posedge clk); 

    cs_n = 0; 
    write_spi(A); 
    cs_n = 1; 

    @(posedge clk); @(posedge clk); 

    cs_n = 0; 
    write_spi(B); 
    cs_n = 1; 

    @(posedge clk); @(posedge clk); 

    cs_n = 0; 
    read_spi(out); 
    cs_n = 1; 

    @(posedge clk); @(posedge clk); 
    $finish;  
    end 
endmodule: top_test
    
/*uvm_get_peek_pdule top_test(); 
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
    recv_data = 7'b001;
    recv_valid = 1; 

    @(negedge clk); recv_data = 7'b001;

    @(negedge clk); recv_data = 7'b100;
    
    @(negedge clk); recv_valid = 0; 
    @(negedge clk); @(negedge clk);

    @(negedge clk); @(negedge clk);

    @(negedge clk); @(negedge clk); 

    reset_n = 0; 

    @(negedge clk); @(negedge clk); 

    reset_n = 1;
    recv_valid = 1; 
    recv_data = 7'b100; 

    @(negedge clk); recv_data= 7'b100; 

    @(negedge clk); recv_data = 7'b010;
    @(negedge clk); recv_valid = 0; 

    @(negedge clk); @(negedge clk); 
    @(negedge clk); @(negedge clk); 

    @(negedge clk); @(negedge clk); 
    @(negedge clk); $finish;

  end
endmodule: top_test
*/
