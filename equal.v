
module equal #(parameter WIDTH=48) (

input [WIDTH-1:0] p,
input [WIDTH-1:0] pattern,
input [WIDTH-1:0] mask,
output pd,
output pbd

);

wire [WIDTH-1:0] pt;
wire [WIDTH-1:0] pt_bar;

assign pt = ~(p ^ pattern) & mask;
assign pt_bar = ~(p ^ ~pattern) & mask;

assign pd = & pt;
assign pbd = & pt_bar;

endmodule
