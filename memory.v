module Memory (
    addr,
    datain,
    dataout,
    sigwr,
    sigon,
    clk
);
  input [4:0] addr;
  input [31:0] datain;
  output reg [31:0] dataout;
  input sigwr;
  input sigon;
  input clk;

  reg signed [31:0] mem[31:0];

  integer i;

  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      mem[i] = 32'b0;
    end
  end

  always @(addr or datain or sigwr or sigon) begin
    $display("%d %d %d %d %d %d %d %d %d %d %d", mem[0], mem[1], mem[2], mem[3], mem[4], mem[5],
             mem[6], mem[7], mem[8], mem[9], mem[10]);
    if (sigon) begin
      if (sigwr) begin
        mem[addr] = datain;
        dataout   = datain;
      end else begin
        dataout = mem[addr];
      end
    end
  end
endmodule