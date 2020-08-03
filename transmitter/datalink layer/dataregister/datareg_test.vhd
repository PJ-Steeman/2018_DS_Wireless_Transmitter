-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY datareg_test IS
END datareg_test;

ARCHITECTURE structural OF datareg_test IS

COMPONENT datareg
	PORT
	(
		clk     	: IN std_logic;							-- clock signaal
		clk_en  	: IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	: IN std_logic;							-- reset
		load     : IN std_logic;											
		shift    : IN std_logic;
		data     : IN std_logic_vector(3 DOWNTO 0);
		sdo_posenc: OUT std_logic    	-- output
	);
END COMPONENT;

FOR uut : datareg USE ENTITY work.datareg(behavior); -- ports aan signalen verbinden
	
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL load       : std_logic;
	SIGNAL shift      : std_logic;
	SIGNAL data       : std_logic_vector(3 DOWNTO 0);
	SIGNAL sdo_posenc : std_logic;
	
BEGIN

uut: datareg PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    => clk,
      	clk_en => clk_en,
      	rst    => rst,
       data   => data,
      	load   => load,
      	shift  => shift,
      	sdo_posenc => sdo_posenc
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0))IS -- vector aanmaken
		BEGIN
		  
		  shift <= stimvect(2);
			load <= stimvect(1); 
			rst <= stimvect(0);
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		clk_en <= '1';
		data <= "1011";

		tbvector("001"); -- reset voor initialisatie
		WAIT FOR period*100;
		tbvector("010");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("010");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		tbvector("100");
		tbvector("000");
		WAIT FOR period*20;
		
		
		WAIT FOR period*20;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;



