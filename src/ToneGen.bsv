package ToneGen;

  import Vector::*;
  import RegFile::*;
  import FIFOF::*;

  interface ToneGen_IFC;
    method Action setFreq(UInt#(32) freq);
    method Action setEnable(Bool en);
    method Bit#(1) pwmOut;
  endinterface

  module mkToneGen(ToneGen_IFC);
    Reg#(UInt#(32)) freq <- mkReg(0);
    Reg#(Bool) enable <- mkReg(False);
    Reg#(UInt#(32)) counter <- mkReg(0);
    Reg#(Bool) pwm <- mkReg(False);

    rule count if(enable);
      if(counter >= freq) begin
        counter <= 0;
        pwm <= !pwm;
      end
      else begin
        counter <= counter + 1;
      end
    endrule

    method Action setFreq(UInt#(32) f);
      freq <= f;
    endmethod

    method Action setEnable(Bool e);
      enable <= e;
    endmethod

    method Bit#(1) pwmOut = pack(pwm);

  endmodule
endpackage