--------------------------------------------------------------------------------
-- Title :      Memory Control 1 (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       ctrl_mem2.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "Memory Control 1" unit reads the stored information from
--              the ROM 1 which is a 320x240 image. This image gets then shown
--              4 times on the monitor.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 03.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_specs_pkg.all;

entity ctrl_mem2 is

  generic (
    -- SPECIFICATION
    -- g_specs: Specification of VGA monitor
    -- g_colour: Colour specification
    -- g_img: Information about image
    g_specs   : t_vga_specs;
    g_colour  : t_colour;
    g_img     : t_image
  );

  port (
    -- SYSTEM
    -- rst_i: System reset
    -- clk_i: System clock
    rst_i       : in  std_logic;
    clk_i       : in  std_logic;

    -- INPUTS
    -- v_px_i: Vertical pixel information
    -- h_px_i: Horizontal pixel information
    -- rom_data: RGB colour from ROM
    -- pb_i: Push-button input for moving object
    v_px_i      : in  std_logic_vector (g_specs.addr.n_v-1 downto 0);
    h_px_i      : in  std_logic_vector (g_specs.addr.n_h-1 downto 0);
    rom_data_i  : in  std_logic_vector (g_colour.n_bus-1 downto 0);
    pb_i        : in  std_logic_vector (3 downto 0);

    -- OUTPUTS
    -- rom_addr_o: Address to access ROM
    -- red_o: Red colour output
    -- green_o: Green colour output
    -- blue_o: Blue colour output
    rom_addr_o  : out std_logic_vector (g_img.n_rom-1 downto 0);
    red_o       : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    green_o     : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    blue_o      : out std_logic_vector (g_colour.n_rgb-1 downto 0)
  );
end entity ctrl_mem2;
