--------------------------------------------------------------------------------
-- Title : IO Control Entity
-- Project : VGA Controller
--------------------------------------------------------------------------------
-- File : io_ctrl.vhd
-- Author : Christoph Amon
-- Company : FH Technikum
-- Last update: 30.03.2020
-- Platform : ModelSim - Starter Edition 10.5b
--------------------------------------------------------------------------------
-- Description: Entity for IO Control
--------------------------------------------------------------------------------
-- Revisions :
-- Date         Version  Author           Description
-- 30.03.2020   v1.0.0   Christoph Amon   Initial stage
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity io_ctrl is

  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    sw_i  : in std_logic_vector (1 downto 0);
    pb_i  : in std_logic_vector (3 downto 0);

    sw_sync_o : out std_logic_vector (1 downto 0);
    pb_sync_o : out std_logic_vector (3 downto 0)
  );

end entity io_ctrl;
