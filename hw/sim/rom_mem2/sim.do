vsim -novopt -t ns -L unisims_ver -lib work work.rom_mem2 work.rom_mem2_tb work.glbl
view *
do wave.do
run 0 ns;
