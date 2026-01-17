`default_nettype none

module spi_peripheral(

    //COPI:Raw Serial Data, nCS: Chip Select (Active low), SCLK: system clock for synchronization
    input wire COPI, nCS, SCLK,
    input wire rst_n, clk,

    output reg[7:0] EN_OUT_7_0,
    output reg[15:8] EN_OUT_15_8,
    output reg[7:0] EN_PWM_MODE_7_0,
    output reg[15:8] EN_PWM_MODE_15_8, 
    output reg[7:0] PWM_DUTY_CYCLE_7_0
);
    
    reg transaction_ready;

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

    //Flip-flops for double sync chain
    reg COPI_sync1, COPI_sync2;
    reg nCS_sync1, nCS_sync2;
    reg SCLK_sync1, SCLK_sync2;

    //double sync chain to clk domain
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            COPI_sync1 <= 1'b0; COPI_sync2 <= 1'b0;
            nCS_sync1 <= 1'b1; nCS_sync2 <= 1'b1;
            SCLK_sync1 <= 1'b0; SCLK_sync2 <= 1'b0;
        end else begin
            COPI_sync1 <= COPI;
            COPI_sync2 <= COPI_sync1;

            nCS_sync1 <= nCS;
            nCS_sync2 <= nCS_sync1;

            SCLK_sync1 <= SCLK;
            SCLK_sync2 <= SCLK_sync1;
        end
    end

    wire nCS_rising_edge;
    wire nCS_falling_edge;
    wire SCLK_rising_edge;
    
    //Edge detection for nCS and SCLK
    assign SCLK_rising_edge = SCLK_sync2 & ~SCLK_sync1;
    assign nCS_rising_edge = nCS_sync2 & ~nCS_sync1;
    assign nCS_falling_edge = ~nCS_sync2 & nCS_sync1;


    reg [3:0] counter;
    //Cycle Counter
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            transaction_ready <= 1'b0;
        end else begin
            if(counter == 15 && nCS_rising_edge) begin
                transaction_ready <= 1'b1;
            end else begin
                transaction_ready <= 1'b0;
            end
        end
    end

    reg [15:0] shift_reg;

    //Shift Register Logic    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            shift_reg <= 16'b0;
        end else begin
            if(nCS_falling_edge) begin
                shift_reg <= 16'b0;
                counter <= 4'b0;
        end else if(!nCS_sync2 && SCLK_rising_edge) begin
                shift_reg <= {shift_reg[14:0], COPI_sync2};
                counter <= counter + 4'd1; 
            end
        end
    end

      //Transaction Components
    wire RW_BIT; //Read/Write bit
    wire [6:0] ADDR; //Address of register
    wire [7:0] DATA; //Serial Data

    assign RW_BIT = shift_reg[15];
    assign ADDR = shift_reg[14:8];
    assign DATA = shift_reg[7:0];

endmodule