-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY correlator_rx IS
	PORT (
		clk          	: IN  std_logic;		-- klok
		clk_en       	: IN  std_logic;		-- klok enable om kloksnelheid te verminderen
		rst          	: IN  std_logic;		-- reset
		sdi_despread 	: IN  std_logic;		-- de gedespreade sdi
		bit_sample   	: IN  std_logic;		-- het sample signaal
		chip_sample2 	: IN  std_logic;		-- het 2 clockperiodes latere chip_sample signaal
		data_out		: OUT std_logic			-- de uitgaande databit
  	 );
END correlator_rx;

ARCHITECTURE behavior OF correlator_rx IS
	SIGNAL next_count : std_logic_vector(5 DOWNTO 0) := "100000";
	SIGNAL pres_count : std_logic_vector(5 DOWNTO 0) := "100000";
BEGIN

syn_corr : PROCESS (clk)							-- synchroon deel correlator
BEGIN
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF ((rst = '1') or (bit_sample = '1'))THEN
			pres_count <= "100000";
		ELSE
			pres_count <= next_count;
		END IF;
	END IF;
END PROCESS syn_corr;

com_corr : PROCESS(bit_sample, chip_sample2, sdi_despread, pres_count)	-- asynchroon deel correlator
BEGIN

	IF (chip_sample2 = '1' AND sdi_despread = '1') THEN
		next_count <= pres_count + 1;   -- optellen
	ELSIF (chip_sample2 = '1' AND sdi_despread = '0') THEN 
		next_count <= pres_count - 1;	-- aftellen
	ELSE
		next_count <= pres_count;
	END IF;

END PROCESS com_corr;

com_bit : PROCESS(bit_sample, pres_count)
BEGIN
	IF (bit_sample = '1') THEN -- als 32 of hoger
		data_out <= pres_count(5);	-- totaal gem = 1
	END IF;
END PROCESS com_bit;
	
END behavior;