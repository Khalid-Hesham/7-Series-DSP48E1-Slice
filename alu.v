// USE_SIMD = ONE48 to disable Single Instruction Multiple Data 
// USE_SIMD = TWO24 to use Single Instruction Multiple Data 
// USE_SIMD = FOUR12 to use Single Instruction Multiple Data 

module alu #(parameter WIDTH = 1) (
  input  wire [WIDTH-1:0] x,
  input  wire [WIDTH-1:0] y,
  input  wire [WIDTH-1:0] z,
  input  wire             cin,
  input  wire             multsignin,
  input  wire [3:0]       alumode,
  input  wire             opmode3,
  output reg              carryout,
  output reg  [WIDTH-1:0] p
);

always @(*) begin
     
    case(alumode)
      4'b0000: {carryout,p} = x + y + z + cin; 
      4'b0001: {carryout,p} = x + y + (~z) + cin; 
      4'b0010: {carryout,p} = ~(x + y + z + cin); 
      4'b0011: {carryout,p} = -x - y + z - cin;
      4'b0100: p =(opmode3) ? ~(x ^ z) : x ^ z; 
      4'b0101: p =(opmode3) ? x ^ z : ~(x ^ z); 
      4'b0110: p =(opmode3) ? x ^ z : ~(x ^ z); 
      4'b0111: p =(opmode3) ? ~(x ^ z) : x ^ z; 
      4'b1100: p =(opmode3) ? x | z : x & z; 
      4'b1101: p =(opmode3) ? x | (~z) : x & (~z); 
      4'b1110: p =(opmode3) ? ~(x | z) : ~(x & z); 
      4'b1111: p =(opmode3) ? (~x) & z : (~x) | z;
      default : begin
              p = 'b0;
              carryout = 'b0;
				   end		 
    endcase
 end


  
endmodule