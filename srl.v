module srl (
    in1,
    in2,
    out
);
  input [31:0] in1;
  input [31:0] in2;
  output [31:0] out;

  assign out = in2[0] == 1 ? {1'b0, in1[31:1]} : in1;
endmodule