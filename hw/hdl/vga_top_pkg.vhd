--------------------------------------------------------------------------------
-- Title :      VGA Top (Package)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_top_pkg.vhd
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
-- 31.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

package vga_top_pkg is

  constant C_F_CLK : integer := 25_000_000;
  constant C_T_CLK : time := 40 ns;

  constant C_N_COLOUR : integer := 4;
  constant C_N_PX     : integer := 10;

  constant C_H_PX_VISIBLE_AREA  : integer := 640;
  constant C_H_PX_FRONT_PORCH   : integer := 16;
  constant C_H_PX_SYNC_PULSE    : integer := 96;
  constant C_H_PX_BACK_PORCH    : integer := 48;
  constant C_H_PX_WHOLE_LINE    : integer := 800;

  constant C_V_LN_VISIBLE_AREA  : integer := 480;
  constant C_V_LN_FRONT_PORCH   : integer := 10;
  constant C_V_LN_SYNC_PULSE    : integer := 2;
  constant C_V_LN_BACK_PORCH    : integer := 33;
  constant C_V_LN_WHOLE_FRAME   : integer := 525;

end package;
