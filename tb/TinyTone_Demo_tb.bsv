package TinyTone_Demo_tb;

  import TinyTone_Peripheral::*;
  import StmtFSM::*;
  import Vector::*;

  module mkTinyTone_Demo_tb(Empty);

    TinyTone_Peripheral_IFC dut <- mkTinyTone_Peripheral;

    rule start_dump;
      $dumpfile("tinytone_demo.vcd");
      $dumpvars();
    endrule

    Stmt testSeq = 
    seq 
      $display("=== TinyTone Demo - Perfect for LinkedIn! ===");
      
      dut.write_data(6'h00, 32'h0, 2'b00); 
      
      repeat(50) delay(1);
      
      $display("Enabling tone generation with low frequency (10 cycles)...");

      dut.write_data(6'h04, 32'd10, 2'b00); 
      delay(1);

      dut.write_data(6'h00, 32'h1, 2'b00); 
      delay(1);
      
      $display("Running for many cycles to show multiple tone periods...");
      repeat(500) delay(1);
      
      $display("Changing frequency to higher pitch (5 cycles)...");
      dut.write_data(6'h04, 32'd5, 2'b00); 
      delay(1);

      repeat(300) delay(1);
      
      $display("Changing to even higher pitch (3 cycles)...");
      dut.write_data(6'h04, 32'd3, 2'b00); 
      delay(1);
      
      repeat(200) delay(1);
      
      $display("Disabling tone generation...");
      dut.write_data(6'h00, 32'h0, 2'b00); 
      
      repeat(50) delay(1);
      
      $display("=== Demo Complete - Check tinytone_demo.vcd for awesome waveforms! ===");
    endseq;

    mkAutoFSM(testSeq);

  endmodule

endpackage
