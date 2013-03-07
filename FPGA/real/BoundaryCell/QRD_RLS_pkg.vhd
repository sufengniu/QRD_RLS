--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

library IEEE_PROPOSED;
use IEEE_PROPOSED.fixed_float_types.all;
use IEEE_PROPOSED.fixed_pkg.all;
use IEEE_PROPOSED.float_pkg.all;

package QRD_RLS_pkg is

--------------------------------------------------------------------------------------
--								Boundary cell generic 
--------------------------------------------------------------------------------------
	-- fixed point
	constant DATA_INT					: integer := 2;				-- input width integer part
	constant DATA_FRA					: integer := 13;				-- input width fractional part
	constant WIDTH_DATA_FIXED				: integer := DATA_INT + DATA_FRA + 1;
		
	constant COS_INT					: integer := 1;				-- cosine width integer part
	constant COS_FRA					: integer := 14;				-- cosine width fractional part
	constant WIDTH_COS_FIXED		: integer := COS_INT + COS_FRA + 1;
	constant COS_EXP					: integer := 8;				-- cosine
	constant COS_FPF					: integer := 23;				-- cosine
	constant	WIDTH_COS_FLOAT		: integer := COS_EXP + COS_FPF + 1;
	
	constant SIN_INT					: integer := 1;				-- sine width integer part
	constant SIN_FRA					: integer := 14;				-- sine width fractional part
	constant WIDTH_SIN_FIXED		: integer := SIN_INT + SIN_FRA + 1;
	constant SIN_EXP					: integer := 8;				-- cosine
	constant SIN_FPF					: integer := 23;				-- cosine
	constant WIDTH_SIN_FLOAT		: integer := SIN_EXP + SIN_FPF + 1;
	
	-- floating point
	constant DATA_EXP					: integer := 8;				-- floating point exp
	constant DATA_FPF					: integer := 23;				-- floating point fractinoal (FPF)
	constant WIDTH_DATA_FLOAT		: integer := DATA_FPF + DATA_EXP + 1;
	
	constant lamda						: real := 0.98;
	constant LAMDA_INT				: integer := 1;				-- lamda integer part width
	constant LAMDA_FRA				: integer := 14;				-- lamda fractional part width
	constant LAMDA_EXP				: integer := 8;
	constant LAMDA_FPF				: integer := 23;
	
	-- testbench generic
   constant VECTOR_LENGTH			: integer := 100;
	type din_t_fixed is array (VECTOR_LENGTH-1 downto 0) of std_logic_vector(WIDTH_FIXED-1 downto 0);
	type dout_t_fixed is array (VECTOR_LENGTH-1 downto 0) of std_logic_vector(WIDTH_FIXED-1 downto 0);
	type din_t_float is array (VECTOR_LENGTH-1 downto 0) of std_logic_vector(WIDTH_FLOAT-1 downto 0);
	type dout_t_float is array (VECTOR_LENGTH-1 downto 0) of std_logic_vector(WIDTH_FLOAT-1 downto 0);

type DATA_TYPE is	record
	re_fixed								: sfixed(DATA_INT downto -DATA_FRA);
	im_fixed								: sfixed(DATA_INT downto -DATA_FRA);
	re_float								: float(DATA_EXP downto -DATA_FPF);
	im_float								: float(DATA_EXP downto -DATA_FPF);
end record;

--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
	
end QRD_RLS_pkg;

package body QRD_RLS_pkg is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;

impure function lamda_fixed(lamda : real) return sfixed is
	variable res : sfixed(LAMDA_INT downto -LAMDA_FRA);
	begin
		res := to_sfixed(lamda, res);							-- lamda =< 1
	return res;
end function;

--impure function lamda_float(lamda : real) return float is
--	variable res : float;
--	begin
--		res <= to_float(lamda, , );
--	return res;
--end function;

--function trounding (
--	data 				: sfixed;
--	left_index		: integer;
--	right_index		: integer) 
--	return sfixed is
--	
--	variable res : sfixed(left_index downto right_index);
--	variable temp : std_logic_vector(data'high + data'low downto 0);
--	variable lsb : std_logic;
--begin
--	temp := to_slv(data);
--	temp()&(temp(1) or temp(0));
--	
--	res := data(left_index downto right_index+1) & lsb;
--	return res;
--end function;

end QRD_RLS_pkg;
