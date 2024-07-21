// (* keep_hirerchy = "yes" *)
`include "params.v"

module dsp_top (

  // dsp input clk
  input   wire                  clk,
  // dual_ad input signals
  input   wire  [`A_WIDTH-1:0]  a,
  input   wire  [`A_WIDTH-1:0]  acin,
  input   wire  [`D_WIDTH-1:0]  d,
  input   wire                  cea1,
  input   wire                  cea2,
  input   wire                  ced,
  input   wire                  cead,
  input   wire                  rsta,
  input   wire                  rstd,
  input   wire                  rstinmode,
  input   wire                  ceinmode,
  // dual_b input signals
  input   wire  [`B_WIDTH-1:0]  b,
  input   wire  [`B_WIDTH-1:0]  bcin,
  input   wire                  ceb1,
  input   wire                  ceb2,
  input   wire                  rstb,
  // c register input signals
  input   wire  [`C_WIDTH-1:0]  c,
  input   wire                  cec,
  input   wire                  rstc,
  // inmode, carryin, opmode, carryinsel input signals
  input   wire  [4:0]           inmode,
  input   wire                  carryin,
  input   wire                  cecarryin,
  input   wire                  rstallcarryin,
  input   wire  [6:0]           opmode,
  input   wire  [2:0]           carryinsel,
  input   wire                  cectrl,
  input   wire                  rstctrl,
  // multiplier output register(m) control signals
  input   wire                  cem,
  input   wire                  rstm,
  // alumode register inputs
  input   wire  [3:0]           alumode,
  input   wire                  cealumode,
  input   wire                  rstalumode,
  // alu output register(p) control signals
  input   wire                  cep,
  input   wire                  rstp,
  // cascading realated inputs
  input   wire                  multsignin,
  input   wire                  carrycascin,
  input   wire  [47:0]          pcin,
  // cascading related iutputs
  output  wire   [`A_WIDTH-1:0]  acout,
  output  wire   [`B_WIDTH-1:0]  bcout,
  output  wire                   multsignout,
  output  wire                   carrycascout,
  output  wire   [47:0]          pcout,
  // dsp outputs
  output  wire   [3:0]           carryout,
  output  wire   [47:0]          p,
  output  wire                   patterndetect,
  output  wire                   patternbdetect,
  output  wire                   overflow,
  output  wire                   underflow

);

// integer and parameter used for generating alu units loop
genvar i;
parameter SIMD = (`USE_SIMD == "ONE48" ? 48 : `USE_SIMD == "TWO24" ? 24 : 12);

// dual_ad 
wire  [`A_WIDTH-1:0] xmux_a;  
wire  [`D_WIDTH-1:0] amult; 
// dual_b
wire  [`B_WIDTH-1:0] xmux_b;
wire  [`B_WIDTH-1:0] bmult;
// c input post mux 
wire  [`C_WIDTH-1:0] c_pmux;
// inputs post muxes 
wire  [4:0]         inmode_pmux;
wire                carryin_pmux;
wire  [6:0]         opmode_pmux;
wire  [2:0]         carryinsel_pmux;
// multiplier result before and after mux
wire  [42:0]        m_res,m;
// x,y,z multiplexers output
wire  [`C_WIDTH-1:0] x,y,z;
// alumode post mux 
wire  [3:0]         alumode_pmux;
// carryin post mux
wire                cin;
// alu result and carryout pre mux
wire [47:0]         alu_res;
wire [3:0]          cout;

// In case of using cascading dsp slices
assign carrycascout = carryout[3];
assign pcout = p;

dual_b #( .B_WIDTH(`B_WIDTH), .B_REG(`B_REG), .B_CASC_REG(`B_CASC_REG), .B_INPUT(`B_INPUT) ) du_b (

.b(b),
.bcin(bcin),
.clk(clk),
.ceb1(ceb1),
.ceb2(ceb2),
.rstb(rstb),
.inmode4(inmode_pmux[4]),
.bcout(bcout),
.xmux(xmux_b),
.bmult(bmult)

);

dual_ad #( .A_WIDTH(`A_WIDTH), .A_REG(`A_REG), .A_CASC_REG(`A_CASC_REG), .A_INPUT(`A_INPUT), .D_WIDTH(`D_WIDTH), .D_REG(`D_REG), .AD_REG(`AD_REG), .USE_DPORT(`USE_DPORT) ) du_ad (

.a(a),
.acin(acin),
.d(d),
.clk(clk),
.cea1(cea1),
.cea2(cea2),
.ced(ced),
.cead(cead),
.rsta(rsta),
.rstd(rstd),
.inmode(inmode_pmux[3:0]),
.acout(acout),
.xmux(xmux_a),
.amult(amult)

);

mux_reg #( .REG(`C_REG), .WIDTH(`C_WIDTH) ) c_mux (

.in(c),
.clk(clk),
.ce(cec),
.rst(rstc),
.out(c_pmux)

);

mux_reg #(.REG(`INMODE_REG), .WIDTH(5)) inmode_mux (

.in(inmode),
.clk(clk),
.ce(ceinmode),
.rst(rstinmode),
.out(inmode_pmux)

);

mux_reg #(.REG(`CARRYIN_REG)) carryin_mux (

.in(carryin),
.clk(clk),
.ce(cecarryin),
.rst(rstallcarryin),
.out(carryin_pmux)

);

mux_reg #(.REG(`OPMODE_REG),.WIDTH(7)) opmode_mux (

.in(opmode),
.clk(clk),
.ce(cectrl),
.rst(rstctrl),
.out(opmode_pmux)

);

mux_reg #(.REG(`CARRYINSEL_REG),.WIDTH(3)) carryin_sel_mux (

.in(carryinsel),
.clk(clk),
.ce(cectrl),
.rst(rstctrl),
.out(carryinsel_pmux)

);

mult #( .B_WIDTH(`B_WIDTH), .USE_MULT(`USE_MULT)) mul_u (

  .opa(amult),
  .opb(bmult),
  .multsignout(multsignout),
  .m_res(m_res)

);

mux_reg #( .REG(`M_REG), .WIDTH(43)) m_mux (

  .in(m_res),
  .clk(clk),
  .ce(cem),
  .rst(rstm),
  .out(m)

);

mux_4x1 #(.WIDTH(`C_WIDTH)) x_mux (

.in0({`C_WIDTH{1'b0}}),
.in1({{5{m[42]}},m}),
.in2(p),
.in3({xmux_a,xmux_b}),
.sel(opmode_pmux[1:0]),
.out(x)

);

mux_4x1 #(.WIDTH(`C_WIDTH)) y_mux (

.in0({`C_WIDTH{1'b0}}),
.in1({{5{m[42]}},m}),
.in2({`C_WIDTH{1'b1}}),
.in3(c_pmux),
.sel(opmode_pmux[3:2]),
.out(y)

);

mux_8x1 #(.WIDTH(`C_WIDTH)) z_mux(

.in0(48'b0),
.in1(pcin),
.in2(p),
.in3(c_pmux),
.in4(p), 
.in5(pcin >> 17),
.in6(p >> 17),
.in7(48'b0),
.sel(opmode_pmux[6:4]),
.out(z)

);


mux_reg #(.REG(`ALU_MODEREG), .WIDTH(4)) alumode_mux (

.in(alumode),
.clk(clk),
.ce(cealumode),
.rst(rstalumode),
.out(alumode_pmux)

);

mux_8x1 #(.WIDTH(1)) carry_mux (

.in0(carryin_pmux),
.in1(~pcin[47]),
.in2(carrycascin),
.in3(pcin[47]),
.in4(carrycascout),
.in5(~p[47]),
.in6(~(amult[24]^bmult[17])),
.in7(p[47]),
.sel(carryinsel_pmux),
.out(cin)

);


generate 
  for(i = 0; i < 48/SIMD; i=i+1) begin
    alu #(.WIDTH(SIMD)) alu_u (
      .x(x[(SIMD*(i+1))-1 : SIMD*i]),
      .y(y[(SIMD*(i+1))-1 : SIMD*i]),
      .z(z[(SIMD*(i+1))-1 : SIMD*i]),
      .cin(cin),
      .multsignin(multsignin),
      .alumode(alumode_pmux),
      .opmode3(opmode_pmux[3]),
      .carryout( cout[SIMD == 12 ? i : SIMD == 24 ? (2*i+1) : 3] ),
      .p(alu_res[(SIMD*(i+1))-1 : SIMD*i])
    );
  end
endgenerate


generate
  if (`USE_PATTERN_DETECT == "PATDET") begin
    pattern_detect #( .SEL_PATTERN(`SEL_PATTERN), .SEL_MASK(`SEL_MASK),
                        .WIDTH(`C_WIDTH), .PATTERN(`PATTERN), .MASK(`MASK), .P_REG(`P_REG)) pd_u (
      .p(alu_res),
      .c(c_pmux),
      .clk(clk),
      .cep(cep),
      .rstp(rstp),
      .pd(patterndetect),
      .pbd(patternbdetect),
      .ov_f(overflow),
      .un_f(underflow)

      );
  end
endgenerate
    

mux_reg #(.REG(`P_REG),.WIDTH(`C_WIDTH)) p_mux (

.in(alu_res),
.clk(clk),
.ce(cep),
.rst(rstp),
.out(p)

);

mux_reg #(.REG(`P_REG),.WIDTH(4)) carryout_mux (

.in(cout),
.clk(clk),
.ce(cep),
.rst(rstp),
.out(carryout)

);



endmodule