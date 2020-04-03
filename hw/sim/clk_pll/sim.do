vsim -novopt -t ps -L unisims_ver -lib work work.clk_pll work.clk_pll_tb work.glbl
view *
do wave.do
run 5 us;
