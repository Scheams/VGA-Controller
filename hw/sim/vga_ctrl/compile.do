# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd
vcom ../../hdl/vga_ctrl_pkg.vhd

# Compile unit
vcom ../../hdl/vga_ctrl.vhd
vcom ../../hdl/vga_ctrl_rtl.vhd
vcom ../../hdl/vga_ctrl_cfg.vhd

# Compile testbench
vcom -2008 ../../tb/vga_ctrl_tb.vhd
