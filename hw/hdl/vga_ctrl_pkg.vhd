--------------------------------------------------------------------------------
-- Title :      VGA Control (Package)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       vga_ctrl_pkg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "VGA Control" unit controlls the hardware operation that
--              is transfered through the VGA cable to the monitor. It takes
--              input signals like the colour information and monitor
--              specifications to perform this action.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 31.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

package vga_ctrl_pkg is

  ------------------------------------------------------------------------------
  -- TYPEDEF
  ------------------------------------------------------------------------------

  -- t_state: Describes current state of VGA controller
  type t_state is (
    S_IDLE,       -- Controller is in IDLE
    S_SYNC,       -- Sync pulse is active
    S_BACKPORCH,  -- Controller performs back-porch
    S_DATA,       -- Data (RGB) is output
    S_FRONTPORCH  -- Controller perfoms front-porch
  );

end package vga_ctrl_pkg;
