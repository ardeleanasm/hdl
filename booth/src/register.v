module register(
		inbus,
		outbus,
		load,
		dump,
		shr,
		shiftout,
		shiftin,
  		lsb
		);

   
   parameter int REG_WIDTH=8;

   input [REG_WIDTH-1:0]  inbus;
   input 		  load;
   input 		  dump;
   input 		  shr;
		  
   input 		  shiftin;
   output reg 		  shiftout;
   output lsb;
   output reg [REG_WIDTH-1:0] outbus;
  
		   
   reg [REG_WIDTH-1:0] storage;

   always @({load,dump,shr}) begin
      case ({load,dump,shr})
      3'b100: begin
         storage = inbus;
         shiftout = 1'b0;
      end
      5'b010: begin
         outbus = storage;
      end
      5'b001: begin
         shiftout = storage[0];
         storage = {shiftin,storage >>1};
      end
      endcase // case ({load,dump,shl,shr})
      
   end // always @ (control)
  assign lsb=storage[0];
endmodule // register
