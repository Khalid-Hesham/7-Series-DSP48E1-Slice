/*

##################################################################################
  `A_INPUT = DIRECT  for direct (default)
  `A_INPUT = CASCADE for cascade 
  `A_REG = 0 for no regs in direct path
  `A_REG = 1 for A2 (default)
  `A_REG = 2 for A1 and A2
  `A_CASC_REG = 0 for no regs in cascaded path
  `A_CASC_REG = 1 for B1 (default)
  `A_CASC_REG = 2 for B1 and B2
  `D_REG = 0 for no regs
  `D_REG = 1 for 1 reg (default)
  `AD_REG = 0 for no regs in A_MULT path
  `AD_REG = 1 for AD (default)
  `USE_DPORT = TRUE d is used 
  `USE_DPORT = FALSE d is unused (default)
##################################################################################
  `B_INPUT = DIRECT  for direct  (default)
  `B_INPUT = CASCADE for cascade 
  `B_REG = 0 for no regs in direct path
  `B_REG = 1 for B2 (default)
  `B_REG = 2 for B1 and B2
  `B_CASC_REG = 0 for no regs in cascaded path
  `B_CASC_REG = 1 for B1 (default)
  `B_CASC_REG = 2 for B1 and B2
##################################################################################
  `C_REG = 0 for no regs in direct path
  `C_REG = 1 for using 1 reg (default)
##################################################################################
  `ALU_MODEREG = 0 for no reg
  `ALU_MODEREG = 1 for 1 reg (default)
##################################################################################
  `CARRYIN_REG = 0 for no regs  
  `CARRYIN_REG = 1 for 1 reg  (default)
##################################################################################
  `CARRYINSEL_REG = 0 for no regs 
  `CARRYINSEL_REG = 1 for 1 reg (default)
##################################################################################
  `INMODE_REG = 1'b0 for no regs
  `INMODE_REG = 1'b1 for 1 reg (default)
##################################################################################
  `OPMODE_REG = 1'b0 for no regs 
  `OPMODE_REG = 1'b1 for 1 reg (default)
##################################################################################
  `M_REG = 1'b0 for no regs
  `M_REG = 1'b1 for 1 reg (default)
##################################################################################
  `P_REG = 1'b0 for 0 reg 
  `P_REG = 1'b1 for 1 reg (default)
##################################################################################
  `USE_MULT = NONE to save power when using only adder/logic unit
  `USE_MULT = MULTIPLY to use multipler (default)
  `USE_MULT = DYNAMIC for user switching between A*B and A:B operations
##################################################################################
  `USE_SIMD = ONE48 for using 1 alu unit (default)
  `USE_SIMD = TWO24 for using 2 alu units in parallel -> `USE_MULT must be NONE
  `USE_SIMD = FOUR12 for using 4 alu units in parallel -> `USE_MULT must be NONE
##################################################################################
   `USE_PATTERN_DETECT = PATDET it means `PATTERN detector and its features are used
   `USE_PATTERN_DETECT = (NO_PATDET) if it isn't used (default) 
   `SEL_PATTERN = C takes `PATTERN dynamically from c
   `SEL_PATTERN = (`PATTERN) takes `PATTERN from the `PATTERN attribute (default)
   `SEL_MASK = C takes `PATTERN dynamically from c
   `SEL_MASK = (`MASK) to use `MASK parameter (default)
   `SEL_MASK = ROUNDING_MODE1 to use c' left shifted by 1
   `SEL_MASK = ROUNDING_MODE2 to use c' left shifted by 2
##################################################################################

*/


`define A_WIDTH     30
`define A_REG       1
`define A_CASC_REG  1
`define A_INPUT   "DIRECT"

`define B_WIDTH     18
`define B_REG       1
`define B_CASC_REG  1
`define B_INPUT   "DIRECT"

`define C_WIDTH     48
`define C_REG       1

`define D_WIDTH     25
`define D_REG       1
`define AD_REG      1
`define USE_DPORT   "TRUE"

`define ALU_MODEREG     1
`define CARRYIN_REG     1
`define CARRYINSEL_REG  1
`define INMODE_REG      1
`define OPMODE_REG      1
`define M_REG           1
`define P_REG           1

`define USE_MULT   "MULTIPLY"
`define USE_SIMD   "ONE48"

`define USE_PATTERN_DETECT "PATDET"
`define SEL_PATTERN   "C"
`define SEL_MASK      "C"
`define PATTERN   48'b0
`define MASK      48'b0

