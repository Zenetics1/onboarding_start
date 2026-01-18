<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
This is a SPI-controlled PWM peripheral, where the SPI Peripheral Module intakes three inputs COPI, nCS, and SCLK. It writes the serially sent data(8 bits) to one of 5 registers:

0x00: en_reg_out_7_0
0x01: en_reg_out_15_8
0x02: en_reg_pwm_7_0
0x03: en_reg_pwm_15_8
0x04: pwm_duty_cycle

A full transaction(16 bits total = 1 Write bit + 7 address bit + 8 data bits) is sent by the controller to the SPI Peripheral with the address(ADDR - 0x00-0x04) determining which register the data is sent too. 

The most significant bit is the read or write, but the read bit has been ommitted for this project and only writing(Bit: 1) is supported.

The registers manage PWM enables, output enables, and duty cycles for the PWM Peripheral.

## How to test

To test locally, use WSL terminal with choosen linux distro(Mine is Ubuntu) and cd into the test directory of the onboarding. 

Assuming you have run the proper commands to set up iverilog and other dependencies as specified in the UWASIC onboarding documentation, you can run:

make -B

This will run you tests.
