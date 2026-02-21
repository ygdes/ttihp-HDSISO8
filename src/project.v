/*
 * Copyright (c) 2026 Yann Guidon / whygee@f-cpu.org
 * SPDX-License-Identifier: Apache-2.0
 * Check the /doc and the diagrams
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

////////////////////////////// Plumbing //////////////////////////////

  // IO config & misc.
  assign uio_oe  = 8'b11111111; // Everything goes out


  // General/housekeeping signals
  wire CLK_SEL, EXT_CLK, EXT_RST, D_IN;
  assign CLK_SEL = ui_in[0];
  assign EXT_CLK = ui_in[1];
  assign EXT_RST = ui_in[2];
  assign D_IN    = ui_in[3];

  wire CLK_OUT;
  assign uo_out[1] = CLK_OUT;


  // SISO
  wire [3:0] Johnson;
  wire D_OUT;
  assign uo_out[0] = D_OUT;
  assign uo_out[2] = Johnson[0];
  assign uo_out[3] = Johnson[1];
  assign uo_out[4] = Johnson[2];
  assign uo_out[5] = Johnson[3];

  wire [7:0] PULSES;
  assign uio_out  = PULSES;


  // LFSR
  wire SHOW_LFSR, LFSR_EN, DIN_SEL;
  assign SHOW_LFSR = ui_in[5],
  assign LFSR_EN   = ui_in[6];
  assign DIN_SEL   = ui_in[7];

  wire LFSR_PERIOD, LFSR_BIT;
  assign uo_out[6] = LFSR_PERIOD;
  assign uo_out[7] = LFSR_BIT;


////////////////////////////// home soup //////////////////////////////

  wire INT_RESET, CLK_OUT, SISO_in;

  // CLK_OUT = clk if CLK_SEL=0, else EXT_CLK
  // assign CLK_OUT = CLK_SEL ? EXT_CLK : clk;
  (* keep *) sg13g2_mux2_2 soup_mux1(.A0(clk), .A1(EXT_CLK), .S(CLK_SEL), .X(CLK_OUT));

  // Combine Reset
  wire and_reset;
  (* keep *) sg13g2_nand2_2 soup_nand1(.Y(and_reset), .A(rst_n), .B(EXT_RST));

//  always@(posedge CLK_OUT) begin
//    // resynch INT_RESET = rst_n AND EXT_RST
//    INT_RESET <= rst_n & EXT_RST;
//  end;
  (* keep *) sg13g2_dfrbpq_2 soup_DFF1(.Q(INT_RESET), .D(and_reset), .RESET_B(1'b1), .CLK(CLK_OUT));

//  always@(posedge CLK_OUT, INT_RESET) begin
//    if (INT_RESET == 1'b0)
//      SISO_in <= 1'b0;
//    else
//    // SISO_in = LFSR_BIT if DIN_SEL=1 else default D_IN
//      SISO_in <= DIN_SEL ? LFSR_BIT : D_IN;
//  end
  wire mux_Din;
  (* keep *) sg13g2_mux2_2 soup_mux2(.A0(D_IN), .A1(LFSR_BIT), .S(DIN_SEL), .X(mux_Din));
  (* keep *) sg13g2_dfrbpq_2 soup_DFF2(.Q(SISO_in), .D(mux_Din), .RESET_B(INT_RESET), .CLK(CLK_OUT));


////////////////////////////// sub-modules //////////////////////////////

  LFSR8 lfsr(
    // In
    .CLK(CLK_OUT),
    .RESET(INT_RESET),
    .LFSR_EN(LFSR_EN),
    // Out
    .LFSR_PERIOD(LFSR_PERIOD),
    .LFSR_BIT(LFSR_BIT),
    .LFSR_STATE(PULSES));  // the LFSR state is temporarily routed to the byte output


////////////////////////////// All the dummies go here //////////////////////////////

  // List all unused inputs to prevent warnings
  wire _unused = &{
    ena,
    SHOW_LFSR,  // will select the uio_out data later
    ui_in[4],
    uio_in,
    1'b0};

  assign uo_out[4] = 1'b0; // unused out

  // dummy constants until I write the corresponding code

  // SISO
  assign D_OUT = 1'b0;
  assign Johnson = 4'b0000;

  // LFSR
  assign LFSR_PERIOD = LFSR_EN;
  assign LFSR_BIT = DIN_SEL;

endmodule
