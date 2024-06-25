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