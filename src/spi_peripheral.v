`default_nettype none

module spi_peripheral(

    //COPI:Raw Serial Data, nCS: Chip Select (Active low), SCLK: system clock for synchronization
    input wire COPI, nCS, SCLK,
    input wire rst_n, clk,

    output reg[7:0] EN_OUT_7_0,
    output reg[15:8] EN_OUT_15_8,
    output reg[7:0] EN_PWM_MODE_7_0,
    output reg[15:8] EN_PWM_MODE_15_8, 
    output reg[7:0] PWM_DUTY_CYCLE_7_0,
);

    //Transaction Components
    wire RW_Bit; //Read/Write bit
    wire [6:0] ADDR; //Address of register
    wire [7:0] DATA; //Serial Data
    
    //Transaction Register Selector
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            EN_OUT_7_0 <= 8'h00;
            EN_OUT_15_8 <= 8'h00;
            EN_PWM_MODE_7_0 <= 8'h00;
            EN_PWM_MODE_15_8 <= 8'h00;
            PWM_DUTY_CYCLE_7_0 <= 8'h00;
        end else begin
            if(transaction_ready && RW_BIT) begin
                case (ADDR)
                    7'h00: EN_OUT_7_0 <= DATA; 
                    7'h01: EN_OUT_15_8 <= DATA;
                    7'h02: EN_PWM_MODE_7_0 <= DATA;
                    7'h03: EN_PWM_MODE_15_8 <= DATA;
                    7'h04: PWM_DUTY_CYCLE_7_0 <= DATA;
                    default: ;
                endcase
            
            end
        end
    end
endmodule