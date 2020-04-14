--------------------------------------------------------------------------------
-- Title :      IO Debounce (Configuration)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       io_debounce_cfg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 14.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b, Vivado 2019.2
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "IO Debounce" Unit is able to debounce switches and
--              pushbuttons. The debounce frequency can be set, the default
--              frequency is 1kHz. With this frequency the switches and buttons
--              go through a 2-stage-FF and therefore the synchronized outputs
--              get set or cleared.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
-- 01.04.2020   v2.0.0   Christoph Amon   From IO Control to IO Debounce Unit
--------------------------------------------------------------------------------

configuration io_debounce_rtl of io_debounce is
  for rtl
  end for;
end configuration io_debounce_rtl;
