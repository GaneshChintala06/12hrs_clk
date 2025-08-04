# Makefile for 12-hour clock Verilog project

# Default simulator
SIM ?= iverilog
TOP_MODULE = clock_12h
TESTBENCH = tb_clock_12h
SOURCES = project.v tb.v
OUTPUT = clock_sim
VCD_FILE = 12hrs_clk.vcd

# Default target
all: compile simulate

# Compile the design and testbench
compile:
	@echo "Compiling Verilog sources..."
	$(SIM) -o $(OUTPUT) $(SOURCES)
	@echo "Compilation complete."

# Run simulation
simulate: compile
	@echo "Running simulation..."
	./$(OUTPUT)
	@echo "Simulation complete. Check $(VCD_FILE) for waveforms."

# Run Python test script
test:
	@echo "Running Python test suite..."
	python3 test.py

# View waveforms (requires GTKWave)
view:
	@if command -v gtkwave >/dev/null 2>&1; then \
		echo "Opening waveform viewer..."; \
		gtkwave $(VCD_FILE) &; \
	else \
		echo "GTKWave not found. Install it to view waveforms."; \
	fi

# Clean generated files
clean:
	@echo "Cleaning up..."
	rm -f $(OUTPUT) $(VCD_FILE) *.vvp
	@echo "Clean complete."

# Synthesis check (requires Yosys)
synth:
	@if command -v yosys >/dev/null 2>&1; then \
		echo "Running synthesis check..."; \
		yosys -p "read_verilog $(TOP_MODULE).v; synth -top $(TOP_MODULE); stat" > synth_report.txt; \
		echo "Synthesis report saved to synth_report.txt"; \
	else \
		echo "Yosys not found. Install it for synthesis checking."; \
	fi

# Help target
help:
	@echo "Available targets:"
	@echo "  all      - Compile and simulate (default)"
	@echo "  compile  - Compile Verilog sources"
	@echo "  simulate - Run simulation"
	@echo "  test     - Run Python test suite"
	@echo "  view     - Open waveform viewer (requires GTKWave)"
	@echo "  synth    - Run synthesis check (requires Yosys)"
	@echo "  clean    - Remove generated files"
	@echo "  help     - Show this help message"

.PHONY: all compile simulate test view clean synth help