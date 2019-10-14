library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity SHIFTER is
port(	shift_lsl 	: in std_logic;
	shift_lsr	: in std_logic;
	shift_asr	: in std_logic;
	shift_ror	: in std_logic;
	shift_rrx	: in std_logic;
	shift_val	: in std_logic_vector(4 downto 0);

	din		: in std_logic_vector(31 downto 0);
	cin		: in std_logic;

	dout		: out std_logic_vector(31 downto 0);
	cout		: out std_logic;

	vdd		: in bit;
	vss		: in bit
	);
end SHIFTER;

architecture Behavior of SHIFTER is

-- LSL
signal lsl_out_1  : std_logic_vector(31 downto 0); -- Sortie LSL 16
signal lsl_out_2  : std_logic_vector(31 downto 0); -- Sortie LSL 8
signal lsl_out_3  : std_logic_vector(31 downto 0); -- Sortie LSL 4
signal lsl_out_4  : std_logic_vector(31 downto 0); -- Sortie LSL 2
signal lsl_out_5  : std_logic_vector(31 downto 0); -- Sortie LSL 1

signal cout_lsl_1 : std_logic; -- Carry en sortie d'étage 1
signal cout_lsl_2 : std_logic; -- Carry en sortie d'étage 2
signal cout_lsl_3 : std_logic; -- Carry en sortie d'étage 3
signal cout_lsl_4 : std_logic; -- Carry en sortie d'étage 4
signal cout_lsl_5 : std_logic; -- Carry en sortie d'étage 5

-- LSR
signal lsr_out_1  : std_logic_vector(31 downto 0); -- Sortie LSR 16
signal lsr_out_2  : std_logic_vector(31 downto 0); -- Sortie LSR 8
signal lsr_out_3  : std_logic_vector(31 downto 0); -- Sortie LSR 4
signal lsr_out_4  : std_logic_vector(31 downto 0); -- Sortie LSR 2
signal lsr_out_5  : std_logic_vector(31 downto 0); -- Sortie LSR 1

signal cout_lsr_1 : std_logic; -- Carry en sortie d'étage 1
signal cout_lsr_2 : std_logic; -- Carry en sortie d'étage 2
signal cout_lsr_3 : std_logic; -- Carry en sortie d'étage 3
signal cout_lsr_4 : std_logic; -- Carry en sortie d'étage 4
signal cout_lsr_5 : std_logic; -- Carry en sortie d'étage 5

-- ASR
signal asr_out_1  : std_logic_vector(31 downto 0); -- Sortie ASR 16
signal asr_out_2  : std_logic_vector(31 downto 0); -- Sortie ASR 8
signal asr_out_3  : std_logic_vector(31 downto 0); -- Sortie ASR 4
signal asr_out_4  : std_logic_vector(31 downto 0); -- Sortie ASR 2
signal asr_out_5  : std_logic_vector(31 downto 0); -- Sortie ASR 1

signal cout_asr_1 : std_logic; -- Carry en sortie d'étage 1
signal cout_asr_2 : std_logic; -- Carry en sortie d'étage 2
signal cout_asr_3 : std_logic; -- Carry en sortie d'étage 3
signal cout_asr_4 : std_logic; -- Carry en sortie d'étage 4
signal cout_asr_5 : std_logic; -- Carry en sortie d'étage 5

-- ROR
signal ror_out_1  : std_logic_vector(31 downto 0); -- Sortie ROR 16
signal ror_out_2  : std_logic_vector(31 downto 0); -- Sortie ROR 8
signal ror_out_3  : std_logic_vector(31 downto 0); -- Sortie ROR 4
signal ror_out_4  : std_logic_vector(31 downto 0); -- Sortie ROR 2
signal ror_out_5  : std_logic_vector(31 downto 0); -- Sortie ROR 1

signal cout_ror_1 : std_logic; -- Carry en sortie d'étage 1
signal cout_ror_2 : std_logic; -- Carry en sortie d'étage 2
signal cout_ror_3 : std_logic; -- Carry en sortie d'étage 3
signal cout_ror_4 : std_logic; -- Carry en sortie d'étage 4
signal cout_ror_5 : std_logic; -- Carry en sortie d'étage 5


signal shift_vect  : std_logic_vector( 3 downto 0); -- Vecteur contenant le type de décalage
signal shift_vect_out : std_logic_vector(4 downto 0);
signal rrx_vect	 	 : std_logic_vector(31 downto 0); -- Vecteur contenant la rotation RRX

begin

shift_vect <= shift_lsl & shift_lsr & shift_asr & shift_ror; -- Concaténation dans le vecteur
shift_vect_out <= shift_vect & shift_rrx;

SHITF_CRY :
  with shift_vect_out select
    cout <= cout_lsl_5 when "10000",
            cout_lsr_5 when "01000",
            cout_asr_5 when "00100",
            cout_ror_5 when "00010",
            din(0)     when "00001",
            cin        when others; -- On renvoie cin par défaut


D_OUT :
  with shift_vect_out select
    dout <= lsl_out_5 when "10000",
            lsr_out_5 when "01000",
            asr_out_5 when "00100",
            ror_out_5 when "00010",
            rrx_vect  when "00001",
            din       when others;


-- LSL

  lsl_out_1 <= std_logic_vector(shift_left(unsigned(din), 16)) when shift_val(4)='1' else din;
  lsl_out_2 <= std_logic_vector(shift_left(unsigned(lsl_out_1), 8)) when shift_val(3)='1' else lsl_out_1;
  lsl_out_3 <= std_logic_vector(shift_left(unsigned(lsl_out_2), 4)) when shift_val(2)='1' else lsl_out_2;
  lsl_out_4 <= std_logic_vector(shift_left(unsigned(lsl_out_3), 2)) when shift_val(1)='1' else lsl_out_3;
  lsl_out_5 <= std_logic_vector(shift_left(unsigned(lsl_out_4), 1)) when shift_val(0)='1' else lsl_out_4;

  cout_lsl_1 <= din(16) when shift_val(4)='1' else cin;
  cout_lsl_2 <= lsl_out_1(24) when shift_val(3)='1' else cout_lsl_1;
  cout_lsl_3 <= lsl_out_2(28) when shift_val(2)='1' else cout_lsl_2;
  cout_lsl_4 <= lsl_out_3(30) when shift_val(1)='1' else cout_lsl_3;
  cout_lsl_5 <= lsl_out_4(31) when shift_val(1)='1' else cout_lsl_4;

-- LSR

  lsr_out_1 <= std_logic_vector(shift_right(unsigned(din), 16)) when shift_val(4)='1' else din;
  lsr_out_2 <= std_logic_vector(shift_right(unsigned(lsr_out_1), 8)) when shift_val(3)='1' else lsr_out_1;
  lsr_out_3 <= std_logic_vector(shift_right(unsigned(lsr_out_2), 4)) when shift_val(2)='1' else lsr_out_2;
  lsr_out_4 <= std_logic_vector(shift_right(unsigned(lsr_out_3), 2)) when shift_val(1)='1' else lsr_out_3;
  lsr_out_5 <= std_logic_vector(shift_right(unsigned(lsr_out_4), 1)) when shift_val(0)='1' else lsr_out_4;

  cout_lsr_1 <= din(15) when shift_val(4)='1' else cin;
  cout_lsr_2 <= lsr_out_1(7) when shift_val(3)='1' else cout_lsr_1;
  cout_lsr_3 <= lsr_out_2(3) when shift_val(2)='1' else cout_lsr_2;
  cout_lsr_4 <= lsr_out_3(1) when shift_val(1)='1' else cout_lsr_3;
  cout_lsr_5 <= lsr_out_4(0) when shift_val(1)='1' else cout_lsr_4;

-- ASR

  asr_out_1 <= std_logic_vector(shift_right(signed(din), 16)) when shift_val(4)='1' else din;
  asr_out_2 <= std_logic_vector(shift_right(signed(asr_out_1), 8)) when shift_val(3)='1' else asr_out_1;
  asr_out_3 <= std_logic_vector(shift_right(signed(asr_out_2), 4)) when shift_val(2)='1' else asr_out_2;
  asr_out_4 <= std_logic_vector(shift_right(signed(asr_out_3), 2)) when shift_val(1)='1' else asr_out_3;
  asr_out_5 <= std_logic_vector(shift_right(signed(asr_out_4), 1)) when shift_val(0)='1' else asr_out_4;

  cout_asr_1 <= din(15) when shift_val(4)='1' else cin;
  cout_asr_2 <= asr_out_1(7) when shift_val(3)='1' else cout_asr_1;
  cout_asr_3 <= asr_out_2(3) when shift_val(2)='1' else cout_asr_2;
  cout_asr_4 <= asr_out_3(1) when shift_val(1)='1' else cout_asr_3;
  cout_asr_5 <= asr_out_4(0) when shift_val(1)='1' else cout_asr_4;

-- ROR

  ror_out_1 <= din(15 downto 0) & din(31 downto 16) when shift_val(4)='1' else din;
  ror_out_2 <= ror_out_1(7 downto 0) & ror_out_1(31 downto 8) when shift_val(3)='1' else ror_out_1;
  ror_out_3 <= ror_out_2(3 downto 0) & ror_out_2(31 downto 4) when shift_val(2)='1' else ror_out_2;
  ror_out_4 <= ror_out_3(1 downto 0) & ror_out_3(31 downto 2) when shift_val(1)='1' else ror_out_3;
  ror_out_5 <= ror_out_4(0) & ror_out_4(31 downto 1) when shift_val(0)='1' else ror_out_4;
  
  cout_ror_1 <= din(15) when shift_val(4)='1' else cin;
  cout_ror_2 <= ror_out_1(7) when shift_val(3)='1' else cout_ror_1;
  cout_ror_3 <= ror_out_2(3) when shift_val(2)='1' else cout_ror_2;
  cout_ror_4 <= ror_out_3(1) when shift_val(1)='1' else cout_ror_3;
  cout_ror_5 <= ror_out_4(0) when shift_val(1)='1' else cout_ror_4;

RRX_SHIFT : rrx_vect <= cin & din(31 downto 1);

end Behavior;
