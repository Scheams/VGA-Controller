# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile unit
vcom ../../hdl/source_mux.vhd
vcom ../../hdl/source_mux_rtl.vhd
vcom ../../hdl/source_mux_cfg.vhd

# Compile testbench
vcom ../../tb/source_mux_tb.vhd
