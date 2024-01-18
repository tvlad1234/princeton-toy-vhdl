
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

entity alu is

    Port (  i_a : in std_logic_vector(15 downto 0);
			i_b : in std_logic_vector(15 downto 0);
			i_op : in std_logic_vector (2 downto 0);
			o_r : out std_logic_vector(15 downto 0)
	);
	
end alu;

architecture Behavioral of alu is

signal shamt : std_logic_vector(3 downto 0);

begin

	shamt <= i_b(3 downto 0);
	
	process (i_a, i_b, i_op, shamt)
	begin
	
		case i_op is
		
		when "001" =>
			o_r <= i_a + i_b;
		
		when "010" =>
			o_r <= i_a - i_b;
			
		when "011" =>
			o_r <= i_a and i_b;
			
		when "100" =>
			o_r <= i_a xor i_b;
		
		when "101" =>
			-- unsigned left shift
			case shamt is
			
			when "0001" =>
				o_r <= i_a(14 downto 0) & '0';
			
			when "0010" =>
				o_r <= i_a(13 downto 0) & "00";
			
			when "0011" =>
				o_r <= i_a(12 downto 0) & "000";
			
			when "0100" =>
				o_r <= i_a(11 downto 0) & "0000";
				
			when "0101" =>
				o_r <= i_a(10 downto 0) & "00000";
				
			when "0110" =>
				o_r <= i_a(9 downto 0) & "000000";
			
			when "0111" =>
				o_r <= i_a(8 downto 0) & "0000000";
			
			when "1000" =>
				o_r <= i_a(7 downto 0) & "00000000";
			
			when "1001" =>
				o_r <= i_a(6 downto 0) & "000000000";
			
			when "1010" =>
				o_r <= i_a(5 downto 0) & "0000000000";
				
			when "1011" =>
				o_r <= i_a(4 downto 0) & "00000000000";
			
			when "1100" =>
				o_r <= i_a(3 downto 0) & "000000000000";
			
			when "1101" =>
				o_r <= i_a(2 downto 0) & "0000000000000";
			
			when "1110" =>
				o_r <= i_a(1 downto 0) & "00000000000000";
			
			when "1111" =>
				o_r <= i_a(0) & "000000000000000";
			
			when others =>
				o_r <= i_a;
			
			end case;
		
		when "110" =>
			-- signed right shift
			case shamt is
			
			when "0001" =>
				o_r <= i_a(15) & i_a(15 downto 1);
			
			when "0010" =>
				o_r <= i_a(15) & i_a(15) & i_a(15 downto 2);
			
			when "0011" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 3);
				
			when "0100" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) &i_a(15 downto 4);
			
			when "0101" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 5);
				
			when "0110" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) &  i_a(15) & i_a(15) & i_a(15 downto 6);
				
			when "0111" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) &i_a(15 downto 7);
				
			when "1000" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 8);
				
			when "1001" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 9);
				
			when "1010" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 10);
				
			when "1011" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 11);
				
			when "1100" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 12);
				
			when "1101" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 13);
			
			when "1110" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15 downto 14);
			
			when "1111" =>
				o_r <= i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15) & i_a(15);
			
			when others =>
				o_r <= i_a;
			
			end case;
			
			
		when others =>
			o_r <= (others => '0');
				
		
		end case;
	
	end process;
	

end Behavioral;