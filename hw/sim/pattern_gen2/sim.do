vsim -novopt -t ns -lib work work.pattern_gen2_tb
view *
do wave.do
run 20000000ns
