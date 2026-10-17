module spi_slave(
  input  logic       clk, reset_n,
  input  logic       sclk, cs_n, 
  input  logic       mosi,
  input  logic       valid_in,
  input  logic [7:0] data_in,
  output logic       miso,
  output logic [7:0] data_out,
  output logic       valid_out);

  logic [2:0] counter;
  logic [7:0] shift_reg_data;

  logic [1:0] mosi_sync, cs_sync_n;

  logic [2:0] sclock_sync;
  logic [7:0] data_reg; 

  always_ff @(posedge clk) begin
    if (~reset_n) begin
      counter <= 3'd0;
      sclock_sync <= 0;
      mosi_sync <= 0;
      cs_sync_n <= 2'b11;
    end

    else begin
      sclock_sync <= {sclock_sync [1:0],sclk};
      //rising edge detector 
      mosi_sync <= {mosi_sync [0], mosi};
      cs_sync_n <= {cs_sync_n [0], cs_n};

      valid_out <= (~sclock_sync[2] & sclock_sync[1] & ~cs_sync_n[1]) 
                   & (counter == 3'b111);

      if (valid_in) data_reg <= data_in;

      if (cs_sync_n[1]) counter <= 3'd0; 
      else if (~sclock_sync[2] & sclock_sync[1] & ~cs_sync_n[1]) begin
        counter <= counter + 1;
        shift_reg_data <= {shift_reg_data [6:0], mosi_sync[1]};
      end
    end
  end

  assign data_out = shift_reg_data;
  assign miso = data_reg[7 - counter]; 
endmodule: spi_slave


