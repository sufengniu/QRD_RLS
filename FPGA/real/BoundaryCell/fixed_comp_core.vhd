----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:26:13 03/19/2013 
-- Design Name: 
-- Module Name:    FIXED_COMP_INSC - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fixed_comp_core is
    Generic (	
			mode					: string := "streaming";		-- streaming/burst: streaming data need more area and power.
																			-- consumption
			oriented				: string := "throughput");		-- throughput/latency, throughput and latency are tradeoff,
																			-- throughput oriented will provide high speed clock rate
																			-- latency oriented will provide low circuit latency
																			-- low performance: power saving, slow speed and small area.
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ce : in  STD_LOGIC);
end Ffixed_comp_core;

architecture Structure of fixed_comp_core is

begin


end Structure;

