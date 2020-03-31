--------------------------------------------------------------------------------
-- Title : VGA Control Package
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : vga_ctrl_pkg.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 31.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
-- Language: VHDL 1076-2008
--------------------------------------------------------------------------------
-- Description: Package for VGA Control
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 31.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

package vga_ctrl_pkg is

  type t_state is (
    S_IDLE,
    S_SYNC,
    S_BACKPORCH,
    S_DATA,
    S_FRONTPORCH
  );

  attribute enum_encoding : string;
  attribute enum_encoding of t_state : type is "one-hot";

end package vga_ctrl_pkg;
