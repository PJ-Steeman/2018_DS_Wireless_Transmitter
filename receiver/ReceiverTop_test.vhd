-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY receiverTop_rx_test IS
END receiverTop_rx_test;

ARCHITECTURE structural of receiverTop_rx_test is

COMPONENT receiverTop_rx
   PORT 
    (
		clk     	   	: IN std_logic;							-- clock signaal
		rst     	   	: IN std_logic;							-- reset
		sdo_spread  	: IN std_logic;       -- up
		dip		       	: IN std_logic_vector(1 DOWNTO 0);
   	display_b    : OUT std_logic_vector(6 DOWNTO 0) -- de aansturing voor de 7seg display
  );
END COMPONENT;

FOR uut : receiverTop_rx USE ENTITY work.receiverTop_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten
  
	CONSTANT period    : TIME := 100 ns;
	CONSTANT delay     : TIME := 10 ns;
	SIGNAL end_of_sim  : BOOLEAN := false;
	
	SIGNAL clk         : std_logic;
	SIGNAL rst         : std_logic;
	SIGNAL sdo_spread  : std_logic;       
	SIGNAL dip         : std_logic_vector(1 DOWNTO 0); -- select PN code;   
	SIGNAL display_b   : std_logic_vector(6 DOWNTO 0);   
	
BEGIN

uut: receiverTop_rx PORT MAP -- ports aan signalen verbinden met port mapping
    (
 	    clk    => clk,
    	 rst    => rst,
	    sdo_spread   => sdo_spread,       
	    dip   => dip,     
	    display_b => display_b
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

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(3 DOWNTO 0))IS -- test vector aanmaken
		BEGIN
			sdo_spread <= stimvect(3);
			dip(1) <= stimvect(2);    -- inputs "linken" met de vector
			dip(0) <= stimvect(1); 
			rst <= stimvect(0);
      
			WAIT FOR period;
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen
		tbvector("0001"); -- reset voor initialisatie
		FOR i IN 0 TO 1 LOOP
		WAIT FOR period*5;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*63;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*47;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*31;
		tbvector("0010");
		WAIT FOR period*47;
		tbvector("1010");
		WAIT FOR period*79;
		tbvector("0010");
		WAIT FOR period*31;
		tbvector("1010");
		WAIT FOR period*31;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		END LOOP;
		
		FOR i IN 0 TO 4 LOOP
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*63;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*47;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*31;
		tbvector("1010");
		WAIT FOR period*47;
		tbvector("0010");
		WAIT FOR period*79;
		tbvector("1010");
		WAIT FOR period*31;
		tbvector("0010");
		WAIT FOR period*31;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		END LOOP;
		
		FOR i IN 0 TO 2 LOOP
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*63;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*47;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*31;
		tbvector("0010");
		WAIT FOR period*47;
		tbvector("1010");
		WAIT FOR period*79;
		tbvector("0010");
		WAIT FOR period*31;
		tbvector("1010");
		WAIT FOR period*31;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		END LOOP;
		
		FOR i IN 0 TO 4 LOOP
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*63;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*47;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*31;
		tbvector("1010");
		WAIT FOR period*47;
		tbvector("0010");
		WAIT FOR period*79;
		tbvector("1010");
		WAIT FOR period*31;
		tbvector("0010");
		WAIT FOR period*31;
		tbvector("1010");
		WAIT FOR period*15;
		tbvector("0010");
		WAIT FOR period*15;
		tbvector("1010");
		WAIT FOR period*15;
		END LOOP;

		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;