:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).

% Start the server
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Serve static files (like HTML)
:- http_handler(root(.), http_reply_from_files('.', []), [prefix]).

% Define HTTP handlers
:- http_handler('/recommend', recommend_books, []).

% Book database
book(sci_fi, 'Dune', 'Frank Herbert').
book(sci_fi, 'Neuromancer', 'William Gibson').
book(fantasy, 'The Lord of the Rings', 'J.R.R. Tolkien').
book(fantasy, 'A Game of Thrones', 'George R.R. Martin').
book(mystery, 'The Girl with the Dragon Tattoo', 'Stieg Larsson').
book(mystery, 'Gone Girl', 'Gillian Flynn').

% Recommendation rules
recommend(Genre, Author, Book) :-
    book(Genre, Book, Author).

recommend(Genre, _, Book) :-
    book(Genre, Book, _).

recommend(_, Author, Book) :-
    book(_, Book, Author).

% Handler for book recommendations
recommend_books(Request) :-
    % Extract parameters with default values
    (   http_parameters(Request,
            [ genre(Genre, [optional(true), default('')]),
              author(Author, [optional(true), default('')])
            ])
    ->  format('Received request with genre: ~w and author: ~w~n', [Genre, Author]),
        % Handle recommendations based on the provided parameters
        findall(json(book{title:Book, author:BookAuthor}),
                (   Genre \= '', recommend(Genre, _, Book),
                     book(Genre, Book, BookAuthor)
                ;   Author \= '', recommend(_, Author, Book),
                     book(_, Book, BookAuthor)
                ;   Genre = '', Author = '', % Handle the case where both are empty
                     book(_, Book, BookAuthor)
                ),
                Recommendations),
        format('Recommendations found: ~w~n', [Recommendations]),
        reply_json(json{recommendations:Recommendations})
    ;   % Handle parameter parsing failure
        reply_json(json{code: 400, message: "Invalid parameters"}, [status(400)])
    ).


% Entry point to start the server on port 3000
:- initialization(start_server(3000)).
