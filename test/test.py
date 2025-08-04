#!/usr/bin/env python3
"""
Test script for 12-hour clock Verilog module
Runs simulation and validates clock behavior
"""

import subprocess
import sys
import os

def run_command(cmd, description):
    """Run a shell command and handle errors"""
    print(f"Running: {description}")
    print(f"Command: {cmd}")
    
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"ERROR: {description} failed!")
        print(f"STDOUT: {result.stdout}")
        print(f"STDERR: {result.stderr}")
        return False
    else:
        print(f"SUCCESS: {description} completed")
        if result.stdout:
            print(f"Output: {result.stdout}")
        return True

def main():
    """Main test function"""
    print("=" * 50)
    print("12-Hour Clock Verilog Test Suite")
    print("=" * 50)
    
    # Check if required files exist
    required_files = ['project.v', 'tb.v']
    for file in required_files:
        if not os.path.exists(file):
            print(f"ERROR: Required file {file} not found!")
            sys.exit(1)
    
    # Compile and run simulation with Icarus Verilog
    if run_command("iverilog -o clock_sim project.v tb.v", "Compilation"):
        if run_command("./clock_sim", "Simulation"):
            print("\n" + "=" * 50)
            print("All tests passed successfully!")
            print("Check 12hrs_clk.vcd for waveform analysis")
            print("=" * 50)
        else:
            sys.exit(1)
    else:
        sys.exit(1)

if __name__ == "__main__":
    main()