`timescale 1 ns/1 ps
`define assert_eq(signal,value) \
    if (signal !== value) begin \
        $display("Assertion Failed in %m: signal != value"); \
        $finish; \
    end

module boothr4_tb;
    reg clk;
    reg beginsig;
    reg locksig;
    reg [7:0] inbus;

    wire [7:0] outbus;
    wire endsig;

    boothr4 booth(
        .inbus(inbus),
        .outbus(outbus),
        .clk(clk),
        .beginsig(beginsig),
        .locksig(locksig),
        .endsig(endsig)
    );

    always begin
        #10 clk = !clk;
    end

    initial begin
        $dumpfile("boothr4.vcd");
        $dumpvars;
        clk<=0;
        #20 beginsig = 1;
        #20 beginsig = 0;
//Set Q on inbus
        inbus = 8'b11010011;
        #5 locksig = 1;
//Set M on inbus
        #10 inbus = 8'b01000101;
        #1000
        $finish;
    end
    initial begin
        $display("\t\ttime\tclk\tbegin\tlock\tinbus\toutbus");
        $monitor("%d,\t%b\t%b\t%b\t%b\t%b",$time,clk,beginsig,locksig,inbus,outbus);
    end
        
endmodule
