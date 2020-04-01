--------------------------------------------------------------------------------
-- Title : VGA Top Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_top_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 01.04.2020
-- Platform : ModelSim - Starter Edition 10.5b
-- Language: VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: Testbench for VGA Top
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 01.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_top_tb is
end vga_top_tb;

architecture sim of vga_top_tb is

  signal s1 : std_logic := '1';

begin

  s1 <= not s1 after 20 ns;

end sim;
