# USB2Serial - S3 Gateware
Contains the Verilog RTL source for USB to Serial port design. This design is targeted for the QuickLogic 
S3B device in the 64-pin QFN package, on the QuickFeather development board. It provides a USB interface 
that may be used to send messages from a USB host to the M4 processor in the S3B, and vice-versa.

The QuickFeather board schematic can be found here in the /doc/ directory:
[QuickFeather github repo](https://github.com/QuickLogic-Corp/quick-feather-dev-board)

Documentation for this design, including the device pinout and the FPGA register map can be found
in the /doc/ directory of this repo.

## Synthesis and Place & Route
This FPGA design may be compiled with the QuickLogic Symbiflow open-source FPGA toolchain running
under Linux/Ubuntu.
[QuickLogic FPGA toolchain](https://github.com/QuickLogic-Corp/quicklogic-fpga-toolchain)
To install the QuickLogic FPGA toolchain, please follow the instructions in the above repo.

Once the above toolchain has been installed, go into the /rtl/ directory of this repo, and execute
the following command line:

```bash
ql_symbiflow -compile -d ql-eos-s3 -t top -v *.v  -p quickfeather.pcf -P pu64 -s usb2serial.sdc
```

The output and log files will be placed into the /build/ sub-directory.