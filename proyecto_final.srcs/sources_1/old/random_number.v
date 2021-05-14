module random_number (
    input start,
    input clock,
    input reset,
    output reg[6:0] random,
    output reg done,
    output reg busy
);

parameter NBITS_COUNTER = 100;

reg[2:0] rCurrentState;
reg[2:0] rNextState;

localparam  INIT = 0;
localparam  IDLE = 1;
localparam  START = 3;
localparam  FINISH = 4;
localparam  RUNNING = 2;

always @(posedge clock or negedge reset) begin
  if(!reset) begin
    rNextState <= INIT;
  end
  else begin
    rCurrentState <= rNextState;
  end
end

always @ (*) begin
        case(rCurrentState)
        INIT: begin
            rNextState <= IDLE;  
        end
        IDLE: begin
            if(start) begin rNextState <= START;
            end
        
        end
        START: begin rNextState <= RUNNING;
        end
        RUNNING: begin 
            if(!start) begin rNextState <= FINISH;
            end
        end  
        FINISH: begin 
            rNextState <= IDLE;
        end  
    endcase
    
end

always @(posedge clock or negedge reset) begin
    if(!reset) begin
    random <= 6'b0;
    done <= 1'b0;
    busy <= 1'b0;
    end

    else begin
    case(rCurrentState)
    
    INIT: begin
    random <= 6'b0;
    done <= 1'b0;
    busy <= 1'b0;
    end
    
    IDLE: begin
        done <= 1'b0;
    end
    
    START: begin
        busy <= 1'b1;
    end    
    
    RUNNING: begin
        random = random + 1;
        if(random == 100) begin random = 0;
        end
    end
    
    FINISH: begin
        done <= 1'b1;
        busy <= 1'b0;
    end
    
    endcase
        
    end


end

endmodule
