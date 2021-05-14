module digital_game(
    input reset,
    input clock,
    input start,
    input register,
    input[6:0] i_number,
    output[7:0] display,
    output[3:0] displaySelector, 
    output uartTX    
);
//ESTADOS
localparam RESET = 3'h0;
localparam IDLE = 3'h1;
localparam GENERATE_RANDOM = 3'h2;
localparam START_SENDING = 3'h3;
localparam SENDING_UART = 3'h4;
localparam WAITING_REGISTER = 3'h5;
localparam COMPARE_DATA = 3'h6;

reg[2:0] r_current_state, r_next_state;

//elementos de random_number
wire random_busy, random_done;
wire[6:0] random_number; 

//elementos de send_integer
wire uart_done, uart_busy;
reg uart_start;

//elementos para comparar y puntaje
reg[3:0] points;
reg compare_flag;

//instantación de modulos
random_number generate_random(
    .start(start),
    .clock(clock),
    .reset(reset),
    .random(random_number),
    .done(random_done),
    .busy(random_busy)
);

send_integer uart(
    .i_data(random_number),
    .i_start(uart_start),
    .reset(reset),
    .clock(clock),
    .o_busy(uart_busy),
    .o_done(uart_done),
    .o_serialTX(uartTX)
);

disp_7_seg_16_max display_mux(
    .clock(clock),
    .reset(reset),
    .data(points),
    .display(display),
    .displaySelector(displaySelector)
);

always@(posedge clock or negedge reset) begin
    if(!reset) begin r_next_state <= RESET;
    end
    else begin r_current_state <= r_next_state; 
    end
end 

always @(*) begin
    case(r_current_state)
    RESET: begin
        if(!reset) begin r_next_state <= RESET;
        end
        else begin r_next_state <= IDLE;
        end
    end
    IDLE: begin
        if(random_busy) begin r_next_state <= GENERATE_RANDOM;
        end
        else begin r_next_state <= IDLE;
        end
    end
    GENERATE_RANDOM: begin
        if(random_done) begin r_next_state <= START_SENDING;
        end
        else begin r_next_state <= GENERATE_RANDOM;
        end
    end
    START_SENDING: begin
        if(uart_busy) begin r_next_state <= SENDING_UART;
        end
        else begin r_next_state <= START_SENDING;
        end
    end
    SENDING_UART: begin
        if(uart_done) begin r_next_state <= WAITING_REGISTER;
        end
        else begin r_next_state <= SENDING_UART;
        end
    end
    WAITING_REGISTER: begin
        if(register) begin r_next_state <= COMPARE_DATA;
        end
        else begin r_next_state <= WAITING_REGISTER;
        end
    end
    COMPARE_DATA: begin
        if(compare_flag) begin r_next_state <= IDLE;
        end
        else begin r_next_state <= COMPARE_DATA;
        end
    end
    
    default: begin r_next_state <= RESET;
    end
    
    endcase
end

always@(*) begin
    case(r_current_state)
    RESET: begin
        points <= 1'b0;
        uart_start <= 1'b0;
        compare_flag = 1'b0;

    end
    IDLE: begin
        compare_flag = 1'b0;
    end
    GENERATE_RANDOM: begin
    end
    START_SENDING: begin
        uart_start <= 1'b1;
    end
    SENDING_UART: begin
        uart_start <= 1'b0;
    end
    WAITING_REGISTER: begin
    end
    COMPARE_DATA:  begin
        if(random_number == i_number) begin points = points + 4'b0001;
        end
        compare_flag = 1;
    end
        
    endcase
end


endmodule
