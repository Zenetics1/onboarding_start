<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
This is a SPI-controlled PWM peripheral, where the SPI Peripheral Module intakes three inputs COPI, nCS, and SCLK and writing the serially sent data(8 bits total) to one of 5 registers. This is based on the address(7 bits) given in a full transaction(16 bits total = 1 Write bit + 7 address bit + 8 data bits), with each register controlling PWM enables, output enables, and duty cycles. 

The data from the register is then sent to the the PWM Peripheral for signal generation.
## How to test

To be written at a later date

