# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile unit
vcom ../../hdl/io_debounce.vhd
vcom ../../hdl/io_debounce_rtl.vhd
vcom ../../hdl/io_debounce_cfg.vhd

# Compile testbench
vcom ../../tb/io_debounce_tb.vhd
