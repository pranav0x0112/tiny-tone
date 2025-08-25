# Makefile for Tiny-Tone

TOP     = mkToneGen_tb
SRC_DIR = src
TB_DIR  = tb
BUILD   = build

BSC = bsc
BSCFLAGS = -u -sim -keep-fires -show-schedule -p +:$(SRC_DIR):$(TB_DIR)

all: sim

$(BUILD):
	mkdir -p $(BUILD)

sim: $(BUILD)
	$(BSC) -u -sim -keep-fires -show-schedule -p +:$(SRC_DIR):$(TB_DIR) -bdir $(BUILD) -simdir $(BUILD) -g $(TOP) $(TB_DIR)/ToneGen_tb.bsv
	$(BSC) -sim -bdir $(BUILD) -simdir $(BUILD) -o $(BUILD)/$(TOP).exe -e $(TOP)
	./$(BUILD)/$(TOP).exe

clean:
	rm -rf $(BUILD) *.bo *.ba *.exe *.vcd

.PHONY: all sim clean