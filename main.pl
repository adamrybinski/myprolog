
% Remove the initialization directive and define main separately
main :-
    run_test('User earns commission').

% Test scenario definition
scenario(
    'User earns commission',
    given([
        affiliate(john),
        referral(john, mary),
        purchase(mary, 100)
    ]),
    when(calculate_commission(john, Amount)),
    then(Amount == 10)
).

% Setup predicates
setup([]).
setup([Condition|Rest]) :-
    assert(Condition),
    setup(Rest).

% Execute action
execute(when(Goal)) :-
    call(Goal).

% Verify result
verify(then(Condition)) :-
    call(Condition).

% Test runner with output
run_test(Name) :-
    write('Running test: '), write(Name), nl,
    scenario(Name, Given, When, Then),
    write('Setting up conditions...'), nl,
    setup(Given),
    write('Executing test...'), nl,
    execute(When),
    write('Verifying result...'), nl,
    (verify(Then) ->
        write('Test passed!'), nl
    ;
        write('Test failed!'), nl
    ).

% Calculate commission
calculate_commission(Person, Amount) :-
    referral(Person, Referred),
    purchase(Referred, Purchase),
    Amount is Purchase * 0.1.

% Main execution
main :-
    run_test('User earns commission'),
    halt.
