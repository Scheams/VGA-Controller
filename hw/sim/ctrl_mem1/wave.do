onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ctrl_mem1_tb/s_rst_i
add wave -noupdate /ctrl_mem1_tb/s_clk_i
add wave -noupdate /ctrl_mem1_tb/s_v_px_i
add wave -noupdate /ctrl_mem1_tb/s_h_px_i
add wave -noupdate /ctrl_mem1_tb/s_rom_data_i
add wave -noupdate /ctrl_mem1_tb/s_rom_addr_o
add wave -noupdate /ctrl_mem1_tb/s_red_o
add wave -noupdate /ctrl_mem1_tb/s_green_o
add wave -noupdate /ctrl_mem1_tb/s_blue_o
add wave -noupdate /ctrl_mem1_tb/u_dut/s_cnt_img1
add wave -noupdate /ctrl_mem1_tb/u_dut/s_cnt_img2
add wave -noupdate /ctrl_mem1_tb/u_dut/s_cnt_img3
add wave -noupdate /ctrl_mem1_tb/u_dut/s_cnt_img4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
