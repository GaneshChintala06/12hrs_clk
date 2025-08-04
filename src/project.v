/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_clock_12h (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Enable - goes high when design is selected
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset_n - low to reset
);

    // Internal registers for clock
    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;
    reg am_pm;

    // Clock logic
    always @(posedge clk) begin
        if (!rst_n) begin
            hours   <= 4'd12;
            minutes <= 6'd0;
            seconds <= 6'd0;
            am_pm   <= 1'b0;    // 0 = AM, 1 = PM
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
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

    // Output assignments
    assign uo_out = {am_pm, 1'b0, seconds[5:4], hours};
    assign uio_out = {2'b00, minutes};
    assign uio_oe  = 8'b11111111;  // All IOs are outputs

    // Suppress warnings for unused inputs
    wire _unused = &{ui_in, uio_in, 1'b0};

endmodule