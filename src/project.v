module tt_um_clock_12h (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    output wire       clk_out,
    output wire       rst_out
);

    // Internal clock signals
    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;
    reg am_pm;

    // Clock counter logic - Pure Verilog for synthesis
    always @(posedge clk or negedge rst_n) begin
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

    // Output assignments
    assign uo_out = {am_pm, 1'b0, seconds[5:4], hours};
    assign uio_out = {2'b00, minutes};
    assign uio_oe = 8'b11111111;  // All outputs
    assign clk_out = clk;
    assign rst_out = rst_n;

endmodule