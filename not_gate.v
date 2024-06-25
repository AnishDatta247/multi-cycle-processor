module not_gate (
    in1,
    res
);
  input [31:0] in1;
  output [31:0] res;

  assign res = ~in1;
endmodule