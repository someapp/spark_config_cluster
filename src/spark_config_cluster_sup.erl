
-module(spark_config_cluster_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,
		 start_link/1,
		 stop/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
-define(SERVER, ?MODULE).
-define(ConfPath,"conf").
-define(ConfFile, "spark_app.config").
-define(SERVER, ?MODULE).


%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    start_link([{?ConfPath, ?ConfFile}]).

start_link(Args) ->
    error_logger:info_msg("Starting ~p supervisor with args ~p", [?SERVER, Args]),
	supervisor:start_link({local, ?SERVER},
    	 	?MODULE, Args).


stop()-> ok.
%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
init([])->
	init([]);
init(Args) ->
	Apps = [syntax_tools, 
			compiler, 
			crypto,
			public_key,
			ssl,
			goldrush, 
			lager, 
			parse_trans,
			json_rec,
			appmon,
			os_mon,
			sasl,
			mnesia],
    lists:map(fun(App) -> 
    			ok = app_util:start_app(App)
    		  end, Apps),		
	Children = lists:flatten([
		?CHILD(spark_config_cluster, Args)	
		]),
    {ok, { {one_for_one, 5, 10}, Children}}.

