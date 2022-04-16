-module(data_handler).
-author("gregory").

%% API
-export([init/2]).


init(Req0, Opts) ->
  Method = cowboy_req:method(Req0),
  Path = cowboy_req:path_info(Req0),
  {ok, InputBody, _} = cowboy_req:read_body(Req0),
  IsValidBody = jsx:is_json(InputBody),
  case IsValidBody of
    true ->
      DecodeBody = jsx:decode(InputBody, [{return_maps, true}]),
      Req = check_validate(Path, DecodeBody, Req0);
%%      Req = route_request(Path, DecodeBody, Req0);
    false when Method == <<"GET">> ->
      Req = route_request(Path, Req0);
    _ ->
      Req = response_server({error, <<"Invalid json">>}, Req0)
  end,
  {ok, Req, Opts}.

route_request([<<"banks">>, <<"get">>], Req) -> response_server(mortgage_calculator:get_banks(), Req);
route_request(_, Req) -> response_server({error, 404, <<"Invalid path">>}, Req).

route_request([<<"banks">>, <<"set">>], Data, Req) -> response_server(mortgage_calculator:set_bank(Data), Req);
route_request([<<"banks">>, <<"update">>], Data, Req) -> response_server(mortgage_calculator:update_bank(Data), Req);
route_request([<<"banks">>, <<"delete">>], Data, Req) -> response_server(mortgage_calculator:delete_bank(Data), Req);
route_request([<<"payment">>, <<"get">>], Data, Req) -> response_server(mortgage_calculator:get_payment(Data), Req);
route_request(_, _Data, Req) -> response_server({error, 404, <<"Invalid path">>}, Req).


response_server({ok, Resp_server}, Req) ->
  cowboy_req:reply(200, #{<<"content-type">> => <<"text/xml; charset=utf-8">>},
    convert_to_json(Resp_server), Req);

response_server({error, Code, Reason}, Req) ->
  cowboy_req:reply(Code, #{<<"content-type">> => <<"text/xml; charset=utf-8">>},
    convert_to_json(#{error => Reason}), Req);

response_server(_, Req) ->
  cowboy_req:reply(400, #{<<"content-type">> => <<"text/xml; charset=utf-8">>},
    convert_to_json(#{error => <<"Unexpected response from mortgage_calculator ~n">>}), Req).


check_validate(Path, ReqData, Req) ->
  case validate:run(Path, ReqData) of
    {error, ErrorData} ->
      response_server({error, 400, ErrorData}, Req);
    {ok, ValidatedData} ->
      route_request(Path, ValidatedData, Req)
  end.

convert_to_json(Response) ->
  jsx:encode(Response).

