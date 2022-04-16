-module(mortgage_calculator).
-author("gregory").
-behaviour(gen_server).

%% API
-export([start_link/0, init/1,
  handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, stop/0]).

%% USER INTERFACE
-export([get_banks/0, set_bank/1, update_bank/1, delete_bank/1,
  get_payment/1]).


start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  gen_server:cast(?MODULE, {create_banks_table}),
  {ok, #{}}.

%%%%%%%%%%%%%%%%% USER INTERFACE %%%%%%%%%%%%%%%

get_banks() ->
  gen_server:call(?MODULE, {read_all}).

set_bank(Data) ->
  gen_server:call(?MODULE, {set_bank, Data}).

update_bank(Data) ->
  gen_server:call(?MODULE, {update_bank, Data}).

delete_bank(Data) ->
  gen_server:call(?MODULE, {delete_bank, Data}).

get_payment(Data) ->
  gen_server:call(?MODULE, {get_payment, Data}).

%%%%%%%%%%%%%%%%% USER INTERFACE %%%%%%%%%%%%%%%

stop() ->
  gen_server:call(?MODULE, terminate).


handle_call({read_all}, _From, State) ->
  io:format("Output all data from etsDB ~n"),
  Reply = {ok, db_ets:read_all_banks(banks_table)},
  {reply, Reply, State};

handle_call({set_bank, Data}, _From, State) ->
  io:format("Set data to etsDB ~n"),
  Reply = {ok, db_ets:set(banks_table, Data)},
  {reply, Reply, State};

handle_call({update_bank, Data}, _From, State) ->
  io:format("Update data in etsDB ~n"),

  Reply = {ok, db_ets:update(banks_table, Data)},
  {reply, Reply, State};

handle_call({delete_bank, Data}, _From, State) ->
  io:format("Delete data in etsDB ~n"),

  Reply = {ok, db_ets:delete(banks_table, Data)},
  {reply, Reply, State};

handle_call({get_payment, Data}, _From, State) ->
  io:format("Get payment ~n"),

  Reply = {ok, util:get_payment(Data)},
  {reply, Reply, State};

handle_call(terminate, _From, State) ->
  {stop, normal, ok, State};

handle_call(Msg, _From, State) ->
  io:format("Unexpected message in handle_call ~p~n", [Msg]),
  {reply, Msg, State}.

handle_cast({create_banks_table}, State) ->
  io:format("Create table ~n"),
  db_ets:create_table(banks_table, set),
  {ok, BanksProp} = application:get_env(mortgage_calculator, banks_properties),
  db_ets:insert_table(banks_table, BanksProp),
  {noreply, State};

handle_cast(Msg, State) ->
  io:format("Unexpected message in handle_cast ~p~n", [Msg]),
  {noreply, State}.

handle_info(Msg, State) ->
  io:format("Unexpected message in handle_info ~p~n", [Msg]),
  {noreply, State}.

terminate(normal, State) ->
  io:format("work with the server has finished ~p~n",[State]),
  ok.
