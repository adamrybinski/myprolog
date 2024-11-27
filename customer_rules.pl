% State validation
valid_state(analytics_queue) :- 
    has_api_key,
    retry_count < 3.

% API key check
has_api_key :-
    api_key(_).

% Transition validation
valid_transition(From, To) :-
    state(From),
    state(To),
    transition(From, To, _).

% Counter for retries
:- dynamic retry_count/1.
retry_count(0).