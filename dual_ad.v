/*
  A_INPUT = DIRECT  for direct 
  A_INPUT = CASCADE for cascade 
  A_REG = 0 for no regs in direct path
  A_REG = 1 for A2
  A_REG = 2 for A1 and A2
  A_CASC_REG = 0 for no regs in cascaded path
  A_CASC_REG = 1 for B1
  A_CASC_REG = 2 for B1 and B2
  D_REG = 0 for no regs
  D_REG = 1 for 1 reg
  AD_REG = 0 for no regs in A_MULT path
  AD_REG = 1 for AD
  USE_DPORT = TRUE d is used 
  USE_DPORT = FALSE d is unused
*/

module dual_ad #(parameter  A_WIDTH = 30, A_INPUT = "DIRECT", A_REG = 1, A_CASC_REG = 1, 
                            D_WIDTH = 25 , D_REG = 1, AD_REG = 1, USE_DPORT = "FALSE") 
(
  
  input   wire  [A_WIDTH-1:0]   a,
  input   wire  [A_WIDTH-1:0]   acin,
  input   wire  [D_WIDTH-1:0]   d,
  input   wire                  clk,
  input   wire                  cea1,
  input   wire                  cea2,
  input   wire                  ced,
  input   wire                  cead,
  input   wire                  rsta,
  input   wire                  rstd,
  input   wire  [3:0]           inmode,
  output  wire  [A_WIDTH-1:0]   acout,
  output  wire  [A_WIDTH-1:0]   xmux,  
  output  wire  [D_WIDTH-1:0]   amult 

);

wire [A_WIDTH-1:0] amult_pre_and;
wire [D_WIDTH-1:0] amult_post_and;
wire [D_WIDTH-1:0] dmux_and;
wire [D_WIDTH-1:0] dmux;
wire [D_WIDTH-1:0] d_reg;
wire [D_WIDTH-1:0] ad;
wire [D_WIDTH-1:0] ad_reg;
wire [D_WIDTH-1:0] admux;

dual_b #( .B_WIDTH(A_WIDTH), .B_INPUT(A_INPUT), .B_REG(A_REG), .B_CASC_REG(A_CASC_REG) ) dual_a (
.b(a),
.bcin(acin),
.clk(clk),
.ceb1(cea1),
.ceb2(cea2),
.rstb(rsta),
.inmode4(inmode[0]),
.bcout(acout),
.xmux(xmux),
.bmult(amult_pre_and)
);

and_gate #(.GATES(D_WIDTH)) a1 (

.a(amult_pre_and[24:0]),
.b( {D_WIDTH{~inmode[1]}} ),
.out(amult_post_and)

);

and_gate #(.GATES(D_WIDTH)) d1 (

.a(dmux),
.b( {D_WIDTH{inmode[2]}} ),
.out(dmux_and)

);

preadd #(.WIDTH(D_WIDTH)) adsub (

.op1(dmux_and),
.op2(amult_post_and),
.inmode3(inmode[3]),
.res(ad)

);

mux_2x1 #(.WIDTH(D_WIDTH)) d_sel (

.in0(d),
.in1(d_reg),
.sel(D_REG == 1),
.out(dmux)

);

mux_2x1 #(.WIDTH(D_WIDTH)) ad_sel (

.in0(ad),
.in1(ad_reg),
.sel(AD_REG == 1),
.out(admux)

);

mux_2x1 #(.WIDTH(D_WIDTH)) a_ad_sel (

.in0(amult_post_and),
.in1(admux),
.sel(USE_DPORT == "TRUE"),
.out(amult)

);

register #(.WIDTH(D_WIDTH)) regd (

.d(d),
.clk(clk),
.rst(rstd),
.en(ced),
.q(d_reg)

);

register #(.WIDTH(D_WIDTH)) regad (

.d(ad),
.clk(clk),
.rst(rstd),
.en(cead),
.q(ad_reg)

);


endmodule