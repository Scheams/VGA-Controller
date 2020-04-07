// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Apr  7 14:23:22 2020
// Host        : chris-surface running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub C:/technikum/chd/vga_controller/hw/ip/vga_pll/vga_pll_stub.v
// Design      : vga_pll
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module vga_pll(clk_o, reset, locked_o, clk_i)
/* synthesis syn_black_box black_box_pad_pin="clk_o,reset,locked_o,clk_i" */;
  output clk_o;
  input reset;
  output locked_o;
  input clk_i;
endmodule
