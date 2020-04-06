-- --------------------------------------------------------------------------------
-- -- Title :      VGA Top (Package)
-- -- Project :    VGA Controller
-- --------------------------------------------------------------------------------
-- -- File :       vga_top_pkg.vhd
-- -- Author :     Christoph Amon
-- -- Company :    FH Technikum
-- -- Last update: 06.04.2020
-- -- Platform :   ModelSim - Starter Edition 10.5b
-- -- Language:    VHDL 1076-2002
-- --------------------------------------------------------------------------------
-- -- Description: The "VGA Top" unit combines all elements together to one
-- --              VGA controller with implemented image generators.
-- --------------------------------------------------------------------------------
-- -- Revisions :
-- -- Date         Version  Author           Description
-- -- 31.03.2020   v1.0.0   Christoph Amon   Initial stage
-- --------------------------------------------------------------------------------

-- library work;
-- use work.vga_specs_pkg.all;

-- package vga_top_pkg is

--   constant C_SPECS  : t_vga_specs := VGA_640x480_60Hz;
--   constant C_COLOUR : t_colour    := VGA_4bit_RGB;

--   constant C_IMG1   : t_image     := VGA_320x240_IMG;
--   constant C_IMG2   : t_image     := VGA_100x100_IMG;

--   constant C_F_OSC  : natural := 100_000_000;
--   constant C_F_DB   : natural :=       1_000;

--   -- -- FREQUENCY
--   -- -- C_F_CLK: System clock frequency
--   -- -- C_F_DB: Button debounce frequency
--   -- -- constant C_F_CLK : integer := 100_000_000;
--   -- -- constant C_F_DB  : integer := 1_000;
--   -- constant C_F_CLK : integer := 25_000_000;
--   -- constant C_F_DB  : integer := 1_000_000;

--   -- -- DATA WIDTH
--   -- -- C_N_COLOUR: Colour bit depth
--   -- -- C_N_PX: Pixel information data width (2^C_N_PX-1 >= C_H_PX_WHOLE_LINE &
--   -- --         2^C_N_PX-1 >= C_V_LN_WHOLE_LINE)
--   -- -- C_N_ADDR1: Address bus width for ROM 1
--   -- constant C_N_COLOUR : integer := 4;
--   -- constant C_N_PX     : integer := 10;
--   -- constant C_N_ADDR1  : integer := 17;
--   -- constant C_N_ADDR2  : integer := 14;

--   -- -- HORIZONTAL SPECS
--   -- constant C_H_PX_VISIBLE_AREA  : integer := 640;
--   -- constant C_H_PX_FRONT_PORCH   : integer := 16;
--   -- constant C_H_PX_SYNC_PULSE    : integer := 96;
--   -- constant C_H_PX_BACK_PORCH    : integer := 48;
--   -- constant C_H_PX_WHOLE_LINE    : integer := 800;

--   -- -- VERTICAL SPECS
--   -- constant C_V_LN_VISIBLE_AREA  : integer := 480;
--   -- constant C_V_LN_FRONT_PORCH   : integer := 10;
--   -- constant C_V_LN_SYNC_PULSE    : integer := 2;
--   -- constant C_V_LN_BACK_PORCH    : integer := 33;
--   -- constant C_V_LN_WHOLE_FRAME   : integer := 525;

-- end package;
