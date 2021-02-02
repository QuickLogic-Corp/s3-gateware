add_input_file { C:/QuickLogic/QuickWorks_2016.1.1_Release/spde/data/PolarPro-III/AL4S3B/rrw/ram_blk.v}
add_input_file { r512x16_512x16.v }
setup_design -manufacturer QuickLogic -family "ArcticLink 4" -part QLAL4S3B -package PU90
compile
synthesize
auto_write r512x16_512x16_v.edf
