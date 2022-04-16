-module(util).
-author("gregory").

%% API
-export([get_payment/1]).

get_payment(Data = #{
  <<"bankName">> := BankName
}) ->
  case db_ets:get(banks_table, BankName) of
    [{BankName, PropList}] ->
      check_bank_data(maps:from_list(PropList), Data);
    _ ->
      #{error => <<"Error database">>}
  end;
get_payment(_) ->
  #{error => <<"Invalid input data">>}.

check_bank_data(_BankData = #{
  <<"interestRate">> := InterestRate,
  <<"creditMax">> := CreditMax,
  <<"initialFeePersent">> := InitialFeePersent,
  <<"creditTerm">> := CreditTermBank
}, _ClientData = #{
  <<"credit">> := Credit,
  <<"initialFee">> := InitialFee,
  <<"creditTerm">> := CreditTermClient
}) ->
  case Credit =< CreditMax
    andalso InitialFee * 100 / Credit >= InitialFeePersent
    andalso CreditTermClient =< CreditTermBank of
    true ->
      MonthlyPayment = ((Credit - InitialFee) * (InterestRate / 12) * math:pow((1 + InterestRate / 12), CreditTermClient)) /
        (math:pow((1 + InterestRate / 12), CreditTermClient) - 1),
      #{<<"monthlyPayment">> => MonthlyPayment};
    false ->
      #{error => <<"Invalid credit client's data">>}
  end;
check_bank_data(_, _) ->
  #{error => <<"Invalid input data">>}.