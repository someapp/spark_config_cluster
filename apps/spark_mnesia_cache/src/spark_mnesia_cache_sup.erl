
-module(spark_mnesia_cache_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,
		 start_link/1,
		 stop/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

-define(SERVER,?MODULE).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER},
    	 ?MODULE, []).

start_link(Args) ->
	app_util:start_app(application:start(sasl)),
	app_util:start_app(application:start(os_mon)),
	app_util:start_app(application:start(appmon)),
	ok.

stop()->
	app_util:stop_app(application:stop(appmon)),
	app_util:stop_app(application:stop(os_mon)),
	app_util:stop_app(application:stop(sasl)),
	ok.
%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
init([])->
	init([]);
init(Args) ->
	Children = [],
    {ok, { {one_for_one, 5, 10}, Children}}.


