module register(
		in,
		out,
		cout,
		clk,
		load,
		dump,
		shr,
		shiftout,
		shiftin
		);

   
   parameter int REG_WIDTH=8;

   input [REG_WIDTH-1:0]  in;
   input 		  load;
   input 		  dump;
   input 		  shr;
   input 		  clk;
		  
   input 		  shiftin;
   output reg 		  shiftout;
      
   output reg [REG_WIDTH-1:0] out;
   output reg [REG_WIDTH-1:0] cout;
   
		   
   reg [REG_WIDTH-1:0] storage;

   always @(posedge clk) begin
      if (load == 1'b1) begin
	 storage <= in;
	 shiftout <= 1'b0;
      end
      if (dump == 1'b1) begin
	 cout <= storage;
      end
      if (shr == 1'b1) begin
	 shiftout <= storage[0];
	 storage <= {shiftin,storage >>1};
      end
   
   end // always @ (control)
   assign out = storage;
   
endmodule // register

