--------------------------------------------------------------------------------
-- Title :      VGA Top (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_top.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 01.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "VGA Top" unit combines all elements together to one
--              VGA controller with implemented image generators.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 01.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity vga_top is

  generic (
    n_colour : integer := 4;
    n_px     : integer := 10
  );

  port (
    rst_i : in  std_logic;
    clk_i : in  std_logic;

    pb_i  : in  std_logic_vector (3 downto 0);
    sw_i  : in  std_logic_vector (2 downto 0);

    h_sync_o : out std_logic;
    v_sync_o : out std_logic;
    red_o    : out std_logic_vector (n_colour-1 downto 0);
    green_o  : out std_logic_vector (n_colour-1 downto 0);
    blue_o   : out std_logic_vector (n_colour-1 downto 0)
  );

end entity vga_top;
