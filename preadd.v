// INMODE[3] = 1 for subtract
// INMODE[3] = 0 for add

module preadd #(parameter WIDTH = 25)(
  input   wire  [WIDTH-1:0]  op1, 
  input   wire  [WIDTH-1:0]  op2, 
  input   wire                    inmode3, 
  output  reg   [WIDTH-1:0]  res
);

always @(*) begin
  if(inmode3)
    res = op1 - op2;
  else
    res = op1 + op2;
end
  
endmodule