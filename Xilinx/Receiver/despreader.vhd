-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY despreader_rx IS
	PORT (
		clk          	: IN  std_logic;		-- klok sigaal
		clk_en       	: IN  std_logic;		-- klok enable om het kloksignaal te vertragen 
		rst          	: IN  std_logic;		-- reset
		sdi_spread   	: IN  std_logic;		-- sdi_spread signaal (ontvangen via antenne)
		pn_seq      	: IN  std_logic;		-- uitgang van de match filter
		chip_sample2   	: IN  std_logic;		-- 2 klokperiodes vertraagde schip_sample
		sdi_despread 	: OUT std_logic			-- het gedespreade (ge XOR-de) sdi signaal
    	 );
END despreader_rx;

ARCHITECTURE behavior OF despreader_rx IS
	SIGNAL pres_desp		: std_logic := '0';
	SIGNAL next_desp	: std_logic;
BEGIN

sdi_despread <= pres_desp;

syn_despread : PROCESS (clk)		-- synchroon deel despreader
BEGIN
	IF (rising_edge(clk) AND clk_en = '1' AND chip_sample2 = '1') THEN
		IF (rst = '1') THEN
			pres_desp <= '0';
		ELSE
			pres_desp <= next_desp;
		END IF;
	END IF;
END PROCESS syn_despread;

com_despread : PROCESS(pres_desp, sdi_spread, pn_seq)		-- combinatorisch deel despreader
BEGIN
    next_desp <= sdi_spread XOR pn_seq;			-- XOR van antenne signaal en match filter
END PROCESS com_despread;
END behavior;
