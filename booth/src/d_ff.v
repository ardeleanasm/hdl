module d_ff(data,clk,reset,q);
	
   input data,clk,reset;
   output reg q;
	
   always @(posedge clk,posedge reset)
     if(reset) begin
	q<=1'b0;
     end 
     else begin
	q<=data;
     end
endmodule
