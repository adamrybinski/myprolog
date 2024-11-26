% main.pl
:- [customeriostate].
:- [validation_rules].
:- [dead_end_detection].

% Automatically execute when file is loaded
:- print_path_to_dead_end(user_activity).
:- find_dead_ends(DeadEnds), write('Dead ends found: '), write(DeadEnds), nl.