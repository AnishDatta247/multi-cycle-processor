module or_gate (
    in1,
    in2,
    res
);
  input [31:0] in1;
  input [31:0] in2;
  output [31:0] res;

  assign res = in1 | in2;
endmodule