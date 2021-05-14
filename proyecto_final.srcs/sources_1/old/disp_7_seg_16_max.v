`timescale 1ns / 1ps

module disp_7_seg_16_max(
    input clock,
    input reset,
    input[3:0] data,
    output[7:0] display,
    output[3:0] displaySelector
);

reg[3:0] dec, unit;

always @(*) begin
    dec = data / 10;
    unit = data % 10;
end

sweep4disp7seg s4d7s(
    .clk(clock),
    .rst(reset),
    .disp0(0),
    .disp1(0),
    .disp2(dec),
    .disp3(unit),
    .seg(display),
    .dispTrans(displaySelector)
);


endmodule
