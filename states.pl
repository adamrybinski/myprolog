% Define all states
state(user_visits).
state(collect_data).
state(validate_email).
state(validate_country).
state(send_welcome).
state(customer_io_queue).
state(email_sent).
state(log_success).
state(trigger_followup).
state(invalid_email_error).
state(blocked_country_error).
state(delivery_failed).
state(retry_validation).
state(retry_delivery).
state(process_complete).

% Define transitions including complete cycles
transition(user_visits, collect_data).
transition(collect_data, validate_email).
transition(collect_data, validate_country).
transition(validate_email, send_welcome).
transition(validate_country, send_welcome).
transition(send_welcome, customer_io_queue).
transition(customer_io_queue, email_sent).
transition(email_sent, log_success).
transition(email_sent, trigger_followup).

% Error recovery paths
transition(validate_email, invalid_email_error).
transition(invalid_email_error, retry_validation).
transition(retry_validation, validate_email).
transition(retry_validation, validate_country).

transition(validate_country, blocked_country_error).
transition(blocked_country_error, retry_validation).

transition(customer_io_queue, delivery_failed).
transition(delivery_failed, retry_delivery).
transition(retry_delivery, customer_io_queue).

% Complete process paths
transition(log_success, process_complete).
transition(trigger_followup, process_complete).
transition(process_complete, user_visits).

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