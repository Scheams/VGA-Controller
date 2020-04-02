--------------------------------------------------------------------------------
-- Title :      VGA Top (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_top.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 02.04.2020
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

library work;
use work.vga_top_pkg.all;

entity vga_top is

  generic (
    -- DATA_WIDTH
    -- n_colour: Bit depth of each colour
    -- n_px: Width of data bus for pixel information
    n_colour : integer := C_N_COLOUR;
    n_px     : integer := C_N_PX
  );

  port (
    -- SYSTEM
    -- rst_i: System reset
    -- clk_i: System clock
    rst_i : in  std_logic;
    clk_i : in  std_logic;

    -- HARDWARE INPUT
    -- pb_i: Push-button input
    -- sw_i: Switch input
    pb_i  : in  std_logic_vector (3 downto 0);
    sw_i  : in  std_logic_vector (2 downto 0);

    -- HARDWARE OUTPUT
    -- h_sync_o: H sync pulse output
    -- v_sync_o: V sync pulse output
    -- red_o: Red colour output
    -- green_o: Green colour output
    -- blue_o: Blue colour output
    h_sync_o : out std_logic;
    v_sync_o : out std_logic;
    red_o    : out std_logic_vector (n_colour-1 downto 0);
    green_o  : out std_logic_vector (n_colour-1 downto 0);
    blue_o   : out std_logic_vector (n_colour-1 downto 0)
  );

end entity vga_top;
