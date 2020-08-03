-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY transmitterTop_test IS
END transmitterTop_test;

ARCHITECTURE structural of transmitterTop_test is

COMPONENT transmitterTop
   PORT 
    (
    	clk     	: IN std_logic;							-- clock signaal
	   rst     	: IN std_logic;							-- reset
	   up_knop        	: IN std_logic;       -- up
	   down_knop      	: IN std_logic;  -- de uitgang van de counter
	   dip		: IN std_logic_vector(1 DOWNTO 0);
    	dec_uit       	: OUT std_logic_vector(6 DOWNTO 0); -- de aansturing voor de 7seg display
	   sdo_spread	: OUT std_logic
  );
END COMPONENT;

FOR uut : transmitterTop USE ENTITY work.transmitterTop(behavior); -- ports aan signalen verbinden
  
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL up_knop       : std_logic;       
	SIGNAL down_knop       : std_logic;      
	SIGNAL dip 	: std_logic_vector(1 DOWNTO 0);
	SIGNAL dec_uit   : std_logic_vector(6 DOWNTO 0); 
 	SIGNAL sdo_spread : std_logic;

BEGIN

uut: transmitterTop PORT MAP -- ports aan signalen verbinden met port mapping
    (
       	clk    => clk,
       	rst    => rst,
       	up_knop   => up_knop,       
	      down_knop   => down_knop,     
	      dip => dip,
	      dec_uit => dec_uit,
        sdo_spread => sdo_spread
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(4 DOWNTO 0))IS -- vector aanmaken
		BEGIN
		  
		  dip <= stimvect(4 DOWNTO 3);
		  up_knop <= stimvect(2);    -- inputs "linken" met de vector
		  down_knop <= stimvect(1); 
		  rst <= stimvect(0);
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		tbvector("00001"); -- reset voor initialisatie
		WAIT FOR period;
		tbvector("00100");
		tbvector("00000");
		tbvector("00100");
		tbvector("00000");
		tbvector("00100");
		WAIT FOR period*100;
		tbvector("00000");
		WAIT FOR period*1000;
		tbvector("00100");
		WAIT FOR period*100;
		tbvector("00000");
		WAIT FOR period*1000;
		tbvector("00100");
		WAIT FOR period*100;
		tbvector("00000");
		WAIT FOR period*1000;
		tbvector("01000");
		WAIT FOR period*100;
		tbvector("10000");
		WAIT FOR period*100;
		tbvector("11000");
		WAIT FOR period*100;
		
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;