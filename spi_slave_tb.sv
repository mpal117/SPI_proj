
module top_test(); 
  logic clk, reset_n; 
  logic sclk, cs_n, mosi; 
  logic miso; 
  logic [7:0] data;
  logic valid; 
  logic [15:0] data_in; 
  logic [4:0] i; 

  top dut(.*); 

  initial begin 
    clk = 0; 
    forever #5 clk = ~ clk; 
  end

  initial begin 
    sclk = 0; 
    forever #50 sclk = ~sclk; 
  end

  initial begin
    $monitor($time,, "valid: %b, data: %b, counter: %b", valid, data, dut.counter); 
    reset_n = 0; 

    #120 reset_n = 1; 
    mosi = 0; 
    cs_n = 1; 
    data_in = 16'b0011_1010_1111_0000; 
  
    for (i = 0; i < 4'b1111; i++) begin
      @(negedge sclk); 
      cs_n = 0; 
      mosi = data_in[i];
    end

    @(negedge sclk); 
    cs_n = 1; 
    #500 $finish; 
  end

  always @(posedge clk)
    if (valid) $display($time,, "data:%b", data);

endmodule: top_test



