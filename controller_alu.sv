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

module FSM(
  input  logic       clk, reset_n, 
  input  logic       recv_valid,
  input  logic [7:0] recv_data,

  output logic [7:0] A, B, operand,
  output logic       ALU_valid, 

  input  logic       operation_done, 
  input  logic [7:0] C, 

  output logic [7:0] send_data,
  output logic       send_valid); 

  logic [7:0] next_operand, next_A, next_B, next_send_data; 
  logic       next_ALU_valid, next_send_valid; 

  enum logic [2:0] {recv_OP, recv_A, recv_B, send} currState, nextState; 

  always_ff @(posedge clk) begin 
    if (~reset_n) currState <= recv_OP; 
    else          currState <= nextState; 
  end

  //next state
  always_comb begin 
    case (currState) 
      recv_OP: nextState = recv_valid     ? recv_A : recv_OP; 
      recv_A:  nextState = recv_valid     ? recv_B : recv_A;
      recv_B:  nextState = operation_done ? send   : recv_B;
      default: nextState = recv_OP; 
    endcase
  end

  //sync
  always_ff @(posedge clk) begin
    if (~reset_n) begin 
      operand <= 8'd0; 
      A <= 8'd0; 
      B <= 8'd0; 
      send_data <= 8'd0; 
      ALU_valid <= 0;
      send_valid <= 0; 
    end else begin
      operand <= next_operand;
      A <= next_A; 
      B <= next_B; 
      send_data <= next_send_data; 
      ALU_valid <= next_ALU_valid; 
      send_valid <= next_send_valid; 
    end
  end

  //output 
  always_comb begin 
    next_operand = operand;
    next_A = A; 
    next_B = B; 
    next_send_data = send_data; 
    next_ALU_valid = ALU_valid; 
    next_send_valid = send_valid; 
    case (currState)
      recv_OP: begin
        if (recv_valid) next_operand = recv_data; 
        //not too sure abt this
        next_ALU_valid = 0; 
        next_send_valid = 0;
      end
      recv_A: if (recv_valid) next_A = recv_data;
      recv_B: begin 
        if (recv_valid) next_B = recv_data;
        next_ALU_valid = 1;
      end
      send: begin 
        if (recv_valid) next_send_data = C;
        next_send_valid = 1;
      end
    endcase
  end

endmodule: FSM

module ALU(
  input  logic       clk, reset_n, 
  input  logic       input_valid, 
  input  logic [7:0] A, B, operand, 
  output logic [7:0] C, 
  output logic       output_valid);
  
  logic [7:0] next_C; 
  logic       next_output_valid; 
  //output valid = operation done 
  always_ff @(posedge clk) begin 
    if (~reset_n) begin 
      C <= 0; 
      output_valid <= 0;
      end 
    else begin 
      C <= next_C; 
      output_valid <= next_output_valid;
    end
  end 

  always_comb begin 
    next_output_valid = 0; 
    next_C = C; 
    if(input_valid) begin
      next_output_valid = 1; 
      case(operand)
        8'b001: next_C = A + B; 
        8'b010: next_C = A - B; 
        8'b100: next_C = A * B; 
      endcase
    end
  end

endmodule: ALU 
