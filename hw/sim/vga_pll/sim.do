vsim -novopt -t ps -L unisims_ver -lib work work.vga_pll work.vga_pll_tb work.glbl
view *
do wave.do
run 5 us;
