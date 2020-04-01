onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_top_tb/s_rst_i
add wave -noupdate /vga_top_tb/s_clk_i
add wave -noupdate /vga_top_tb/s_pb_i
add wave -noupdate /vga_top_tb/s_sw_i
add wave -noupdate /vga_top_tb/s_h_sync_o
add wave -noupdate /vga_top_tb/s_v_sync_o
add wave -noupdate /vga_top_tb/s_red_o
add wave -noupdate /vga_top_tb/s_green_o
add wave -noupdate /vga_top_tb/s_blue_o
add wave -noupdate /vga_top_tb/u_dut/u_pg1/red_o
add wave -noupdate /vga_top_tb/u_dut/u_pg1/green_o
add wave -noupdate /vga_top_tb/u_dut/u_pg1/blue_o
add wave -noupdate /vga_top_tb/u_dut/u_mux/n_colour
add wave -noupdate /vga_top_tb/u_dut/u_mux/sw_sync_i
add wave -noupdate /vga_top_tb/u_dut/u_mux/rgb_pg1_i
add wave -noupdate /vga_top_tb/u_dut/u_mux/rgb_pg2_i
add wave -noupdate /vga_top_tb/u_dut/u_mux/rgb_mem1_i
add wave -noupdate /vga_top_tb/u_dut/u_mux/rgb_mem2_i
add wave -noupdate /vga_top_tb/u_dut/u_mux/rgb_vga_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19438914 ns} 0}
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
WaveRestoreZoom {19406376 ns} {20031244 ns}
