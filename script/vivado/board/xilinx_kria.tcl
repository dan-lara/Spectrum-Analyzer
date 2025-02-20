set common_properties {}
set ip_properties {}
set bd_properties {}

set cpu_regex "/*zynq*"

lappend common_properties [dict create name part value xck26-sfvc784-2LV-c]
lappend common_properties [dict create name board_part value xilinx.com:kv260_som:part0:1.4]
lappend bd_properties [dict create name "board_connections" value "som240_1_connector xilinx.com:kv260_carrier:som240_1_connector:1.3"]
