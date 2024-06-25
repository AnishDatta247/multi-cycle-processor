module ALU (
    in1,
    in2,
    out,
    select,
    clk
);
  input [31:0] in1;
  input [31:0] in2;
  input [3:0] select;
  input clk;
  output [31:0] out;

  wire [31:0] outputs[9:0];

  adder add (
      in1,
      in2,
      0,
      outputs[0]
  );
  subtract sub (
      in1,
      in2,
      outputs[1]
  );
  and_gate andm (
      in1,
      in2,
      outputs[2]
  );
  or_gate orm (
      in1,
      in2,
      outputs[3]
  );
  xor_gate xorm (
      in1,
      in2,
      outputs[4]
  );
  not_gate notm (
      in1,
      outputs[5]
  );
  sla slam (
      in1,
      in2,
      outputs[6]
  );
  sra sram (
      in1,
      in2,
      outputs[7]
  );
  srl srlm (
      in1,
      in2,
      outputs[8]
  );

  //   always @(in1 or in2 or select) begin
  //     out = outputs[select];
  //   end
  assign out = outputs[select];
endmodule