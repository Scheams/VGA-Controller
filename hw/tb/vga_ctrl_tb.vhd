--------------------------------------------------------------------------------
-- Title : VGA Control Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Testbench for VGA Control
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ctrl_tb is
end vga_ctrl_tb;

architecture sim of vga_ctrl_tb is

  signal s_clk_i : std_logic := '1';
  signal s_rst_i : std_logic := '1';

begin

  s_rst_i <= '0' after 20 ns;
  s_clk_i <= not s_clk_i after 20 ns;

end sim;
