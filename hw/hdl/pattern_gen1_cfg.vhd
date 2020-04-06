--------------------------------------------------------------------------------
-- Title :      Pattern Generator 1 (Configuration)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       pattern_gen1_cfg.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
-- Language:    VHDL 1076-2002
--------------------------------------------------------------------------------
-- Description: The "Pattern Generator 1" unit creates a defined pattern for
--              the VGA controller. The generator creates horizontal stripes
--              with Red-Green-Blue-Black order.
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 09.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

configuration pattern_gen1_rtl of pattern_gen1 is
  for rtl
  end for;
end configuration pattern_gen1_rtl;
