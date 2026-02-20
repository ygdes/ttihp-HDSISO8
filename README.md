![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Project: HDSISO8

This is a prototype of a shift register that explores how to store data more densely than classic DFFs could, using the specific IHP CMOS PDK.

A complex synchronous-to-asynchronous-to-synchronous interface ensures glitch-free operation, and past the controller's overhead, allows arbitrary depth at ~2× density, with good clock speed and a reasonable dynamic power. Expect P&R mayhem though because I can't do the manual layout.

The scalability comes from modularity: one IO block controls as many 32-bit tranches as you like, with an unconventional clocking system.

An extra LFSR is provided for extra testability, using just a 'scope and a signal generator for frequency characterisation.

More info: reach me at https://hackaday.io/whygee
