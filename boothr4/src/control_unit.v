/*
S0 : begin = 1 
S1 : lock  = 1 => c0=1
S2 : lock = 1, Q[-1] = 0 => c1
S3 : Q = 001/010 => c2    	S4
     Q = 101/110 => c2,c3 	S4
     Q = 011     => c2,c4	S4
     Q = 100     => c2,c3,c4	S4
S4 : xxxxxxxxxxx => c5		S5
S5 : Count=1	 => 		S6
     else Count+1=> c6		S3
S6 : 		 => c7
		 => c8          S7
S7 : DONE
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
            endsig,
            control
        );
    
    input               clk;
    input               beginsig;
    input               locksig;
    input       [2:0]   q_reg;
    output reg  [8:0]   control;
    output              endsig;
    
    reg         [2:0]   current_state;
    reg         [2:0]   next_state;

    reg         [1:0]   counter;


    always @(posedge clk, posedge beginsig) begin
        if (beginsig) begin
            current_state = `S0;
        end
        else begin
            current_state = next_state;
        end
    end
    
    always @(locksig,current_state) begin
        case (current_state)
            `S0: begin
                if (locksig) begin
                    next_state = `S1;
                end
            end
            `S1: begin
                next_state = `S2;
            end
            `S2: begin
                next_state = `S3;
            end
            `S3: begin
                next_state = `S4;
            end
            `S4: begin
                next_state = `S5;
            end
            `S5: begin
                if (counter == 2'b11) begin
                    next_state = `S6;
                end
                else begin
                    next_state = `S3;
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
            `S0:;// Do nothing in this state.
            `S1: begin
                counter = 2'b0;
                control = 9'b000000001;
            end
            `S2: begin
                control = 9'b000000010;
            end
            `S3: begin
                case (q_reg)
                    3'b001,3'b010: begin
                        control = 9'b000000100;
                    end
                    3'b101,3'b110: begin
                        control = 9'b000001100;
                    end
                    3'b011: begin
                        control = 9'b000010100;
                    end
                    3'b100: begin
                        control = 9'b000011100;
                    end
                    default:;
                endcase
            end
            `S4: begin
                control = 9'b000100000;
            end
            `S5: begin
                if (counter != 2'b11) begin
                    control = 9'b001000000;
                    counter = counter +1'b1;
                end
            end
            `S6: begin
                control = 9'b010000000;
            end
            `S7:begin
                control = 9'b100000000;
            end
            default:;
             endcase
    end
    assign endsig=(current_state != `S7 && current_state != `S0)?1'b1:1'b0;
endmodule   
