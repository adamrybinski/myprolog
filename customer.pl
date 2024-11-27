% main.pl
:- [customer_state].
:- [customer_rules].
:- [customer_dead_end_detection].
:- [customer_detectloops].

% Logging predicate

% Track specific loop between identified and track_event
detect_tracking_loop :-
    path_to_state(identified, track_event, Path1),
    path_to_state(track_event, identified, Path2),
    append(Path1, Path2, FullPath),
    log_message(warning, 
        format(atom(Msg), 'Loop detected at state ~w with path ~w', [State, Path])),
    detect_loop(identified, FullPath).

% Automatically execute when file is loaded
:- initialization((
    log_message(info, format(atom(Msg), 'Starting path tracking from ~w to ~w', [Start, End])),
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
