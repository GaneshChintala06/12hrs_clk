module clock_12h(
    input wire clk,
    input wire rst,
    output reg [3:0] hours,     
    output reg [5:0] minutes,   
    output reg [5:0] seconds,   
    output reg am_pm            
);

    // Clock logic with proper formatting and explicit widths
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hours   <= 4'd12;   // Reset to 12:00:00 AM (12 is correct for 12-hour format)
            minutes <= 6'd0;
            seconds <= 6'd0;
            am_pm   <= 1'b0;    // AM = 0, PM = 1
        end else begin
            // Increment seconds every clock cycle
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                
                // Increment minutes when seconds roll over
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    
                    // Hour logic - handle 12-hour format transitions
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        am_pm <= ~am_pm;  // Toggle AM/PM at 12
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;    // 12 -> 1
                    end else begin
                        hours <= hours + 4'd1;  // Explicit width
                    end
                end else begin
                    minutes <= minutes + 6'd1;  // Explicit width
                end
            end else begin
                seconds <= seconds + 6'd1;      // Explicit width
            end
        end
    end

endmodule