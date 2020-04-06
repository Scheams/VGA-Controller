# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile unit
vcom ../../hdl/ctrl_mem1.vhd
vcom ../../hdl/ctrl_mem1_rtl.vhd
vcom ../../hdl/ctrl_mem1_cfg.vhd

# Compile testbench
vcom ../../tb/ctrl_mem1_tb.vhd
