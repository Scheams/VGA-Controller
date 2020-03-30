onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /source_mux_tb/s_sw_sync_i
add wave -noupdate -radix hexadecimal /source_mux_tb/s_rgb_pg1_i
add wave -noupdate -radix hexadecimal /source_mux_tb/s_rgb_pg2_i
add wave -noupdate -radix hexadecimal /source_mux_tb/s_rgb_mem1_i
add wave -noupdate -radix hexadecimal /source_mux_tb/s_rgb_mem2_i
add wave -noupdate -radix hexadecimal /source_mux_tb/s_rgb_vga_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ms} 0}
quietly wave cursor active 1
configure wave -namecolwidth 205
configure wave -valuecolwidth 51
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
WaveRestoreZoom {0 ms} {15 ms}
