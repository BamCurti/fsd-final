// Company: 
// Engineer: 
// 
// Create Date: 13.05.2021 19:03:00
// Design Name: 
// Module Name: digital_gameTB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module digital_gameTB();

reg reset;
reg clock;
reg start;
reg register;
reg[6:0] i_number;
wire[7:0] display;
wire[3:0] displaySelector; 
wire uartTX;

digital_game DUT(
    .reset(reset),
    .clock(clock),
    .start(start),
    .register(register),
    .i_number(i_number),
    .display(display),
    .displaySelector(displaySelector), 
    .uartTX(uartTX)    
);

always begin #1 clock = ~clock;
end

initial begin
    clock = 0;
    reset = 1;
    start = 0;
    register = 0;
    i_number = 6'd0;
    
    #10;
    
    reset = 0;
    
    #10;
    
    reset = 1;
    
    #10;
    
    //EMPIEZA A CONTAR
    start = 1;
    #10;
    
    //TERMINA DE CONTAR
    start = 0;
    
    //MANDA INFORMACIÓN POR UART
    #1_000_000;
    
    //REGISTRO
    i_number = 4;
    #10;
    register = 1;
    #10;
    register = 0;
    
    #1_000_000;
    
    
    $stop();
    
end


endmodule
