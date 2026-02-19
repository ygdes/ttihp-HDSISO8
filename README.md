# Tiny Tapeout Project: HDSISO8

This is a prototype that explores how to store more data in a shift register than a classic DFF could, using the specific IHP CMOS PDK.

A complex synchronous-to-asynchronous-to-synchronous interface ensures glitch-free operation, and past the overhead, allows arbitrary depth at ~2× density and good clock speed while keeping the dynamic power reasonable. Expect P&R mayhem though.

The scalability comes from modularity (one IO block and as many 32-bit tranches as you like) and an unconventional clocking system.

more info: reach me at https://hackaday.io/whygee
