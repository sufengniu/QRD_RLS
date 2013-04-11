----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
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

use IEEE.fixed_float_types.all;
use IEEE.fixed_pkg.all;
use IEEE.float_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.QRD_RLS_pkg.all;

entity InternalCell is
	Generic ( 
			platform			: string := "FPGA";		-- FPGA/ASIC
			data_type			: string := "real";		-- real/complex 
			data_form			: string := "fixed";		-- fixed/floating
			mode				: string := "streaming";	-- streaming/burst: streaming data need more area and power.
											-- consumption
			oriented			: string := "throughput";	-- throughput/latency, throughput and latency are tradeoff,
											-- throughput oriented will provide high speed clock rate
											-- latency oriented will provide low circuit latency
			arch				: string := "unfolded"		-- folded/unfolded: folded can be used for larger matrix size.
			 );
	Port ( 
			clk 				: in	STD_LOGIC;
			rst 				: in	STD_LOGIC;
			ce 				: in	STD_LOGIC;
			 
			data_in_rdy			: out	STD_LOGIC;
			data_in				: in	work.QRD_RLS_pkg.DATA_TYPE;
			data_in_valid			: in	STD_LOGIC;
			
			cos_valid 			: out	STD_LOGIC;
			cos				: out	sfixed (WIDTH_COS-1 downto 0);
			sin_valid 			: out	STD_LOGIC;
			sin 				: out	sfixed (WIDTH_SIN-1 downto 0);
			data_out_valid			: out	STD_LOGIC;
			data_out			: out	work.QRD_RLS_pkg.DATA_TYPE);
end InternalCell;

architecture Behavioral of InternalCell is

begin

INTER_GEN: if (data_form = "fixed") and (data_type = "real") generate	
		data_out.im <= (others => '0');
		FIXED_REAL_INSC: entity work.fixed_real_core
		generic map (	
				mode			=> mode,
				oriented		=> oriented )
		port map(	
				clk			=> clk,
				rst			=> rst,
				ce			=> ce,
			 
				data_in_rdy		=> data_in_rdy,
				data_in			=> data_in.re,
				data_in_valid		=> data_in_valid,
			 
				cos_valid		=> cos_valid,
				cos			=> cos,
				sin_valid		=> sin_valid,
				sin			=> sin,
				data_out_valid		=> data_out_valid,
				data_out		=> data_out.re );
elsif (data_form = "float") and (data_type = "real") generate
		data_out.im <= (others => '0');
		FLOAT_REAL_INSC: entity work.float_real_core
		generic map (	
				mode			=> mode,
				oriented		=> oriented )
		port map(	
				clk			=> clk,
				rst			=> rst,
				ce			=> ce,
			 
				data_in_rdy		=> data_in_rdy,
				data_in			=> data_in.re,
				data_in_valid		=> data_in_valid,
			 
				cos_valid		=> cos_valid,
				cos			=> cos,
				sin_valid		=> sin_valid,
				sin			=> sin,
				data_out_valid		=> data_out_valid,
				data_out		=> data_out.re );

elsif (data_form = "fixed") and (data_type = "complex") generate
		FIXED_COMP_INSC: entity work.fixed_comp_core
		generic map (	
				mode			=> mode,
				oriented		=> oriented )
		port map(	
				clk			=> clk,
				rst			=> rst,
				ce			=> ce,
			 
				data_in_rdy		=> data_in_rdy,
				data_in			=> data_in,
				data_in_valid		=> data_in_valid,
			 
				cos_valid		=> cos_valid,
				cos			=> cos,
				sin_valid		=> sin_valid,
				sin			=> sin,
				data_out_valid		=> data_out_valid,
				data_out		=> data_out );

elsif (data_form = "float") and (data_type = "complex") generate

		FLOAT_COMP_INSC: entity work.float_comp_core
		generic map (	
				mode			=> mode,
				oriented		=> oriented )
		port map(	
				clk			=> clk,
				rst			=> rst,
				ce			=> ce,
			 
				data_in_rdy		=> data_in_rdy,
				data_in			=> data_in,
				data_in_valid		=> data_in_valid,
			 
				cos_valid		=> cos_valid,
				cos			=> cos,
				sin_valid		=> sin_valid,
				sin			=> sin,
				data_out_valid		=> data_out_valid,
				data_out		=> data_out );
	--end;
end generate BOUND_GEN;

end Behavioral;

