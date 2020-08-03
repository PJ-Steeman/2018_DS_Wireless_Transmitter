-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY segdec IS
	PORT
	(
		ingang    : IN std_logic_vector(3 DOWNTO 0);		-- waarde van de u/d teller
		uitgang_b : OUT std_logic_vector(6 DOWNTO 0)		-- welke "staafjes op te lichten"
	);
END segdec;

ARCHITECTURE behavior OF segdec IS
BEGIN

segdec : PROCESS (ingang)
BEGIN
	CASE ingang IS
		WHEN "0000" => uitgang_b <= "0000001"; -- '0'
		WHEN "0001" => uitgang_b <= "1001111"; -- '1'
		WHEN "0010" => uitgang_b <= "0010010"; -- '2'
		WHEN "0011" => uitgang_b <= "0000110"; -- '3'
		WHEN "0100" => uitgang_b <= "1001100"; -- '4'
		WHEN "0101" => uitgang_b <= "0100100"; -- '5'
		WHEN "0110" => uitgang_b <= "0100000"; -- '6'
		WHEN "0111" => uitgang_b <= "0001111"; -- '7'
		WHEN "1000" => uitgang_b <= "0000000"; -- '8'
		WHEN "1001" => uitgang_b <= "0000100"; -- '9'
		WHEN "1010" => uitgang_b <= "0000010"; -- 'A'
		WHEN "1011" => uitgang_b <= "1100000"; -- 'B'
		WHEN "1100" => uitgang_b <= "0110001"; -- 'C'
		WHEN "1101" => uitgang_b <= "1000010"; -- 'D'
		WHEN "1110" => uitgang_b <= "0010000"; -- 'E'
		WHEN "1111" => uitgang_b <= "0111000"; -- 'F'
		WHEN OTHERS => uitgang_b <= "0000000";
	END CASE;
END PROCESS segdec;
END behavior;
