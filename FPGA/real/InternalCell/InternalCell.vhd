----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sufeng Niu
-- 
-- Create Date:    14:08:49 10/30/2012 
-- Design Name: 
-- Module Name:    BoundaryCell - Behavioral 
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

--hardware implementation
library IEEE_PROPOSED;
use IEEE_PROPOSED.fixed_float_types.all;
use IEEE_PROPOSED.fixed_pkg.all;
use IEEE_PROPOSED.float_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.QRD_RLS_pkg.all;
use work.fixed_real_core;

entity InternalCell is
	Generic ( 
			platform				: string := "FPGA";			-- FPGA/ASIC
			data_type			: string := "real";			-- real/complex 
			data_form			: string := "fixed";			-- fixed/floating
			mode					: string := "streaming";	-- streaming/burst: streaming data need more area and power.
																		-- consumption
			oriented				: string := "throughput";	-- throughput/latency, throughput and latency are tradeoff,
																		-- throughput oriented will provide high speed clock rate
																		-- latency oriented will provide low circuit latency
			arch					: string := "unfolded"		-- folded/unfolded: folded can be used for larger matrix size.
			 );
	Port ( 
			clk 					: in	STD_LOGIC;
			rst 					: in	STD_LOGIC;
			ce 					: in	STD_LOGIC;
			 
			data_in_rdy			: out	STD_LOGIC;
			data_in				: in	work.QRD_RLS_pkg.DATA_TYPE;
			data_in_valid		: in	STD_LOGIC;
			
			cos_valid 			: out	STD_LOGIC;
			cos					: out	sfixed (WIDTH_COS-1 downto 0);
			sin_valid 			: out	STD_LOGIC;
			sin 					: out	sfixed (WIDTH_SIN-1 downto 0);
			data_out_valid		: out	STD_LOGIC;
			data_out				: out	work.QRD_RLS_pkg.DATA_TYPE);
end InternalCell;

architecture Behavioral of InternalCell is

begin

FIXED_REAL_GEN: if (data_form = "fixed") and (data_type = "real") generate
begin	
	data_out.im_fixed <= (others => '0');
	data_out.re_float <= (others => '0');
	data_out.im_float <= (others => '0');
	FIXED_REAL_INSC: entity work.fixed_real_core
	generic map (	
			mode					=> mode,
			oriented				=> oriented )
	port map (	
			clk					=> clk,
			rst					=> rst,
			ce						=>	ce,
			 
			data_in_rdy			=> data_in_rdy,
			data_in				=> data_in.re_fixed,
			data_in_valid		=> data_in_valid,
		 
			cos_valid			=> cos_valid,
			cos					=> cos,
			sin_valid			=> sin_valid,
			sin					=> sin,
			data_out_valid		=> data_out_valid,
			data_out				=> data_out.re_fixed );
end generate FIXED_REAL_GEN;

FLOAT_REAL_GEN: if (data_form = "float") and (data_type = "real") generate
begin
	data_out.re_fixed <= (others => '0');
	data_out.im_fixed <= (others => '0');
	data_out.im_float <= (others => '0');
	FLOAT_REAL_INSC: entity work.float_real_core
	generic map (	
			mode					=> mode,
			oriented				=> oriented )
	port map (	
			clk					=> clk,
			rst					=> rst,
			ce						=>	ce,
		 
			data_in_rdy			=> data_in_rdy,
			data_in				=> data_in.re_float,
			data_in_valid		=> data_in_valid,
		 
			cos_valid			=> cos_valid,
			cos					=> cos,
			sin_valid			=> sin_valid,
			sin					=> sin,
			data_out_valid		=> data_out_valid,
			data_out				=> data_out.re_float );
end generate FLOAT_REAL_GEN;

FIXED_COMP_GEN: if (data_form = "fixed") and (data_type = "complex") generate
begin
	data_out.re_float <= (others => '0');
	data_out.im_float <= (others => '0');
	FIXED_COMP_INSC: entity work.fixed_comp_core
	generic map (	
			mode					=> mode,
			oriented				=> oriented )
	port map (	
			clk					=> clk,
			rst					=> rst,
			ce						=>	ce,
		 
			data_in_rdy			=> data_in_rdy,
			data_in_re			=> data_in.re_fixed,
			data_in_im			=> data_in.im_fixed,
			data_in_valid		=> data_in_valid,
		 
			cos_valid			=> cos_valid,
			cos					=> cos,
			sin_valid			=> sin_valid,
			sin					=> sin,
			data_out_valid		=> data_out_valid,
			data_out_re			=> data_out.re_fixed,
			data_out_im			=> data_out.im_fixed );
end generate FIXED_COMP_GEN;

FLOAT_COMP_GEN: if (data_form = "float") and (data_type = "complex") generate
begin
	data_out.re_fixed <= (others => '0');
	data_out.im_fixed <= (others => '0');
	FLOAT_COMP_INSC: entity work.float_comp_core
	generic map (	
			mode					=> mode,
			oriented				=> oriented )
	port map (	
			clk					=> clk,
			rst					=> rst,
			ce						=>	ce,
			 
			data_in_rdy			=> data_in_rdy,
			data_in_re			=> data_in.re_float,
			data_in_im			=> data_in.im_float,
			data_in_valid		=> data_in_valid,
		 
			cos_valid			=> cos_valid,
			cos					=> cos,
			sin_valid			=> sin_valid,
			sin					=> sin,
			data_out_valid		=> data_out_valid,
			data_out_re			=> data_out.re_float,
			data_out_im			=> data_out.im_float );
end generate FLOAT_COMP_GEN;

end Behavioral;

