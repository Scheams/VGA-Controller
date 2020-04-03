# https://www.xilinx.com/support/answers/66533.html
# Use in Tcl:
# report_compile_order -used_in simulation

vlog ../../generate/clk_pll/clk_pll_clk_wiz.v
vlog ../../generate/clk_pll/clk_pll.v
vlog ../../generate/ip_user_files/sim_scripts/clk_pll/modelsim/glbl.v

vcom ../../tb/clk_pll_tb.vhd
