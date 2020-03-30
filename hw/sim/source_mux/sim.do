vsim -novopt -t ns -lib work work.source_mux_tb
view *
do wave.do
run 100 ns
