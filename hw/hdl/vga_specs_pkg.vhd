--------------------------------------------------------------------------------
-- Title :      VGA Specifications (Package)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_specs_pkg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
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

  -- Record for colour bit width definition
  type t_colour is record
    n_rgb     : natural;    -- Width of one colour
    n_bus     : natural;    -- Width of a bus of all 3 colours
  end record t_colour;

  -- Record for image information in ROM
  type t_image is record
    height    : natural;    -- Height of image
    width     : natural;    -- Width of image
    n_rom     : natural;    -- Bus width for ROM address
    size_rom  : natural;    -- Size of ROM
  end record t_image;

  -- Record for freqeuncy
  type t_vga_frequency is record
    f_pixel     : natural;  -- Pixel frequency for VGA controller
    f_min       : natural;  -- Min frequency (used in simulation)
    f_max       : natural;  -- Max frequency (used in simulation)
    f_min_vesa  : natural;  -- Min frequency (used in simulation) VESA standard
    f_max_vesa  : natural;  -- Max frequency (used in simulation) VESA standard
  end record t_vga_frequency;

  -- Record for horizontal timing specifications
  type t_vga_h_timing is record
    visible_area  : natural;  -- Visible area in pixels
    front_porch   : natural;  -- Front porch in pixels
    sync_pulse    : natural;  -- Sync pulse in pixels
    back_porch    : natural;  -- Back porch in pixels
    whole_line    : natural;  -- One whole line in pixels
  end record t_vga_h_timing;

  -- Record for vertical timing specifications
  type t_vga_v_timing is record
    visible_area  : natural;  -- Visible area in lines
    front_porch   : natural;  -- Front porch in lines
    sync_pulse    : natural;  -- Sync pulse in lines
    back_porch    : natural;  -- Back porch in lines
    whole_frame   : natural;  -- Complete frame in lines
  end record t_vga_v_timing;

  -- Record for addressing lines
  type t_vga_addr is record
    n_h : natural;      -- Bit width of horizontal pixel information
    n_v : natural;      -- Bit width of vertical line information
  end record t_vga_addr;

  -- Record for complete VGA specifications
  type t_vga_specs is record
    f_frame : natural;          -- Frequency of one frame (FPS)
    f_px    : t_vga_frequency;  -- Frequency of pixel clock
    px_h    : t_vga_h_timing;   -- Horizontal timing
    ln_v    : t_vga_v_timing;   -- Vertical timing
    addr    : t_vga_addr;       -- Addressing
  end record t_vga_specs;

  ------------------------------------------------------------------------------
  -- CONSTANTS
  ------------------------------------------------------------------------------

  -- Use 4 bit colour depth
  constant VGA_4bit_RGB : t_colour := (
    n_rgb  => 4,
    n_bus  => 12
  );

  -- 100x100 px image
  constant VGA_100x100_IMG : t_image := (
    height    => 100,
    width     => 100,
    n_rom     => 14,
    size_rom  => 10000
  );

  -- 320x240 px image
  constant VGA_320x240_IMG : t_image := (
    height    => 240,
    width     => 320,
    n_rom     => 17,
    size_rom  => 76800
  );

  -- 640x480 resolution with 60 Hz refresh rate
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

  ------------------------------------------------------------------------------
  -- PROCEDURES
  ------------------------------------------------------------------------------

  -- Combine RGB colours to one bus
  procedure p_rgb_to_bus (
      constant c_n_rgb  : in  natural;
      signal   s_bus    : out std_logic_vector;
      signal   s_red    : in  std_logic_vector;
      signal   s_green  : in  std_logic_vector;
      signal   s_blue   : in  std_logic_vector
    );

  -- Split up RGB bus into Red, Green and Blue
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
