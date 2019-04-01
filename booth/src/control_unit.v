`define WAIT  3'b000
`define BEGIN  3'b001
`define INPUT  3'b010
`define SCAN  3'b011
`define TEST  3'b100
`define OUTA  3'b101
`define OUTQ  3'b110
`define DONE  3'b111
`timescale 1 ns/1 ps
module control_unit
  (
   clk,
   beginsig,
   locksig,
   q_reg,
   counter_in,
   counter_out,
   endsig,
   control,

   );

   parameter int COUNTER_BITS=3;
   
   input 	 clk;
   input 	 beginsig;
   input 	 locksig;
   input [1:0] 	 q_reg;
   input [COUNTER_BITS-1:0] counter_in;
   output [COUNTER_BITS-1:0] counter_out;
   
   output reg [7:0] 	     control;
   output 		     endsig;
   
   reg [2:0] 		     current_state;
   reg [2:0] 		     next_state;
   
   reg [COUNTER_BITS-1:0]    counter;


   always @(posedge clk, posedge beginsig) 
     begin:FSM_SEQ
	if (beginsig == 1'b1) begin
           current_state = `WAIT;
	end
	else begin
	   if (locksig == 1'b1) begin
	      current_state =  next_state;
	   end
	end
     end

   
   always @(current_state) begin
      case (current_state)
	`WAIT: begin
	   $display("S0->S1");
	   next_state = `BEGIN;
	end
	`BEGIN: begin
	   $display("S1->S2");
	   next_state = `INPUT;
	end
	`INPUT: begin
	   $display("S2->S3");
	   next_state = `SCAN;
	end
	`SCAN: begin
	   $display("S3->S4");
	   next_state = `TEST;
	end
	`TEST: begin
	   if (counter == 3'b111) begin
	      $display("S4->S5");
	      next_state = `OUTA;
	   end
	   else begin
	      $display("S4->S3");
              next_state = `SCAN;
	   end
	end
	`OUTA: begin
	   $display("S5->S6");
	   next_state = `OUTQ;
	end
	`OUTQ: begin
	   $display("S6->S7");
	   next_state = `DONE;
	end
	default:;
      endcase // case (state)
   end
   
   
   always @(current_state) begin
      case (current_state)
        `WAIT:;
        `BEGIN: begin
	   control = 1<<0;
	end
        `INPUT: begin
	   control = 1<<1;
        end
        `SCAN: begin
	   case (q_reg)
	     2'b01: begin
		control = 1<<2;
	     end
	     2'b10: begin
		control = (1<<2) | (1<<3);
	     end
	   endcase
	end
        `TEST: begin
	   if (counter != 3'b111) begin
	      control=1<<4;
	   end
	end
        `OUTA: begin
	   control = 1<<5;
        end
        `OUTQ: begin
	   control = 1<<6;
        end
        default:;
      endcase
      
   end
   
  
   assign endsig=(current_state != `DONE)?1'b1:1'b0;
   assign counter = counter_in;
   assign counter_out = counter;
   
endmodule   



