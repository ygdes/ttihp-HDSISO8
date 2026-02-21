## How it works

As the name implies, it's a high density shift register for deep digital delays. According to the PDK for CMOS IHP at
https://github.com/IHP-GmbH/IHP-Open-PDK/blob/main/ihp-sg13g2/libs.ref/sg13g2_stdcell/doc/sg13g2_stdcell_typ_1p20V_25C.pdf

* Area of sg13g2_dfrbpq_1 : 48.98880
* Area of sg13g2_mux2_1 : 18.14400

MUX2 is almost 3× smaller than the DFF gate and could be used as a latch (which is larger, what the hail ?). This implementation uses 4 MUX-latches to store 3 bits at a given time and non-overlapping "clock" pulses perform the shifting.

Compared to a normal DFF, it could store twice the same amount of bits per unit of surface, if the controller is excluded, but since it could work for any depth, the controller's size becomes insignificant. Depths of several kilobits are possible withouth hassle (if all goes well), without heavily taxing the clock network, reducing simultaneous switching noise...

The apparent complexity comes from the 8-phase clock, which is brought to the "asynchronous" domain and the 8 pulses. Each of the 8 lanes is 8× slower (which relaxes timing constraints) but the overall throughput is preserved. So it "should" work at "full speed", I expect 50MHz to work (more or less).

For implementation, I use the Verilog workflow and instatiate cells directly from
https://github.com/IHP-GmbH/IHP-Open-PDK/blob/main/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v

## How to test

WARNING : This is highly experimental, only a first shot and also my first tapeout! I have a long experience in FPGA design, so I am confident (too confident?) but the edges are very rough and will irk the EDA tools. Also I learn Verilog and I miss VHDL...

* Clock and Reset can be asserted by external pins and internal signals.
* The pin CLK_OUT copies the currently selected clock, for external triggering and troubleshooting. If it oscillates, it should work.
* External reset (asserted at 0 like the internal one) overrides the internal reset, don't let it float. A weak pull-up to 1 is advised.
* External clock (pin EXT_CLK) can be selected using pin CLK_SEL (don't let them float)
* Always assert RESET (to 0) while changing the state of CLK_SEL
* Startup: RESET asserted, run clock, release RESET (RESET is internally clock-resynchronised)
* Input a '1' or a '0' on D_IN, and observe the value appearing on D_OUT after 256 clock cycles (or so)

Extra insight and observability:
* The IO port shows the 8 internal staggered pulses, turning from 0 to 1 and back to 0 in a linear sequence (think KITT or a 4017).
* 3 output pins provide the state of the 3-bit Gray counter, thus you should observe a pretty pattern where only one pin changes at each clock cycle.

## Bonus: LFSR

An 8-bit LFSR is also integrated to ease testing. Thus an oscilloscope and a variable frequency oscillator are enough to characterise the achieveable speed.

* Assert the external reset (0)
* Enable the internal LFSR by asserting pin LFRS_EN to 1
* Assert pin DIN_SEL (1) to route the LFSR bitstream to the SISO input
* run the clock (internal or external, depending on CLK_SEL)
* release Reset (1) (now it should be started)
* Connect an oscilloscope to observe the two traces D_OUT and LFSR_BIT while triggering on LFSR_PERIOD
* See if both traces match.
* Send me pictures of your scope traces!

Note: 8 bits gives a period of 255, the actual depth of the SISO is not exactly that so a shift is expected.

Note 2: The LFSR_PERIOD pulse appears 192 clock cycles after the release of the RESET pin.

![](TT_interface_PRNG_2.png)

You can play with it on Falstad's interactive simulator, using the .cjs file in this directory. A short link is https://is.gd/5dnN2C but might not work forever.

## External hardware

A basic custom test board will be put together, to hook the variable frequency generator and the oscilloscope probes.

Optionally, if you only want to make a "light chaser", hook 8 LED to the IO port, select the external clock and add a 555.
