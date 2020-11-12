
module AL4S3B_FPGA_top ( usbp_io, usbn_io, usb_pu_cntrl_o, spi_cs_o, spi_sck_o, 
                         spi_mosi_o, spi_miso_i, accel_intn_o, led_o ) ;

    inout usbp_io ;
    inout usbn_io ;
    output usb_pu_cntrl_o ;
    output spi_cs_o ;
    output spi_sck_o ;
    output spi_mosi_o ;
    input spi_miso_i ;
    output accel_intn_o ;
    output led_o ;
