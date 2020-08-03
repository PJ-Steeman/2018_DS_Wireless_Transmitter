-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY receiverTop_rx is
  PORT 
  (
		clk     	   	: IN std_logic;							-- clock signaal
		rst     	   	: IN std_logic;							-- reset
		sdo_spread  	: IN std_logic;      					-- binnenkomend signaal (antenne) 
		dip		       	: IN std_logic_vector(1 DOWNTO 0);		-- selectie pn code
		display_b    : OUT std_logic_vector(6 DOWNTO 0) 		-- de aansturing voor de 7seg display
  );
END receiverTop_rx;

ARCHITECTURE behavior OF receiverTop_rx IS
    
    -- aanmaken van componenten om later op te roepen
    
COMPONENT apptop_rx IS
PORT
	(
		clk        	: IN std_logic;
		clk_en     	: IN std_logic;
		rst        	: IN std_logic;
		bit_sample	 : IN std_logic;
		pre_in	  	  : IN std_logic_vector(6 DOWNTO 0);
		latch_in  	 : IN std_logic_vector(3 DOWNTO 0);
		seg_display	: OUT std_logic_vector(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT shiftreg_rx IS
	PORT
	(
		clk        : IN std_logic;
		clk_en     : IN std_logic;
		rst        : IN std_logic;
		data_in    : IN std_logic;
		bit_sample : IN std_logic;
		pre	       : OUT std_logic_vector(6 DOWNTO 0); 
		latch      : OUT std_logic_vector(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT acctop_rx is
  PORT 
  (
		clk     	 	 : IN std_logic;			-- clock signaal
		clk_en  	 	 : IN std_logic;			-- clock enable om clock frequentie te verlagen
		rst     	 	 : IN std_logic;			-- reset
		sdi_spread	 : IN std_logic;
		pn_sel			   : IN std_logic_vector(1 DOWNTO 0); -- select PN code
		bit_sample		: OUT std_logic;
		databit			  : OUT std_logic

	);
END COMPONENT;

COMPONENT clkDiv_rx IS
	PORT
	(
		clk     : IN std_logic;
		rst     : IN std_logic;
		clk_en  : OUT std_logic
	);
END COMPONENT;

SIGNAL bit_sample, databit : std_logic;
SIGNAL preamble		: std_logic_vector(6 DOWNTO 0);
SIGNAL data		: std_logic_vector(3 DOWNTO 0);
SIGNAL clk_en : std_logic;

BEGIN
    -- de benodigde componenten oproepen en van port mapping de juiste signalen eraan verbinden

deler_rx : clkDiv_rx
PORT MAP(
  clk => clk,
  rst => NOT(rst),
  clk_en => clk_en
);

app_int : apptop_rx
PORT MAP(
		clk => clk,
		clk_en => clk_en,
		rst => NOT(rst),
		bit_sample	 => bit_sample,
		pre_in	  	  => preamble,
		latch_in  	 => data,
		seg_display	=> display_b
	);

dat_int : shiftreg_rx
PORT MAP(
		clk        	=> clk,
		clk_en     	=> clk_en,
		rst        	=> NOT(rst),
		data_in    	=> databit,
		bit_sample 	=> bit_sample,
		pre	   		   => preamble,
		latch      	=> data
	);

acc_int : acctop_rx
PORT MAP(
		clk     	   => clk,
		clk_en  	   => clk_en,
		rst     	   => NOT(rst),
		sdi_spread	 => sdo_spread,
		pn_sel		    => NOT(dip),
		bit_sample	 => bit_sample,
		databit		   => databit
	);

END behavior;