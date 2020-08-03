-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY latch_rx IS
	PORT (
		clk        : IN  std_logic;						-- klok
		clk_en     : IN  std_logic;						-- klok enable om kloksnelheid te vertragen
		rst        : IN  std_logic;						-- reset
		bit_sample : IN  std_logic;						-- wanneer men mag sampelen
		pre	   : IN  std_logic_vector(6 DOWNTO 0);		-- preamble waarde
		latch_in   : IN  std_logic_vector(3 DOWNTO 0); 	-- data in
		latch_out  : OUT std_logic_vector(3 DOWNTO 0) := "0000"	-- data out
    );
END latch_rx;

ARCHITECTURE behavior OF latch_rx IS
	CONSTANT preamble: std_logic_vector(6 DOWNTO 0) := "0111110";
BEGIN

com_latch : PROCESS(pre, latch_in)							-- asynchroon deel latch
BEGIN
	IF (pre = preamble) THEN
		latch_out <= latch_in;
	END IF;
END PROCESS com_latch;
END behavior;