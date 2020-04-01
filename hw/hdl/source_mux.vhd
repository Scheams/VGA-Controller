--------------------------------------------------------------------------------
-- Title :      Source MUX (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       source_mux.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 01.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
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

entity source_mux is

  generic (
    n_colour : integer
  );

  port (
    sw_sync_i   : in  std_logic_vector (2 downto 0);

    rgb_pg1_i   : in  std_logic_vector (3*n_colour-1 downto 0);
    rgb_pg2_i   : in  std_logic_vector (3*n_colour-1 downto 0);
    rgb_mem1_i  : in  std_logic_vector (3*n_colour-1 downto 0);
    rgb_mem2_i  : in  std_logic_vector (3*n_colour-1 downto 0);

    rgb_vga_o   : out std_logic_vector (3*n_colour-1 downto 0)
  );

end entity source_mux;
