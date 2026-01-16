`default_nettype none

module spi_peripheral(
    input wire COPI, nCS, SCLK,
    input wire rst_n, clk,

    reg[7:0] EN_OUT_7_0,
    reg[15:8] EN_OUT_15_8,
    reg[7:0] EN_PWM_MODE_7_0,
    reg[15:8] EN_PWM_MODE_15_8, 
    reg[7:0] PWM_DUTY_CYCLE_7_0,
);

    always @(posedge SCLK) begin
        nCS <= 0;

    end
endmodule