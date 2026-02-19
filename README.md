# Tiny Tapeout Project: HDSISO8

This is a prototype that explores how to store more data in a shift register than a classic DFF could, using the specific IHP CMOS PDK.
This is based on https://github.com/IHP-GmbH/IHP-Open-PDK/blob/main/ihp-sg13g2/libs.ref/sg13g2_stdcell/doc/sg13g2_stdcell_typ_1p20V_25C.pdf

Area of sg13g2_dfrbpq_1 : 48.98880
Area of sg13g2_mux2_1 : 18.14400

A complex synchronous-to-asynchronous-to-synchronous interface ensures glitch-free operation, and past the overhead, allows arbitrary depth at ~2× density and good clock speed while keeping the dynamic power reasonable. Expect P&R mayhem though.

The scalability comes from modularity (one IO block and as many 32-bit tranches as you like) and an unconventional clocking system.

more info: reach me at https://hackaday.io/whygee
