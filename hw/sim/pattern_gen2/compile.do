# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile unit
vcom ../../hdl/pattern_gen2.vhd
vcom ../../hdl/pattern_gen2_rtl.vhd
vcom ../../hdl/pattern_gen2_cfg.vhd

# Compile testbench
vcom ../../tb/pattern_gen2_tb.vhd
