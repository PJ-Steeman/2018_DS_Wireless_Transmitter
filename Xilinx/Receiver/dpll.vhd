-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY dpll_rx IS
  PORT (
		  clk          	: IN  std_logic;		-- clock signaal
		  clk_en       	: IN  std_logic;		-- clock enable om het klok signaal eventueel te vertragen
		  rst          	: IN  std_logic;		-- reset
		  sdi_spread   	: IN  std_logic;		-- inkomend signaal (via antenne)
		  chip_sample  	: OUT std_logic;		-- signaal om de zender en ontvanger te syncen
		  chip_sample1 	: OUT std_logic;
		  chip_sample2 	: OUT std_logic;
		  extb_out     	: OUT std_logic			-- duid begin van nieuw signaal over antenne aan
  	 );
END dpll_rx;


ARCHITECTURE behavior OF dpll_rx IS
	SIGNAL extb : std_logic;
	TYPE state_det IS (w0, w1, p1, p0);
	SIGNAL pres_state_det, next_state_det	: state_det;
	
	SIGNAL next_count_dec : std_logic_vector(3 DOWNTO 0);
	SIGNAL pres_count_dec : std_logic_vector(3 DOWNTO 0);
	SIGNAL segment_in : std_logic_vector(4 DOWNTO 0);
	
	TYPE state_sema IS (wEXTB, wCS);
	SIGNAL chip_sample_int, chip_sample1_int, chip_sample2_int  : std_logic;
	
	SIGNAL pres_state_sema, next_state_sema	: state_sema;
	SIGNAL segment_out : std_logic_vector(4 DOWNTO 0);
	
	SIGNAL next_count_dec2 : std_logic_vector(4 DOWNTO 0);
	SIGNAL pres_count_dec2 : std_logic_vector(4 DOWNTO 0);
	
	SIGNAL count_dec : std_logic_vector(4 DOWNTO 0);
	
	
BEGIN

extb_out <= extb;
chip_sample <= chip_sample_int;
chip_sample1 <= chip_sample1_int;
chip_sample2 <= chip_sample2_int;

syn_trans_det : PROCESS(clk)						-- synchroon deel van de trans. det.
BEGIN												-- detetcteert verandering van sdi_spread signaal
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF (rst = '1') THEN
			pres_state_det <= w1;
		ELSE
			pres_state_det <= next_state_det;
		END IF;
	END IF;
END PROCESS syn_trans_det;


com_trans_det : PROCESS(pres_state_det, sdi_spread)
BEGIN

CASE pres_state_det IS								-- asynchroon deel van de trans.det.

	WHEN w0 => extb <= '0';
		IF (sdi_spread = '0') THEN
			next_state_det <= p0;
		ELSE
			next_state_det <= w0;
		END IF;

	WHEN p0 => extb <= '1';
		IF (sdi_spread = '1') THEN
			next_state_det <= p1;
		ELSE
			next_state_det <= w1;
		END IF;  

	WHEN p1 => extb <= '1';
		IF (sdi_spread = '0') THEN
			next_state_det <= p0;
		ELSE
			next_state_det <= w0;
		END IF; 

	WHEN w1 => extb <= '0';
		IF (sdi_spread = '1') THEN
			next_state_det <= p1;
		ELSE
			next_state_det <= w1;
		END IF;  

	WHEN OTHERS => extb <= '0';
		next_state_det <= w0;
END CASE;
END PROCESS com_trans_det;

syn_count1: PROCESS(clk)								-- synchroon deel counter
BEGIN													-- bepaald op welke timing een signaal plaatsvindt
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF (rst = '1') THEN
			pres_count_dec <= (OTHERS => '0');
		ELSE  
			pres_count_dec <= next_count_dec;
		END IF;
	END IF;
END PROCESS syn_count1;

com_count1: PROCESS(pres_count_dec, extb)				-- asynchroon deel counter
BEGIN
	IF (extb = '0') THEN
		IF pres_count_dec = "1111" THEN
			next_count_dec <= pres_count_dec;
		ELSE
			next_count_dec <= pres_count_dec + 1;
		END IF;
	ELSE 
			next_count_dec <= (OTHERS => '0');
	END IF;
END PROCESS com_count1;

com_dec1: PROCESS(pres_count_dec)						-- decoder
BEGIN													-- zet afhakleijk van de timing van het signaal een segment hoog
	IF (pres_count_dec <= "0100") THEN
		segment_in <= "10000";
	ELSIF (pres_count_dec <= "0110") THEN
		segment_in <= "01000";
	ELSIF (pres_count_dec <= "1000") THEN
		segment_in <= "00100";
	ELSIF (pres_count_dec <= "1010") THEN
		segment_in <= "00010";
	ELSIF (pres_count_dec <= "1111") THEN
		segment_in <= "00001";
	ELSE
		segment_in <= "00100";
	END IF;
END PROCESS com_dec1;

syn_sema: PROCESS(clk)									-- synchroon deel semaphore
BEGIN													-- gebruikt om het signaal te vertragen of te vervroegen
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF (rst = '1') THEN 
			pres_state_sema <= wEXTB;
		ELSE
			pres_state_sema <= next_state_sema;
		END IF;
	END IF;
END PROCESS syn_sema;

com_sema: PROCESS(pres_state_sema, extb, chip_sample1_int, segment_in)
BEGIN

CASE pres_state_sema IS									-- asynchroon deel semaphore

	WHEN wEXTB => segment_out <= "00100";
		IF (extb = '1') THEN
			next_state_sema <= wCS;
		ELSE
			next_state_sema <= wEXTB;
		END IF;

	WHEN wCS => segment_out <= segment_in;
		IF (chip_sample1_int = '1') THEN
			next_state_sema <= wEXTB;
		ELSE
			next_state_sema <= wCS;
		END IF;  

	WHEN OTHERS => next_state_sema <= wEXTB;
		next_state_sema <= wEXTB;
END CASE;
END PROCESS com_sema;

com_dec2: PROCESS(segment_out)
BEGIN
	IF (segment_out = "10000") THEN
		count_dec <= "10010";
	ELSIF (segment_out = "01000") THEN
		count_dec <= "10000";
	ELSIF (segment_out = "00100") THEN
		count_dec <= "01111";
	ELSIF (segment_out = "00010") THEN
		count_dec <= "01110";
	ELSIF (segment_out = "00001") THEN
		count_dec <= "01100";
	ELSE
		count_dec <= "01111";
	END IF;
END PROCESS com_dec2;

syn_count2: PROCESS(clk)							-- synchroon deel teller
BEGIN												-- hier worden de chip_sample's hoog gezet
	IF (rising_edge(clk) AND clk_en = '1') THEN
		IF (rst = '1') THEN
			pres_count_dec2 <= "01111";
			chip_sample1_int <= '0';
			chip_sample2_int <= '0';
		ELSE  
			pres_count_dec2 <= next_count_dec2;
			IF(chip_sample_int = '1') THEN
				chip_sample1_int <= '1';
			ELSIF(chip_sample1_int = '1') THEN
				chip_sample2_int <= '1';
				chip_sample1_int <= '0';
			ELSIF(chip_sample2_int = '1') THEN
				chip_sample2_int <= '0';
			END IF;
		END IF;
	END IF;
END PROCESS syn_count2;

com_count2: PROCESS(pres_count_dec2, count_dec)		-- asynchroon deel teller
BEGIN
	IF (pres_count_dec2 = 0) THEN
		next_count_dec2 <= count_dec;
		chip_sample_int <= '0';
	ELSIF (pres_count_dec2 = 1) THEN
		next_count_dec2 <= pres_count_dec2 - 1;
		chip_sample_int <= '1';
	ELSE
		next_count_dec2 <= pres_count_dec2 - 1;
		chip_sample_int <= '0';
	END IF;
END PROCESS com_count2;

END behavior;