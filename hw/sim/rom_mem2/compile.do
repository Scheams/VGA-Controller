# https://www.xilinx.com/support/answers/66533.html
# Use in Tcl:
# report_compile_order -used_in simulation

# Copy memory file
file copy -force ../../generate/ip_user_files/mem_init_files/rom_mem2.mif ./

# Compile packages
vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../tb/vga_sim_pkg.vhd

# Compile unit
vlog ../../generate/rom_mem2/simulation/blk_mem_gen_v8_4.v
vlog ../../generate/rom_mem2/sim/rom_mem2.v
vlog ../../generate/ip_user_files/sim_scripts/rom_mem2/modelsim/glbl.v

# Compile testbench
vcom ../../tb/rom_mem2_tb.vhd
