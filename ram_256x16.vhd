
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity ram_256x16 is

    Port (  i_clk : in std_logic;
			i_ce : in std_logic;
			i_we : in std_logic;
			i_addr : in std_logic_vector(7 downto 0);
			o_data : out std_logic_vector(15 downto 0);
			i_data : in std_logic_vector(15 downto 0)
	);
	
end ram_256x16;

architecture Behavioral of ram_256x16 is

type ram_array is array (0 to 255 ) of std_logic_vector (15 downto 0);

---- Fibonnaci
--	x"8B01",  
--	x"9AFF", 
--	x"1AAB",
--	x"2BAB",
--	x"DA04", 

signal ram_data : ram_array := (

	x"0000", -- address 0
	x"ABCD", -- address 1	
	
	-- program start:
	x"7B01", -- address 2, load 01 into RB
    x"8AFF", -- load from switches into RA
    x"F10A", -- link and jump routine at 0A
    x"9AFF", -- display contents of RA
    x"CA03", -- if RA is zero, go to inst at 3 (load from switches)
    x"2AAB", -- RA <= RA - RB
    
    
    
	x"7105", -- load 04 into R1
	x"E100", -- jump to address in R1 ; addr 9
	
	x"8201", -- load from addr 1 in R2 -- addr 10
	x"92FF", -- display contents of R2
	x"1000", -- nop
	x"1000", -- nop
	x"1000", -- nop
	x"E100", -- jump to contents of R1
	
	others => x"0000"
	);

begin

o_data <= ram_data(to_integer(unsigned(i_addr)));

process (i_clk, i_ce)
begin

	if rising_edge(i_clk) and i_ce = '1' then
	
		if i_we = '1' then
			ram_data(to_integer(unsigned(i_addr))) <= i_data;
		end if;
		
	end if;

end process;

end Behavioral;
