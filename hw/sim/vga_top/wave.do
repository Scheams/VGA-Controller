onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_top_tb/s_rst_i
add wave -noupdate /vga_top_tb/s_clk_i
add wave -noupdate /vga_top_tb/u_dut/s_vga_clk
add wave -noupdate /vga_top_tb/u_dut/s_locked
add wave -noupdate /vga_top_tb/s_pb_i
add wave -noupdate /vga_top_tb/s_sw_i
add wave -noupdate /vga_top_tb/s_h_sync_o
add wave -noupdate /vga_top_tb/s_v_sync_o
add wave -noupdate /vga_top_tb/s_red_o
add wave -noupdate /vga_top_tb/s_green_o
add wave -noupdate /vga_top_tb/s_blue_o
add wave -noupdate /vga_top_tb/u_dut/u_controller/px_h_o
add wave -noupdate /vga_top_tb/u_dut/u_controller/px_v_o
add wave -noupdate /vga_top_tb/u_dut/u_mc2/s_pb_prev
add wave -noupdate /vga_top_tb/u_dut/u_mc2/s_h_tmp_offset
add wave -noupdate /vga_top_tb/u_dut/u_mc2/s_v_tmp_offset
add wave -noupdate /vga_top_tb/u_dut/u_mc2/s_h_offset
add wave -noupdate /vga_top_tb/u_dut/u_mc2/s_v_offset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15004000000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
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
WaveRestoreZoom {0 ps} {71742258 ns}
