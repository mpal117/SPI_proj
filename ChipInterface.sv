module ChipInterface(
  input  logic       CLK12MHZ, 
  input  logic [3:0] btn,
  input  logic [7:0] ja, 
  output logic [7:0] jb); 

  top t(.clk(CLK12MHZ), .reset_n(~btn[0]), .sclk(ja[0]), .cs_n(ja[1]),
        .mosi(ja[2]), .miso(jb[0])); 

  assign jb[7:1] = '0; 
endmodule: ChipInterface
