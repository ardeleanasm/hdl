module boothr4
         (
            inbus,
            outbus,
            clk,
            beginsig,
            locksig,
            endsig
         );
    input           clk;
    input           beginsig;
    input           locksig;
    input  [7:0]    inbus;

    output          endsig;
    output [7:0]    outbus;

    wire   [2:0]    q_reg;
    wire   [8:0]    control; 

    control_unit cu
            (
                .clk(clk),
                .beginsig(beginsig),
                .locksig(locksig),
                .q_reg(q_reg),
                .endsig(endsig),
                .control(control)
            );
    booth_algo algo
            (
                .control(control),
                .inbus(inbus),
                .outbus(outbus),
                .q_reg(q_reg)
            );
endmodule
