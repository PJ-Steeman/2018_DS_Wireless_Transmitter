-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY datatop_test IS
END datatop_test;

ARCHITECTURE structural of datatop_test is

COMPONENT datatop
    PORT 
  (
    clk     	 : IN std_logic;							-- clock signaal
		clk_en  	 : IN std_logic;							-- clock enable om clock frequentie te verlagen
		rst     	 : IN std_logic;							-- reset
		pn_start  : IN std_logic;       -- up
		data      : IN std_logic_vector(3 DOWNTO 0);  -- de uitgang van de counter
    sdo_posenc: OUT std_logic -- de aansturing voor de 7seg display
  );
END COMPONENT;

FOR uut : datatop USE ENTITY work.datatop(behavior); -- ports aan signalen verbinden
  
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL clk_en     : std_logic;
	SIGNAL rst        : std_logic;
  SIGNAL data       : std_logic_vector(3 DOWNTO 0);      
	SIGNAL	sdo_posenc : std_logic;
	SIGNAL	pn_start   : std_logic; 
  
  SIGNAL load_int, shift_int : std_logic;

BEGIN

uut: datatop PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	clk    => clk,
      	clk_en => clk_en,
      	rst    => rst,   
	     sdo_posenc => sdo_posenc,
	     pn_start => pn_start,
       data => data
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
			pn_start <= stimvect(1); 
			rst <= stimvect(0);
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen
    clk_en <= '1';
    data <= "1011";

		tbvector("01"); -- reset voor initialisatie
		WAIT FOR period;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		tbvector("10");
		tbvector("00");
		WAIT FOR period*5;
		
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;