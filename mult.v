// USE_MULT = NONE to save power when using only adder/logic unit
// USE_MULT = MULTIPLY to use multipler
// USE_MULT = DYNAMIC for user switching between A*B and A:B operations on the fly and


module mult #(parameter A_WIDTH = 25, B_WIDTH = 18, RES_WIDTH = A_WIDTH + B_WIDTH, USE_MULT = "MULTIPLY") (

input [A_WIDTH-1:0]     opa,
input [B_WIDTH-1:0]     opb,
output                  multsignout,
output [RES_WIDTH-1:0]  m_res

);

assign m_res = (USE_MULT == "MULTIPLY") ? opa * opb : 'b0;
assign multsignout = m_res[RES_WIDTH-1];


endmodule