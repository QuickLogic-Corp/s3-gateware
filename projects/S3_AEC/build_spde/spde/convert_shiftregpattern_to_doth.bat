REM
REM  Batch to generate usb2serial.bin
REM 
REM copy AL4S3B_FPGA_top.chp usb2serial.chp
REM spdecl.exe -load usb2serial.chp -save_config_bits
perl convert_fbcfg_to_cpuwrites.pl -h ShiftRegPattern.qlal4s3b.top > fpga.h
REM del usb2serial.clk usb2serial.spd temp.txt spdecl.log qlal4s3b_usb2serial.jlink qlal4s3b_usb2serial.bin ShiftRegPattern.qlal4s3b.usb2serial ShiftPattern.qlal4s3b.usb2serial.csv
pause

