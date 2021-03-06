-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY totaal_test IS
END totaal_test;

ARCHITECTURE structural of totaal_test is

COMPONENT totaal
   PORT 
    (
    	 clk     	 : IN std_logic;							-- clock signaal
		  rst     	   	: IN std_logic;							-- reset
		  up_knop      : IN std_logic;       -- up
	    down_knop    : IN std_logic;  -- de uitgang van de counter
		  dip		       	: IN std_logic_vector(1 DOWNTO 0);
		  disp_trans   : OUT std_logic_vector(6 DOWNTO 0);
   	  disp_rec     : OUT std_logic_vector(6 DOWNTO 0) -- de aansturing voor de 7seg display
  );
END COMPONENT;

FOR uut : totaal USE ENTITY work.totaal(behavior); -- ports aan signalen verbinden
  
	CONSTANT period   : TIME := 100 ns;
	CONSTANT delay    : TIME := 10 ns;
	SIGNAL end_of_sim : BOOLEAN := false;
	
	SIGNAL clk        : std_logic;
	SIGNAL rst        : std_logic;
	SIGNAL up_knop       : std_logic;       
	SIGNAL down_knop       : std_logic;      
	SIGNAL dip 	: std_logic_vector(1 DOWNTO 0);
	SIGNAL disp_trans   : std_logic_vector(6 DOWNTO 0); 
 	SIGNAL disp_rec : std_logic_vector(6 DOWNTO 0);

BEGIN

uut: totaal PORT MAP -- ports aan signalen verbinden met port mapping
    (
       	clk    => clk,
       	rst    => rst,
       	up_knop   => up_knop,       
	      down_knop   => down_knop,     
	      dip => dip,
	      disp_trans => disp_trans,
        disp_rec => disp_rec
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

		tbvector("01001"); -- reset voor initialisatie
		WAIT FOR period*31;
		tbvector("01100");
		tbvector("01000");
		tbvector("01100");
		tbvector("01000");
		tbvector("01100");
	  WAIT FOR period*10000;
	  tbvector("01000");
	  WAIT FOR period*10000;
	  tbvector("01100");
		tbvector("01000");
		tbvector("01100");
		tbvector("01000");
		tbvector("01100");
	  WAIT FOR period*10000;
	  tbvector("01000");
	  WAIT FOR period*10000;
	  tbvector("10100");
		tbvector("10000");
		tbvector("10100");
		tbvector("10000");
		tbvector("10100");
	  WAIT FOR period*10000;
	  tbvector("01000");
	  WAIT FOR period*10000;
		
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;