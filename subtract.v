module subtract (
    inp1,
    inp2,
    diff
);
  input [31:0] inp1;
  input [31:0] inp2;
  output [31:0] diff;

  wire [31:0] bout;

  not_gate inv (
      inp2,
      bout
  );
  adder addition (
      inp1,
      bout,
      1'b1,
      diff
  );
endmodule