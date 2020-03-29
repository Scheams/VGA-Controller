vsim -novopt -t ns -lib work work.pattern_gen2_tb
view *
do wave.do
run 40000ns
