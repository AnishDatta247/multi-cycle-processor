module RegisterBank (
    wVal,
    wReg,
    rReg1,
    rReg2,
    sig,
    rVal1,
    rVal2,
    clk
);
  input signed [31:0] wVal;  //value to be written
  input [4:0] wReg;  //register to write to
  input [4:0] rReg1;  //register to read
  input [4:0] rReg2;  //register to read
  input sig;  //write if sig is 1
  output signed [31:0] rVal1;  //read value
  output signed [31:0] rVal2;  //read value
  input clk;

  reg signed [31:0] regBank[31:0];

  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      regBank[i] <= 0;
    end
  end

  assign rVal1 = regBank[rReg1];
  assign rVal2 = regBank[rReg2];

  always @(sig or wVal) begin
    //     $display("RegBank:    %d %d %d %d %d %d %d %d %d %d %d", regBank[0], regBank[1], regBank[2], regBank[3], regBank[4], regBank[5], regBank[6], regBank[7], regBank[8], regBank[9], regBank[10]);

    if (sig == 1) begin
      regBank[wReg] = wVal;
    end
  end
endmodule