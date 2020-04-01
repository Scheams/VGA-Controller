onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /io_debounce_tb/s_clk_i
add wave -noupdate /io_debounce_tb/s_rst_i
add wave -noupdate /io_debounce_tb/u_dut/s_en
add wave -noupdate -color Magenta /io_debounce_tb/s_sw_i(0)
add wave -noupdate -color Magenta /io_debounce_tb/s_sw_sync_o(0)
add wave -noupdate -color Gold /io_debounce_tb/s_sw_i(1)
add wave -noupdate -color Gold /io_debounce_tb/s_sw_sync_o(1)
add wave -noupdate -color Magenta /io_debounce_tb/s_pb_i(0)
add wave -noupdate -color Magenta /io_debounce_tb/s_pb_sync_o(0)
add wave -noupdate -color Gold /io_debounce_tb/s_pb_i(1)
add wave -noupdate -color Gold /io_debounce_tb/s_pb_sync_o(1)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1066 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
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
WaveRestoreZoom {0 ns} {2100 ns}
