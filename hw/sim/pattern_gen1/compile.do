# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile unit
vcom ../../hdl/pattern_gen1.vhd
vcom ../../hdl/pattern_gen1_rtl.vhd
vcom ../../hdl/pattern_gen1_cfg.vhd

# Compile testbench
vcom ../../tb/pattern_gen1_tb.vhd
