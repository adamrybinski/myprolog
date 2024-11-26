% Dead end detection for three-argument transitions
dead_end(State) :-
    state(State),
    \+ transition(State, _, _).

% Find all dead ends
find_dead_ends(DeadEnds) :-
    findall(State, dead_end(State), DeadEnds).

% Find path to dead end with reverse order for correct display
path_to_dead_end(Start, ReversedPath) :-
    find_path_to_dead(Start, [Start], Path),
    reverse(Path, ReversedPath).

% Modified find path rule for three-argument transitions
find_path_to_dead(Current, Visited, Visited) :-
    dead_end(Current).

find_path_to_dead(Current, Visited, FinalPath) :-
    transition(Current, Next, _),
    \+ member(Next, Visited),
    find_path_to_dead(Next, [Next|Visited], FinalPath).

% Pretty print path with event information
print_path_to_dead_end(Start) :-
    path_to_dead_end(Start, Path),
    format('Path to dead end starting from ~w:\n', [Start]),
    print_steps(Path, 1),
    fail.

print_path_to_dead_end(_).

% Helper rule to print steps with event information
print_steps([Last], N) :-
    format('Step ~w: ~w (Dead End)\n\n', [N, Last]).

print_steps([Current,Next|Rest], N) :-
    transition(Current, Next, Event),
    format('Step ~w: ~w -[~w]-> ~w\n', [N, Current, Event, Next]),
    N1 is N + 1,
    print_steps([Next|Rest], N1).