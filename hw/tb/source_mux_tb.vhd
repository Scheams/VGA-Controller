--------------------------------------------------------------------------------
-- Title : Source MUX Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : source_mux_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Testbench for Source MUX
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity source_mux_tb is
end source_mux_tb;

architecture sim of source_mux_tb is

  signal s_clk_i : std_logic := '1';
  signal s_rst_i : std_logic := '1';

begin

  s_rst_i <= '0' after 20 ns;
  s_clk_i <= not s_clk_i after 20 ns;

end sim;
