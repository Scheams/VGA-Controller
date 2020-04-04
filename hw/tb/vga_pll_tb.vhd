--------------------------------------------------------------------------------
-- Title :      Clk PLL (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_pll_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 04.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "Clk PLL" Unit produces a clock that is required for the
--              VGA Controller.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 03.04.2020   v1.0.0   Christoph Amon   Initial stage
-- 04.04.2020   v2.0.0   Christoph Amon   Change module name to vga_pll
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;
use work.vga_sim_pkg.all;

entity vga_pll_tb is
end entity vga_pll_tb;

architecture sim of vga_pll_tb is

  ------------------------------------------------------------------------------
  -- COMPONENT
  ------------------------------------------------------------------------------

  component vga_pll
    port (
      reset     : in  std_logic;
      clk_i     : in  std_logic;
      clk_o     : out std_logic;
      locked_o  : out std_logic
    );
  end component vga_pll;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- In- and Output signals
  signal s_reset    : std_logic := '1';
  signal s_clk_i    : std_logic := '1';
  signal s_clk_o    : std_logic;
  signal s_locked_o : std_logic;

  -- Signal to calculate and verify output
  signal s_stamp   : time;
  signal s_delta   : time;
  signal s_frq     : integer;

begin

  -- Create reset and clock signal
  s_reset <= '0' after T_RST;
  s_clk_i <= not s_clk_i after T_OSC / 2;

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  dut: vga_pll
  port map (
    reset     => s_reset,
    clk_i     => s_clk_i,
    clk_o     => s_clk_o,
    locked_o  => s_locked_o
  );

  ------------------------------------------------------------------------------
  -- Simulation process
  ------------------------------------------------------------------------------
  p_sim: process
  begin
    -- Wait until PLL is ready
    wait until s_locked_o = '1';

    -- Wait for rising edge, take timestamp
    wait until s_clk_o = '1';
    s_stamp <= now;

    -- Wait for next rising edge, calculate difference
    wait until s_clk_o = '1';
    s_delta <= now - s_stamp;
    wait for 1 ps;

    -- Calculate frequency
    s_frq <= 1 sec / s_delta;
    wait for 1 ps;

    -- Report freqeuncy
    report "PLL clock is " & integer'image(s_frq) & " Hz" severity note;

    -- Check if in custom limits
    assert (s_frq >= SPECS.f_px.f_min) and (s_frq <= SPECS.f_px.f_max)
      report "PLL clock is not in custom min/max limits!"
      severity failure;

    -- Check if in limits on VESA tolerance
    assert (s_frq >= SPECS.f_px.f_min_vesa) and (s_frq <= SPECS.f_px.f_max_vesa)
      report "PLL clock is not in limits of VESA tolerance +- 0.5%."
      severity warning;

    wait;
  end process p_sim;

end sim;
