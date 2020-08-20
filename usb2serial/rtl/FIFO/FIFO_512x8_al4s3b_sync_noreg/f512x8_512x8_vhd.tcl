add_input_file { C:/QuickLogic/QuickWorks_2016.2_Release/spde/data/PolarPro-III/AL4S3B/rrw/fifo_blk.vhd}
add_input_file { f512x8_512x8.vhd }
setup_design -manufacturer QuickLogic -family "ArcticLink 4" -part QLAL4S3B -package PU90
compile
synthesize
auto_write f512x8_512x8_vhd.edf
