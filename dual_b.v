/*
  B_INPUT = DIRECT  for direct 
  B_INPUT = CASCADE for cascade 
  B_REG = 0 for no regs in direct path
  B_REG = 1 for B2 
  B_REG = 2 for B1 and B2
  B_CASC_REG = 0 for no regs in cascaded path
  B_CASC_REG = 1 for B1
  B_CASC_REG = 2 for B1 and B2
*/

module dual_b #(parameter B_WIDTH = 18, B_INPUT = "DIRECT" , B_REG = 1, B_CASC_REG = 1) (
  input   wire  [B_WIDTH-1:0]   b,
  input   wire  [B_WIDTH-1:0]   bcin,
  input   wire                  clk,
  input   wire                  ceb1,
  input   wire                  ceb2,
  input   wire                  rstb,
  input   wire                  inmode4,
  output  wire  [B_WIDTH-1:0]   bcout,
  output  wire  [B_WIDTH-1:0]   xmux,
  output  wire  [B_WIDTH-1:0]   bmult
);

wire [B_WIDTH-1:0] b1,b1_reg;
wire [B_WIDTH-1:0] b2,b2_reg;


mux_2x1 #(.WIDTH(B_WIDTH)) bin_sel (

.in0(b),
.in1(bcin),
.sel( (B_INPUT == "CASCADE") ),
.out(b1)

);

mux_2x1 #(.WIDTH(B_WIDTH)) b1_sel (

.in0(b1),
.in1(b1_reg),
.sel( (B_REG == 2) ),
.out(b2)

);

mux_2x1 #(.WIDTH(B_WIDTH)) b2_sel ( 

.in0(b2),
.in1(b2_reg),
.sel( (B_REG == 1 || B_REG == 2) ),
.out(xmux)

);

mux_2x1 #(.WIDTH(B_WIDTH)) b12_sel (

.in0(b1_reg),
.in1(xmux),
.sel( ( (B_REG == 0 && B_CASC_REG == 0) || (B_REG == 2 && B_CASC_REG == 2) ) ),
.out(bcout)

);

mux_2x1 #(.WIDTH(B_WIDTH)) bmult_sel (

.in0(xmux),
.in1(b1_reg),
.sel(inmode4),
.out(bmult)

);

register #(.WIDTH(B_WIDTH)) regb1 (

.d(b1),
.clk(clk),
.rst(rstb),
.en(ceb1),
.q(b1_reg)

);

register #(.WIDTH(B_WIDTH)) regb2 (

.d(b2),
.clk(clk),
.rst(rstb),
.en(ceb2),
.q(b2_reg)

);
endmodule