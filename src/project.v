module clock_12h(
    input clk,
    input rst,
    output reg [3:0] hours,     
    output reg [5:0] minutes,   
    output reg [5:0] seconds,   
    output reg am_pm            
);
 
    always @(posedge clk or posedge rst) begin
    if (rst) begin
        hours   <= 4'd11;   // 12:00:00 AM
        minutes <= 6'd0;
        seconds <= 6'd0;
        am_pm   <= 1'b0;    // AM
    end else begin
      if (seconds == 6'd59) begin
            seconds <= 6'd0;
        if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd12;
                    am_pm <= ~am_pm; 
                end else if (hours == 4'd12) begin
                    hours <= 4'd1;
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end
endmodule