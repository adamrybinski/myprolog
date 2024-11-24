% Fakty
% Wartości nieruchomości
nieruchomosc(dzialki_jablonka, 392200).        % Działki w Jabłonce (9913, 9914, 9915)
nieruchomosc(dom_jablonka_polowa, 990500).    % 1/2 domu w Jabłonce (3873)
nieruchomosc(kasinka_mala_5_8, 390750).       % 5/8 udziału w nieruchomości w Kasince Małej (9466)
nieruchomosc(las, 700000).                    % Las
nieruchomosc(mieszkanie_krakow, 150000).      % Mieszkanie Pauliny w Krakowie

% Przydzielone nieruchomości
darowizna(paulina, mieszkanie_krakow, 150000). % Udział Pauliny - mieszkanie w Krakowie
darowizna(wojtek, kasinka_mala_5_8, 390750).  % Udział Wojtka - pełne 5/8 Kasinka Mała
darowizna(wojtek, dzialki_jablonka_polowa, 196100). % Wojtek - połowa działek w Jabłonce
darowizna(alicja, dzialki_jablonka_polowa, 196100). % Alicja - połowa działek w Jabłonce

% Koszty opłacone przez spadkobierców
koszt_oplacony(adam, biegly, 3800).      % Adam pokrył wszystkie koszty biegłego
koszt_oplacony(adam, prawne, 40000).    % Adam pokrył koszty prawne
koszt_oplacony(paulina, prawne, 5000).  % Paulina pokryła część kosztów prawnych

% Suma przydzielonych nieruchomości dla danej osoby
suma_przydzielonych_nieruchomosci(Osoba, SumaPrzydzielona) :-
    findall(PrzydzielonaKwota, darowizna(Osoba, _, PrzydzielonaKwota), PrzydzieloneKwoty),
    sum_list(PrzydzieloneKwoty, SumaPrzydzielona).

% Początkowy udział spadkobiercy (1/5 wartości całkowitej)
poczatkowy_udzial(_, Udzial) :-
    nieruchomosc(dzialki_jablonka, P1),
    nieruchomosc(dom_jablonka_polowa, P2),
    nieruchomosc(kasinka_mala_5_8, P3),
    nieruchomosc(las, P4),
    nieruchomosc(mieszkanie_krakow, P5),
    Suma is P1 + P2 + P3 + P4 + P5,
    Udzial is Suma / 5.

% Koszty prawne i biegłego
biegly(opracowanie_sobieskiego, 1500, 5).
biegly(opracowanie_magurska, 800, 5).
biegly(opracowanie_kasinka, 1500, 6).

koszty_prawne_suma(SumaKosztowPrawnych) :-
    honorarium_mecenas(30000),
    koszty_sadowe(10000),
    SumaKosztowPrawnych is 30000 + 10000.

koszt_prawny_na_osobe(KosztPrawnyNaOsobe) :-
    koszty_prawne_suma(SumaKosztowPrawnych),
    KosztPrawnyNaOsobe is SumaKosztowPrawnych / 5.

% Obliczanie kosztów biegłego na osobę
koszt_biegly_na_osobe(KosztNaOsobe) :-
    findall(Koszt/Beneficiaries, biegly(_, Koszt, Beneficiaries), ListaKosztow),
    findall(IndywidualnyKoszt, (
        member(Koszt/Beneficiaries, ListaKosztow),
        IndywidualnyKoszt is Koszt / Beneficiaries
    ), KosztyNaOsobe),
    sum_list(KosztyNaOsobe, KosztNaOsobe).

% Obliczanie kosztów opłaconych przez daną osobę
koszt_oplacony_przez(Osoba, SumaOplaconychKosztow) :-
    findall(Kwota, koszt_oplacony(Osoba, _, Kwota), ListaKosztow),
    sum_list(ListaKosztow, SumaOplaconychKosztow).

% Obliczanie dostosowanego udziału dla spadkobiercy
udzial_osoby(Osoba, DostosowanyUdzial) :-
    poczatkowy_udzial(Osoba, PoczatkowyUdzial),
    suma_przydzielonych_nieruchomosci(Osoba, SumaPrzydzielona),
    koszt_biegly_na_osobe(KosztBieglyNaOsobe),
    koszt_prawny_na_osobe(KosztPrawnyNaOsobe),
    koszt_oplacony_przez(Osoba, KosztOplacony), % Calculate total KosztOplaconys
    DostosowanyUdzial is PoczatkowyUdzial
                  - SumaPrzydzielona
                  - KosztBieglyNaOsobe
                  - KosztPrawnyNaOsobe
                  + KosztOplacony.

% Całkowita wartość spadku
calkowita_wartosc_spadku(SumaSpadku) :-
    nieruchomosc(dzialki_jablonka, P1),
    nieruchomosc(dom_jablonka_polowa, P2),
    nieruchomosc(kasinka_mala_5_8, P3),
    nieruchomosc(las, P4),
    nieruchomosc(mieszkanie_krakow, P5),
    SumaSpadku is P1 + P2 + P3 + P4 + P5.

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
