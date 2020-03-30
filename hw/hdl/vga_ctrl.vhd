--------------------------------------------------------------------------------
-- Title : VGA Control Entity
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
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

  port (
    rst_i    : in  std_logic;
    clk_i    : in  std_logic;
    rgb_i    : in  std_logic_vector (11 downto 0);

    h_sync_o : out std_logic;
    v_sync_o : out std_logic;
    red_o    : out std_logic_vector (3 downto 0);
    green_o  : out std_logic_vector (3 downto 0);
    blue_o   : out std_logic_vector (3 downto 0);
    px_x_o   : out std_logic_vector (9 downto 0);
    px_y_o   : out std_logic_vector (9 downto 0)
  );

end entity vga_ctrl;
