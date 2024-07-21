module register #(parameter WIDTH = 1)(
  input   wire  [WIDTH-1:0]  d,
  input   wire               clk,
  input   wire               rst,
  input   wire               en,
  output  reg   [WIDTH-1:0]  q
);

always @(posedge clk)
 begin
     if (rst)
	  q <= 'b0;
	 else
      q <= en ? d : q ;	 
 end


endmodule