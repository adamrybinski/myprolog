% Obliczenia - Prolog, komenda: swipl -s obliczenia.pl
% Fakty
% Wartości nieruchomości w PLN
nieruchomosc(dzialki_jablonka, 392000).       % Działki w Jabłonce (9913, 9914, 9915)
nieruchomosc(polowa_domu_jablonka, 990500).  % Połowa domu w Jabłonce (3873)
nieruchomosc(kasinka_cala, 625200).          % Cała nieruchomość w Kasince (w tym Anna/Magda)
nieruchomosc(kasinka_mala_5_8, 390750).      % 5/8 nieruchomości w Kasince - Wojtek (9466)
nieruchomosc(kasinka_mala_3_8, 234450).      % 3/8 nieruchomości w Kasince - Magda/Anna
nieruchomosc(las, 700000).                   % Las
nieruchomosc(mieszkanie_krakow, 150000).     % Mieszkanie Podarowane Paulinie w Krakowie

pieniadze(konto_bankowe, 65000). % Pieniadze wyciagniete przez Wojciecha
samochod(samochodAudi, 10000).

% Przydzielone darowizny/pieniadze
darowizna(paulina, mieszkanie_krakow, 150000). % Mieszkanie w Krakowie - Paulina
darowizna(wojtek, kasinka_mala_5_8, 156250).   % 5/8 nieruchomości w Kasince - Wojtek
darowizna(wojtek, dzialki_jablonka_polowa, 196000). % Połowa działek w Jabłonce - Wojtek
darowizna(alicja, dzialki_jablonka_polowa, 196000). % Połowa działek w Jabłonce - Alicja
darowizna(wojtek, konto_bankowe, 65000). % Pieniadze wyciagniete przez Wojciecha

% Koszty biegłych i prawne w PLN
koszt_biegly(raport_sobieskiego, 1500). % Raport dotyczący Sobieskiego (dom w Jabłonce)
koszt_biegly(raport_magurska, 800).     % Raport dotyczący Magurska (działki w Jabłonce)
koszt_biegly(raport_kasinka, 1500).     % Raport dotyczący Kasinki (nieruchomość)

% Koszty pokryte przez spadkobierców w PLN
koszt_pokryty(adam, biegly, 3800).  % Adam pokrył wszystkie koszty biegłych
koszt_pokryty(adam, prawne, 36000). % Tymczasowa wartosc - Adam pokrył koszty prawne

% Honorarium prawnika
honorarium_pana_mecenasa(30000). % Tymczasowa wartość w PLN

% Koszty sądowe
koszty_sadowe(6000). % Tymczasowa wartość w PLN

% Helper predicate to sum a list
sum_list([], 0).
sum_list([H|T], Sum) :-
    sum_list(T, Rest),
    Sum is H + Rest.

% Suma już przydzielonych nieruchomości dla osoby
suma_darowizn(Osoba, SumaDarowiznOsoby) :-
    findall(Darowizna, darowizna(Osoba, _, Darowizna), WszystkieDarowizny),
    sum_list(WszystkieDarowizny, SumaDarowiznOsoby).

% Całkowita wartość spadku
calkowita_wartosc_spadku(CalkowitaWartosc) :-
    nieruchomosc(dzialki_jablonka, P1),
    nieruchomosc(polowa_domu_jablonka, P2),
    nieruchomosc(kasinka_mala_5_8, P3),
    nieruchomosc(las, P4),
    nieruchomosc(mieszkanie_krakow, P5),
    % pieniadze(konto_bankowe, P6),
    % samochod(samochodAudi, P7),
    CalkowitaWartosc is P1 + P2 + P3 + P4 + P5.

% Początkowy udział spadkobiercy (1/5 całkowitej wartości)
poczatkowy_udzial(Udzial) :-
    calkowita_wartosc_spadku(CalkowitaWartosc),
    Udzial is CalkowitaWartosc / 5.

% Koszty biegłego na osobę
koszt_biegly_na_osobe(KosztNaOsobe) :-
    koszt_biegly(raport_sobieskiego, KosztSobieskiego),
    koszt_biegly(raport_magurska, KosztMagurska),
    koszt_biegly(raport_kasinka, KosztKasinka),
    SumaKosztow is KosztSobieskiego + KosztMagurska + KosztKasinka,
    KosztNaOsobe is SumaKosztow / 5.

% Koszty prawne na osobę
koszt_prawny_na_osobe(KosztNaOsobe) :-
    honorarium_pana_mecenasa(Honorarium),
    koszty_sadowe(Sadowe),
    SumaKosztowPrawnych is Honorarium + Sadowe,
    KosztNaOsobe is SumaKosztowPrawnych / 5.

% Suma kosztów pokrytych przez osobę
suma_kosztow_pokrytych(Osoba, KosztyPokrytePrzezOsobe) :-
    findall(Kwota, koszt_pokryty(Osoba, _, Kwota), ListaPokrytych),
    sum_list(ListaPokrytych, KosztyPokrytePrzezOsobe).

% Dostosowany udział spadkobiercy
udzial_dostosowany(Osoba, UdzialDostosowany) :-
    poczatkowy_udzial(PoczatkowyUdzial),
    suma_darowizn(Osoba, SumaDarowiznOsoby),
    % koszt_biegly_na_osobe(KosztBieglyNaOsobe),
    % koszt_prawny_na_osobe(KosztPrawnyNaOsobe),
    % suma_kosztow_pokrytych(Osoba, KosztyPokrytePrzezOsobe),
    UdzialDostosowany is PoczatkowyUdzial
                     - SumaDarowiznOsoby.
                    %  - KosztBieglyNaOsobe
                    %  - KosztPrawnyNaOsobe
                    %  + KosztyPokrytePrzezOsobe.

% Main predicate
main(_) :-
    print_results,
    halt.

print_results :-
    calkowita_wartosc_spadku(CalkowitaWartosc),
    format("Całkowita wartość spadku: ~w PLN~n", [CalkowitaWartosc]),
    
    udzial_dostosowany(adam, UdzialAdama),
    format("Udział Adama: ~w PLN~n", [UdzialAdama]),
    
    udzial_dostosowany(paulina, UdzialPauliny),
    format("Udział Pauliny: ~w PLN~n", [UdzialPauliny]),
    
    udzial_dostosowany(wojtek, UdzialWojtka),
    format("Udział Wojtka: ~w PLN~n", [UdzialWojtka]),
    
    udzial_dostosowany(alicja, UdzialAlicji),
    format("Udział Alicji: ~w PLN~n", [UdzialAlicji]),
    
    udzial_dostosowany(janusz, UdzialJanusza),
    format("Udział Janusza: ~w PLN~n", [UdzialJanusza]).


% Entry point
:- initialization(main(_)).
