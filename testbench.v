module Processor_tb;

  reg clk;

  Processor uut (.clk(clk));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    #1000000;
    $finish;
  end

endmodule