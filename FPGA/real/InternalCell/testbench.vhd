-- TestBench Template 

LIBRARY std;
USE std.textio.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.all;

library work;
USE work.QRD_RLS_pkg.all;

ENTITY testbench IS
	Generic (
			INVEC    : string  := "test_vector.txt";
			OUTVEC   : string  := "res_vector.txt");
END testbench;

ARCHITECTURE behavior OF testbench IS 

-- Fill and export rams
   impure function fill_ram (filename : in string) return din_t is                 
      FILE ram_file					: text;                       
      variable ram_line				: line;
      variable vector_input		: real;      
      variable ram					: din_t;  
   begin
      file_open(ram_file, filename, READ_MODE);
      report "Filling RAM from file" severity note;
      for I in 0 to VECTOR_LENGTH-1 loop                                  
         readline (ram_file, ram_line);                             
         read (ram_line, vector_input);
         ram(I) := STD_LOGIC_VECTOR(TO_SIGNED(integer(vector_input*(2.0**FW_IN)),work.newton_pkg.WIDTH_IN));
      end loop;   
		report "Filling RAM from file, done" severity note;
      file_close(ram_file);                                                 
      return ram;                                                  
   end function;
   
   procedure export_ram ( filename : in string; ram : dout_t) is
      FILE out_file					: text;
      variable ram_line				: line;
      variable int_v					: real;
      --variable seperator			: string(1 downto 0) := ", ";
      --variable closing			: string(1 downto 0) := "*i";
   begin
      file_open(out_file, filename, WRITE_MODE);
      report "Dumping Ram to file" severity note;
      for I in 0 to VECTOR_LENGTH-1 loop
		
			int_v := real(to_integer(signed(ram(I))))/real(2.0**FW_OUT);

         write(ram_line, int_v);
         --write(ram_line, seperator);
         --write(ram_line, int_v2);
         --write(ram_line, closing);
         writeline (out_file, ram_line);
      end loop;
      file_close(out_file);
   end procedure;

  -- Component Declaration
COMPONENT InternalCell
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
         data_in				: in	STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0);
         data_in_valid		: in	STD_LOGIC;
          
			cos_valid 			: out	STD_LOGIC;
         cos 					: out	STD_LOGIC_VECTOR (WIDTH_COS-1 downto 0);
         sin_valid 			: out	STD_LOGIC;
         sin 					: out	STD_LOGIC_VECTOR (WIDTH_SIN-1 downto 0);
			data_out_valid		: out	STD_LOGIC;
			data_out				: out	STD_LOGIC_VECTOR (WIDTH_OUT-1 downto 0));
END COMPONENT;

SIGNAL clk	         :  std_logic;
SIGNAL rst	         :  std_logic;
SIGNAL ce				:  std_logic;
signal DataOutValid	:  std_logic;
SIGNAL DataIn			:  std_logic_vector(WIDTH_IN-1 downto 0);
SIGNAL DataOut			:  std_logic_vector(WIDTH_OUT-1 downto 0);

signal DataInRam		: din_t;
signal DataOutRam		: dout_t;

constant clk_period	: time := 10 ns;
constant UNLOAD_CYCLES : integer := VECTOR_LENGTH-1;

BEGIN

-- Clock process definitions
   clk_process: process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process; 

  -- Component Instantiation
uut: BoundaryCell 
	Generic map( 
			platform				=> platform,
			data_type			=> data_type,
			data_form			=> data_form,
			mode					=> mode,
			oriented				=> oriented,
			arch					=> arch
			 )
	Port map( 
			clk 					=> clk,
         rst 					=> rst,
         ce 					=> ce,
			 
         data_in_rdy			=> data_in_rdy,
         data_in				=> data_in,
         data_in_valid		=> data_in_valid,
          
			cos_valid 			=> cos_valid,
         cos 					=> cos,
         sin_valid 			=> sin_valid,
         sin 					=> sin,
			data_out_valid		=> data_out_valid,
			data_out				=> data_out );

  --  Test Bench Statements
   tb_read : PROCESS
   BEGIN
      report "Starting test bench";
		DataIn <= (others => '0');
		rst <= '1';
      ce <= '0';
		wait for 100 ns;
		DataInRam <= (others => (others => '0'));
		rst <= '0';
		ce <= '1';
		
      DataInRam <= fill_ram(INVEC);
		  
		for i in 0 to VECTOR_LENGTH-1 loop
		   wait until rising_edge(clk);
			DataIn <= DataInRam(i);
		end loop;
		wait for clk_period;
		ce <= '0';
		  
      wait; -- will wait forever
   END PROCESS tb_read;
   
   tb_write : PROCESS
   BEGIN
		
      for j in 0 to VECTOR_LENGTH-1 loop
        wait until DataOutValid = '1' and rising_edge(clk);
		  DataOutRam(j) <= DataOut;
      end loop;
      
      export_ram(OUTVEC, DataOutRam);
        
   END PROCESS tb_write;
   
   --  End Test Bench  

  END;
