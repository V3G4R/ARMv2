library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Alu is
	port ( op1	: in Std_Logic_Vector(31 downto 0);
	       op2	: in Std_Logic_Vector(31 downto 0);
	       cin	: in Std_Logic;
	       cmd	: in Std_Logic_Vector(1 downto 0);
	       res	: out Std_Logic_Vector(31 downto 0);
	       cout	: out Std_logic;
 	       z	: out Std_logic;
 	       n	: out Std_logic;
 	       v	: out Std_logic;
 	       vdd	:in bit;
 	       vss	:in bit);
end Alu;
architecture Behavioral of Alu is
	signal res_adder 	 : Std_Logic_Vector(31 downto 0);
	signal res_sig   	 : Std_Logic_Vector(31 downto 0);
	signal cout_adder	 : Std_Logic;
	signal cout_sig		 : Std_Logic;

	component Adder
		port (
		i1     : in std_logic_vector(31 downto 0); 
		i2     : in std_logic_vector(31 downto 0); 
      		sum    : out std_logic_vector(31 downto 0); 
      		cin    : in std_logic;
      		cout   : out std_logic);
	end component;

begin
	adder_inst : Adder PORT MAP(op1, op2, res_adder, cin, cout);

--Resultat
	res  <= res_sig;
	cout <= cout_sig;
--Opérations
	with cmd select
		res_sig <= res_adder when   "00",
		     	   op1 AND op2 when "01",
		     	   op1 OR op2 when "10",
		     	   op1 XOR op2 when "11",
		    	   x"00000000" when others;
--Flags
	z <= '1' when (to_integer(unsigned(res_sig)) = 0) else '0';
	n <= '1' when (res_sig(31) = '1') else '0';
	v <= ( (not(op1(31)) and not(op2(31)) and res_sig(31)) or (op1(31) and op2(31) and not(res_sig(31))) );

end Behavioral;

