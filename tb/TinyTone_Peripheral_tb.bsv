package TinyTone_Peripheral_tb;

  import TinyTone_Peripheral::*;
  import StmtFSM::*;
  import Vector::*;

  module mkTinyTone_Peripheral_tb(Empty);

    TinyTone_Peripheral_IFC dut <- mkTinyTone_Peripheral;

    rule start_dump;
      $dumpfile("tinytone_peripheral.vcd");
      $dumpvars();
    endrule

    Stmt testSeq = 
    seq 
      $display("Starting TinyTone Peripheral test...");
      $display("Testing register interface...");

      dut.write_data(6'h00, 32'h1, 2'b00); 
      delay(10);
      
      dut.write_data(6'h04, 32'd100, 2'b00); 
      delay(10);

      action
        let ctrl <- dut.read_data(6'h00, 2'b00);
        $display("Control register: 0x%08x", ctrl);
      endaction
      
      action
        let freq <- dut.read_data(6'h04, 2'b00);
        $display("Frequency register: 0x%08x", freq);
      endaction
      
      action
        let version <- dut.read_data(6'h0C, 2'b00);
        $display("Version register: 0x%08x", version);
      endaction
      
      $display("Running PWM generation for 200 cycles...");

      repeat (200) action
        let status <- dut.read_data(6'h08, 2'b00);
        let outputs = dut.uo_out(8'h00);
        $display("Status: 0x%08x, PWM out: %0d, Output pins: 0x%02x", 
                 status, outputs[0], outputs);
      endaction
      
      dut.write_data(6'h00, 32'h0, 2'b00); 
      delay(10);

      repeat (20) action
        let outputs = dut.uo_out(8'h00);
        $display("After disable - PWM out: %0d", outputs[0]);
      endaction
      
      $display("TinyTone Peripheral test complete!");
    endseq;

    mkAutoFSM(testSeq);

  endmodule

endpackage