vsim -novopt -t ns -lib work work.io_debounce_tb
view *
do wave.do
run 6 us;
