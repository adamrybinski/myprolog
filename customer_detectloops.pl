% Logging with proper format
log_message(Type, Message) :-
    get_time(Timestamp),
    format('[~w] ~w: ~w~n', [Timestamp, Type, Message]).

% Fixed detect_loop
detect_loop(State, Path) :-
    member(State, Path),
    length(Path, Length),
    Length > 1,
    format('[Loop] Detected at state ~w with path ~w~n', [State, Path]),
    log_path(Path).

% Fixed path tracking
path_to_state(Start, End, Path) :-
    format('[Path] Starting from ~w to ~w~n', [Start, End]),
    path_to_state(Start, End, [Start], Path).

path_to_state(Current, End, Visited, Path) :-
    transition(Current, Next, Event),
    \+ member(Next, Visited),
    format('[Transition] ~w -> ~w via ~w~n', [Current, Next, Event]),
    (Next = End -> 
        Path = [Next|Visited],
        log_message(info, 
            format(atom(Msg), 'Transition: ~w -> ~w via ~w', [Current, Next, Event]))
    ;
        path_to_state(Next, End, [Next|Visited], Path)
    ).
