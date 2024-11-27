% main.pl
:- [customeriostate].
:- [validation_rules].
:- [dead_end_detection].
:- [detectloops].

% Logging predicate
log_message(Type, Message) :-
    get_time(Timestamp),
    format('[~w] ~w: ~w~n', [Timestamp, Type, Message]).

% Enhanced loop detection with logging
detect_loop(State, Path) :-
    member(State, Path),
    length(Path, Length),
    Length > 1,
    log_message(warning, 
        format(atom(Msg), 'Loop detected at state ~w with path ~w', [State, Path])),
    log_path(Path).

% Log individual path steps
log_path([]).
log_path([State|Rest]) :-
    log_message(info, format(atom(Msg), 'Path state: ~w', [State])),
    log_path(Rest).

% Enhanced path tracking with logging
path_to_state(Start, End, Path) :-
    log_message(info, format(atom(Msg), 'Starting path tracking from ~w to ~w', [Start, End])),
    path_to_state(Start, End, [Start], Path).

path_to_state(Current, End, Visited, Path) :-
    transition(Current, Next, Event),
    \+ member(Next, Visited),
    log_message(info, 
        format(atom(Msg), 'Transition: ~w -> ~w via ~w', [Current, Next, Event])),
    (Next = End -> 
        Path = [Next|Visited],
        log_message(info, 'Path found'),
        log_path(Path)
    ;
        path_to_state(Next, End, [Next|Visited], Path)
    ).

% Track specific loop between identified and track_event
detect_tracking_loop :-
    path_to_state(identified, track_event, Path1),
    path_to_state(track_event, identified, Path2),
    append(Path1, Path2, FullPath),
    log_message(warning, 'Checking for tracking loop'),
    detect_loop(identified, FullPath).

% Automatically execute when file is loaded
:- initialization((
    log_message(info, 'Starting dead end and loop detection'),
    print_path_to_dead_end(user_activity),
    find_dead_ends(DeadEnds),
    log_message(info, format(atom(Msg), 'Dead ends found: ~w', [DeadEnds])),
    detect_tracking_loop
)).

% Query helper for tracking loop detection
check_tracking_loop :-
    log_message(info, 'Checking tracking loop pattern'),
    findall(Path, (
        path_to_state(identified, track_event, Path1),
        path_to_state(track_event, identified, Path2),
        append(Path1, Path2, Path),
        detect_loop(identified, Path)
    ), Loops),
    log_message(info, format(atom(Msg), 'Found ~w tracking loops', [length(Loops)])),
    print_loops(Loops).

% Helper to print detected loops
print_loops([]).
print_loops([Loop|Rest]) :-
    log_message(info, format(atom(Msg), 'Loop path: ~w', [Loop])),
    print_loops(Rest).

halt.