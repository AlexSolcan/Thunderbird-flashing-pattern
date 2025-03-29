----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2024 10:33:22 PM
-- Design Name: 
-- Module Name: flashing_pattern - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flashing_pattern is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           left : in STD_LOGIC;
           right : in STD_LOGIC;
           hazzard : in STD_LOGIC;
           La : out STD_LOGIC;
           Lb : out STD_LOGIC;
           Lc : out STD_LOGIC;
           Ra : out STD_LOGIC;
           Rb : out STD_LOGIC;
           Rc : out STD_LOGIC);
end flashing_pattern;

architecture Behavioral of flashing_pattern is

constant fdiv : integer := 25;
constant ndiv : integer := 10**9/fdiv;
signal en : std_logic := '0';

type stages is (idle, left1, left2, left3, right1, right2, right3, hazzardon, hazzardoff);
signal stage, next_stage : stages;

begin

divider : process (reset, clk)
variable div : integer := 0;
begin 
if reset = '1' then
div := 0;
en <= '0';
elsif rising_edge(clk) then
if div = ndiv - 1 then
div := 0;
en <= '1';
else
div := div + 1;
en <= '0';
end if;
end if;
end process;

counter : process(clk, reset)
begin

if reset = '1' then
stage <= idle;
elsif rising_edge(clk) then
if en = '1' then
stage <= next_stage;
end if;
end if;
end process counter;

UUT : process(stage, left, right, hazzard)
begin

case stage is

when idle => if hazzard = '1' then
next_stage <= hazzardon;
elsif left = '1' then
next_stage <= left1;
elsif right = '1' then
next_stage <= right1;
else
next_stage <= idle;
end if;

when left1 => if hazzard = '1' then
next_stage <= hazzardon;
elsif left = '0' then 
next_stage <= idle;
else
next_stage <= left2;
end if;

when left2 => if hazzard = '1' then
next_stage <= hazzardon;
elsif left = '0' then 
next_stage <= idle;
else
next_stage <= left3;
end if;

when left3 => if hazzard = '1' then
next_stage <= hazzardon;
elsif left = '0' then 
next_stage <= idle;
else
next_stage <= left1;
end if;

when right1 => if hazzard = '1' then
next_stage <= hazzardon;
elsif right = '0' then
next_stage <= idle;
else
next_stage <= right2;
end if;

when right2 => if hazzard = '1' then
next_stage <= hazzardon;
elsif right = '0' then
next_stage <= idle;
else
next_stage <= right3;
end if;

when right3 => if hazzard = '1' then
next_stage <= hazzardon;
elsif right = '0' then
next_stage <= idle;
else
next_stage <= right1;
end if;

when hazzardon => next_stage <= hazzardoff;
when hazzardoff => if hazzard = '1' then
           next_stage <= hazzardon;
           else
           next_stage <= idle;
           end if;

when others => next_stage <= idle;
end case;
end process UUT;

combinatii : process(stage)
begin

La <= '0';
Lb <= '0';
Lc <= '0';
Ra <= '0';
Rb <= '0';
Rc <= '0';

case stage is

when left1 => La <= '1';
when left2 => La <= '1'; Lb <= '1';
when left3 => La <= '1'; Lb <= '1'; Lc <= '1';

when right1 => Ra <= '1';
when right2 => Ra <= '1'; Rb <= '1';
when right3 => Ra <= '1'; Rb <= '1'; Rc <= '1';

when hazzardon =>
La <= '1';
Lb <= '1';
Lc <= '1';
Ra <= '1';
Rb <= '1';
Rc <= '1';

when others =>
end case;
end process combinatii;
end Behavioral;
