module adder (
    inp1,
    inp2,
    cin,
    sum
);
  input [31:0] inp1;
  input [31:0] inp2;
  input cin;
  output [31:0] sum;

  wire [31:0] P, G;
  wire [31:0] C;

  // Generate and Propagate signals
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin
      assign P[i] = inp1[i] ^ inp2[i];
      assign G[i] = inp1[i] & inp2[i];
    end
  endgenerate

  // Calculate the carries
  assign C[0] = G[0] | (P[0] & cin);
  generate
    for (i = 1; i < 32; i = i + 1) begin
      assign C[i] = G[i] | (P[i] & C[i-1]);
    end
  endgenerate

  // Calculate the sum bits
  assign sum[0] = P[0] ^ cin;
  generate
    for (i = 1; i < 32; i = i + 1) begin
      assign sum[i] = P[i] ^ C[i-1];
    end
  endgenerate
endmodule