% Core states
state(init).
state(unidentified).
state(identify_user).
state(identified).
state(track_event).
state(error_state).

% Events
event(init).
event(identify_request).
event(identify_success).
event(track_request).
event(track_success).
event(error_occurred).
event(retry).

% Actions
action(identify_request, store_user_traits).
action(identify_success, complete_identification).
action(track_request, queue_event).
action(track_success, complete_tracking).
action(error_occurred, log_error).
action(retry, clear_error).

% Guards
guard(identify_request, has_valid_user_id).
guard(track_request, has_valid_event_data).
guard(retry, error_is_recoverable).

% State transitions with events
transition(init, unidentified, init).
transition(unidentified, identify_user, identify_request).
transition(identify_user, identified, identify_success).
transition(identify_user, error_state, error_occurred).
transition(identified, track_event, track_request).
transition(track_event, identified, track_success).
transition(track_event, error_state, error_occurred).
transition(error_state, unidentified, retry).

% Guard conditions
guard_condition(has_valid_user_id, user_id_present).
guard_condition(has_valid_event_data, event_name_present).
guard_condition(error_is_recoverable, can_retry).

% Action effects
action_effect(store_user_traits, user_identified).
action_effect(complete_identification, identification_completed).
action_effect(queue_event, event_queued).
action_effect(complete_tracking, tracking_completed).
action_effect(log_error, error_logged).
action_effect(clear_error, error_cleared).