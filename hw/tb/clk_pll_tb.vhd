--------------------------------------------------------------------------------
-- Title :      Clk PLL (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       clk_pll_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 03.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "Clk PLL" Unit produces a clock that is required for the
--              VGA Controller.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 03.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_pll_tb is
end entity clk_pll_tb;

architecture sim of clk_pll_tb is

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  constant C_N_F : integer := 100_000_000;
  constant C_T   : time    := 1 sec / C_N_F;

  ------------------------------------------------------------------------------
  -- COMPONENT
  ------------------------------------------------------------------------------

  component clk_pll
    port (
      reset   : in  std_logic;
      clk_i   : in  std_logic;
      clk_o   : out std_logic;
      locked  : out std_logic
    );
  end component clk_pll;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- In- and Output signals
  signal s_reset   : std_logic := '1';
  signal s_clk_i   : std_logic := '1';
  signal s_clk_o   : std_logic;
  signal s_locked  : std_logic;

  signal s_stamp   : time;
  signal s_delta   : time;

begin

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  dut: clk_pll
  port map (
    reset   => s_reset,
    clk_i   => s_clk_i,
    clk_o   => s_clk_o,
    locked  => s_locked
  );

  -- Create reset and clock signal
  s_reset <= '0' after 200 ns;
  s_clk_i <= not s_clk_i after C_T/2;

  p_sim: process
  begin
    wait until s_locked = '1';

    wait until s_clk_o = '1';
    s_stamp <= now;

    wait until s_clk_o = '1';
    s_delta <= now - s_stamp;

    wait for 1 ps;

    report "Clock is " & integer'image(1 sec / s_delta) & " Hz" severity note;

    wait;

  end process p_sim;

end sim;
