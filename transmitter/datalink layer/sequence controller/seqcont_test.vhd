-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY seqcont_test IS
END seqcont_test;

ARCHITECTURE structural OF seqcont_test IS

COMPONENT seqcont
	PORT
	(
		clk     	: IN std_logic;							-- clock signaal
		clk_en  	: IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	: IN std_logic;							-- reset
		pn_start : IN std_logic;							
		load 	   : OUT std_logic;						
		shift    : OUT std_logic		-- output
	);
END COMPONENT;

FOR uut : seqcont USE ENTITY work.seqcont(behavior); -- ports aan signalen verbinden
	
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL pn_start   : std_logic;
	SIGNAL load       : std_logic;
	SIGNAL shift      : std_logic;
	
BEGIN

uut: seqcont PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    => clk,
      	clk_en => clk_en,
      	rst    => rst,
      	pn_start    => pn_start,
      	load => load,
      	shift => shift
    );

clock : PROCESS -- kloksignaal voor de synchrone elementen
	BEGIN
    	clk <= '0';
    	WAIT FOR period/2;
    	LOOP
			clk <= '0';
			WAIT FOR period/2;
			clk <= '1';
			WAIT FOR period/2;
			EXIT WHEN end_of_sim;
		END LOOP;
	WAIT;
  END PROCESS clock;

tb : PROCESS -- testbench

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0))IS -- vector aanmaken
		BEGIN
			pn_start <= stimvect(1); -- inputs "linken" met de vector
			rst <= stimvect(0);
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';

		tbvector("01"); -- reset voor initialisatie
		WAIT FOR period*100;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*31;
		
		WAIT FOR period*20;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
