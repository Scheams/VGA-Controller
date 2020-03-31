--------------------------------------------------------------------------------
-- Title : VGA Control Entity
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 31.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
-- Language: VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: Entity for VGA Control
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity vga_ctrl is

  generic (
    n_colour : integer;
    n_px     : integer;

    h_px_visible_area : integer;
    h_px_front_porch  : integer;
    h_px_sync_pulse   : integer;
    h_px_back_porch   : integer;
    h_px_whole_line   : integer;

    v_ln_visible_area : integer;
    v_ln_front_porch  : integer;
    v_ln_sync_pulse   : integer;
    v_ln_back_porch   : integer;
    v_ln_whole_frame  : integer
  );

  port (
    rst_i    : in  std_logic;
    clk_i    : in  std_logic;

    red_i    : in  std_logic_vector (n_colour-1 downto 0);
    green_i  : in  std_logic_vector (n_colour-1 downto 0);
    blue_i   : in  std_logic_vector (n_colour-1 downto 0);

    h_sync_o : out std_logic;
    v_sync_o : out std_logic;
    red_o    : out std_logic_vector (n_colour-1 downto 0);
    green_o  : out std_logic_vector (n_colour-1 downto 0);
    blue_o   : out std_logic_vector (n_colour-1 downto 0);

    px_x_o   : out std_logic_vector (n_px-1 downto 0);
    px_y_o   : out std_logic_vector (n_px-1 downto 0)
  );

end entity vga_ctrl;
