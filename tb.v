`timescale 1ns/1ps
`include "params.v"

module tb();

localparam CLK_PERIOD = 100;
localparam PIPELINE = `A_REG + ( `AD_REG && (`USE_DPORT == "TRUE") ) + `M_REG + `P_REG;

reg                   clk;
reg   [`A_WIDTH-1:0]  a;
reg   [`A_WIDTH-1:0]  acin;
reg   [`D_WIDTH-1:0]  d;
reg                   cea1;
reg                   cea2;
reg                   ced;
reg                   cead;
reg                   rsta;
reg                   rstd;
reg                   rstinmode;
reg                   ceinmode;
reg   [`B_WIDTH-1:0]  b;
reg   [`B_WIDTH-1:0]  bcin;
reg                   ceb1;
reg                   ceb2;
reg                   rstb;
reg   [`C_WIDTH-1:0]  c;
reg                   cec;
reg                   rstc;
reg   [4:0]           inmode;
reg                   carryin;
reg                   cecarryin;
reg                   rstallcarryin;
reg   [6:0]           opmode;
reg   [2:0]           carryinsel;
reg                   cectrl;
reg                   rstctrl;
reg                   cem;
reg                   rstm;
reg   [3:0]           alumode;
reg                   cealumode;
reg                   rstalumode;
reg                   cep;
reg                   rstp;
reg                   multsignin;
reg                   carrycascin;
reg   [47:0]          pcin;
wire  [`A_WIDTH-1:0]  acout;
wire  [`B_WIDTH-1:0]  bcout;
wire                  multsignout;
wire                  carrycascout;
wire  [47:0]          pcout;
wire  [3:0]           carryout;
wire  [47:0]          p;
wire                  patterndetect;
wire                  patternbdetect;
wire                  overflow;
wire                  underflow;

integer i;
integer j;

initial 
 begin
     
	 start();
	 operation();
	
	$stop;
 end

task operation ();
  begin
    for(i=0; i<128; i=i+1)
      begin
        opmode = i;
        for(j=0; j<16; j=j+1) 
          begin
            alumode = j;
            repeat (PIPELINE) @(posedge clk);
            // ##(PIPELINE);
            // #(PIPELINE*CLK_PERIOD);
            a = a + 1'b1;
            b = b + 1'b1;
            c = c + 1'b1;
            d = d + 1'b1;
          end
      end
  end
endtask 

task start();
  begin 
     
    clk = 1'b0;
    a = 'd5;
    b = 'd7;
    c = 'd12;
    d = 'd7;
    acin = 'd7;
    bcin = 'd8;

    cea1 = 1'b1;
    cea2 = 1'b1;
    ceb1  = 1'b1;
    ceb2 = 1'b1;
    cec  = 1'b1;
    ced = 1'b1;
    cead = 1'b1;
    cem = 1'b1;
    cep = 1'b1;
    
    rsta = 1'b1;
    rstb  = 1'b1;
    rstc = 1'b1;
    rstd  = 1'b1;
    rstm  = 1'b1;
    rstp = 1'b1;
    
    inmode = 5'd4;
    ceinmode = 1'b1;
    rstinmode = 1'b1;
    
    alumode = 4'd0;
    cealumode = 1'b1;
    rstalumode = 1'b1;
    
    carryin = 1'b0;
    cecarryin = 1'b1;
    rstallcarryin = 1'b0;
    
    carrycascin = 1'b0;

    carryinsel = 3'd0;
    opmode = 7'd0;
    cectrl = 1'b1;
    rstctrl = 1'b1;
    
    multsignin = 1'b1;
    pcin = 'd122;
    
    @(posedge clk) 
      begin
        rsta = 1'b0;
        rstallcarryin = 1'b0;
        rstalumode = 1'b0;
        rstb = 1'b0;
        rstc = 1'b0;
        rstctrl = 1'b0;
        rstd = 1'b0;
        rstinmode = 1'b0;
        rstm = 1'b0;
        rstp = 1'b0;
      end
  end
endtask

always #(CLK_PERIOD/2) clk = ~clk;

dsp_top dut (

.clk(clk),
.a(a),
.acin(acin),
.d(d),
.cea1(cea1),
.cea2(cea2),
.ced(ced),
.cead(cead),
.rsta(rsta),
.rstd(rstd),
.rstinmode(rstinmode),
.ceinmode(ceinmode),
.b(b),
.bcin(bcin),
.ceb1(ceb1),
.ceb2(ceb2),
.rstb(rstb),
.c(c),
.cec(cec),
.rstc(rstc),
.inmode(inmode),
.carryin(carryin),
.cecarryin(cecarryin),
.rstallcarryin(rstallcarryin),
.opmode(opmode),
.carryinsel(carryinsel),
.cectrl(cectrl),
.rstctrl(rstctrl),
.cem(cem),
.rstm(rstm),
.alumode(alumode),
.cealumode(cealumode),
.rstalumode(rstalumode),
.cep(cep),
.rstp(rstp),
.multsignin(multsignin),
.carrycascin(carrycascin),
.pcin(pcin),
.acout(acout),
.bcout(bcout),
.multsignout(multsignout),
.carrycascout(carrycascout),
.pcout(pcout),
.carryout(carryout),
.p(p),
.patterndetect(patterndetect),
.patternbdetect(patternbdetect),
.overflow(overflow),
.underflow(underflow)

);

endmodule