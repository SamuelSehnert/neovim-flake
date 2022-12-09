`timescale 1ns / 1ps

module counter #(WIDTH = 8) (
    input logic rst,
    input logic clk,
    input logic en,
    output logic [WIDTH-1:0] count,
    output logic max
);

    assign max = count == {WIDTH{1'b1}};

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            count <= 'b0;
        else if (en)
            count <= count + 1;
    end
endmodule
