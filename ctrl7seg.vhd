----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2023 07:26:46 PM
-- Design Name: ctrl7seg
-- Module Name: ctrl7seg - Behavioral
-- Project Name: Chrono
-- Target Devices: Basys-3
-- Tool Versions: Vivado 2020.1
-- Description: Controller Display 7 segmente
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl7seg is
    Port ( ck100MHz : in STD_LOGIC;
           data : in std_logic_vector (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end ctrl7seg;

architecture Behavioral of ctrl7seg is

signal cntPresc: unsigned (19 downto 0);
alias cntAn is cntPresc(19 downto 18);
signal HEX: std_logic_vector (3 downto 0);

begin

prescaler:process(ck100MHz)
begin

if rising_edge(ck100MHz) then
    cntPresc <= cntPresc + 1;
end if;

end process;

-- selectam anodul
an <= "1110" when cntAn = "00" else
      "1101" when cntAn = "01" else
      "1011" when cntAn = "10" else
      "0111";
      
-- selectam cifra
 HEX <= data(3 downto 0) when cntAn = "00" else
        data(7 downto 4) when cntAn = "01" else
        data(11 downto 8) when cntAn = "10" else
        data (15 downto 12);
        
 dp<='0' when cntAn = "10" else '1';
 
     with HEX SELect
   seg<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0
 

end Behavioral;
