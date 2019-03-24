/*
State          Inputs            Next State     Ctrl
S0             begin = 0,lock=1  S1             c0
S1             x                 S2             c1
S2             Q1Q0=01           S3             c2
               Q1Q0=10           S3             c2c3
S3             CountX=1          S5             -
               CountX=0          S4             
S4             X                 S2             c4  
S5             X                 S6             c5
S6             X                 S7             c6
S7             DONE
*/
`define S0  3'b000
`define S1  3'b001
`define S2  3'b010
`define S3  3'b011
`define S4  3'b100
`define S5  3'b101
`define S6  3'b110
`define S7  3'b111
module control_unit
  (
   clk,
   beginsig,
   locksig,
   q_reg,
   counter_in,
   endsig,
   control,

   );

   parameter int COUNTER_BITS=3;
   parameter int MAX_VALUE_COUNT=3'b111;
   
   input 	                 clk;
   input 	                 beginsig;
   input 	                 locksig;
   input      [1:0]      	 q_reg;
   input      [COUNTER_BITS-1:0] counter_in;
   output reg [7:0] 	         control;
   output 		         endsig;
   
   reg [2:0] current_state;
   reg [2:0] next_state;
   
   reg [COUNTER_BITS-1:0] 	       counter;

   always @(posedge clk, posedge beginsig) begin
      if (beginsig && !locksig) begin
         current_state = `S0;
      end
      else begin
         current_state = next_state;
      end
   end
   
   always @(locksig,current_state) begin
      case (current_state)
        `S0: begin
           next_state = `S1;
        end
        `S1: begin
           next_state = `S2;
        end
        `S2: begin
           next_state = `S3;
        end
        `S3: begin
	   if (counter == MAX_VALUE_COUNT) begin
	      next_state = `S5;
	   end
	   else begin
              next_state = `S4;
	   end
        `S4: begin
           next_state = `S2;
        end
        `S5: begin
	   next_state = `S6;
         end
        end
        `S6: begin
           next_state = `S7;
        end
        `S7: begin
        end
        default:;
      endcase
   end
   
   
   always @(current_state) begin
      case (current_state)
        `S0: begin
	   if (locksig) begin
	     control = 1<<0;
	   end
	end
        `S1: begin
           control = 1<<1;
        end
        `S2: begin
	   case (q_reg)
	     2'b01: begin
		control = 1<<2;
	     end
	     2'b10: begin
		control = (1<<2) | (1<<3);
	     end
	   endcase
        end
        `S3:;
        `S4: begin
           control = 1<<4;
        end
        `S5: begin
           control = 1<<5;
        end
        `S6: begin
           control = 1<<6;
        end
        `S7:;
        default:;
      endcase
   end
   assign endsig=(current_state != `S7)?1'b1:1'b0;
   assign counter = counter_in;

endmodule   



