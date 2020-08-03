-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mux_rx_test IS
END mux_rx_test;

ARCHITECTURE structural OF mux_rx_test IS

COMPONENT mux_rx_test  -- component declaratie
	PORT
	(
		in0, in1, in2, in3  	: IN std_logic;
		sel		               	: IN std_logic_vector(1 DOWNTO 0);
		sdo_spread           	: OUT std_logic
	);
END COMPONENT;

FOR uut : mux_rx_test USE ENTITY work.mux_rx(behavior); -- signalen aanmaken die overeenkomen met de poorten
  	
 	SIGNAL end_of_sim 				: BOOLEAN := false;
 	CONSTANT period   				: TIME := 100 ns;
 	
	SIGNAL in0, in1, in2, in3     	: std_logic;
	SIGNAL sel     					: std_logic_vector(1 DOWNTO 0);
	SIGNAL sdo_spread	 			: std_logic;
	
BEGIN

uut: mux_rx_test PORT MAP -- ports aan signalen verbinden met port mapping
    (
      	in0   		=> in0,
      	in1 		=> in1,
      	in2   		=> in2,
      	in3 		=> in3,
      	sel 		=> sel,
		sdo_spread	=> sdo_spread
    );

tb : PROCESS -- testbench

	PROCEDURE tbvector(CONSTANT stimvect : IN std_logic_vector(5 DOWNTO 0))IS -- test vector aanmaken
		BEGIN
			in0 <= stimvect(0); -- inputs "linken" met de vector
			in1 <= stimvect(1);
			in2 <= stimvect(2);
			in3 <= stimvect(3);
			sel(0) <= stimvect(4);
			sel(1) <= stimvect(5);
      
	END tbvector;
	BEGIN	-- verschillende mogelijke scenario's aflopen

		tbvector("000101");
		WAIT FOR period;
		tbvector("010101");
		WAIT FOR period;
		tbvector("100101");
		WAIT FOR period;
		tbvector("110101");
		WAIT FOR period;
      
		end_of_sim <= true;
		WAIT;

	END PROCESS;
END;
