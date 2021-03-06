-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY shiftreg_rx IS
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
	END;

ARCHITECTURE behavior OF shiftreg_rx IS
	SIGNAL pres_data	: std_logic_vector(10 DOWNTO 0) := (OTHERS => '0');
	SIGNAL next_data	: std_logic_vector(10 DOWNTO 0) := (OTHERS => '0');
BEGIN

pre <= pres_data(10 DOWNTO 4);
latch <= pres_data(3 DOWNTO 0);

syn_shiftreg : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF (rst = '1') THEN
			pres_data <= (OTHERS => '0');
		ELSE
			pres_data <= next_data;
		END IF;
	END IF;
END PROCESS syn_shiftreg;

com_shiftreg : PROCESS (pres_data, data_in, bit_sample)
BEGIN
  IF (bit_sample = '1') THEN
	     next_data <=  pres_data(9 DOWNTO 0) & data_in;
	ELSE
	     next_data <= pres_data;
	 END IF;
END PROCESS com_shiftreg;
END behavior;
