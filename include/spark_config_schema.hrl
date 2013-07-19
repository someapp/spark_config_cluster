-ifndef(SPARK_CONFIG_SCHEMA_HRL).
-define(SPARK_CONFIG_SCHEMA_HRL, true).

-record(spark_config_schema, {
	memberid :: bitstring(),
	brandid :: bitstring(),
	presence :: bitstring(),
	token :: pos_integer()
}).

-export_records([spark_config_schema]).
-endif.