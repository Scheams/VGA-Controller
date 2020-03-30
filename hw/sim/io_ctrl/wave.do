onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /io_ctrl_tb/s_clk_i
add wave -noupdate /io_ctrl_tb/s_rst_i
add wave -noupdate /io_ctrl_tb/u_dut/s_en
add wave -noupdate -color Red /io_ctrl_tb/s_sw_i(0)
add wave -noupdate -color Red /io_ctrl_tb/s_sw_sync_o(0)
add wave -noupdate -color Blue /io_ctrl_tb/s_sw_i(1)
add wave -noupdate -color Blue /io_ctrl_tb/s_sw_sync_o(1)
add wave -noupdate -color Gold /io_ctrl_tb/s_pb_i(0)
add wave -noupdate -color Gold /io_ctrl_tb/s_pb_sync_o(0)
add wave -noupdate -color Magenta /io_ctrl_tb/s_pb_i(1)
add wave -noupdate -color Magenta /io_ctrl_tb/s_pb_sync_o(1)
add wave -noupdate -color Gray75 /io_ctrl_tb/s_pb_i(2)
add wave -noupdate -color Gray75 /io_ctrl_tb/s_pb_sync_o(2)
add wave -noupdate -color {Sea Green} /io_ctrl_tb/s_pb_i(3)
add wave -noupdate -color {Sea Green} /io_ctrl_tb/s_pb_sync_o(3)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2635155 ns} 0} {{Cursor 2} {14484616 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 186
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
WaveRestoreZoom {0 ns} {15750 us}
