--------------------------------------------------------------------------------
-- Title :      Pattern Generator 2 (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen2.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 02.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "Pattern Generator 2" unit creates a chess-like format with
--              the colours Red-Green-Blue. Over the whole frame there are
--              10 x 10 tiles.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 29.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity pattern_gen2 is
  generic (
    -- DATA WIDTH
    -- n_colour: Bit depth of each colour
    -- n_px: Width of data bus for pixel information
    n_colour  : integer;
    n_px      : integer;

    -- VALUE
    -- i_h_res: Resolution of width (horizontal pixel) of monitor
    -- i_v_res: Resolution of height (vertical pixel) of monitor
    i_h_res   : integer;
    i_v_res   : integer
  );

  port (
    -- SYSTE;
    -- clk_i: System clock
    -- rst_i: System reset
    clk_i   : in  std_logic;
    rst_i   : in  std_logic;

    -- INPUTS
    -- v_px_i: Vertical pixel information
    -- h_px_i: Horizontal pixel information
    v_px_i  : in  std_logic_vector (n_px-1 downto 0);
    h_px_i  : in  std_logic_vector (n_px-1 downto 0);

    -- OUTPUTS
    -- red_o: Red colour output
    -- green_o: Green colour output
    -- blue_o: Blue colour output
    red_o   : out std_logic_vector (n_colour-1 downto 0);
    green_o : out std_logic_vector (n_colour-1 downto 0);
    blue_o  : out std_logic_vector (n_colour-1 downto 0)
  );
end entity pattern_gen2;
