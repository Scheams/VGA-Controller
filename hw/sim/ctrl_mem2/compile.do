# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile unit
vcom ../../hdl/ctrl_mem2.vhd
vcom ../../hdl/ctrl_mem2_rtl.vhd
vcom ../../hdl/ctrl_mem2_cfg.vhd

# Compile testbench
vcom ../../tb/ctrl_mem2_tb.vhd
