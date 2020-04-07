-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Tue Apr  7 14:23:22 2020
-- Host        : chris-surface running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub C:/technikum/chd/vga_controller/hw/ip/vga_pll/vga_pll_stub.vhdl
-- Design      : vga_pll
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_pll is
  Port ( 
    clk_o : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked_o : out STD_LOGIC;
    clk_i : in STD_LOGIC
  );

end vga_pll;

architecture stub of vga_pll is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_o,reset,locked_o,clk_i";
begin
end;
