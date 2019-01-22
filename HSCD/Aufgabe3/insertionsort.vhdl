PROCEDURE sort(a: INOUT string; n: positive) IS
	VARIABLE key: character;
	VARIABLE j: natural;
	variable i: natural range 0 to n-1;
	BEGIN
	while i <= n-1 LOOP
		key := a(i);
		j := i-1;
		WHILE j >= 0 LOOP
			IF a(j) <= key THEN
				EXIT;
			END IF;
			a(j+1) := a(j);
			j := j - 1;
		END LOOP;
		a(j+1) := key;
		i := i +1;
	END LOOP;
END PROCEDURE;


//////////////////////////////////////////// WHILE auflösen

type TState is (S0, S1, S2);
variable state: TState := S0;

variable i: natural range 0 to n-1;
begin
	loop
		case state is
			-- Initialisierungszustand
			when S0 =>
				i := 0;
				state := S1;
				-- Ausführungszustand
			when S1 =>
				if i < n then
					key := a(i);
					j := i-1;
					a(j+1) := key;
					i := i +1;
					state := S2;
				else
					return;
				end if;
			when S2 =>
				if j >= 0 then
					//TODO: key + 1 möglich ??
					if a(j) < key+1 then
						EXIT;
					end if;
				a(j+1) := a(j);
				j := j-1;
		end case;
	end loop;
end procedure;


////////////////////////////////////////////////////////////////////////////////////////

type TState is (S0, S1, S2);
signal state, state0: TState;

signal swp, swp0: std_logic;
signal flg, flg0: std_logic;
signal d, d0: std_logic;
signal i, i0, i1: std_logic_vector(7 downto 0);
signal j, j0: std_logic_vector(8 downto 0);
signal m, m0: std_logic_vector(7 downto 0);
signal y, y0: std_logic_vector(7 downto 0);
signal tmp, tmp0: std_logic_vector(7 downto 0);
signal min, min0: std_logic_vector(7 downto 0);
signal ofs: std_logic_vector(7 downto 0);

begin
	done <= d;
	ADR <= ptr + ofs;
	i1 <= i + 1;

	reg: process (rst, clk) is

	begin
		if rst=RSTDEF then
			state <= S0;
			min <= (others => '0');
		elsif rising_edge(clk) then
			state <= state0;
			min <= min0;
		end if;
	end process;

	fsm: process (state, min, i, m, ... ) is
		begin
			state0 <= state;
			min0 <= min;
			case state is
				when S1 =>
					min0 <= i;
					if i < n then
						key := a(i);
						j := i-1;
						a(j+1) := key;
						i := i +1;
						state := S2;
					else
						return;
				when S2 =>
					ofs <= min;
					if j >= 0 then
						//TODO: key + 1 möglich ??
						if a(j) < key+1 then
							EXIT;
						end if;
						a(j+1) := a(j);
						j := j-1;
			end case;
		end process;


/////////////////////////////////////////////////////////// Variablen werden zu Registern

type TState is (S0, S1, S2);
signal state, state0: TState;

signal swp, swp0: std_logic;
signal flg, flg0: std_logic;
signal d, d0: std_logic;
signal i, i0, i1: std_logic_vector(7 downto 0);
signal j, j0: std_logic_vector(8 downto 0);
signal m, m0: std_logic_vector(7 downto 0);
signal y, y0: std_logic_vector(7 downto 0);
signal tmp, tmp0: std_logic_vector(7 downto 0);
signal min, min0: std_logic_vector(7 downto 0);
signal ofs: std_logic_vector(7 downto 0);

begin
	done <= d;
	ADR <= ptr + ofs;
	i1 <= i + 1;

	reg: process (rst, clk) is

	begin
		if rst=RSTDEF then
			state <= S0;
			i <= (others => '0');
			j <= (others => '0');
			m <= (others => '0');
			y <= (others => '0');
			tmp <= (others => '0');
			min <= (others => '0');
			d <= '0';
			flg <= '0';
			swp <= '0';
		elsif rising_edge(clk) then
			state <= state0;
			i <= i0;
			j <= j0;
			m <= m0;
			y <= y0;
			tmp <= tmp0;
			min <= min0;
			d <= d0;
			flg <= flg0;
			swp <= swp0;	
		end if;
	end process;

	fsm: process (state, strt, len, i, i1, j, d, m, y, tmp, min, flg, swp, dib) is
		begin
			state0 <= state;
			i0 <= i;
			j0 <= j;
			m0 <= m;
			y0 <= y;
			tmp0 <= tmp;
			min0 <= min;
			 <= d;
			flg0 <= flg;
			swp0 <= swp;
			ofs <= i; -- default (others => '0');
			WEB <= '0';
			ENB <= '0';
			DOB <= tmp; -- default (others => '0');
			case state is
				if strt='1' then
					d0 <= '0';
					i0 <= (others => '0');
					m0 <= len - 1;
					state0 <= S1;
				end if;
				when S1 =>
					if i<m then
						-- ofs <= i;
						ENB <= '1';
						min0 <= i;
						flg0 <= '0';
						swp0 <= '0';
						j0 <= '0' & i1;
						state0 <= S2;
					else
						d0 <= '1';
						state0 <= S0;
					end if;
				when S2 =>
					ofs <= min;
					if j >= 0 then
						//TODO: key + 1 möglich ??
						if a(j) < key+1 then
							EXIT;
						end if;
						a(j+1) := a(j);
						j := j-1;
				when S3 =>
					if DIB<tmp then
						swp0 <= '1';
						min0 <= j(min0'range);
						tmp0 <= DIB;
					end if;
					j0 <= j + 1;
					state0 <= S2;
				when S4 =>
					-- ofs <= i;
					-- DOB <= tmp;
					ENB <= '1';
					WEB <= '1';
					i0 <= i1;
					state0 <= S1;
			end case;
		end process;
end verhalten;
