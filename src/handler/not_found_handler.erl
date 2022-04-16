-module(not_found_handler).
-author("gregory").

%% API
-export([init/2]).


init(Req, Opts) ->
  io:format("Not Found request! ~p~n", [Req]),
  Resp = cowboy_req:reply(404,  #{<<"content-type">> => <<"application/json; charset=utf-8">>},
    jsx:encode(#{<<"result">> => <<"Not Found">>}), Req),
  {ok, Resp, Opts}.