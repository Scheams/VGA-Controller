--------------------------------------------------------------------------------
-- Title :      ROM Memory 1 (Testbench)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       rom_mem1_tb.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "ROM Mem 1" Unit stores data for the Memory Control 1 unit
--              that represents a picture which is half in dimension of the
--              monitor specs. This image can then be shown 4 times on the
--              screen.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 04.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;
use work.vga_sim_pkg.all;

entity rom_mem1_tb is
end entity rom_mem1_tb;

architecture sim of rom_mem1_tb is

  ------------------------------------------------------------------------------
  -- COMPONENT
  ------------------------------------------------------------------------------

  component rom_mem1 is
    port (
      clka  : in  std_logic;
      addra : in  std_logic_vector (16 downto 0);
      douta : out std_logic_vector (11 downto 0)
    );
  end component rom_mem1;

  ------------------------------------------------------------------------------
  -- SIGNALS
  ------------------------------------------------------------------------------

  -- In- and output signals of DUT
  signal s_clka  : std_logic := '1';
  signal s_addra : std_logic_vector (IMG1.n_rom-1 downto 0) := (others => '0');
  signal s_douta : std_logic_vector (COLOUR.n_bus-1 downto 0);

begin

  ------------------------------------------------------------------------------
  -- Device under test
  ------------------------------------------------------------------------------
  u_dut: rom_mem1
  port map (
    clka  => s_clka,
    addra => s_addra,
    douta => s_douta
  );

  -- Create clock signal
  s_clka <= not s_clka after T_OSC / 2;

  ------------------------------------------------------------------------------
  -- Simulation process, increase address
  ------------------------------------------------------------------------------
  p_sim: process
  begin

    for i in 0 to IMG1.size_rom-1 loop

      s_addra <= std_logic_vector(to_unsigned(i, s_addra'length));

      wait for T_VGA;
    end loop;

    wait;

  end process p_sim;

end sim;
