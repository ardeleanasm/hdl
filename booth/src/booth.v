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

   wire 		  q_1; 		
   wire 		  q_0;
   wire [BUS_WIDTH-1:0]   q_reg;
   wire [BUS_WIDTH-1:0]   a_reg;
   
   wire [BUS_WIDTH-1:0]   control;
   wire [BUS_WIDTH-1:0]   m_reg;
   wire [2:0] 		  counter_out;
   wire [2:0] 		  counter_in;
   wire [BUS_WIDTH-1:0]   bus;

   wire 		  shiftout_a;
   
   
   
  


   register #(.REG_WIDTH(8)) A
     (
     .inbus(a_reg),
     .outbus(bus),
     .load(control[0]),
     .dump(control[5]),
     .shr(control[4]),
     .shiftout(shiftout_a),
       .shiftin(a_reg[BUS_WIDTH-1]),
       .lsb()
     );

   register #(.REG_WIDTH(8)) Q
     (
      .inbus(inbus),
      .outbus(bus),
      .load(control[1]),
      .dump(control[6]),
      .shr(control[4]),
      .shiftout(q_1),
       .shiftin(shiftout_a),
       .lsb(q_0)
      );

   register #(.REG_WIDTH(1)) Q_1
     (
       .inbus(q_0),
      .outbus(),
      .load(control[0]),
      .dump(),
      .shr(control[4]),
      .shiftout(),
       .shiftin(q_1),
       .lsb()
      );

   register #(.REG_WIDTH(8)) M
     (
      .inbus(inbus),
      .outbus(m_reg),
      .load(control[0]),
      .dump(),
      .shr(),
      .shiftout(),
       .shiftin(),
       .lsb()
      );

   register #(.REG_WIDTH(3)) COUNTER
     (
      .inbus(counter_in),
      .outbus(counter_out),
      .load(control[0]),
      .dump(control[4]),
      .shr(),
      .shiftout(),
       .shiftin(),
       .lsb()
      );
   

   adder #(.REG_WIDTH(BUS_WIDTH)) ADDER
     (  .input_a(bus),
	.input_b(m_reg),
	.output_c(a_reg),
	.ctl_add(control[2]),
	.ctl_sub(control[3]),
	.ctl_init(control[0])
      );

   adder #(.REG_WIDTH(3)) COUNTER_INC
     (  .input_a(counter_out),
	.input_b(3'b001),
	.output_c(counter_in),
	.ctl_add(control[4]),
	.ctl_sub(1'b0),
	.ctl_init(control[0])
	);

   control_unit #(.COUNTER_BITS(3),.MAX_VALUE_COUNT(3'b111)) CTL
     (  .clk(clk),
	.beginsig(beginsig),
	.locksig(locksig),
      .q_reg({q_0,q_1}),
	.counter_in(counter_out),
	.endsig(endsig),
	.control(control)
      );
   
   assign outbus=bus;
   
endmodule // booth

