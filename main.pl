% Fakty
% Wartości nieruchomości
nieruchomosc(dzialki_jablonka, 392200).        % Działki w Jabłonce (9913, 9914, 9915)
nieruchomosc(dom_jablonka_polowa, 990500).    % 1/2 domu w Jabłonce (3873)
nieruchomosc(kasinka_mala_5_8, 390750).       % 5/8 udziału w nieruchomości w Kasince Małej (9466)
nieruchomosc(las, 700000).                    % Las
nieruchomosc(mieszkanie_krakow, 150000).      % Mieszkanie Pauliny w Krakowie

% Całkowita wartość spadku (suma wszystkich nieruchomości)
calkowita_wartosc_spadku(Suma) :-
    nieruchomosc(dzialki_jablonka, P1),
    nieruchomosc(dom_jablonka_polowa, P2),
    nieruchomosc(kasinka_mala_5_8, P3),
    nieruchomosc(las, P4),
    nieruchomosc(mieszkanie_krakow, P5),
    Suma is P1 + P2 + P3 + P4 + P5.

% Początkowy udział 1/5 dla każdego spadkobiercy
poczatkowy_udzial(Osoba, Udzial) :-
    calkowita_wartosc_spadku(Suma),
    Udzial is Suma / 5.

% Przydzielone nieruchomości
darowizna(paulina, mieszkanie_krakow, 150000). % Udział Pauliny - mieszkanie w Krakowie
darowizna(wojtek, kasinka_mala_5_8, 390750).  % Udział Wojtka - pełne 5/8 Kasinka Mała
darowizna(wojtek, dzialki_jablonka_polowa, 196100). % Wojtek - połowa działek w Jabłonce
darowizna(alicja, dzialki_jablonka_polowa, 196100). % Alicja - połowa działek w Jabłonce

% Udział prawnika (zaktualizowany po calej sprawie)
honorarium_mecenas(0). % Tymczasowy placeholder, do aktualizacji

% Obliczanie dostosowanego udziału dla spadkobiercy
udzial_osoby(Osoba, DostosowanyUdzial) :-
    poczatkowy_udzial(Osoba, PoczatkowyUdzial),
    findall(PrzydzielonaKwota, darowizna(Osoba, _, PrzydzielonaKwota), PrzydzieloneKwoty),
    sum_list(PrzydzieloneKwoty, SumaPrzydzielona),
    honorarium_mecenas(UdzialPrawnika),
    KosztPrawnikaNaOsobe is UdzialPrawnika / 5,
    DostosowanyUdzial is PoczatkowyUdzial - SumaPrzydzielona - KosztPrawnikaNaOsobe.

% Predefiniowane zapytania
:- calkowita_wartosc_spadku(SumaSpadku),
   format("Całkowita wartość spadku: ~w PLN~n", [SumaSpadku]),
   
   udzial_osoby(adam, UdzialAdama),
   format("Udział Adama: ~w PLN~n", [UdzialAdama]),
   
   udzial_osoby(paulina, UdzialPauliny),
   format("Udział Pauliny: ~w PLN~n", [UdzialPauliny]),
   
   udzial_osoby(wojtek, UdzialWojtka),
   format("Udział Wojtka: ~w PLN~n", [UdzialWojtka]),
   
   udzial_osoby(alicja, UdzialAlicji),
   format("Udział Alicji: ~w PLN~n", [UdzialAlicji]),
   
   udzial_osoby(janusz, UdzialJanusza),
   format("Udział Janusza: ~w PLN~n", [UdzialJanusza]),
   
   halt.
