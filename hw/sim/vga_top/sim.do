vsim -novopt -t ps -L unisims_ver -lib work work.vga_top_tb work.glbl
view *
do wave.do
run 0 ms
