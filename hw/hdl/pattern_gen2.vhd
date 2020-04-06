--------------------------------------------------------------------------------
-- Title :      Pattern Generator 2 (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen2.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
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

library work;
use work.vga_specs_pkg.all;

entity pattern_gen2 is
  generic (
    -- SPECIFICATION
    -- g_specs: Specification of VGA monitor
    -- g_colour: Colour specification
    g_specs   : t_vga_specs;
    g_colour  : t_colour
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
    v_px_i  : in  std_logic_vector (g_specs.addr.n_v-1 downto 0);
    h_px_i  : in  std_logic_vector (g_specs.addr.n_h-1 downto 0);

    -- OUTPUTS
    -- red_o: Red colour output
    -- green_o: Green colour output
    -- blue_o: Blue colour output
    red_o   : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    green_o : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    blue_o  : out std_logic_vector (g_colour.n_rgb-1 downto 0)
  );
end entity pattern_gen2;
