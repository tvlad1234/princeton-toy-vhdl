
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity reg_file is

    Port (  i_clk : in std_logic;
			i_ce : in std_logic;
			i_we : in std_logic;
			i_r1_addr : in std_logic_vector(3 downto 0);
			i_r2_addr : in std_logic_vector(3 downto 0);
			i_w_addr : in std_logic_vector(3 downto 0);
			o_r1_data : out std_logic_vector(15 downto 0);
			o_r2_data : out std_logic_vector(15 downto 0);
			i_w_data : in std_logic_vector(15 downto 0)
	);
	
end reg_file;

architecture Behavioral of reg_file is

type reg_array is array (0 to 15 ) of std_logic_vector (15 downto 0);

signal reg_data : reg_array;


begin

o_r1_data <= (others => '0') when i_r1_addr = "0000" else reg_data(to_integer(unsigned(i_r1_addr)));
o_r2_data <= (others => '0') when i_r2_addr = "0000" else reg_data(to_integer(unsigned(i_r2_addr)));

process (i_clk, i_ce)
begin

	if rising_edge(i_clk) and i_ce = '1' then
	
		if i_we = '1' and not (i_w_addr = "0000") then
			reg_data(to_integer(unsigned(i_w_addr))) <= i_w_data;
		end if;
		
	end if;

end process;

end Behavioral;