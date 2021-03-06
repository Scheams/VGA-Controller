--------------------------------------------------------------------------------
-- Title :      Source MUX (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       source_mux_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "Source MUX" unit maps different source input to the VGA
--              controller unit. Depending on the position of 3 input switches
--              the MUX selects the RGB information from 4 different sources.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;
use work.vga_sim_pkg.all;

entity source_mux_tb is
end source_mux_tb;

architecture sim of source_mux_tb is

  ------------------------------------------------------------------------------
  -- FUNCTIONS
  ------------------------------------------------------------------------------

  -- https://stackoverflow.com/a/38850022
  function to_string ( a: std_logic_vector) return string is
    variable b : string (1 to a'length) := (others => NUL);
    variable stri : integer := 1;
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
        stri := stri+1;
        end loop;
    return b;
    end function;

  ------------------------------------------------------------------------------
  -- COMPONENTS
  ------------------------------------------------------------------------------

  component source_mux
    generic (
      g_colour  : t_colour
    );
    port (
      sw_sync_i   : in  std_logic_vector (2 downto 0);
      rgb_pg1_i   : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_pg2_i   : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_mem1_i  : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_mem2_i  : in  std_logic_vector (g_colour.n_bus-1 downto 0);
      rgb_vga_o   : out std_logic_vector (g_colour.n_bus-1 downto 0)
    );
  end component source_mux;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- In- and Output signals
  signal s_sw_sync_i   : std_logic_vector (2 downto 0);
  signal s_rgb_pg1_i   : std_logic_vector (COLOUR.n_bus-1 downto 0);
  signal s_rgb_pg2_i   : std_logic_vector (COLOUR.n_bus-1 downto 0);
  signal s_rgb_mem1_i  : std_logic_vector (COLOUR.n_bus-1 downto 0);
  signal s_rgb_mem2_i  : std_logic_vector (COLOUR.n_bus-1 downto 0);
  signal s_rgb_vga_o   : std_logic_vector (COLOUR.n_bus-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  u_dut: source_mux
  generic map (
    g_colour => COLOUR
  )
  port map (
    sw_sync_i   => s_sw_sync_i,
    rgb_pg1_i   => s_rgb_pg1_i,
    rgb_pg2_i   => s_rgb_pg2_i,
    rgb_mem1_i  => s_rgb_mem1_i,
    rgb_mem2_i  => s_rgb_mem2_i,
    rgb_vga_o   => s_rgb_vga_o
  );

  ------------------------------------------------------------------------------
  -- Simulate all switch positions and check if multiplex works correct
  ------------------------------------------------------------------------------
  p_sim: process
  begin

    s_rgb_pg1_i <= (others => '0');
    s_rgb_pg1_i(0) <= '1';
    s_rgb_pg2_i <= (others => '0');
    s_rgb_pg2_i(1) <= '1';
    s_rgb_mem1_i <= (others => '0');
    s_rgb_mem1_i(2) <= '1';
    s_rgb_mem2_i <= (others => '1');

    -- Check Pattern Gen 1
    s_sw_sync_i <= "000";
    wait for 1 ms;
    assert s_rgb_vga_o = s_rgb_pg1_i
      report "Pattern Generator 1 failed at SW pos: " & to_string(s_sw_sync_i)
      severity error;
    wait for 1 ms;

    -- Check Pattern Gen 2
    s_sw_sync_i <= "001";
    wait for 1 ms;
    assert s_rgb_vga_o = s_rgb_pg2_i
      report "Pattern Generator 2 failed at SW pos: " & to_string(s_sw_sync_i)
      severity error;
    wait for 1 ms;

    -- Check Mem Control 1 (Position 1)
    s_sw_sync_i <= "010";
    wait for 1 ms;
    assert s_rgb_vga_o = s_rgb_mem1_i
      report "Memory Control 1 failed at SW pos: " & to_string(s_sw_sync_i)
      severity error;
    wait for 1 ms;

    -- Check Mem Control 1 (Position 2)
    s_sw_sync_i <= "011";
    wait for 1 ms;
    assert s_rgb_vga_o = s_rgb_mem1_i
      report "Memory Control 1 failed at SW pos: " & to_string(s_sw_sync_i)
      severity error;
    wait for 1 ms;

    -- Check Mem Control 2 (all different positions)
    for i in 0 to 3 loop
      s_sw_sync_i <= std_logic_vector(unsigned(s_sw_sync_i) + 1);
      wait for 1 ms;
      assert s_rgb_vga_o = s_rgb_mem2_i
        report "Memory Control 2 failed at SW pos: " & to_string(s_sw_sync_i)
        severity error;
      wait for 1 ms;
    end loop;

    wait;

  end process p_sim;

end sim;
