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
module booth ( inbus,
	       outbus,
	       clk,
	       beginsig,
	       locksig,
	       endsig
	      );
   localparam BUS_WIDTH=8;
      
   input [BUS_WIDTH-1:0] inbus;
   input 		 clk;
   input 		 beginsig;
   input 		 locksig;
   output 		 endsig;
   output [BUS_WIDTH-1:0] outbus;

   wire [7:0] 		  control;


   // wire that connect M register with adder
   wire [BUS_WIDTH-1:0]   m_wire;
   
   wire [BUS_WIDTH-1:0]   q_wire;
   
// wire that connect A register with adder
   wire [BUS_WIDTH-1:0]   a_wire;

   // wire that connect ADDER output with A register
   wire [BUS_WIDTH-1:0]   sum_wire;
   
   wire 		  q_0_wire;
   wire 		  q_1_wire;
   wire 		  a_0_wire;
   wire [2:0] 		  counter_wire;
   wire [2:0] 		  counter_inc_wire;
 		  

   register #(.REG_WIDTH(BUS_WIDTH)) MREG 
     (
      .in(inbus),
      .out(m_wire),
      .cout(),
      .clk(clk),
      .load(control[0]),
      .dump(),
      .shr(),
      .shiftout(),
      .shiftin()
      );

   register #(.REG_WIDTH(BUS_WIDTH)) QREG
     (
      .in(inbus),
      .out(q_wire),
      .cout(outbus),
      .clk(clk),
      .load(control[1]),
      .dump(control[6]),
      .shr(control[4]),
      .shiftout(q_0_wire),
      .shiftin(a_0_wire)
      );

   d_ff Q_1
     (
      .data(q_0_wire),
      .clk(control[4]),
      .reset(control[1]),
      .q(q_1_wire)
      );
   
   
   register #(.REG_WIDTH(BUS_WIDTH)) AREG
     (
      .in(sum_wire),
      .out(a_wire),
      .cout(outbus),
      .clk(clk),
      .load(control[0]|control[2]|control[3]),
      .dump(control[5]),
      .shr(control[4]),
      .shiftout(a_0_wire),
      .shiftin(sum_wire[BUS_WIDTH-1])
      );
   
   adder #(.REG_WIDTH(BUS_WIDTH)) ADDER
     (
      .clk(clk),
      .input_a(a_wire),
      .input_b(m_wire),
      .output_c(sum_wire),
      .ctl_add(control[2]),
      .ctl_sub(control[3]),
      .ctl_init(control[0])
      );

   adder #(.REG_WIDTH(3)) COUNTER_INC
     (
      .clk(clk),
      .input_a(counter_wire),
      .input_b(3'b001),
      .output_c(counter_inc_wire),
      .ctl_add(control[4]),
      .ctl_sub(1'b0),
      .ctl_init(control[0])
      );
   
   control_unit #(.COUNTER_BITS(3)) CTL
     (  
	.clk(clk),
	.beginsig(beginsig),
	.locksig(locksig),
	.q_reg({q_wire[0],q_1_wire}),
	.counter_in(counter_inc_wire),
	.counter_out(counter_wire),
	.endsig(endsig),
	.control(control)
	);
   initial begin
      $monitor("%b %b %b %b",a_wire,a_0_wire,q_wire,q_1_wire);
   end

  


   

   
endmodule // booth
