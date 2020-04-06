--------------------------------------------------------------------------------
-- Title :      IO Debounce (Entity)
-- Project :    VGA Controller
--------------------------------------------------------------------------------
-- File :       io_debounce.vhd
-- Author :     Christoph Amon
-- Company :    FH Technikum
-- Last update: 06.04.2020
-- Platform :   ModelSim - Starter Edition 10.5b
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_debounce is

  generic (
    -- FREQUENCY
    -- f_sys: System clock frequency (default 100 MHz)
    -- f_debounce: Debounce frequency (default 1 kHz)
    f_sys       : integer := 100_000_000;
    f_debounce  : integer := 1_000;

    -- DATA WIDTH
    -- n_sw: Number of switches
    -- n_pb: Number of push-buttons
    n_sw        : integer;
    n_pb        : integer
  );

  port (
    -- SYSTEM
    -- rst_i: System reset
    -- clk_i: System clock
    rst_i       : in std_logic;
    clk_i       : in std_logic;

    -- INPUTS
    -- sw_i: Switch inputs
    -- pb_i: Push-button inputs
    sw_i        : in std_logic_vector (n_sw-1 downto 0);
    pb_i        : in std_logic_vector (n_pb-1 downto 0);

    -- OUTPUTS
    -- sw_sync_o: Debounced switch output
    -- pb_sync_o: Debounced push-button output
    sw_sync_o   : out std_logic_vector (n_sw-1 downto 0);
    pb_sync_o   : out std_logic_vector (n_pb-1 downto 0)
  );

end entity io_debounce;
