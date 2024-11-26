% Define all states
state(user_activity).
state(signup_event).
state(signin_event).
state(task_conversion).
state(analytics_queue).
state(customer_io_track).
state(event_logged).
state(track_failed).
state(retry_track).
state(process_complete).
% Define main flow transitions
transition(user_activity, signup_event).
transition(user_activity, signin_event).
transition(user_activity, task_conversion).
transition(signup_event, analytics_queue).
transition(signin_event, analytics_queue).
transition(task_conversion, analytics_queue).
transition(analytics_queue, customer_io_track).
transition(customer_io_track, event_logged).
transition(event_logged, process_complete).
% Error handling transitions
transition(customer_io_track, track_failed).
transition(track_failed, retry_track).
transition(retry_track, customer_io_track).
% Process completion
transition(event_logged, process_complete).
transition(process_complete, user_activity).