-module(spark_mnesia_cache).

-behaviour(gen_server).


-export([start_link/0, stop/0]).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2, terminate/2,code_change/2,code_change/3]).

