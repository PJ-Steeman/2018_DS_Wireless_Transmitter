-- Pieter-Jan Steeman

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY acctop_rx is
  PORT 
  (
		clk     	 	: IN std_logic;			-- clock signaal
		clk_en  	 	: IN std_logic;			-- clock enable om clock frequentie te verlagen
		rst     	 	: IN std_logic;			-- reset
		sdi_spread		: IN std_logic;			-- sdi_spread signaal (ontvangen via antenne)
		pn_sel			: IN std_logic_vector(1 DOWNTO 0); -- select PN code
		bit_sample		: OUT std_logic;		-- wanneer men mag sampelen
		databit			: OUT std_logic			-- uitgaande databit
  );
END acctop_rx;

ARCHITECTURE behavior OF acctop_rx IS
        
COMPONENT correlator_rx IS
	PORT (
		clk          	: IN  std_logic;		-- klok
		clk_en       	: IN  std_logic;		-- klok enable om kloksnelheid te verminderen
		rst          	: IN  std_logic;		-- reset
		sdi_despread 	: IN  std_logic;
		bit_sample   	: IN  std_logic;
		chip_sample2 	: IN  std_logic;
		data_out	: OUT std_logic
  	 );
END COMPONENT;

COMPONENT despreader_rx IS
	PORT (
		clk          : IN  std_logic;
		clk_en       : IN  std_logic;
		rst          : IN  std_logic;
		sdi_spread   : IN  std_logic;
		pn_seq      : IN  std_logic;
		chip_sample2   : IN  std_logic;
		sdi_despread : OUT std_logic
    	 );
END COMPONENT;

COMPONENT dpll_rx IS
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
END COMPONENT;

COMPONENT mfilter_rx IS
	PORT
	(
		clk         : IN std_logic;
		clk_en      : IN std_logic;
		rst         : IN std_logic;
		sdi_spread  : IN std_logic;
		chip_sample  : IN std_logic;
		sel_pn    : IN std_logic_vector(1 DOWNTO 0);
		seq_det     : OUT std_logic
	);
END COMPONENT;

COMPONENT pngen_rx IS
	PORT
	(
		clk        	: IN std_logic;
		clk_en     	: IN std_logic;
		rst        	: IN std_logic;
		seq_det    	: IN std_logic;
		chip_sample1	: IN std_logic;
		bit_sample  	: OUT std_logic;
		pn_ml1      	: OUT std_logic;
		pn_ml2       	: OUT std_logic;
		pn_gold      	: OUT std_logic
	);
END COMPONENT;

COMPONENT mux_rx IS
	PORT
	(
		in0, in1, in2, in3  	: IN std_logic;						-- inputs van de multiplexer
		sel		        : IN std_logic_vector(1 DOWNTO 0);			-- select signaal
		sdo_spread           	: OUT std_logic						-- output
	);
END COMPONENT;

COMPONENT edgedetector_rx IS
	PORT
	(
		clk     : IN std_logic;		-- clock signaal
		clk_en  : IN std_logic;		-- clock enable om clock frequentie te verlagen
		rst     : IN std_logic;		-- reset
		ingang  : IN std_logic; 	-- input
		uitgang : OUT std_logic  	-- output
	);
END COMPONENT;

SIGNAL b_s, b_s_edge : std_logic := '0';
SIGNAL chip_sample, chip_sample1, chip_sample2	: std_logic := '1';
SIGNAL pn_ml1, pn_ml2, pn_gold, pn_seq : std_logic;
SIGNAL match_out, desp_out : std_logic;
SIGNAL seq_det : std_logic := '0';
SIGNAL sdi_despread: std_logic;
SIGNAL extb : std_logic;
	

BEGIN					-- verbinden van interne signalen met de in/uitgangen
    
bit_sample <= b_s_edge;

int_dpll_rx : dpll_rx		-- de benodigde componenten aanmaken en via port mapping de juiste signalen eraan verbinden
PORT MAP(
    	clk 		=> clk,
	clk_en 		=> clk_en,
	rst 		=> rst,
	sdi_spread  	=> sdi_spread,
	chip_sample  	=> chip_sample,
	chip_sample1 	=> chip_sample1,
	chip_sample2 	=> chip_sample2,
	extb_out  	=> extb  	
);

int_mfilter_rx : mfilter_rx
PORT MAP(
    	clk   		=> clk,
	clk_en 		=> clk_en,
	rst  		=> rst,
	sdi_spread  	=> sdi_spread,
	chip_sample  	=> chip_sample,
	sel_pn  	=> pn_sel,
	seq_det  	=> match_out
);  

int_mux1_rx : mux_rx
PORT MAP(
	in0      	=> extb,
	in1      	=> match_out,
	in2      	=> match_out,
	in3      	=> match_out,
	sel 	 	=> pn_sel,
	sdo_spread 	=> seq_det
);

int_pngen_rx : pngen_rx
PORT MAP(
	clk      	=> clk,
	clk_en  	=> clk_en,
	rst  		=> rst,
	seq_det  	=> seq_det,
	chip_sample1	=> chip_sample1,
	bit_sample  	=> b_s,
	pn_ml1    	=> pn_ml1,
	pn_ml2   	=> pn_ml2,
	pn_gold  	=> pn_gold
);

int_edge_rx : edgedetector_rx
PORT MAP(
	clk   		=> clk,
	clk_en  	=> clk_en,
	rst   		=> rst,
	ingang 		=> b_s,
	uitgang		=> b_s_edge

);

int_mux2_rx : mux_rx
PORT MAP(
	in0      	=> '0',
	in1      	=> pn_ml1,
	in2      	=> pn_ml2,
	in3      	=> pn_gold,
	sel 		=> pn_sel,
	sdo_spread    	=> pn_seq
);

int_desp_rx : despreader_rx
PORT MAP(
	clk 		=> clk,
	clk_en  	=> clk_en,
	rst  		=> rst,
	sdi_spread 	=> sdi_spread,
	pn_seq 		=> pn_seq,
	chip_sample2 	=> chip_sample2,
	sdi_despread 	=> desp_out
);

int_mux3_rx : mux_rx
PORT MAP(
	in0      	=> sdi_spread,
	in1      	=> desp_out,
	in2      	=> desp_out,
	in3      	=> desp_out,
	sel 		=> pn_sel,
	sdo_spread    	=> sdi_despread
);

int_corr_rx : correlator_rx
PORT MAP(
	clk          	=> clk,
	clk_en       	=> clk_en,
	rst          	=> rst,
	sdi_despread 	=> sdi_despread,
	bit_sample   	=> b_s_edge,
	chip_sample2 	=> chip_sample2,
	data_out	=> databit

);
END behavior;