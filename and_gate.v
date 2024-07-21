module and_gate #(parameter GATES = 1) (
  input   wire  [GATES-1:0]  a,
  input   wire  [GATES-1:0]  b,
  output  wire  [GATES-1:0]  out
);

assign out = a & b;


endmodule