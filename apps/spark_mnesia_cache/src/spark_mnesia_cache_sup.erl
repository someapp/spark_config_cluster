
-module(spark_mnesia_cache_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
init([])->
	init([]);
init(Args) ->
	Children = [],
    {ok, { {one_for_one, 5, 10}, Children}}.

start_app(ok)->
	ok;
start_app({error, {already_started, App}}
		when is_atom(App) ->
	ok;
start_app({error, {Reason, App}}) ->
		when is_atom(App) ->
	{error, {Reason, App}};
start_app({E, {Reason, App}}) ->
	{E, {Reason, App}};
start_app(_)-> {error, badarg}.

stop_app(ok)->
	ok;
stop_app({error,{not_started,App}})
		when is_atom(App)->
	ok;
stop_app({error, {Reason, App}}) ->
		when is_atom(App) ->
	{error, {Reason, App}};
stop_app({E, {Reason, App}}) ->
	{E, {Reason, App}};
stop_app(_)-> {error, badarg}.

