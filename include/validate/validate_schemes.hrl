
-define(BanksGet, #{}).

-define(BanksSet,
  #{
    <<"bankName">> => [required, {min_length, 1}],
    <<"interestRate">> => [required, positive_integer],
    <<"creditMax">> => [required, positive_integer],
    <<"initialFeePersent">> => [required, positive_integer],
    <<"creditTerm">> => [required, positive_integer]
  }
).

-define(BanksUpdate,
  #{
    <<"bankName">> => [required, {min_length, 1}],
    <<"interestRate">> => [positive_integer],
    <<"creditMax">> => [positive_integer],
    <<"initialFeePersent">> => [positive_integer],
    <<"creditTerm">> => [positive_integer]
  }
).

-define(BanksDelete,
  #{
    <<"bankName">> => [required, {min_length, 1}]
  }
).

-define(PaymentGet,
  #{
    <<"bankName">> => [required, {min_length, 1}],
    <<"credit">> => [required, positive_integer],
    <<"initialFee">> => [required, positive_integer],
    <<"creditTerm">> => [required, positive_integer]
  }
).