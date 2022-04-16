%%%-------------------------------------------------------------------
%% @doc mortgage_calculator public API
%% @end
%%%-------------------------------------------------------------------

-module(mortgage_calculator_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Port = 8080,
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api/v1/[...]", data_handler, []},
            {'_', not_found_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http, [{port, Port}], #{
        env => #{dispatch => Dispatch}
    }),

    case mortgage_calculator_sup:start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Other ->
            {error, Other}
    end.

stop(_State) ->
    ok = cowboy:stop_listener(http).

