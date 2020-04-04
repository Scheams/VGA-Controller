--------------------------------------------------------------------------------
-- Title :      VGA Simulation (Package)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_sim_pkg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 04.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "VGA Simuatlion" package includes constants that are used
--              during simulation of all testbenches.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 04.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library work;
use work.vga_specs_pkg.all;

package vga_sim_pkg is

  constant SPECS  : t_vga_specs := VGA_640x480_60Hz;
  constant COLOUR : t_colour    := VGA_4bit_RGB;

  constant F_OSC    : natural := 100_000_000;
  constant F_VGA    : natural :=  25_000_000;

  constant T_RST    : time    := 200 ns;

  constant T_OSC    : time    := 1 sec / F_OSC;
  constant T_VGA    : time    := 1 sec / F_VGA;

end package vga_sim_pkg;
