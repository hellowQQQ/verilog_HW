#creat physical clock port clk pad
create_clock -name clk -period 20ns [get_ports clk]

#creat virtual clock for output pad ledo
create_clock -name vir_clk -period 20ns

#set output delay
set_output_delay -clock vir_clk -max 1   [get_ports {ledo[*]}]
set_output_delay -clock vir_clk -min 0.5 [get_ports {ledo[*]}]