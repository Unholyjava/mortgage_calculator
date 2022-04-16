-module(db_ets).
-author("gregory").

%% API
-compile(export_all).

read_all_banks(Name) ->
  ets:tab2list(Name).

create_table(Name, Type) ->
  ets:new(Name, [Type, public, named_table, {keypos, 1}]).

insert_table(Name, Data) ->
  ets:insert(Name, Data).

get(Name, Key) ->
  ets:lookup(Name, Key).

set(Name, Data) ->
  BankName = maps:get(<<"bankName">>, Data, <<>>),
  case ets:lookup(Name, BankName) of
    [] ->
      NewBank = maps:without([<<"bankName">>], Data),
      insert_table(Name, {BankName, maps:to_list(NewBank)});
    [_List] ->
      #{error => <<"Bank is exist">>}
  end.

update(Name, Data) ->
  BankName = maps:get(<<"bankName">>, Data, <<>>),
  case ets:lookup(Name, BankName) of
    [] ->
      #{error => <<"Bank is not exist">>};
    [_List] ->
      NewBank = maps:without([<<"bankName">>], Data),
      insert_table(Name, {BankName, maps:to_list(NewBank)})
  end.

delete(Name, Data) ->
  BankName = maps:get(<<"bankName">>, Data, <<>>),
  case ets:lookup(Name, BankName) of
    [] ->
      #{error => <<"Bank is not exist">>};
    [_List] ->
      ets:delete(Name, BankName)
  end.