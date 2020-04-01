--------------------------------------------------------------------------------
-- Title : VGA Top Entity
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_top.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 01.04.2020
-- Platform : ModelSim - Starter Edition 10.5b
-- Language: VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: Entity for VGA Top
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 01.04.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity vga_top is

  port (
    rst_i    : in  std_logic;
    clk_i    : in  std_logic
  );

end entity vga_top;
