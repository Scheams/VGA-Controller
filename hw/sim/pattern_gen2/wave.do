onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pattern_gen2_tb/s_clk_i
add wave -noupdate /pattern_gen2_tb/s_rst_i
add wave -noupdate -format Analog-Step -height 74 -max 1023.0 -min 1.0 -radix unsigned /pattern_gen2_tb/s_v_px_i
add wave -noupdate -format Analog-Step -height 74 -max 1023.0 -min 1.0 -radix unsigned /pattern_gen2_tb/s_h_px_i
add wave -noupdate /pattern_gen2_tb/s_red_o
add wave -noupdate /pattern_gen2_tb/s_green_o
add wave -noupdate /pattern_gen2_tb/s_blue_o
add wave -noupdate /pattern_gen2_tb/s_colour
add wave -noupdate /pattern_gen2_tb/s_v_back_porch
add wave -noupdate /pattern_gen2_tb/s_v_front_porch
add wave -noupdate /pattern_gen2_tb/s_h_back_porch
add wave -noupdate /pattern_gen2_tb/s_h_front_porch
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {1036406 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
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
WaveRestoreZoom {992901 ns} {1265896 ns}
