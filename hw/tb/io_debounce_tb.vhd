--------------------------------------------------------------------------------
-- Title :      IO Debounce (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       io_debounce_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "IO Debounce" Unit is able to debounce switches and
--              pushbuttons. The debounce frequency can be set, the default
--              frequency is 1kHz. With this frequency the switches and buttons
--              go through a 2-stage-FF and therefore the synchronized outputs
--              get set or cleared.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
-- 01.04.2020   v2.0.0   Christoph Amon   From IO Control to IO Debounce Unit
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_sim_pkg.all;

entity io_debounce_tb is
end entity io_debounce_tb;

architecture sim of io_debounce_tb is

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  constant C_N_SW   : integer := 2;
  constant C_N_PB   : integer := 2;

  constant C_SW_ZEROS : std_logic_vector (C_N_SW-1 downto 0) := (others => '0');
  constant C_PB_ZEROS : std_logic_vector (C_N_PB-1 downto 0) := (others => '0');

  ------------------------------------------------------------------------------
  -- COMPONENTS
  ------------------------------------------------------------------------------

  component io_debounce
    generic (
      f_sys      : integer := 100_000_000;
      f_debounce : integer := 1_000;
      n_sw       : integer;
      n_pb       : integer
    );
    port (
      rst_i : in std_logic;
      clk_i : in std_logic;
      sw_i  : in std_logic_vector (n_sw-1 downto 0);
      pb_i  : in std_logic_vector (n_pb-1 downto 0);
      sw_sync_o : out std_logic_vector (n_sw-1 downto 0);
      pb_sync_o : out std_logic_vector (n_pb-1 downto 0)
    );
  end component;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- Signals for In- and Output of component
  signal s_clk_i : std_logic := '1';
  signal s_rst_i : std_logic := '1';
  signal s_sw_i  : std_logic_vector (C_N_SW-1 downto 0) := (others => '0');
  signal s_pb_i  : std_logic_vector (C_N_PB-1 downto 0) := (others => '0');
  signal s_sw_sync_o : std_logic_vector (C_N_SW-1 downto 0);
  signal s_pb_sync_o : std_logic_vector (C_N_PB-1 downto 0);

begin

  -- Create reset pulse and clock signal
  s_rst_i <= '0' after T_RST;
  s_clk_i <= not s_clk_i after T_OSC / 2;

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  u_dut: io_debounce
  generic map (
    f_sys       => F_OSC,
    f_debounce  => F_DB,
    n_sw        => C_N_SW,
    n_pb        => C_N_PB
  )
  port map (
    clk_i => s_clk_i,
    rst_i => s_rst_i,
    sw_i  => s_sw_i,
    pb_i  => s_pb_i,
    sw_sync_o => s_sw_sync_o,
    pb_sync_o => s_pb_sync_o
  );

  ------------------------------------------------------------------------------
  -- Simulate push buttons
  ------------------------------------------------------------------------------
  p_pb: process
  begin
    wait for T_RST;

    s_pb_i(0) <= '1' after T_DB / 5, '0' after T_DB * 3;
    s_pb_i(1) <= '1' after T_DB * 4 / 3;

    wait;
  end process p_pb;

  ------------------------------------------------------------------------------
  -- Simulate switches
  ------------------------------------------------------------------------------
  p_sw: process
  begin
    wait for T_RST;

    s_sw_i(0) <= '1' after T_DB / 5, '0' after T_DB * 3 / 5,
                 '1' after T_DB * 3 / 2;
    s_sw_i(1) <= '1', '0' after T_DB * 4 / 5, '1' after T_DB * 7 / 5,
                 '0' after T_DB * 2;

    wait;
  end process p_sw;

  ------------------------------------------------------------------------------
  -- Check if debouncing behaves the right way
  ------------------------------------------------------------------------------
  p_check: process
  begin
    wait for T_RST + 5 * T_DB / 5;

    wait for T_DB;
    assert s_sw_sync_o(0) = '0' and s_sw_sync_o(1) = '0' and
           s_pb_sync_o(0) = '0' and s_pb_sync_o(1) = '0'
      report "Stage 1 failed debounce!" severity error;

    wait for T_DB;
    assert s_sw_sync_o(0) = '0' and s_sw_sync_o(1) = '0' and
           s_pb_sync_o(0) = '1' and s_pb_sync_o(1) = '0'
      report "Stage 2 failed debounce!" severity error;

    wait for T_DB;
    assert s_sw_sync_o(0) = '1' and s_sw_sync_o(1) = '0' and
           s_pb_sync_o(0) = '1' and s_pb_sync_o(1) = '1'
      report "Stage 3 failed debounce!" severity error;

    wait for T_DB;
    assert s_sw_sync_o(0) = '1' and s_sw_sync_o(1) = '0' and
            s_pb_sync_o(0) = '0' and s_pb_sync_o(1) = '1'
      report "Stage 4 failed debounce!" severity error;

    wait;
  end process p_check;

end sim;
