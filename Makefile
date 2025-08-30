# Makefile for Tiny-Tone

TOP_BASIC     = mkToneGen_tb
TOP_PERIPHERAL = mkTinyTone_Peripheral_tb
SRC_DIR = src
TB_DIR  = tb
BUILD   = build

BSC = bsc
BSCFLAGS = -u -sim -keep-fires -show-schedule -p +:$(SRC_DIR):$(TB_DIR)

all: sim-peripheral

$(BUILD):
	mkdir -p $(BUILD)


sim-basic: $(BUILD)
	$(BSC) $(BSCFLAGS) -bdir $(BUILD) -simdir $(BUILD) -g $(TOP_BASIC) $(TB_DIR)/ToneGen_tb.bsv
	$(BSC) -sim -bdir $(BUILD) -simdir $(BUILD) -o $(BUILD)/$(TOP_BASIC).exe -e $(TOP_BASIC)
	./$(BUILD)/$(TOP_BASIC).exe

sim-peripheral: $(BUILD)
	$(BSC) $(BSCFLAGS) -bdir $(BUILD) -simdir $(BUILD) -g $(TOP_PERIPHERAL) $(TB_DIR)/TinyTone_Peripheral_tb.bsv
	$(BSC) -sim -bdir $(BUILD) -simdir $(BUILD) -o $(BUILD)/$(TOP_PERIPHERAL).exe -e $(TOP_PERIPHERAL)
	./$(BUILD)/$(TOP_PERIPHERAL).exe

sim-demo: $(BUILD)
	$(BSC) $(BSCFLAGS) -bdir $(BUILD) -simdir $(BUILD) -g mkTinyTone_Demo_tb $(TB_DIR)/TinyTone_Demo_tb.bsv
	$(BSC) -sim -bdir $(BUILD) -simdir $(BUILD) -o $(BUILD)/mkTinyTone_Demo_tb.exe -e mkTinyTone_Demo_tb
	./$(BUILD)/mkTinyTone_Demo_tb.exe

verilog: $(BUILD)
	$(BSC) -u -verilog -keep-fires -p +:$(SRC_DIR) -bdir $(BUILD) -vdir $(BUILD) -g mkTinyTone_Peripheral $(SRC_DIR)/TinyTone_Peripheral.bsv

# Default to peripheral simulation
sim: sim-peripheral

clean:
	rm -rf $(BUILD) *.bo *.ba *.exe *.vcd

.PHONY: all sim sim-basic sim-peripheral sim-demo verilog clean