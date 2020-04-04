--------------------------------------------------------------------------------
-- Title :      VGA Specifications (Package)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_specs_pkg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 04.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: The "VGA Specifications" package includes constants for
--              predefined VGA specifications.
--              Sources are from the website: http://tinyvga.com/vga-timing
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 04.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

package vga_specs_pkg is

  ------------------------------------------------------------------------------
  -- TYPEDEFS
  ------------------------------------------------------------------------------

  type t_colour is record
    n_colour  : natural;
    n_rgb     : natural;
  end record t_colour;

  type t_vga_frequency is record
    f_pixel     : natural;
    f_min       : natural;
    f_max       : natural;
    f_min_vesa  : natural;
    f_max_vesa  : natural;
  end record t_vga_frequency;

  type t_vga_h_timing is record
    visible_area  : natural;
    front_porch   : natural;
    sync_pulse    : natural;
    back_porch    : natural;
    whole_line    : natural;
  end record t_vga_h_timing;

  type t_vga_v_timing is record
    visible_area  : natural;
    front_porch   : natural;
    sync_pulse    : natural;
    back_porch    : natural;
    whole_frame    : natural;
  end record t_vga_v_timing;

  type t_vga_addr is record
    n_h : natural;
    n_v : natural;
  end record t_vga_addr;

  type t_vga_specs is record
    f_frame : natural;
    f_px    : t_vga_frequency;
    px_h    : t_vga_h_timing;
    ln_v    : t_vga_v_timing;
    addr    : t_vga_addr;
  end record t_vga_specs;

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  constant VGA_4bit_RGB : t_colour := (
    n_colour  => 4,
    n_rgb     => 12
  );

  constant VGA_640x480_60Hz : t_vga_specs := (
    f_frame => 60,
    f_px    => (
      f_pixel     => 25_175_000,
      f_min       => 25_000_000,
      f_max       => 25_200_000,
      f_min_vesa  => 25_162_412,
      f_max_vesa  => 25_187_587
    ),
    px_h    => (
      visible_area => 640,
      front_porch  => 16,
      sync_pulse   => 96,
      back_porch   => 48,
      whole_line   => 800
    ),
    ln_v    => (
      visible_area => 480,
      front_porch  => 10,
      sync_pulse   => 2,
      back_porch   => 33,
      whole_frame  => 525
    ),
    addr    => (
      n_h => 10,
      n_v => 10
    )
  );

end package vga_specs_pkg;
