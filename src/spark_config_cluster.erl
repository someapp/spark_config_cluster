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
	    confsrc = [],
		configList = []
}).

start_link(Args) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, Args ,[]).

init(Args)->
	[{Path, Conf}] = Args,
    Start = app_util:os_now(),
    error_logger:info_msg("Initiating ~p with config ~p ~p", [?SERVER, Path, File]),
    
    {ok, [ConfList]} = app_config_util:load_config(Path,File),
    {ok, #state{confsrc = lists:concat([Path,"/",Conf])}}.

start()->
   	gen_server:call(?SERVER, start).

stop()->
 	gen_server:call(?SERVER, stop).



create_user_webpresence()->
  	Start = app_util:os_now(),
 	Schema = node(),
 	Ret = case mnesia:create_schema([Schema]) of
  		ok ->
  			ok = app_util:start_app(mnesia),
        	error_logger:info_msg("Create user_presence table", []),
  			{atomic, ok} = mnesia:create_table(user_webpresence,
  							[{ram_copies, [node()]},
  							{type, set},
  							{attribute, record_info(fields, user_webpresence)},
  							{index, [memberid]}
  							]), 
  			R = mnesia:add_table_index(user_webpresence, memberid),
      		error_logger:info_msg("Created table user_webpresence table with {atomic, ok} index for user_presence table status ~p", [R]),
      		R;
  		{error,{S, {already_exists, S}}} -> 
        	error_logger:info_msg("Failure to create_schema: ~p", [{S, {already_exists, S}}]),
        	%ok = should_delete_schema(Schema),
        	ok = app_util:start_app(mnesia);
    	Else ->
        	error_logger:error_msg("Failure to create_schema: ~p", [Else]),
        	ok = app_util:start_app(mnesia)
  	end,
  	End = app_util:os_now(),
  	error_logger:info_msg("Create user_presence table ~p Start ~p End ~p", [?SERVER, Start, End]),
  	Ret.