onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /pattern_gen1_tb/s_v_px_i
add wave -noupdate -radix unsigned /pattern_gen1_tb/s_h_px_i
add wave -noupdate /pattern_gen1_tb/s_red_o
add wave -noupdate /pattern_gen1_tb/s_green_o
add wave -noupdate /pattern_gen1_tb/s_blue_o
add wave -noupdate /pattern_gen1_tb/s_colour
add wave -noupdate -format Analog-Step -height 74 -max 39.0 /pattern_gen1_tb/u_dut/s_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9061840 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 199
configure wave -valuecolwidth 59
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
WaveRestoreZoom {0 ns} {21 ms}
