library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder is
   port (
      i1, i2 	: in std_logic_vector(31 downto 0); 
      cin 	: in std_logic;
      sum       : out std_logic_vector(31 downto 0); 
      cout 	: out std_logic
   );
end Adder;
 
architecture Behavioral of Adder is
   signal temp : unsigned(32 downto 0); 
begin 
   temp <= ("0" & unsigned(i1) + unsigned(i2) + "1") when cin='1' else ("0" & unsigned(i1) + unsigned(i2)) ;
   sum  <= std_logic_vector(temp(31 downto 0)); 
   cout <= temp(32);
end Behavioral;
