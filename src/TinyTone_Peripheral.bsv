package TinyTone_Peripheral;

  import ToneGen::*;
  import Vector::*;
  import RegFile::*;
  import FIFOF::*;

  interface TinyTone_Peripheral_IFC;
    method Action write_data(Bit#(6) address, Bit#(32) data, Bit#(2) data_write_n);
    method ActionValue#(Bit#(32)) read_data(Bit#(6) address, Bit#(2) data_read_n);
    method Bool data_ready();
    method Bool user_interrupt();
    method Bit#(8) uo_out(Bit#(8) ui_in);
  endinterface

  // Register map:
  // 0x00: Control Register (bit 0: enable, bits 31-1: reserved)
  // 0x04: Frequency Register (32-bit frequency divider value)
  // 0x08: Status Register (bit 0: pwm_out, bits 31-1: reserved)
  // 0x0C: Version Register (read-only, 0x00010000 = v1.0)

  module mkTinyTone_Peripheral(TinyTone_Peripheral_IFC);
    
    ToneGen_IFC toneGen <- mkToneGen;
    

    Reg#(Bit#(32)) controlReg <- mkReg(0);  // 0x00
    Reg#(Bit#(32)) freqReg <- mkReg(1000);  // 0x04 - default to 1000 cycles
    Reg#(Bit#(32)) versionReg <- mkReg(32'h00010000); // 0x0C - v1.0
    

    Reg#(Bool) dataReady <- mkReg(True);

    Reg#(Bool) prevEnable <- mkReg(False);
    Reg#(UInt#(32)) prevFreq <- mkReg(1000);
  
    rule updateToneGenEnable if (prevEnable != (controlReg[0] == 1));
      toneGen.setEnable(controlReg[0] == 1);
      prevEnable <= (controlReg[0] == 1);
    endrule
    
    rule updateToneGenFreq if (prevFreq != unpack(freqReg));
      toneGen.setFreq(unpack(freqReg));
      prevFreq <= unpack(freqReg);
    endrule

    method Action write_data(Bit#(6) address, Bit#(32) data, Bit#(2) data_write_n);
      if (data_write_n == 0) begin 
        case (address[5:2])
          0: controlReg <= data;        
          1: freqReg <= data;       
          default: noAction;
        endcase
      end
    endmethod

    method ActionValue#(Bit#(32)) read_data(Bit#(6) address, Bit#(2) data_read_n);
      Bit#(32) result = 0;
      if (data_read_n == 0) begin 
        case (address[5:2])
          0: result = controlReg;   
          1: result = freqReg;       
          2: result = zeroExtend(toneGen.pwmOut);
          3: result = versionReg;   
          default: result = 0;
        endcase
      end
      return result;
    endmethod

    method Bool data_ready() = dataReady;
    
    method Bool user_interrupt() = False; 

    method Bit#(8) uo_out(Bit#(8) ui_in);
      Bit#(8) output_pins = 0;
      output_pins[0] = toneGen.pwmOut; 
      return output_pins;
    endmethod

  endmodule

endpackage