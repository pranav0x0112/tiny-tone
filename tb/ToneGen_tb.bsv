package ToneGen_tb;

  import ToneGen::*;
  import StmtFSM::*;
  import Vector::*;

  module mkToneGen_tb(Empty);

    ToneGen_IFC dut <- mkToneGen;

    Reg#(Bool) dumpDone <- mkReg(False);

    rule dump_once (!dumpDone);
      $dumpfile("tonegen.vcd");
      $dumpvars();
      dumpDone <= True;
    endrule

    Stmt testSeq = 
    seq 
      dut.setEnable(True);
      $display("Starting PWM test...");

      dut.setFreq(5);

      dut.setEnable(True);

      repeat (50) action
        $display("pwmOut = %0d", dut.pwmOut);
      endaction

      dut.setEnable(False);
      $display("Test Complete!");
    endseq;

    mkAutoFSM(testSeq);

  endmodule
endpackage