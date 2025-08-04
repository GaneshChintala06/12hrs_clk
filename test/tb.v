`timescale 1ns / 1ps

module tb_clock_12h;

    // Inputs
    reg clk;
    reg rst;
    
    // Outputs
    wire [3:0] hours;
    wire [5:0] minutes;
    wire [5:0] seconds;
    wire am_pm;
    
    // Instantiate the Unit Under Test (UUT)
    clock_12h uut (
        .clk(clk), 
        .rst(rst), 
        .hours(hours), 
        .minutes(minutes), 
        .seconds(seconds), 
        .am_pm(am_pm)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock for simulation
    end
    
    // Test sequence
    initial begin
        // Initialize Inputs
        rst = 1;
        
        // Wait for global reset
        #100;
        rst = 0;
        
        // Monitor for a few seconds
        $monitor("Time: %0d:%02d:%02d %s", 
                 hours, minutes, seconds, am_pm ? "PM" : "AM");
        
        // Test reset functionality
        #1000;
        $display("\n--- Testing Reset ---");
        rst = 1;
        #20;
        rst = 0;
        
        // Fast simulation - advance time quickly
        repeat(100) begin
            #10;
        end
        
        // Test hour rollover
        $display("\n--- Testing Hour Rollover ---");
        force uut.hours = 4'd11;
        force uut.minutes = 6'd59;
        force uut.seconds = 6'd58;
        #20;
        release uut.hours;
        release uut.minutes;
        release uut.seconds;
        
        repeat(5) #10;
        
        $display("\n--- Testing 12 to 1 Rollover ---");
        force uut.hours = 4'd12;
        force uut.minutes = 6'd59;
        force uut.seconds = 6'd58;
        #20;
        release uut.hours;
        release uut.minutes;
        release uut.seconds;
        
        repeat(5) #10;
        
        $finish;
    end
    
    // VCD dump for waveform viewing
    initial begin
        $dumpfile("clock_12h.vcd");
        $dumpvars(0, tb_clock_12h);
    end
      
endmodule