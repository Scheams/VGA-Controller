--------------------------------------------------------------------------------
-- Title :      Pattern Generator 1 (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen1.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 01.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "Pattern Generator 1" unit creates a defined pattern for
--              the VGA controller. The generator creates horizontal stripes
--              with Red-Green-Blue-Black order.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 09.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity pattern_gen1 is

  generic (
    n_colour : integer;
    n_px : integer;

    monitor_width : integer
  );

  port (
    rst_i   : in  std_logic;
    clk_i   : in  std_logic;

    v_px_i  : in  std_logic_vector (n_px-1 downto 0);
    h_px_i  : in  std_logic_vector (n_px-1 downto 0);

    red_o   : out std_logic_vector (n_colour-1 downto 0);
    green_o : out std_logic_vector (n_colour-1 downto 0);
    blue_o  : out std_logic_vector (n_colour-1 downto 0)
  );
end entity pattern_gen1;
