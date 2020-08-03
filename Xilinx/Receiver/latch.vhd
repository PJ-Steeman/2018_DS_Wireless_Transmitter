-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY latch_rx IS
	PORT (
		clk        : IN  std_logic;
		clk_en     : IN  std_logic;
		rst        : IN  std_logic;
		bit_sample : IN  std_logic;						-- wanneer men mag sampelen
		pre	   : IN  std_logic_vector(6 DOWNTO 0);		-- preamble waarde
		latch_in   : IN  std_logic_vector(3 DOWNTO 0); 	-- data in
		latch_out  : OUT std_logic_vector(3 DOWNTO 0) := "0000"	-- data out
    );
END latch_rx;

ARCHITECTURE behavior OF latch_rx IS
	CONSTANT preamble: std_logic_vector(6 DOWNTO 0) := "0111110";
	SIGNAL pres_latch, next_latch : std_logic_vector(3 DOWNTO 0);
BEGIN

latch_out <= pres_latch;

syn_latch : PROCESS(clk)
BEGIN
	IF (rising_edge(clk) AND clk_en = '1' AND bit_sample = '1') THEN
		IF (rst = '1') THEN
			pres_latch <= (OTHERS => '0');
		ELSE
			pres_latch <= next_latch;
		END IF;
	END IF;
END PROCESS syn_latch;

com_latch : PROCESS(bit_sample, pre, latch_in)
BEGIN
	IF (pre = preamble) THEN
		next_latch <= latch_in;
	ELSE
		next_latch <= pres_latch;
	END IF;
END PROCESS com_latch;
END behavior;