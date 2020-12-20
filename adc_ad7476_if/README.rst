=========================
ADC_7476_IF - S3 Gateware
=========================

Contains the Verilog RTL source for an ADC interface design, for the
Analog Devices 7476 ADC. This design is targeted for the QuickLogic S3B
device in the 64-pin QFN package, on the QuickFeather development board.
The design interfaces to an eternal ADC, connected to the QuickFeather
board via a Pmod connector (connector J8 on the QuickFeather board).

The QuickFeather board schematic can be found here in the /doc/
directory: `QuickFeather github
repo <https://github.com/QuickLogic-Corp/quick-feather-dev-board>`__

This design is intended to be connected to an external board containing
the ADC, such as the Pmod AD1 from Digilent: `Digilent Pmod
AD1 <https://store.digilentinc.com/pmod-ad1-two-12-bit-a-d-inputs/>`__

Documentation for this design, including the device pinout and the FPGA
register map can be found in the /doc/ directory of this repo.

This s3-gateware repo is used in the following app in the qorc-sdk repo:
`qorc-sdk/qf_apps/qf_mqttsn_ai_app/ <https://github.com/QuickLogic-Corp/qorc-sdk/tree/master/qf_apps/qf_mqttsn_ai_app>`__
This FPGA design will be compiled automatically when the above project
is compiled (assuming the QuickLogic Symbiflow tools have been
installed, and this repo from s3-gateware has been pulled). If you would
like to compile just the FPGA design alone, using the QuickLogic
Symbiflow tools, follow the instructions below.

.. _synthesis-and-place--route:

Synthesis and Place & Route
---------------------------

This FPGA design may be compiled with the QuickLogic Symbiflow
open-source FPGA toolchain running under Linux/Ubuntu. `QuickLogic FPGA
toolchain <https://github.com/QuickLogic-Corp/quicklogic-fpga-toolchain>`__
To install the QuickLogic FPGA toolchain, please follow the instructions
in the above repo.

Once the above toolchain has been installed, go into the /rtl/ directory
of this repo, and execute the following command line:

.. code:: bash

   ql_symbiflow -compile -d ql-eos-s3 -P pu64 -v *.v -t top -p quickfeather.pcf

The output and log files will be placed into the /build/ sub-directory.
