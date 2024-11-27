% Core states
state(user_activity).
state(analytics_queue).
state(customer_io_track).
state(event_logged).
state(identify_user).
state(track_event).
state(page_view).
state(group_association).
state(alias_merge).
state(error_state).

% Events
event(identify_request).
event(track_request).
event(page_request).
event(group_request).
event(alias_request).
event(flush_queue).
event(batch_full).
event(error_occurred).
event(retry_attempt).
event(shutdown_initiated).

% Actions
action(identify_request, store_user_traits).
action(track_request, queue_event).
action(page_request, record_page_view).
action(group_request, associate_group).
action(flush_queue, send_to_customer_io).
action(error_occurred, log_error).
action(retry_attempt, increment_retry_count).
action(shutdown_initiated, flush_remaining_events).

% Guards
guard(identify_request, has_valid_user_id).
guard(track_request, has_valid_event_data).
guard(queue_event, within_batch_limit).
guard(send_to_customer_io, queue_not_empty).
guard(retry_attempt, retry_count_within_limit).
guard(flush_queue, has_pending_events).

% State transitions with events
transition(user_activity, identify_user, identify_request).
transition(user_activity, track_event, track_request).
transition(user_activity, page_view, page_request).
transition(track_event, analytics_queue, queue_event).
transition(analytics_queue, customer_io_track, batch_full).
transition(customer_io_track, event_logged, track_success).
transition(customer_io_track, error_state, error_occurred).
transition(error_state, analytics_queue, retry_attempt).
% Complete the event logging cycle
transition(event_logged, user_activity, cycle_complete).

% Connect identification flow
transition(identify_user, analytics_queue, queue_identify).

% Connect page view tracking
transition(page_view, analytics_queue, queue_page).

% Group and alias handling
transition(group_association, analytics_queue, queue_group).
transition(alias_merge, analytics_queue, queue_alias).

% Guard conditions
guard_condition(has_valid_user_id, user_id_present).
guard_condition(has_valid_event_data, event_name_present).
guard_condition(within_batch_limit, batch_size_under_20).
guard_condition(queue_not_empty, events_pending).
guard_condition(retry_count_within_limit, retries_under_3).

% Action effects
action_effect(store_user_traits, user_identified).
action_effect(queue_event, event_queued).
action_effect(send_to_customer_io, events_sent).
action_effect(log_error, error_logged).
action_effect(increment_retry_count, retry_incremented).