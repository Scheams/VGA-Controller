
vcom ../../hdl/vga_ctrl_pkg.vhd
vcom ../../hdl/vga_top_pkg.vhd

vlog ../../generate/clk_pll/clk_pll_clk_wiz.v
vlog ../../generate/clk_pll/clk_pll.v
vlog ../../generate/ip_user_files/sim_scripts/clk_pll/modelsim/glbl.v

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

vcom ../../hdl/source_mux.vhd
vcom ../../hdl/source_mux_rtl.vhd
vcom ../../hdl/source_mux_cfg.vhd

vcom ../../hdl/vga_top.vhd
vcom ../../hdl/vga_top_structural.vhd
vcom ../../hdl/vga_top_cfg.vhd

vcom ../../tb/vga_monitor/vga_monitor_.vhd
vcom ../../tb/vga_monitor/vga_monitor_sim.vhd

vcom ../../tb/vga_top_tb.vhd
