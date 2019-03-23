module booth_algo
            (
                control,
                inbus, 
                outbus,
                q_reg
            );

    input       [8:0]   control;
    input       [7:0]   inbus;
    output reg  [7:0]   outbus;
    output      [2:0]   q_reg;

    reg         [17:0]  AQ;
    reg         [7:0]   M;
    reg         [8:0]   M1;
    reg         [8:0]   M2;
    reg         [8:0]   sum;
 
    always @(control) begin
        case (control)
            9'b000000001: begin
                AQ[8:1] = inbus;
                AQ[17:9] = 9'b0;
                AQ[0] = 1'b0;
            end
            9'b000000010: begin
                M = inbus;
                M1 = {M[7],M};
                M2 = M1<<1;
            end
            9'b000000100: begin
                AQ[17:9] = AQ[17:9] + M1;
            end
            9'b000001100: begin
                AQ[17:9] = AQ[17:9] - M1;
            end
            9'b000010100: begin
                AQ[17:9] = AQ[17:9] + M2;
            end
            9'b000011100: begin
                AQ[17:9] = AQ[17:9] - M2;
            end
            9'b000100000: begin
                sum = AQ[17:9];
                AQ = {sum[8],sum[8],sum,AQ[8:2]};
            end
            9'b001000000:;
            9'b010000000: begin
                outbus = AQ[8:1];
            end
            9'b100000000: begin
                outbus = AQ[16:9];
            end
        endcase
    end
    assign q_reg=AQ[2:0];   
endmodule
