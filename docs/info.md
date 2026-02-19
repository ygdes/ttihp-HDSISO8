## How it works

As the name implies, it's a high density shift register for deep digital delays. According to the PDK for CMOS IHP:
https://github.com/IHP-GmbH/IHP-Open-PDK/blob/main/ihp-sg13g2/libs.ref/sg13g2_stdcell/doc/sg13g2_stdcell_typ_1p20V_25C.pdf

* Area of sg13g2_dfrbpq_1 : 48.98880
* Area of sg13g2_mux2_1 : 18.14400

MUX2 is almost 3× smaller than the DFF gate and could be used as a latch (which is larger, what the hail ?). This implementation uses 4 MUX-latches to store 3 bits at a given time and non-overlapping "clock" pulses perform the shifting.

Compared to a normal DFF, it could store twice the same amount of bits per unit of surface, if the controller is excluded, but since it could work for any depth, the controller's size becomes insignificant. Depths of several kilobits are possible withouth hassle (if all goes well).

The apparent complexity comes from the 8-phase clock, which is brought to the "asynchronous" domain and the 8 pulses. Each of the 8 lanes is 8× slower (which relaxes timing constraints) but the overall throughput is preserved. So it "should" work at "full speed" (50MHz should work).

## How to test

WARNING : This is highly experimental, only a first shot and also a first tapeout! I have a long experience in FPGA design, so I am confident but the edges are very rough and will irk the EDA tools. Also I learn Verilog and I miss VHDL...

* Clock and Reset can be asserted by external pins and internal signals.
* External reset overrides the internal reset, don't let it float.
* External clock (pin EXT_CLK) can be selected using pin CLK_SEL (don't let them float)
* Always force RESET when changing the state of CLK_SEL
* Startup : RESET asserted, run clock, release RESET (RESET is internally clock-resynchronised)
* Input a '1' or a '0' on D_IN, and observe the value appearing on D_OUT after 256 clock cycles (or so)

Extra insight and observability:
* The IO port shows the 8 internal staggered pulses, turning from 0 to 1 and back to 0 in a linear sequence (think KITT or 4017).
* 3 output pins provide the state of the 3-bit Gray counter, thus you should observe a pretty pattern where only one pin changes at each clock cycle.

Thus a variable frequency oscillator can be applied to characterise the achieveable speed, coupled with a 8-bit LFSR for example.

## External hardware

A basic custom test board will be put together, to hook the variable frequency generator and the oscilloscope.
