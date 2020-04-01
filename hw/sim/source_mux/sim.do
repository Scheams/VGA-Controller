vsim -novopt -t ms -lib work work.source_mux_tb
view *
do wave.do
run 17 ms
