--------------------------------------------------------------------------------
-- Title :      Memory Control 1 (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       ctrl_mem2.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 03.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
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

entity ctrl_mem2 is

  generic (
    -- DATA WIDTH
    -- n_colour: Bit depth of each colour
    -- n_px: Width of data bus for pixel information
    -- n_addr: Bit width of ROM address bus
    n_colour  : integer;
    n_px      : integer;
    n_addr    : integer;

    -- VALUE
    -- i_h_res: Resolution of width (horizontal pixel) of monitor
    -- i_v_res: Resolution of height (vertical pixel) of monitor
    i_h_res   : integer;
    i_v_res   : integer
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
    v_px_i      : in  std_logic_vector (n_px-1 downto 0);
    h_px_i      : in  std_logic_vector (n_px-1 downto 0);
    rom_data_i  : in  std_logic_vector (3*n_colour-1 downto 0);

    -- OUTPUTS
    -- rom_addr_o: Address to access ROM
    -- red_o: Red colour output
    -- green_o: Green colour output
    -- blue_o: Blue colour output
    rom_addr_o  : out std_logic_vector (n_addr-1 downto 0);
    red_o       : out std_logic_vector (n_colour-1 downto 0);
    green_o     : out std_logic_vector (n_colour-1 downto 0);
    blue_o      : out std_logic_vector (n_colour-1 downto 0)
  );
end entity ctrl_mem2;
