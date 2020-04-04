# Compile package
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile PLL source
vlog ../../generate/vga_pll/vga_pll_clk_wiz.v
vlog ../../generate/vga_pll/vga_pll.v

# Needed for ModelSim simulation
vlog ../../generate/ip_user_files/sim_scripts/vga_pll/modelsim/glbl.v

# Compile testbench
vcom ../../tb/vga_pll_tb.vhd
