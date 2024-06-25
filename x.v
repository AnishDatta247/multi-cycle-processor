// Code your design here
// Code your design here
// Code your design here
module Processor (
    clk
);
  input clk;

  reg [ 2:0] state;
  reg [15:0] imm1;
  reg [20:0] imm2;
  reg [25:0] imm3;

  reg [6:0] pc, npc;
  wire [31:0] ir;
  reg  [ 4:0] mar;
  reg signed [31:0] datain, stackin;
  wire signed [31:0] dataout, stackout;
  reg signed [31:0] A, B;
  wire signed [31:0] alu_out;
  reg signed  [31:0] wVal;
  wire signed [31:0] rVal1, rVal2;
  reg [4:0] wReg, rReg1, rReg2;

  wire sigwr, sigon;
  reg ifsig;
  wire [1:0] alusc, wrreg, res;
  wire [2:0] br, st;
  wire [3:0] alu_op;
  reg regwr;
  reg memwr, memon, cond, stackwr, stackon;

  InsMem ins (
      pc,
      0,
      ir,
      0,
      ifsig,
      clk
  );

  initial begin
    pc = -1;
    pc = 0;
    state = 0;
  end

  ControlUnit cu (
      ir,
      alu_op,
      alusc,
      wrreg,
      sigwr,
      sigon,
      res,
      br,
      st,
      clk
  );
  Memory data (
      mar,
      datain,
      dataout,
      memwr,
      memon,
      clk
  );
  ALU alu (
      A,
      B,
      alu_out,
      alu_op,
      clk
  );
  RegisterBank regb (
      wVal,
      wReg,
      rReg1,
      rReg2,
      regwr,
      rVal1,
      rVal2,
      clk
  );
  // Stack stack (
  //     sp,
  //     stackin,
  //     stackout,
  //     stackwr,
  //     stackon,
  //     clk
  // );

  always @(posedge clk) begin
    //     $display("state: %d, pc: %d, ir: %b, A: %d, B: %d, wReg: %d, alu_out: %d, wVal: %d, regwr: %d, rVal1: %d, rVal2: %d, br: %d, cond: %d", state, pc, ir, A, B, wReg, alu_out, wVal, regwr, rVal1, rVal2, br, cond);
    if (pc == 52 && state == 1) begin
      state <= 1;
      $finish;
    end

    // if (ir[31:26]==26) begin
    //   case(state)
    //     0: begin
    //       state <= 1;
    //       ifsig <= 1;
    //       npc <= pc+1;
    //     end
    //   endcase
    // end

    case (state)
      0: begin  //IF Stage
        state <= 1;
        regwr <= 0;
        ifsig <= 1;
        npc   <= pc + 1;
      end
      1: begin  //ID state
        state <= 2;
        ifsig <= 0;
        rReg1 <= ir[25:21];
        rReg2 <= ir[20:16];
        imm1  <= ir[15:0];
        imm2  <= ir[20:0];
        imm3  <= ir[25:0];
      end
      2: begin  //EX Stage
        state <= 3;
        if (br == 0) A <= rVal1;
        else A <= pc;

        if (alusc == 1) B <= {imm1[15] == 1 ? 16'b1111111111111111 : 16'b0000000000000000, imm1};
        else if (alusc == 2) B <= {imm2[20] == 1 ? 11'b11111111111 : 11'b00000000000, imm2};
        else if (alusc == 3) B <= {imm3[25] == 1 ? 6'b111111 : 6'b000000, imm3};
        else B <= rVal2;

        if (br == 1) cond <= 1;
        else if (br == 2) cond <= (rVal1 < 0);
        else if (br == 3) cond <= (rVal1 > 0);
        else if (br == 4) cond <= (rVal1 == 0);
        else cond <= 0;
      end
      3: begin  //MEM Stage
        state <= 4;
        if (cond) pc <= alu_out;
        else pc <= npc;

        if (sigon == 1) mar <= alu_out;
        if (sigwr == 1) datain <= rVal2;
        memwr <= sigwr;
        memon <= sigon;

        //         if(st==1) begin
        //           sp <= alu_out;
        //           stackin <= rVal2;
        //         end
        //         else if(st==2)  begin
        //         end
      end
      4: begin  //WB Stage
        state <= 0;
        if (wrreg == 1) wReg <= ir[15:11];
        else if (wrreg == 2) wReg <= ir[20:16];
        else if (wrreg == 3) wReg <= ir[25:21];

        if (res == 1) wVal <= rVal1;
        else if (res == 2) wVal <= alu_out;
        else if (res == 3) wVal <= dataout;
        memwr <= 0;
        memon <= 0;

        if (wrreg != 0) regwr <= 1;
        //         $display("\n");
      end
    endcase
  end
endmodule




module ControlUnit (
    inscode,
    aluop,
    alusc,
    wrreg,
    memwr,
    memen,
    res,
    br,
    st,
    clk
);
  input [31:0] inscode;
  output reg [3:0] aluop;
  output reg memwr, memen;
  output reg [2:0] br, st;
  output reg [1:0] alusc, wrreg, res;
  input clk;

  always @(inscode) begin
    case (inscode[31:26])
      0: begin
        aluop <= 0;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      1: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      2: begin
        aluop <= 1;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      3: begin
        aluop <= 1;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      4: begin
        aluop <= 2;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      5: begin
        aluop <= 2;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      6: begin
        aluop <= 3;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      7: begin
        aluop <= 3;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      8: begin
        aluop <= 4;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      9: begin
        aluop <= 4;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      10: begin
        aluop <= 5;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      11: begin
        aluop <= 5;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      12: begin
        aluop <= 6;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      13: begin
        aluop <= 6;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      14: begin
        aluop <= 7;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      15: begin
        aluop <= 7;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      16: begin
        aluop <= 8;
        alusc <= 0;
        wrreg <= 1;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      17: begin
        aluop <= 8;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 0;
        st <= 0;
      end
      18: begin
        aluop <= 0;
        alusc <= 1;
        wrreg <= 2;
        memwr <= 0;
        memen <= 1;
        res <= 3;
        br <= 0;
        st <= 0;
      end
      19: begin
        aluop <= 0;
        alusc <= 1;
        wrreg <= 0;
        memwr <= 1;
        memen <= 1;
        res <= 1;
        br <= 0;
        st <= 0;
      end
      20: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 2;
        memwr <= 0;
        memen <= 1;
        res <= 3;
        br <= 0;
        st <= 0;
      end
      21: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 0;
        memwr <= 1;
        memen <= 1;
        res <= 0;
        br <= 0;
        st <= 0;
      end
      22: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 0;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 1;
        st <= 0;
      end
      23: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 0;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 2;
        st <= 0;
      end
      24: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 0;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 3;
        st <= 0;
      end
      25: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 0;
        memwr <= 0;
        memen <= 0;
        res <= 2;
        br <= 4;
        st <= 0;
      end
      26: begin
        aluop <= 0;
        alusc <= 1;
        wrreg <= 2;
        memwr <= 0;
        memen <= 0;
        res <= 1;
        br <= 0;
        st <= 1;
      end
      27: begin
        aluop <= 0;
        alusc <= 2;
        wrreg <= 3;
        memwr <= 0;
        memen <= 1;
        res <= 3;
        br <= 0;
        st <= 2;
      end
      28: begin
        aluop <= 0;
        alusc <= 3;
        wrreg <= 0;
        memwr <= 1;
        memen <= 1;
        res <= 0;
        br <= 0;
        st <= 3;
      end
      29: begin
        aluop <= 0;
        alusc <= 3;
        wrreg <= 0;
        memwr <= 0;
        memen <= 1;
        res <= 0;
        br <= 0;
        st <= 4;
      end
      30: begin
        aluop <= 0;
        alusc <= 0;
        wrreg <= 2;
        memwr <= 0;
        memen <= 0;
        res <= 1;
        br <= 0;
        st <= 0;
      end
      31: begin
        aluop <= 0;
        alusc <= 3;
        wrreg <= 0;
        memwr <= 0;
        memen <= 0;
        res <= 0;
        br <= 0;
        st <= 0;
      end
      32: begin
        aluop <= 0;
        alusc <= 3;
        wrreg <= 0;
        memwr <= 0;
        memen <= 0;
        res <= 0;
        br <= 0;
        st <= 0;
      end
    endcase
  end
endmodule




module InsMem (
    addr,
    datain,
    dataout,
    sigwr,
    sigon,
    clk
);
  input [6:0] addr;
  input [31:0] datain;
  output reg [31:0] dataout;
  input sigwr;
  input sigon;
  input clk;

  reg [31:0] mem[127:0];

  initial begin
    mem[0]  <= 32'b00000100001000000000000000011000;
    mem[1]  <= 32'b01001100000000010000000000000000;
    mem[2]  <= 32'b01111000000000010000000000000000;
    mem[3]  <= 32'b00000100001000000000000000101101;
    mem[4]  <= 32'b01001100000000010000000000000001;
    mem[5]  <= 32'b01111000000000010000000000000000;
    mem[6]  <= 32'b00000100001000000000000000001010;
    mem[7]  <= 32'b01001100000000010000000000000010;
    mem[8]  <= 32'b01111000000000010000000000000000;
    mem[9]  <= 32'b00000100001000000000000000001000;
    mem[10] <= 32'b01001100000000010000000000000011;
    mem[11] <= 32'b01111000000000010000000000000000;
    mem[12] <= 32'b00000100001000000000000000010110;
    mem[13] <= 32'b01001100000000010000000000000100;
    mem[14] <= 32'b01111000000000010000000000000000;
    mem[15] <= 32'b00000100001111111111111110011100;
    mem[16] <= 32'b01001100000000010000000000000101;
    mem[17] <= 32'b01111000000000010000000000000000;
    mem[18] <= 32'b00000100001111111111111111011110;
    mem[19] <= 32'b01001100000000010000000000000110;
    mem[20] <= 32'b01111000000000010000000000000000;
    mem[21] <= 32'b00000100001000000000000001011010;
    mem[22] <= 32'b01001100000000010000000000000111;
    mem[23] <= 32'b01111000000000010000000000000000;
    mem[24] <= 32'b00000100001000000000000000000000;
    mem[25] <= 32'b01001100000000010000000000001000;
    mem[26] <= 32'b01111000000000010000000000000000;
    mem[27] <= 32'b00000100001111111111111111101001;
    mem[28] <= 32'b01001100000000010000000000001001;
    mem[29] <= 32'b01111000000000010000000000000000;
    mem[30] <= 32'b00000100001000000000000000001000;
    mem[31] <= 32'b00000100010000000000000000001001;
    mem[32] <= 32'b00001100010000000000000000000001;
    mem[33] <= 32'b01011100010000000000000000010011;
    mem[34] <= 32'b00001000001000100001100000000000;
    mem[35] <= 32'b00001000001000110010000000000000;
    mem[36] <= 32'b01111000100001010000000000000000;
    mem[37] <= 32'b00000100101000000000000000000001;
    mem[38] <= 32'b00001100101000000000000000000001;
    mem[39] <= 32'b01011100101000000000000000001100;
    mem[40] <= 32'b00001000100001010011000000000000;
    mem[41] <= 32'b01001000110001110000000000000000;
    mem[42] <= 32'b01001000110010000000000000000001;
    mem[43] <= 32'b00001001000001110100100000000000;
    mem[44] <= 32'b01100001001000000000000000000110;
    mem[45] <= 32'b00000001000001110100000000000000;
    mem[46] <= 32'b00001001000001110011100000000000;
    mem[47] <= 32'b00001001000001110100000000000000;
    mem[48] <= 32'b01001100110001110000000000000000;
    mem[49] <= 32'b01001100110010000000000000000001;
    mem[50] <= 32'b01011011111111111111111111110100;
    mem[51] <= 32'b01011011111111111111111111101101;
  end

  always @(addr or datain or sigwr or sigon) begin
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
    $monitor("%d %d %d %d %d %d %d %d %d %d %d", mem[0], mem[1], mem[2], mem[3], mem[4], mem[5],
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


module and_gate (
    in1,
    in2,
    res
);
  input [31:0] in1;
  input [31:0] in2;
  output [31:0] res;

  assign res = in1 & in2;
endmodule

module not_gate (
    in1,
    res
);
  input [31:0] in1;
  output [31:0] res;

  assign res = ~in1;
endmodule

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

module xor_gate (
    in1,
    in2,
    res
);
  input [31:0] in1;
  input [31:0] in2;
  output [31:0] res;

  assign res = in1 ^ in2;
endmodule

module sla (
    in1,
    in2,
    out
);
  input [31:0] in1;
  input [31:0] in2;
  output [31:0] out;

  assign out = in2[0] == 1 ? {in1[31], in1[29:0], 1'b0} : in1;
endmodule

module sra (
    in1,
    in2,
    out
);
  input [31:0] in1;
  input [31:0] in2;
  output [31:0] out;

  assign out = in2[0] == 1 ? {in1[31], in1[31:1]} : in1;
endmodule

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
