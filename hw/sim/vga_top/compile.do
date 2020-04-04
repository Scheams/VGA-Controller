file copy -force ../../generate/ip_user_files/mem_init_files/rom_mem1.mif ./
file copy -force ../../generate/ip_user_files/mem_init_files/rom_mem2.mif ./

vcom ../../hdl/vga_specs_pkg.vhd
vcom ../../hdl/vga_ctrl_pkg.vhd
vcom ../../hdl/vga_top_pkg.vhd

vlog ../../generate/vga_pll/vga_pll_clk_wiz.v
vlog ../../generate/vga_pll/vga_pll.v

vlog ../../generate/rom_mem1/simulation/blk_mem_gen_v8_4.v
vlog ../../generate/rom_mem1/sim/rom_mem1.v
vlog ../../generate/rom_mem2/sim/rom_mem2.v

vlog ../../generate/ip_user_files/sim_scripts/vga_pll/modelsim/glbl.v

vcom ../../hdl/vga_ctrl.vhd
vcom ../../hdl/vga_ctrl_rtl.vhd
vcom ../../hdl/vga_ctrl_cfg.vhd

vcom ../../hdl/io_debounce.vhd
vcom ../../hdl/io_debounce_rtl.vhd
vcom ../../hdl/io_debounce_cfg.vhd

vcom ../../hdl/pattern_gen1.vhd
vcom ../../hdl/pattern_gen1_rtl.vhd
vcom ../../hdl/pattern_gen1_cfg.vhd

vcom ../../hdl/pattern_gen2.vhd
vcom ../../hdl/pattern_gen2_rtl.vhd
vcom ../../hdl/pattern_gen2_cfg.vhd

vcom ../../hdl/ctrl_mem1.vhd
vcom ../../hdl/ctrl_mem1_rtl.vhd
vcom ../../hdl/ctrl_mem1_cfg.vhd

vcom ../../hdl/ctrl_mem2.vhd
vcom ../../hdl/ctrl_mem2_rtl.vhd
vcom ../../hdl/ctrl_mem2_cfg.vhd

vcom ../../hdl/source_mux.vhd
vcom ../../hdl/source_mux_rtl.vhd
vcom ../../hdl/source_mux_cfg.vhd

vcom ../../hdl/vga_top.vhd
vcom ../../hdl/vga_top_structural.vhd
vcom ../../hdl/vga_top_cfg.vhd

vcom ../../tb/vga_monitor/vga_monitor_.vhd
vcom ../../tb/vga_monitor/vga_monitor_sim.vhd

vcom ../../tb/vga_top_tb.vhd
