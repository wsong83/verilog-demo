# clock 50MHz
set_property -dict { PACKAGE_PIN Y18    IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 20 -waveform {0 5} [get_ports {clk}];

# reset, active low
set_property -dict { PACKAGE_PIN F20    IOSTANDARD LVCMOS33 } [get_ports { rstn }];

# user key
set_property -dict { PACKAGE_PIN M13    IOSTANDARD LVCMOS33 } [get_ports { key[0] }];
set_property -dict { PACKAGE_PIN K14    IOSTANDARD LVCMOS33 } [get_ports { key[1] }];
set_property -dict { PACKAGE_PIN K13    IOSTANDARD LVCMOS33 } [get_ports { key[2] }];
set_property -dict { PACKAGE_PIN L13    IOSTANDARD LVCMOS33 } [get_ports { key[3] }];

# led
set_property -dict { PACKAGE_PIN F19    IOSTANDARD LVCMOS33 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN E21    IOSTANDARD LVCMOS33 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN D20    IOSTANDARD LVCMOS33 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN C20    IOSTANDARD LVCMOS33 } [get_ports { led[3] }];

# 7Segment LED
set_property -dict { PACKAGE_PIN M2    IOSTANDARD LVCMOS33 } [get_ports { seg_sel[0] }];
set_property -dict { PACKAGE_PIN N4    IOSTANDARD LVCMOS33 } [get_ports { seg_sel[1] }];
set_property -dict { PACKAGE_PIN L5    IOSTANDARD LVCMOS33 } [get_ports { seg_sel[2] }];
set_property -dict { PACKAGE_PIN L4    IOSTANDARD LVCMOS33 } [get_ports { seg_sel[3] }];
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { seg_sel[4] }];
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { seg_sel[5] }];

set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[0] }];
set_property -dict { PACKAGE_PIN M3    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[1] }];
set_property -dict { PACKAGE_PIN J6    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[2] }];
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[3] }];
set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[4] }];
set_property -dict { PACKAGE_PIN K6    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[5] }];
set_property -dict { PACKAGE_PIN K3    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[6] }];
set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { seg_dig[7] }];

