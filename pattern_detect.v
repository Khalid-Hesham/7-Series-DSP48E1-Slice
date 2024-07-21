/*
   USE_PATTERN_DETECT = PATDET it means pattern detector and its features are used
   USE_PATTERN_DETECT = (NO_PATDET) if it isn't used 
   SEL_PATTERN = C takes pattern dynamically from c
   SEL_PATTERN = (PATTERN) means pattern is attribute
   SEL_MASK = (MASK) to use mask parameter
   SEL_MASK = C takes pattern dynamically from c
   SEL_MASK = ROUNDING_MODE1 to use c' left shifted by 1
   SEL_MASK = ROUNDING_MODE2 to use c' left shifted by 2
   P_REG = 1'b1 for 1 reg 
   P_REG = 1'b0 for 0 reg 
*/
module pattern_detect #(parameter SEL_PATTERN = "PATTERN", SEL_MASK = "MASK", WIDTH = 48, PATTERN = 48'b0, MASK = 48'b0, P_REG = 1) (

input   wire  [WIDTH-1:0] p,
input   wire  [WIDTH-1:0] c,
input   wire              clk,
input   wire              cep,
input   wire              rstp,
output  wire              pd,
output  wire              pbd,
output  wire              ov_f,
output  wire              un_f

);


localparam M_MUX_SEL = SEL_MASK == "C" ? 2'b00 :
                       SEL_MASK == "ROUNDING_MODE2" ? 2'b01 :
                       SEL_MASK == "ROUNDING_MODE1" ? 2'b10 : 2'b11;
                      

wire [WIDTH-1:0]  pat_pmux;
wire [WIDTH-1:0]  mask_pmux;
wire              pat_d, patb_d;
wire              pd_past, pbd_past;

and a1 (ov_f,pd_past,~pd,~pbd);
and a2 (un_f,pbd_past,~pd,~pbd);

mux_2x1 #(.WIDTH(WIDTH)) pattern_mux (

.in0(c),
.in1(PATTERN),
.sel( (SEL_PATTERN == "PATTERN") ),
.out(pat_pmux)

);

mux_4x1 #(.WIDTH(WIDTH)) mask_mux (

.in0(c),
.in1((~c) << 2),
.in2((~c) << 1),
.in3(MASK),
.sel(M_MUX_SEL),
.out(mask_pmux)

);

equal #(.WIDTH(WIDTH)) eq (

.p(p),
.pattern(pat_pmux),
.mask(mask_pmux),
.pd(pat_d),
.pbd(patb_d)

);

mux_reg #(.REG(P_REG),.WIDTH(1)) pd_mux (

.in(pat_d),
.clk(clk),
.ce(cep),
.rst(rstp),
.out(pd)

);

mux_reg #(.REG(P_REG),.WIDTH(1)) pbd_mux (

.in(patb_d),
.clk(clk),
.ce(cep),
.rst(rstp),
.out(pbd)

);

register #(.WIDTH(1)) reg_pd(

.d(pd),
.clk(clk),
.rst(rstp),
.en(1'b1),
.q(pd_past)

);

register #(.WIDTH(1)) reg_pbd(

.d(pbd),
.clk(clk),
.rst(rstp),
.en(1'b1),
.q(pbd_past)

);


endmodule