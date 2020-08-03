-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mux_rx IS
	PORT
	(
		in0, in1, in2, in3  	: IN std_logic;						-- inputs van de multiplexer
		sel		        : IN std_logic_vector(1 DOWNTO 0);			-- select signaal
		sdo_spread           	: OUT std_logic						-- output
	);
END mux_rx;

ARCHITECTURE behavior OF mux_rx IS	
BEGIN													
multiplex : PROCESS (in0, in1, in2, in3, sel)
BEGIN
	CASE sel IS				-- afhankelijk van het select signaal wordt 1 van de 4 ingangen verbonden met de uitgang
		WHEN "00" => sdo_spread  <= in0;
		WHEN "01" => sdo_spread  <= in1;
		WHEN "10" => sdo_spread  <= in2;
		WHEN "11" => sdo_spread  <= in3;
		WHEN OTHERS => sdo_spread <= in0;		-- indien het ingangsignaal undefined is zal de eerste ingang gekoze worden
	END CASE;
END PROCESS multiplex;
END behavior;