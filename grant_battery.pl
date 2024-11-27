question('partially covered by the grant').

% Rule for partially covered by the grant
partially_covered_by_grant :-
    write('Is the grant partially covered by the grant? (yes/no) '),
    read(Answer),
    assertz(grant_partially_covered(Answer)),
    open('temp_facts.pl', write, Stream),
    write(Stream, 'grant_partially_covered('), write(Stream, Answer), write(Stream, ').\n'),
    close(Stream).
question('payed monthly every month and how many years').

% Rule for payed monthly every month and how many years
payed_monthly_every_month_and_how_many_years :-
    write('Is the payment made monthly every month for 5 years? (yes/no) '),
    read(Answer),
    assertz(payment_monthly_for_5_years(Answer)),
    open('temp_facts.pl', append, Stream),
    write(Stream, 'payment_monthly_for_5_years('), write(Stream, Answer), write(Stream, ').\n'),
    close(Stream).
question('you need a solar-powered battery that can at least light up 1 room and is compatible with AC').

% Rule for solar-powered battery requirements
solar_powered_battery_requirements :-
    write('Do you need a solar-powered battery that can at least light up 1 room and is compatible with AC? (yes/no) '),
    read(Answer),
    assertz(solar_battery_requirements(Answer)),
    open('temp_facts.pl', append, Stream),
    write(Stream, 'solar_battery_requirements('), write(Stream, Answer), write(Stream, ').\n'),
    close(Stream).
