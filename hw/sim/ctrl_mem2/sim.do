vsim -novopt -t ns -lib work work.ctrl_mem2_tb
view *
do wave.do
run 0 ns;
