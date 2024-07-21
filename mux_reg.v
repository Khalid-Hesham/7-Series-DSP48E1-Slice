// REG = 0 for no regs
// REG = 1 for 1 reg

module mux_reg #(parameter REG = 1, WIDTH = 1)(

input [WIDTH-1:0] in,
input clk,
input ce,
input rst,
output [WIDTH-1:0] out

);

wire [WIDTH-1:0] in_reg;

mux_2x1 #(.WIDTH(WIDTH)) in_sel (

.in0(in),
.in1(in_reg),
.sel(REG == 1),
.out(out)

);

register #(.WIDTH(WIDTH)) reg_in (

.d(in),
.clk(clk),
.rst(rst),
.en(ce),
.q(in_reg)

);

endmodule 
