-module(validate).
-author("dn030578khv").

%% API
-export([
  run/2
]).

-include("validate/validate_schemes.hrl").


run([_Head | _Tail ] = Path, ReqData) ->
  case detect_scheme(Path, ReqData) of
    undefined ->
      {error, <<"Invalid path">>};
    Scheme ->
      case liver:validate(Scheme, ReqData) of
        {ok, _ValidatedData} = Ok ->
          Ok;
        {error, ErrorData} ->
          io:format("Error validate ~p", [{Path, ReqData}]),
          {error, #{
            <<"description">> => <<"error validate">>,
            <<"additional">> => ErrorData
          }}
      end
  end.


detect_scheme([<<"banks">>, <<"get">>], _WebReq) -> ?BanksGet;
detect_scheme([<<"banks">>, <<"set">>], _WebReq) -> ?BanksSet;
detect_scheme([<<"banks">>, <<"update">>], _WebReq) -> ?BanksUpdate;
detect_scheme([<<"banks">>, <<"delete">>], _WebReq) -> ?BanksDelete;
detect_scheme([<<"payment">>, <<"get">>], _WebReq) -> ?PaymentGet;
detect_scheme(_, _) -> undefined.
