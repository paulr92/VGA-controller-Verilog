onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_display_timing_controller/DUT/clk
add wave -noupdate /tb_display_timing_controller/DUT/rst
add wave -noupdate -divider Timing
add wave -noupdate /tb_display_timing_controller/DUT/state_hor
add wave -noupdate /tb_display_timing_controller/DUT/hs
add wave -noupdate /tb_display_timing_controller/DUT/state_vert
add wave -noupdate /tb_display_timing_controller/DUT/vs
add wave -noupdate /tb_display_timing_controller/DUT/active_video_area
add wave -noupdate -divider Horizontal
add wave -noupdate -group Horizontal -radix unsigned /tb_display_timing_controller/DUT/hor_ctr_q
add wave -noupdate -group Horizontal -radix unsigned /tb_display_timing_controller/DUT/x
add wave -noupdate -group Horizontal /tb_display_timing_controller/DUT/hor_act
add wave -noupdate -divider Vertical
add wave -noupdate -expand -group Vertical /tb_display_timing_controller/DUT/vert_tick
add wave -noupdate -expand -group Vertical -radix unsigned /tb_display_timing_controller/DUT/vert_ctr_q
add wave -noupdate -expand -group Vertical -radix unsigned /tb_display_timing_controller/DUT/y
add wave -noupdate -expand -group Vertical /tb_display_timing_controller/DUT/vert_act
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1088060000 ps} 0}
configure wave -namecolwidth 294
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
WaveRestoreZoom {28129687485 ps} {30098437501 ps}
