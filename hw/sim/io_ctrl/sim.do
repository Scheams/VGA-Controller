vsim -novopt -t ns -lib work work.io_ctrl
view *
do wave.do
run 1000ns
