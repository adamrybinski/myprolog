nieruchomosc(dzialki_jablonka, 392000).       % Działki w Jabłonce (9913, 9914, 9915)
nieruchomosc(polowa_domu_jablonka, 990500).  % Połowa domu w Jabłonce (3873)
nieruchomosc(kasinka_cala, 625200).          % Cała nieruchomość w Kasince (w tym Anna/Magda)
nieruchomosc(kasinka_mala_5_8, 390750).      % 5/8 nieruchomości w Kasince - Wojtek (9466)
nieruchomosc(kasinka_mala_3_8, 234450).      % 3/8 nieruchomości w Kasince - Magda/Anna
nieruchomosc(las, 700000).                   % Las
nieruchomosc(mieszkanie_krakow, 150000).     % Mieszkanie Podarowane Paulinie w Krakowie

darowizna(paulina, mieszkanie_krakow, 150000). % Mieszkanie w Krakowie - Paulina
darowizna(wojtek, kasinka_mala_5_8, 156250).   % 5/8 nieruchomości w Kasince - Wojtek
darowizna(wojtek, dzialki_jablonka_polowa, 196000). % Połowa działek w Jabłonce - Wojtek
darowizna(alicja, dzialki_jablonka_polowa, 196000). % Połowa działek w Jabłonce - Alicja

suma_darowizn(Osoba, SumaDarowiznOsoby) :-
    findall(Darowizna, darowizna(Osoba, _, Darowizna), WszystkieDarowizny),
    sum_list(WszystkieDarowizny, SumaDarowiznOsoby).

calkowita_wartosc_spadku(CalkowitaWartosc) :-
    nieruchomosc(dzialki_jablonka, P1),
    nieruchomosc(polowa_domu_jablonka, P2),
    nieruchomosc(kasinka_mala_5_8, P3),
    nieruchomosc(las, P4),
    nieruchomosc(mieszkanie_krakow, P5),
    CalkowitaWartosc is P1 + P2 + P3 + P4 + P5.

poczatkowy_udzial(Udzial) :-
    calkowita_wartosc_spadku(CalkowitaWartosc),
    Udzial is CalkowitaWartosc / 5.

udzial_dostosowany(Osoba, UdzialDostosowany) :-
    poczatkowy_udzial(PoczatkowyUdzial),
    suma_darowizn(Osoba, SumaDarowiznOsoby),
    UdzialDostosowany is PoczatkowyUdzial
                     - SumaDarowiznOsoby.


:- calkowita_wartosc_spadku(CalkowitaWartosc),
   format("Całkowita wartość spadku: ~:d PLN~n", [CalkowitaWartosc]),

   udzial_dostosowany(adam, UdzialAdama),
   format("Udział Adama: ~:d PLN~n", [UdzialAdama]),

   udzial_dostosowany(paulina, UdzialPauliny),
   format("Udział Pauliny: ~:d PLN~n", [UdzialPauliny]),

   udzial_dostosowany(wojtek, UdzialWojtka),
   format("Udział Wojtka: ~:d PLN~n", [UdzialWojtka]),

   udzial_dostosowany(alicja, UdzialAlicji),
   format("Udział Alicji: ~:d PLN~n", [UdzialAlicji]),

   udzial_dostosowany(janusz, UdzialJanusza),
   format("Udział Janusza: ~:d PLN~n", [UdzialJanusza]).
