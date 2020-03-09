--------------------------------------------------------------------------------
-- Title : Pattern Generator 1 Entity
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : pattern_gen1.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 09.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Entity for Pattern Generator 1
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 09.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity pattern_gen1 is
  port (
    -- INPUTS
    -- v_px_i: Vertical pixel index (0 - 639)
    -- h_px_i: Horizontal pixel index (0 - 479)
    v_px_i  : in  std_logic_vector (9 downto 0);
    h_px_i  : in  std_logic_vector (9 downto 0);

    -- OUTPUTS
    -- red_o: 4-bit output for red
    -- green_o: 4-bit output for green
    -- blue_o: 4-bit output for blue
    red_o   : out std_logic_vector (3 downto 0);
    green_o : out std_logic_vector (3 downto 0);
    blue_o  : out std_logic_vector (3 downto 0)
  );
end entity pattern_gen1;
