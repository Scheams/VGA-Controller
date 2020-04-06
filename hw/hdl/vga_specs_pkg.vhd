--------------------------------------------------------------------------------
-- Title :      VGA Specifications (Package)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_specs_pkg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "VGA Specifications" package includes constants for
--              predefined VGA specifications.
--              Sources are from the website: http://tinyvga.com/vga-timing
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 04.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vga_specs_pkg is

  ------------------------------------------------------------------------------
  -- TYPEDEFS
  ------------------------------------------------------------------------------

  type t_colour is record
    n_rgb     : natural;
    n_bus     : natural;
  end record t_colour;

  type t_image is record
    height    : natural;
    width     : natural;
    n_rom     : natural;
    size_rom  : natural;
  end record t_image;

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
    whole_frame   : natural;
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
    n_rgb  => 4,
    n_bus  => 12
  );

  constant VGA_100x100_IMG : t_image := (
    height    => 100,
    width     => 100,
    n_rom     => 14,
    size_rom  => 10000
  );

  constant VGA_320x240_IMG : t_image := (
    height    => 240,
    width     => 320,
    n_rom     => 17,
    size_rom  => 76800
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

  procedure p_rgb_to_bus (
      constant c_n_rgb  : in  natural;
      signal   s_bus    : out std_logic_vector;
      signal   s_red    : in  std_logic_vector;
      signal   s_green  : in  std_logic_vector;
      signal   s_blue   : in  std_logic_vector
    );

  procedure p_bus_to_rgb (
      constant c_n_rgb  : in  natural;
      signal   s_bus    : in  std_logic_vector;
      signal   s_red    : out std_logic_vector;
      signal   s_green  : out std_logic_vector;
      signal   s_blue   : out std_logic_vector
    );

end package vga_specs_pkg;

package body vga_specs_pkg is

  procedure p_rgb_to_bus (
      constant c_n_rgb  : in  natural;
      signal   s_bus    : out std_logic_vector;
      signal   s_red    : in  std_logic_vector;
      signal   s_green  : in  std_logic_vector;
      signal   s_blue   : in  std_logic_vector
    ) is
  begin
    s_bus (  c_n_rgb-1 downto         0) <= s_blue;
    s_bus (2*c_n_rgb-1 downto   c_n_rgb) <= s_green;
    s_bus (3*c_n_rgb-1 downto 2*c_n_rgb) <= s_red;
  end procedure p_rgb_to_bus;

  procedure p_bus_to_rgb (
      constant c_n_rgb  : in  natural;
      signal   s_bus    : in  std_logic_vector;
      signal   s_red    : out std_logic_vector;
      signal   s_green  : out std_logic_vector;
      signal   s_blue   : out std_logic_vector
    ) is
  begin
    s_blue  <= s_bus (  c_n_rgb-1 downto         0);
    s_green <= s_bus (2*c_n_rgb-1 downto   c_n_rgb);
    s_red   <= s_bus (3*c_n_rgb-1 downto 2*c_n_rgb);
  end procedure p_bus_to_rgb;

end package body vga_specs_pkg;
