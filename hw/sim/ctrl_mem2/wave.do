onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ctrl_mem2_tb/s_rst_i
add wave -noupdate /ctrl_mem2_tb/s_clk_i
add wave -noupdate -format Analog-Step -height 74 -max 1023.0000000000001 -radix unsigned /ctrl_mem2_tb/s_v_px_i
add wave -noupdate -format Analog-Step -height 74 -max 1023.0000000000001 -radix unsigned /ctrl_mem2_tb/s_h_px_i
add wave -noupdate /ctrl_mem2_tb/s_rom_data_i
add wave -noupdate -format Analog-Step -height 74 -max 800.0 -radix unsigned /ctrl_mem2_tb/s_rom_addr_o
add wave -noupdate /ctrl_mem2_tb/s_red_o
add wave -noupdate /ctrl_mem2_tb/s_green_o
add wave -noupdate /ctrl_mem2_tb/s_blue_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1200921 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 192
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1031848 ns} {1318065 ns}
