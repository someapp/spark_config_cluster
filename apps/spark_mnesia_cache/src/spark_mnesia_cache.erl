-module(spark_mnesia_cache).
-behaviour(gen_server).

-export([
	load_config/0,
	load_config/1,
	load_config/2,
	lookup/1,
	lookup/2,
	update/2,
	remove/1,
	synchronize/0,
	list_cluster/0
]).

-export([start_link/0,
	 	 stop/0]).

-export([init/1,
		 handle_call/3,
		 handle_cast/2,
		 handle_info/2,
		 terminate/2,
		 code_change/2,
		 code_change/3]).

-include_lib("lager/include/lager.hrl").

-define(SERVER, ?MODULE).
-define(SVRNAME(VSN), list_to_atom(atom_to_list(?SERVER)++VSN).
-define(CONFPATH,"conf").
-define(APP_START(APP), app_helper:start_app(application:start(APP))).
-define(APP_STOP(APP), app_helper:stop_app(application:stop(APP))).


-record(state, {
		conf
}).

start()->  
  ?APP_START(os_mon),
  ?APP_START(appmon),
  ?APP_START(sasl),
  ?APP_START(mnesia),
  ?APP_START(syntax_tools),
  ?APP_START(compiler),
  ?APP_START(goldrush),
  ?APP_START(lager),
  ?APP_START(?SERVER).

stop()->
  ?APP_STOP(?SERVER).
  ?APP_STOP(lager),
  ?APP_STOP(goldrush),
  ?APP_STOP(compiler),
  ?APP_STOP(syntax_tools),
  ?APP_STOP(mnesia),
  ?APP_STOP(appmon),
  ?APP_STOP(os_mon),
  ?APP_STOP(sasl).

load_config()-> ok.

load_config()


