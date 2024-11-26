% Dead end detection
dead_end(State) :-
    state(State),
    \+ transition(State, _).

% Find all dead ends
find_dead_ends(DeadEnds) :-
    findall(State, dead_end(State), DeadEnds).

% All previous state and transition definitions remain the same...

% Find path to dead end with reverse order for correct display
path_to_dead_end(Start, ReversedPath) :-
    find_path_to_dead(Start, [Start], Path),
    reverse(Path, ReversedPath).

% Modified find path rule
find_path_to_dead(Current, Visited, Visited) :-
    dead_end(Current).

find_path_to_dead(Current, Visited, FinalPath) :-
    transition(Current, Next),
    \+ member(Next, Visited),
    find_path_to_dead(Next, [Next|Visited], FinalPath).

% Pretty print path
print_path_to_dead_end(Start) :-
    path_to_dead_end(Start, Path),
    format('Path to dead end starting from ~w:\n', [Start]),
    print_steps(Path, 1),
    fail.  % This will force backtracking to find all paths

print_path_to_dead_end(_).  % Catch-all to avoid false at the end

% Helper rule to print steps
print_steps([Last], N) :-
    format('Step ~w: ~w (Dead End)\n\n', [N, Last]).

print_steps([Current,Next|Rest], N) :-
    format('Step ~w: ~w -> ~w\n', [N, Current, Next]),
    N1 is N + 1,
    print_steps([Next|Rest], N1).

% print_path_to_dead_end(user_visits).