----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/18/2024 04:24:06 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_halted : out STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end top;

architecture Behavioral of top is

component ctrl7seg is
    Port ( ck100MHz : in STD_LOGIC;
           data : in std_logic_vector (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component ctrl7seg;

component princeton_toy is
    Port ( i_clk : in STD_LOGIC;
           i_ce : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (15 downto 0);
           o_data : out STD_LOGIC_VECTOR (15 downto 0);
           o_halted : out STD_LOGIC
           );
end component princeton_toy;

signal port_o_data : std_logic_vector(15 downto 0);
signal cpu_ce : std_logic;
signal cnt_presc: integer range 0 to 6250001 := 0;

begin

U_sevseg: ctrl7seg port map(i_clk, port_o_data, an, dp, seg);
U_toy: princeton_toy port map(i_clk, cpu_ce, i_reset, sw, port_o_data, o_halted);
 
process(i_clk)
begin

	if falling_edge(i_clk) then 

		if cnt_presc = 6250000 then
            cnt_presc <= 1;
            cpu_ce <= '1';
        else 
            cnt_presc <= cnt_presc + 1;
            cpu_ce <= '0';
        end if;

        else 
            cnt_presc <= cnt_presc;
    end if;

end process;

end Behavioral;
