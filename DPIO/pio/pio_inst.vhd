	component pio is
		port (
			clk_clk       : in  std_logic                    := 'X'; -- clk
			led1_export   : out std_logic_vector(3 downto 0);        -- export
			reset_reset_n : in  std_logic                    := 'X'; -- reset_n
			led2_export   : out std_logic_vector(7 downto 0)         -- export
		);
	end component pio;

	u0 : component pio
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			led1_export   => CONNECTED_TO_led1_export,   --  led1.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			led2_export   => CONNECTED_TO_led2_export    --  led2.export
		);

