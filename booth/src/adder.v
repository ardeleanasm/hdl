module adder(
	     clk,
	     input_a,
	     input_b,
	     output_c,
	     ctl_add,
	     ctl_sub,
	     ctl_init
	     );
   parameter int REG_WIDTH=8;
   input 	 clk;
   input 	 ctl_add;
   input 	 ctl_sub;
   input 	 ctl_init;
   
   input [REG_WIDTH-1:0] input_a;
   input [REG_WIDTH-1:0] input_b;
   output reg [REG_WIDTH-1:0] output_c;

   always @(posedge clk) begin
      case ({ctl_add,ctl_sub,ctl_init})
	3'b100: begin
	   output_c <= input_a + input_b;
	end
	3'b110: begin
	   output_c <= input_a - input_b;
	end
	3'b001: begin
	   output_c = 0;
	end
      endcase
   end // always @(control)
   
endmodule // adder
