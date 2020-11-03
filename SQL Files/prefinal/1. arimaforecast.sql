SET SCHEMA PALTEST;
DROP TYPE PAL_ARIMA_MODEL_T;
CREATE TYPE PAL_ARIMA_MODEL_T AS TABLE(
 "NAME" VARCHAR (50),
 "VALUE" VARCHAR (5000)
);
DROP TYPE PAL_ARIMA_CONTROL_T;
CREATE TYPE PAL_ARIMA_CONTROL_T AS TABLE(
 "NAME" VARCHAR (50),
 "INTARGS" INTEGER,
 "DOUBLEARGS" DOUBLE,
 "STRINGARGS" VARCHAR (100) );

DROP TYPE PAL_ARIMA_RESULT_T;
CREATE TYPE PAL_ARIMA_RESULT_T AS TABLE(
 "TIMESTAMP" INTEGER,
 "MEAN" DOUBLE,
 "LOW80%" DOUBLE,
 "HIGH80%" DOUBLE,
 "LOW95%" DOUBLE,
 "HIGH95%" DOUBLE
);
DROP TABLE PAL_ARIMA_PDATA_TBL;
CREATE COLUMN TABLE PAL_ARIMA_PDATA_TBL("POSITION" INT, "SCHEMA_NAME"
NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (1, 'PALTEST', 'PAL_ARIMA_MODEL_T', 'IN');
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (2, 'PALTEST', 'PAL_ARIMA_CONTROL_T',
'IN');
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (3, 'PALTEST', 'PAL_ARIMA_RESULT_T',
'OUT');
CALL SYS.AFLLANG_WRAPPER_PROCEDURE_DROP('PALTEST', 'PAL_ARIMAFORECAST_PROC');
CALL SYS.AFLLANG_WRAPPER_PROCEDURE_CREATE('AFLPAL','ARIMAFORECAST', 'PALTEST',
'PAL_ARIMAFORECAST_PROC', PAL_ARIMA_PDATA_TBL);
DROP TABLE #PAL_CONTROL_TBL;
CREATE LOCAL TEMPORARY COLUMN TABLE #PAL_CONTROL_TBL ( "NAME" VARCHAR
(50),"INTARGS" INTEGER,"DOUBLEARGS" DOUBLE,"STRINGARGS" VARCHAR (100));
INSERT INTO #PAL_CONTROL_TBL VALUES ('ForecastLength', 30,null,null);
DROP TABLE PAL_ARIMA_RESULT_TBL;
CREATE COLUMN TABLE PAL_ARIMA_RESULT_TBL LIKE PAL_ARIMA_RESULT_T;
SELECT * FROM PAL_ARIMA_MODEL_TBL;
CALL PALTEST.PAL_ARIMAFORECAST_PROC(PAL_ARIMA_MODEL_TBL, "#PAL_CONTROL_TBL",
PAL_ARIMA_RESULT_TBL) WITH OVERVIEW;
SELECT * FROM PAL_ARIMA_RESULT_TBL;
