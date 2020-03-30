--------------------------------------------------------------------------------
-- Title : IO Control Testbench
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : io_ctrl_tb.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Testbench for IO Control
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity io_ctrl_tb is
end io_ctrl_tb;

architecture sim of io_ctrl_tb is

  component io_ctrl
    port (
      clk_i : in std_logic;
      rst_i : in std_logic;
      sw_i  : in std_logic_vector (1 downto 0);
      pb_i  : in std_logic_vector (3 downto 0);

      sw_sync_o : out std_logic_vector (1 downto 0);
      pb_sync_o : out std_logic_vector (3 downto 0)
    );
  end component;

  signal s_clk_i : std_logic := '1';
  signal s_rst_i : std_logic := '1';
  signal s_sw_i  : std_logic_vector (1 downto 0);
  signal s_pb_i  : std_logic_vector (3 downto 0);

  signal s_sw_sync_o : std_logic_vector (1 downto 0);
  signal s_pb_sync_o : std_logic_vector (3 downto 0);

begin

  u_dut: io_ctrl
  port map (
    clk_i => s_clk_i,
    rst_i => s_rst_i,
    sw_i  => s_sw_i,
    pb_i  => s_pb_i,

    sw_sync_o => s_sw_sync_o,
    pb_sync_o => s_pb_sync_o
  );

  s_rst_i <= '0' after 20 ns;
  s_clk_i <= not s_clk_i after 20 ns;

  p_pb: process
  begin
    s_pb_i <= "0000";
    wait for 40 ns;

    s_pb_i(0) <= '1', '0' after 3 ms;
    s_pb_i(1) <= '1' after 6 ms, '0' after 9 ms;
    s_pb_i(2) <= '1' after 9 ms, '0' after 12 ms;
    s_pb_i(3) <= '1' after 12 ms, '0' after 13 ms, '1' after 14 ms;

    wait;

  end process p_pb;

  p_sw: process
  begin
    s_sw_i <= "00";
    wait for 40 ns;

    s_sw_i(0) <= '1', '0' after 1 ms, '1' after 2 ms, '0' after 6 ms;
    s_sw_i(1) <= '1' after 5 ms, '0' after 7 ms, '1' after 8 ms, '0' after 11 ms;

    wait;

  end process p_sw;

end sim;
