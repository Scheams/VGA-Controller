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
add wave -noupdate /vga_top_tb/u_dut/u_mc1/v_px_i
add wave -noupdate /vga_top_tb/u_dut/u_mc1/h_px_i
add wave -noupdate /vga_top_tb/u_dut/u_mc1/rom_data_i
add wave -noupdate /vga_top_tb/u_dut/u_mc1/rom_addr_o
add wave -noupdate /vga_top_tb/u_dut/u_mc1/red_o
add wave -noupdate /vga_top_tb/u_dut/u_mc1/green_o
add wave -noupdate /vga_top_tb/u_dut/u_mc1/blue_o
add wave -noupdate -format Analog-Step -height 30 -max 80000.0 -radix unsigned /vga_top_tb/u_dut/u_mc1/s_rom_addr_o
add wave -noupdate /vga_top_tb/u_dut/u_mc1/s_prev_px
add wave -noupdate -clampanalog 1 -format Analog-Step -height 30 -max 80000.0 -radix unsigned /vga_top_tb/u_dut/u_mc1/s_cnt_img1
add wave -noupdate -clampanalog 1 -format Analog-Step -height 30 -max 80000.0 -radix unsigned /vga_top_tb/u_dut/u_mc1/s_cnt_img2
add wave -noupdate -clampanalog 1 -format Analog-Step -height 30 -max 80000.0 -radix unsigned /vga_top_tb/u_dut/u_mc1/s_cnt_img3
add wave -noupdate -clampanalog 1 -format Analog-Step -height 30 -max 80000.0 -radix unsigned /vga_top_tb/u_dut/u_mc1/s_cnt_img4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65624701116 ps} 0}
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
WaveRestoreZoom {0 ps} {174443061442 ps}
