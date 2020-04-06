--------------------------------------------------------------------------------
-- Title :      VGA Control (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_ctrl.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "VGA Control" unit controlls the hardware operation that
--              is transfered through the VGA cable to the monitor. It takes
--              input signals like the colour information and monitor
--              specifications to perform this action.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
-- 04.04.2020   v1.1.0   Christoph Amon   Add enable signal
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.vga_specs_pkg.all;

entity vga_ctrl is

  generic (
    -- SPECIFICATION
    -- g_specs: Specification of VGA monitor
    -- g_colour: Colour specification
    g_specs   : t_vga_specs;
    g_colour  : t_colour
  );

  port (
    -- SYSTEM
    -- rst_i: System reset
    -- clk_i: System clock
    -- enable_i: VGA Controller enable
    rst_i    : in  std_logic;
    clk_i    : in  std_logic;
    enable_i : in  std_logic;

    -- INPUTS
    -- red_i: Red colour input
    -- green_i: Green colour input
    -- blue_i: Blue colour input
    red_i    : in  std_logic_vector (g_colour.n_rgb-1 downto 0);
    green_i  : in  std_logic_vector (g_colour.n_rgb-1 downto 0);
    blue_i   : in  std_logic_vector (g_colour.n_rgb-1 downto 0);

    -- HARDWARE OUTPUT
    -- h_sync_o: Horizontal Sync Pulse output
    -- v_sync_o: Vertical Sync Pulse output
    -- red_o: Red colour output
    -- green_o: Green colour output
    -- blue_o: Blue colour output
    h_sync_o : out std_logic;
    v_sync_o : out std_logic;
    red_o    : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    green_o  : out std_logic_vector (g_colour.n_rgb-1 downto 0);
    blue_o   : out std_logic_vector (g_colour.n_rgb-1 downto 0);

    -- OUTPUT
    -- px_h_o: Horizontal pixel information
    -- px_v_o: Vertical pixel information
    px_h_o   : out std_logic_vector (g_specs.addr.n_h-1 downto 0);
    px_v_o   : out std_logic_vector (g_specs.addr.n_v-1 downto 0)
  );

end entity vga_ctrl;
