-module(spark_config_cluster).

-behaviour(gen_server).

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
-define(SVRNAME(VSN), list_to_atom(atom_to_list(?SERVER)++VSN)).
-define(CONFPATH,"conf").

-record(state, {
		conf_file = []
}).




