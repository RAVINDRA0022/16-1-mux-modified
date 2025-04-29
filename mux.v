`timescale 1ns / 1ps

module modified_mux(
    input wire clk,               
    input wire [16:1] in,         
    input wire [3:0] sel,          
    output wire out             
);

    wire out_lower, out_upper;     // Wires from 8:1 muxes
    reg out_lower_reg, out_upper_reg; // Pipeline registers
    reg sel3_reg;                 

    // Instantiate lower 8:1 mux
    eight_1_mux u1 (
        .in({in[8], in[7], in[6], in[5], in[4], in[3], in[2], in[1]}),
        .sel(sel[2:0]),
        .out2(out_lower)
    );

    // Instantiate upper 8:1 mux
    eight_1_mux u2 (
        .in({in[16], in[15], in[14], in[13], in[12], in[11], in[10], in[9]}),
        .sel(sel[2:0]),
        .out2(out_upper)
    );

    // Pipeline Stage
    always @(posedge clk) begin
        out_lower_reg <= out_lower;
        out_upper_reg <= out_upper;
        sel3_reg <= sel[3];
    end

    // Instantiate 2:1 mux using registered outputs
    two_1_mux u3 (
        .in0(out_lower_reg),
        .in1(out_upper_reg),
        .sel(sel3_reg),
        .out(out)
    );

endmodule

// 8:1 MUX
module eight_1_mux(
    input wire [7:0] in,
    input wire [2:0] sel,
    output reg out2
);
    always @(*) begin
        case (sel)
            3'b000: out2 = in[0];
            3'b001: out2 = in[1];
            3'b010: out2 = in[2];
            3'b011: out2 = in[3];
            3'b100: out2 = in[4];
            3'b101: out2 = in[5];
            3'b110: out2 = in[6];
            3'b111: out2 = in[7];
        endcase
    end
endmodule

// 2:1 MUX
module two_1_mux(
    input wire in0,
    input wire in1,
    input wire sel,
    output reg out
);
    always @(*) begin
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
    end
endmodule
