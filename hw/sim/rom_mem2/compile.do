# https://www.xilinx.com/support/answers/66533.html
# Use in Tcl:
# report_compile_order -used_in simulation

file copy -force ../../generate/ip_user_files/mem_init_files/rom_mem2.mif ./

vlog ../../generate/rom_mem2/simulation/blk_mem_gen_v8_4.v
vlog ../../generate/rom_mem2/sim/rom_mem2.v
vlog ../../generate/ip_user_files/sim_scripts/rom_mem2/modelsim/glbl.v

vcom ../../tb/rom_mem2_tb.vhd
