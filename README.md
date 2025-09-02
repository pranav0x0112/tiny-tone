# Tiny-Tone

A PWM tone generator peripheral designed for [TinyQV](https://github.com/TinyTapeout/ttsky25a-tinyQV) - A RISC-V SoC for Tiny Tapeout.

> Read the full journey of Tiny-Tone [here](https://tiny-tone.hashnode.dev/tiny-tone)

## What is it?

TinyTone generates configurable PWM signals for audio tone generation. It provides a memory-mapped interface allowing the RISC-V SoC to control frequency and enable/disable tone output in real-time.

## Features

- Memory-mapped register interface (Control, Frequency, Status, Version)
- Configurable PWM frequency generation
- Real-time frequency control
- TinyQV-compatible timing and interface

## Usage

```bash
# Test the peripheral
make sim-peripheral

# Test basic tone generator  
make sim-basic

# Generate demo waveforms
make sim-demo

# Generate Verilog for TinyQV integration
make verilog

# Clean build artifacts
make clean
```

## Register Map

| Address | Register | Description |
|---------|----------|-------------|
| 0x00 | Control | Bit 0: Enable (1=on, 0=off) |
| 0x04 | Frequency | PWM frequency divider value |
| 0x08 | Status | Bit 0: Current PWM output state |
| 0x0C | Version | Version identifier (0x00010000) |

## Output

PWM signal appears on output pin 0, ready for driving speakers or buzzers.

Built with [Bluespec SystemVerilog](https://github.com/B-Lang-org/bsc).