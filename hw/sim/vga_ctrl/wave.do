onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_ctrl_tb/s_rst_i
add wave -noupdate /vga_ctrl_tb/s_clk_i
add wave -noupdate -color Magenta /vga_ctrl_tb/s_h_sync_o
add wave -noupdate -color Magenta /vga_ctrl_tb/u_dut/s_h_state
add wave -noupdate -color Blue /vga_ctrl_tb/s_v_sync_o
add wave -noupdate -color Blue /vga_ctrl_tb/u_dut/s_v_state
add wave -noupdate /vga_ctrl_tb/s_red_o
add wave -noupdate /vga_ctrl_tb/s_green_o
add wave -noupdate /vga_ctrl_tb/s_blue_o
add wave -noupdate -radix unsigned /vga_ctrl_tb/s_px_x_o
add wave -noupdate -radix unsigned /vga_ctrl_tb/s_px_y_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 10} {99389 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
configure wave -valuecolwidth 136
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
WaveRestoreZoom {0 ns} {42 ms}
