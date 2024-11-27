% Core states
state(user_activity).
state(identify_user).
state(track_event).
state(error_state).

% Events
event(identify_request).
event(track_request).
event(error_occurred).

% Actions
action(identify_request, store_user_traits).
action(track_request, queue_event).
action(error_occurred, log_error).

% Guards
guard(identify_request, has_valid_user_id).
guard(track_request, has_valid_event_data).

% State transitions with events
transition(user_activity, identify_user, identify_request).
transition(user_activity, track_event, track_request).
transition(track_event, error_state, error_occurred).
transition(identify_user, error_state, error_occurred).

% Guard conditions
guard_condition(has_valid_user_id, user_id_present).
guard_condition(has_valid_event_data, event_name_present).

% Action effects
action_effect(store_user_traits, user_identified).
action_effect(queue_event, event_queued).
action_effect(log_error, error_logged).