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
use ieee.numeric_std.all;

entity source_mux_tb is
end source_mux_tb;

architecture sim of source_mux_tb is

  component source_mux
    port (
      sw_sync_i   : in  std_logic_vector (2 downto 0);
      rgb_pg1_i   : in  std_logic_vector (11 downto 0);
      rgb_pg2_i   : in  std_logic_vector (11 downto 0);
      rgb_mem1_i  : in  std_logic_vector (11 downto 0);
      rgb_mem2_i  : in  std_logic_vector (11 downto 0);

      rgb_vga_o   : out std_logic_vector (11 downto 0)
    );
  end component source_mux;

  signal s_sw_sync_i   : std_logic_vector (2 downto 0);
  signal s_rgb_pg1_i   : std_logic_vector (11 downto 0);
  signal s_rgb_pg2_i   : std_logic_vector (11 downto 0);
  signal s_rgb_mem1_i  : std_logic_vector (11 downto 0);
  signal s_rgb_mem2_i  : std_logic_vector (11 downto 0);

  signal s_rgb_vga_o   : std_logic_vector (11 downto 0);

begin

  u_dut: source_mux
  port map (
    sw_sync_i   => s_sw_sync_i,
    rgb_pg1_i   => s_rgb_pg1_i,
    rgb_pg2_i   => s_rgb_pg2_i,
    rgb_mem1_i  => s_rgb_mem1_i,
    rgb_mem2_i  => s_rgb_mem2_i,
    rgb_vga_o   => s_rgb_vga_o
  );

  p_sim: process
  begin

  s_rgb_pg1_i <= O"0007";
  s_rgb_pg2_i <= O"0070";
  s_rgb_mem1_i <= O"0700";
  s_rgb_mem2_i <= O"7000";

  for i in 0 to 7 loop
    s_sw_sync_i <= std_logic_vector(to_signed(i, s_sw_sync_i'length));
    wait for 2 ms;
  end loop;

  wait;

  end process p_sim;

end sim;
