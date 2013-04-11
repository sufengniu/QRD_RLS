----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:20:14 11/10/2012 
-- Design Name: 
-- Module Name:    fixed_real_core - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

--Xilinx tool implementation
library IEEE_PROPOSED;
use IEEE_PROPOSED.fixed_float_types.all;
use IEEE_PROPOSED.fixed_pkg.all;
use IEEE_PROPOSED.float_pkg.all;

--modelsim simulation
--use IEEE.fixed_float_types.all;
--use IEEE.fixed_pkg.all;
--use IEEE.float_pkg.all;

library work;
use work.QRD_RLS_pkg.all;

entity fixed_real_core is
    Generic (	
			mode					: string := "streaming";		-- streaming/burst: streaming data need more area and power.
																			-- consumption
			oriented				: string := "throughput");		-- throughput/latency, throughput and latency are tradeoff,
																			-- throughput oriented will provide high speed clock rate
																			-- latency oriented will provide low circuit latency
																			-- low performance: power saving, slow speed and small area.
	Port ( 	
			clk 					: in  STD_LOGIC;
			rst 					: in  STD_LOGIC;
			ce 					: in  STD_LOGIC;

			data_in_rdy			: out STD_LOGIC;
			data_in				: in  sfixed (DATA_INT downto -DATA_FRA);
			data_in_valid		: in  STD_LOGIC;
          
			cos_valid 			: out STD_LOGIC;
			cos 					: out sfixed (COS_INT downto -COS_FRA);
			sin_valid 			: out STD_LOGIC;
			sin 					: out sfixed (SIN_INT downto -SIN_FRA);
			data_out_valid		: out STD_LOGIC;
			data_out				: out sfixed (DATA_INT downto -DATA_FRA));
end fixed_real_core;

architecture Structure of fixed_real_core is

signal data_in_buff, data_out_buff	: sfixed (DATA_INT downto -DATA_FRA);
signal data_in_sq	: sfixed(sfixed_high(data_in_buff, '*', data_in_buff) 
								downto sfixed_low(data_in_buff, '*', data_in_buff));
signal r_sq, r_sq_buff	: sfixed( downto );

constant lamda : sfixed(LAMDA_INT downto -LAMDA_FRA) := lamda_fixed(lamda);

begin

-- input/output buffer
process(clk, rst)
begin
	if rst = '1' then
		data_in_buff	<= (others => '0');
		data_out			<= (others => '0');
	elsif rising_edge(clk) then
		if ce = '1' then
			if data_in_valid = '1' then
				data_in_buff <= data_in;
			end if;
			data_out <= data_out_buff;
		end if;
	end if;
end process;

process(clk, rst)
begin
	if rst = '1' then
		data_in_sq	<= (others => '0');
		r_sq			<= (others => '0');
		r_sqr_buff	<= (others => '0');
	elsif rising_edge(clk) then
		if ce = '1' then
			data_in_sq	<= data_in_buff * data_in_buff;
			r_sq			<= data_in_sq + lamda*r_sq_buff;
			r_sq_buff	<= trounding(r_sq, , );
			
		end if;
	end if;
end process;

-- square root approximation
process(clk, rst)
begin
	if rst = '1' then
		
	elsif rising_edge(clk) then
		if ce = '1' then
			
		end if;
	end if;
end process;

end Structure;

