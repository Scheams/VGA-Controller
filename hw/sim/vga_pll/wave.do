onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_pll_tb/s_reset
add wave -noupdate /vga_pll_tb/s_clk_i
add wave -noupdate /vga_pll_tb/s_clk_o
add wave -noupdate /vga_pll_tb/s_locked_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2543605 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5250 ns}
