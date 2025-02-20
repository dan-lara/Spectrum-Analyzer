##########################
## MIPI ISP interface 0 ##
##########################
### CLOCKS ##
#set_property PACKAGE_PIN F1 [get_ports mipi_phy_if_clk_n]
#set_property PACKAGE_PIN G1 [get_ports mipi_phy_if_clk_p]
#
### DATA LANES ##
#set_property PACKAGE_PIN E1 [get_ports mipi_phy_if_data_p[0]]
#set_property PACKAGE_PIN D1 [get_ports mipi_phy_if_data_n[0]]
#set_property PACKAGE_PIN F2 [get_ports mipi_phy_if_data_p[1]]
#set_property PACKAGE_PIN E2 [get_ports mipi_phy_if_data_n[1]]
#set_property PACKAGE_PIN G3 [get_ports mipi_phy_if_data_p[2]]
#set_property PACKAGE_PIN F3 [get_ports mipi_phy_if_data_n[2]]
#set_property PACKAGE_PIN E4 [get_ports mipi_phy_if_data_p[3]]
#set_property PACKAGE_PIN E3 [get_ports mipi_phy_if_data_n[3]]

## MISC ##
set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_phy_if_0_clk_p}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_phy_if_0_clk_n}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_phy_if_0_data_p[*]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {mipi_phy_if_0_data_n[*]}]

##########
## GPIO ##
##########
## ISP AP1302_RST_B HDA02 (Reset of the camera module) ##
#set_property PACKAGE_PIN J11 [get_ports {ap1302_rst_b}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ap1302_rst_b}]
#set_property SLEW SLOW [get_ports {ap1302_rst_b}]
#set_property DRIVE 4 [get_ports {ap1302_rst_b}]

## ISP AP1302_STANDBY HDA03 (Standby signal for the camera module) ##
#set_property PACKAGE_PIN J10 [get_ports {ap1302_standby}]
#set_property IOSTANDARD LVCMOS33 [get_ports {ap1302_standby}]
#set_property SLEW SLOW [get_ports {ap1302_standby}]
#set_property DRIVE 4 [get_ports {ap1302_standby}]

## Fan speed enable ##
set_property PACKAGE_PIN A12 [get_ports {fan_en_b}]
set_property IOSTANDARD LVCMOS33 [get_ports {fan_en_b}]
set_property SLEW SLOW [get_ports {fan_en_b}]
set_property DRIVE 4 [get_ports {fan_en_b}]

###################
## I2C Interface ##
###################
## TO AP1302 + Sensor AR1335
set_property PACKAGE_PIN G11 [get_ports iic_rtl_0_scl_io]
set_property PACKAGE_PIN F10 [get_ports iic_rtl_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_*]
set_property SLEW SLOW [get_ports iic_*]
set_property DRIVE 4 [get_ports iic_*]

###############
## PMOD pins ##
###############
#set_property PACKAGE_PIN H12     [get_ports pmod_pin1]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin1]
#set_property SLEW SLOW           [get_ports pmod_pin1]
#set_property DRIVE 4             [get_ports pmod_pin1]

#set_property PACKAGE_PIN E10     [get_ports pmod_pin2]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin2]
#set_property SLEW SLOW           [get_ports pmod_pin2]
#set_property DRIVE 4             [get_ports pmod_pin2]

#set_property PACKAGE_PIN D10     [get_ports pmod_pin3]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin3]
#set_property SLEW SLOW           [get_ports pmod_pin3]
#set_property DRIVE 4             [get_ports pmod_pin3]

#set_property PACKAGE_PIN C11     [get_ports pmod_pin4]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin4]
#set_property SLEW SLOW           [get_ports pmod_pin4]
#set_property DRIVE 4             [get_ports pmod_pin4]

#set_property PACKAGE_PIN B10     [get_ports pmod_pin7]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin7]
#set_property SLEW SLOW           [get_ports pmod_pin7]
#set_property DRIVE 4             [get_ports pmod_pin7]

#set_property PACKAGE_PIN E12     [get_ports pmod_pin8]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin8]
#set_property SLEW SLOW           [get_ports pmod_pin8]
#set_property DRIVE 4             [get_ports pmod_pin8]

#set_property PACKAGE_PIN D11     [get_ports pmod_pin9]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin9]
#set_property SLEW SLOW           [get_ports pmod_pin9]
#set_property DRIVE 4             [get_ports pmod_pin9]

#set_property PACKAGE_PIN B11     [get_ports pmod_pin10]
#set_property IOSTANDARD LVCMOS33 [get_ports pmod_pin10]
#set_property SLEW SLOW           [get_ports pmod_pin10]
#set_property DRIVE 4             [get_ports pmod_pin10]

