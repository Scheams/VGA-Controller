vsim -novopt -t ns -L unisims_ver -lib work work.rom_mem1 work.rom_mem1_tb work.glbl
view *
do wave.do
run 0 ns;
