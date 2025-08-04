module clock_12h (
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] hours,
    output reg  [5:0] minutes,
    output reg  [5:0] seconds,
    output reg        am_pm
);

    // Clock counter logic - Pure Verilog for synthesis
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hours   <= 4'd12;
            minutes <= 6'd0;
            seconds <= 6'd0;
            am_pm   <= 1'b0;    // 0 = AM, 1 = PM
        end else begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Handle hour transitions
                    case (hours)
                        4'd11: begin
                            hours <= 4'd12;
                            am_pm <= ~am_pm;
                        end
                        4'd12: begin
                            hours <= 4'd1;
                        end
                        default: begin
                            hours <= hours + 4'd1;
                        end
                    endcase
                end else begin
                    minutes <= minutes + 6'd1;
                end
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end

endmodule