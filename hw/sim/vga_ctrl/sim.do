vsim -novopt -t ns -lib work work.vga_ctrl_tb
view *
do wave.do
run 40 ms
