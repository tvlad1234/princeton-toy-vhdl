----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/18/2024 12:22:35 AM
-- Design Name: 
-- Module Name: test_toy - Behavioral
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

entity test_toy is
--  Port ( );
end test_toy;

architecture Behavioral of test_toy is

component princeton_toy is
    Port ( i_clk : in STD_LOGIC;
           i_ce : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (15 downto 0);
           o_data : out STD_LOGIC_VECTOR (15 downto 0);
           o_halted : out STD_LOGIC
           );
end component princeton_toy;

signal clk, reset, halted : std_logic;
signal i_in, o_out : std_logic_vector (15 downto 0);
signal clk_en : std_logic := '1';
begin

i_in <= x"0005";

UT: princeton_toy port map (clk, clk_en, reset, i_in, o_out, halted);

process
begin
clk <= '1'; wait for 0.5 ns;
clk <= '0'; wait for 0.5 ns;
end process;

reset <= '1', '0' after 1.4 ns; --'0' after 61.3 ns, '1' after 62 ns;

end Behavioral;
