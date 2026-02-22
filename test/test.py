# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

# modified for the LFSR
# by Yann Guidon / 2026

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

# I/O bits and constants:
CLK_SEL     =   1  # assign CLK_SEL = ui_in[0];
EXT_CLK     =   2  # assign EXT_CLK = ui_in[1];
EXT_RST     =   4  # assign EXT_RST = ui_in[2];
D_IN        =   8  # assign D_IN    = ui_in[3];
                   # ui_in[3] unused
SHOW_LFSR   =  32  # assign SHOW_LFSR = ui_in[5];
LFSR_EN     =  64  # assign LFSR_EN   = ui_in[6];
DIN_SEL     = 128  # assign DIN_SEL   = ui_in[7];

D_OUT       =   1  # assign uo_out[0] = D_OUT;
CLK_OUT     =   2  # assign uo_out[1] = CLK_OUT;
Johnson0    =   4  # assign uo_out[2] = Johnson[0];
Johnson1    =   8  # assign uo_out[3] = Johnson[1];
Johnson2    =  16  # assign uo_out[4] = Johnson[2];
Johnson3    =  32  # assign uo_out[5] = Johnson[3];
LFSR_PERIOD =  64  # assign uo_out[6] = LFSR_PERIOD;
LFSR_BIT    = 128  # assign uo_out[7] = LFSR_BIT;

# assign uio_out  = PULSES or LFSR;

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.uio_in.value = 0  # will not change
    dut.ena.value = 1     # no change either
    dut.rst_n.value = 0   # circuit stopped

    dut.ui_in.value = LFSR_EN + SHOW_LFSR # early selection
    # CLK_SEL=0, internal clock selected.
    # DIN_SEL not used yet.
    await ClockCycles(dut.clk, 2)
  
    dut.rst_n.value = 1            # wake up (from inside)
    await ClockCycles(dut.clk, 2)
    dut._log.info("Test project behavior")

    # The real wake-up

    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = EXT_RST + LFSR_EN + SHOW_LFSR  # RESET released, it should take one clock to take effect
    await ClockCycles(dut.clk, 1)
    assert dut.uio_out.value == 6 # init pattern
    dut._log.info("wake up")

    i = 0
    while (True):   # run baby run
      await ClockCycles(dut.clk, 1)
      i = i+1
      assert i < 200
      if dut.uo_out.value[6]:
        dut._log.info("Period 1: " + str(i) + " = " + str(dut.uio_out.value))
        assert dut.uio_out.value == 255
        assert i == 193
        break

    i = 0
    while (True):  # one more time ?
      #assert dut.uio_out.value != 0
      await ClockCycles(dut.clk, 1)
      i = i+1
      assert i < 260
      if dut.uo_out.value[6]:
        dut._log.info("Period 2: " + str(i) + " = " + str(dut.uio_out.value))
        assert dut.uio_out.value == 255
        assert i == 255
        break

    dut._log.info(" OK !")

# junkyard...

#    for i in range(1, 254):
#      await ClockCycles(dut.clk, 1)
#      assert dut.uo_out.value[6] == 0

#    for i in range(1, ):   # run baby run
#      await ClockCycles(dut.clk, 1)
#      if i > 180:
#        dut._log.info(str(i) + ": " + str(dut.uo_out.value[6]))

#    await ClockCycles(dut.clk, 1)
#    if dut.uo_out.value[6] :
#      dut._log.info("Period")
#    assert dut.uo_out.value[6] == 1

#    dut.ui_in.value = 20
#    await ClockCycles(dut.clk, 1)
#    assert dut.uo_out.value == 129

