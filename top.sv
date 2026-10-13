module fsm_alu_cnx( 
  input  logic       clk, reset_n,
  output logic       operation_done,

  input  logic       recv_valid,
  input  logic [7:0] recv_data,

  output logic [7:0] C,
  output logic [7:0] A, B, operand,

  output logic       ALU_valid,
  output logic [7:0] send_data,
  output logic       send_valid);

  FSM fsm(.*); 
  ALU alu(.input_valid(ALU_valid), .output_valid(operation_done), .*);

endmodule: fsm_alu_cnx

module top(
  input  logic       clk, reset_n, 
  input  logic       sclk, cs_n, 
  
  input  logic       mosi, 

  output logic       miso); 

  logic [7:0] C, A, B, operand;
  logic operation_done, ALU_valid; 

  logic [7:0] fsm_to_spi_s, spi_s_to_fsm; 
  logic       fsm_to_spi_s_valid, spi_s_to_fsm_valid; 

  spi_slave spi_s (.clk, .reset_n, .sclk, .cs_n, .mosi, 
                  .valid_in(fsm_to_spi_s_valid), .data_in(fsm_to_spi_s), 
                  .miso, .data_out(spi_s_to_fsm), .valid_out(spi_s_to_fsm_valid)); 

  fsm_alu_cnx cnx (.clk, .reset_n, .operation_done, .C, .A, .B, .operand, .ALU_valid, 
                  .recv_valid(spi_s_to_fsm_valid), .recv_data(spi_s_to_fsm), 
                  .send_data(fsm_to_spi_s), .send_valid(fsm_to_spi_s_valid));


endmodule: top   
