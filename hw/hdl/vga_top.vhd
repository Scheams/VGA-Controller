--------------------------------------------------------------------------------
-- Title :      VGA Top (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_top.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2002
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
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;

entity vga_top is

  generic (
    -- VGA SPECIFICATIONS
    -- g_specs: General VGA specification
    -- g_colour: Colour information
    g_specs   : t_vga_specs := VGA_640x480_60Hz;
    g_colour  : t_colour    := VGA_4bit_RGB;

    -- IMAGE SPECIFICATIONS
    -- g_img1: Image for memory control 1
    -- g_img2: Image for memory control 2
    g_img1    : t_image     := VGA_320x240_IMG;
    g_img2    : t_image     := VGA_100x100_IMG;

    -- SYSTEM
    -- g_f_osc: Oscillator frequency
    -- g_f_db: Button debounce frequency
    g_f_osc   : natural     := 100_000_000;
    g_f_db    : natural     :=       1_000
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
    red_o    : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    green_o  : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    blue_o   : out std_logic_vector (g_colour.n_rgb-1 downto 0)
  );

end entity vga_top;
