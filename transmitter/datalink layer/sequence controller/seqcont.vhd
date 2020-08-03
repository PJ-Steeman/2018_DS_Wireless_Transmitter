-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY seqcont IS
	PORT
	(
		clk     	: IN std_logic;							-- clock signaal
		clk_en  	: IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	: IN std_logic;							-- reset
		pn_start : IN std_logic;							
		load 	   : OUT std_logic;						
		shift    : OUT std_logic		-- output
	);
END seqcont;

ARCHITECTURE behavior OF seqcont IS
		 SIGNAL next_count : std_logic_vector(3 DOWNTO 0);
	   SIGNAL pres_count : std_logic_vector(3 DOWNTO 0);
	   SIGNAL next_load : std_logic;
	   SIGNAL next_shift : std_logic;
BEGIN
  
syn_seq : PROCESS (clk)
BEGIN
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF (rst = '1') THEN
			pres_count <= "1010";
			load <= '0';
      shift <= '0';
		ELSE 
			pres_count <= next_count;
			load <= next_load;
			shift <= next_shift;
		END IF;
	END IF;
END PROCESS syn_seq;

com_sec : PROCESS (pres_count, pn_start)
BEGIN
	IF pres_count = "1010" AND pn_start = '1' THEN
		next_count <= "0000";
		next_load <= '1';
  		next_shift <= '0';
	ELSIF pn_start = '1' THEN
		next_count <= pres_count + 1;
		next_load <= '0';
  		next_shift <= '1';
	ELSE
		next_load <= '0';
    next_shift <= '0';
		next_count <= pres_count; 
	END IF;
END PROCESS com_sec;
END behavior;
