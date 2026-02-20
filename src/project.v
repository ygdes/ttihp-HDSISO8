/*
 * Copyright (c) 2026 Yann Guidon
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_ygdes_hdsiso8 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

//  ui[0]: "CLK_SEL"
//  ui[1]: "EXT_CLK"
//  ui[2]: "EXT_RST"
//  ui[3]: "D_IN"

//  ui[6]: "LFSR_EN"
//  ui[7]: "DIN_SEL"

//  uo[0]: "D_OUT"
//  uo[1]: "GRAY0"
//  uo[2]: "GRAY1"
//  uo[3]: "GRAY2"
//  uo[4]: "CLK_OUT"

//  uo[6]: "LFSR_PERIOD"
//  uo[7]: "LFSR_BIT"

//  uio[0]: "PULSE0"
//  uio[1]: "PULSE1"
//  uio[2]: "PULSE2"
//  uio[3]: "PULSE3"
//  uio[4]: "PULSE4"
//  uio[5]: "PULSE5"
//  uio[6]: "PULSE6"
//  uio[7]: "PULSE7"
    
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = {5'b00000, ena, clk, rst_n}; // en attendant de sortir les pulses
  assign uio_oe  = 8'b111111; // tout en sortie !

  // List all unused inputs to prevent warnings
  // wire _unused = &{ena, clk, rst_n, 1'b0}; ==> envoyé sur uio_out

endmodule
