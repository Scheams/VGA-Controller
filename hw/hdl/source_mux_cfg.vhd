--------------------------------------------------------------------------------
-- Title :      Source MUX (Configuration)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       source_mux_cfg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "Source MUX" unit maps different source input to the VGA
--              controller unit. Depending on the position of 3 input switches
--              the MUX selects the RGB information from 4 different sources.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

configuration source_mux_rtl of source_mux is
  for rtl
  end for;
end configuration source_mux_rtl;
