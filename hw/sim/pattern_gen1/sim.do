vsim -novopt -t ns -lib work work.pattern_gen1_tb
view *
do wave.do
run 1000ns
