create_clock -period 5 [get_ports clk]
set_ideal_network  [get_ports clk]
set_clock_uncertainty 0.5 [get_clocks clk]

set_ideal_network  [get_ports rstn]

set_driving_cell -lib_cell AND2_X1  [all_inputs]
# set_input_transition -max 0.1 [all_inputs]
set_input_delay 2.0 -max -clock clk [all_inputs]

set_load -pin_load 0.6 [all_outputs]
set_output_delay 3.0 -max -clock clk [all_outputs]

set_max_area 0

set_max_fanout 50 ${current_design}

set_critical_range 5 ${current_design}
