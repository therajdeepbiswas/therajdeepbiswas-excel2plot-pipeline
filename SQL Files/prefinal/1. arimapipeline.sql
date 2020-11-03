SET SCHEMA PALTEST;
DROP TYPE PAL_ARIMA_DATA_T;
CREATE TYPE PAL_ARIMA_DATA_T AS TABLE("TIMESTAMP" INTEGER, "X1" DOUBLE);
DROP TYPE PAL_ARIMA_CONTROL_T;
CREATE TYPE PAL_ARIMA_CONTROL_T AS TABLE("NAME" VARCHAR (50), "INTARGS" INTEGER, "DOUBLEARGS" DOUBLE, "STRINGARGS" VARCHAR (100));
DROP TYPE PAL_ARIMA_MODEL_T;
CREATE TYPE PAL_ARIMA_MODEL_T AS TABLE("NAME" VARCHAR (50), "VALUE" VARCHAR (5000));
DROP TABLE PAL_ARIMA_PDATA_TBL;
CREATE COLUMN TABLE PAL_ARIMA_PDATA_TBL("POSITION" INT, "SCHEMA_NAME" NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (1, 'PALTEST', 'PAL_ARIMA_DATA_T', 'IN');
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (2, 'PALTEST', 'PAL_ARIMA_CONTROL_T', 'IN');
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (3, 'PALTEST', 'PAL_ARIMA_MODEL_T', 'OUT');
CALL SYS.AFLLANG_WRAPPER_PROCEDURE_DROP('PALTEST', 'PAL_ARIMATRAIN_PROC');
CALL SYS.AFLLANG_WRAPPER_PROCEDURE_CREATE('AFLPAL','ARIMATRAIN', 'PALTEST', 'PAL_ARIMATRAIN_PROC', PAL_ARIMA_PDATA_TBL);
DROP TABLE PAL_ARIMA_DATA_TBL;
CREATE COLUMN TABLE PAL_ARIMA_DATA_TBL LIKE PAL_ARIMA_DATA_T;
/* INSERT INTO PAL_ARIMA_DATA_TBL queries */
INSERT INTO PAL_ARIMA_DATA_TBL VALUES(1, 57312.88);
INSERT INTO PAL_ARIMA_DATA_TBL VALUES(2, 77039.16);
INSERT INTO PAL_ARIMA_DATA_TBL VALUES(3, 71343.67);
INSERT INTO PAL_ARIMA_DATA_TBL VALUES(4, 68489.11);
INSERT INTO PAL_ARIMA_DATA_TBL VALUES(5, 53801.93);
DROP TABLE #PAL_CONTROL_TBL;
CREATE LOCAL TEMPORARY COLUMN TABLE #PAL_CONTROL_TBL ("NAME" VARCHAR(50), "INTARGS" INTEGER, "DOUBLEARGS" DOUBLE, "STRINGARGS" VARCHAR(100));
/* these can be finetuned */
INSERT INTO #PAL_CONTROL_TBL VALUES ('P', 1,null,null);
INSERT INTO #PAL_CONTROL_TBL VALUES ('Q', 1,null,null);
INSERT INTO #PAL_CONTROL_TBL VALUES ('D', 0,null,null);
INSERT INTO #PAL_CONTROL_TBL VALUES ('METHOD', 1,null,null);
INSERT INTO #PAL_CONTROL_TBL VALUES ('STATIONARY', 1,null,null);
DROP TABLE PAL_ARIMA_MODEL_TBL;
CREATE COLUMN TABLE PAL_ARIMA_MODEL_TBL LIKE PAL_ARIMA_MODEL_T;
CALL PALTEST.PAL_ARIMATRAIN_PROC(PAL_ARIMA_DATA_TBL, "#PAL_CONTROL_TBL", PAL_ARIMA_MODEL_TBL) WITH OVERVIEW;
/* forecast here on */
DROP TYPE PAL_ARIMA_MODEL_T;
CREATE TYPE PAL_ARIMA_MODEL_T AS TABLE( "NAME" VARCHAR (50), "VALUE" VARCHAR (5000));
DROP TYPE PAL_ARIMA_CONTROL_T;
CREATE TYPE PAL_ARIMA_CONTROL_T AS TABLE( "NAME" VARCHAR (50), "INTARGS" INTEGER, "DOUBLEARGS" DOUBLE, "STRINGARGS" VARCHAR (100) );
DROP TYPE PAL_ARIMA_RESULT_T;
CREATE TYPE PAL_ARIMA_RESULT_T AS TABLE( "TIMESTAMP" INTEGER, "MEAN" DOUBLE, "LOW80%" DOUBLE, "HIGH80%" DOUBLE, "LOW95%" DOUBLE, "HIGH95%" DOUBLE);
DROP TABLE PAL_ARIMA_PDATA_TBL;
CREATE COLUMN TABLE PAL_ARIMA_PDATA_TBL("POSITION" INT, "SCHEMA_NAME" NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (1, 'PALTEST', 'PAL_ARIMA_MODEL_T', 'IN');
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (2, 'PALTEST', 'PAL_ARIMA_CONTROL_T','IN');
INSERT INTO PAL_ARIMA_PDATA_TBL VALUES (3, 'PALTEST', 'PAL_ARIMA_RESULT_T','OUT');
CALL SYS.AFLLANG_WRAPPER_PROCEDURE_DROP('PALTEST', 'PAL_ARIMAFORECAST_PROC');
CALL SYS.AFLLANG_WRAPPER_PROCEDURE_CREATE('AFLPAL','ARIMAFORECAST', 'PALTEST','PAL_ARIMAFORECAST_PROC', PAL_ARIMA_PDATA_TBL);
DROP TABLE #PAL_CONTROL_TBL;
CREATE LOCAL TEMPORARY COLUMN TABLE #PAL_CONTROL_TBL ( "NAME" VARCHAR(50),"INTARGS" INTEGER,"DOUBLEARGS" DOUBLE,"STRINGARGS" VARCHAR (100));
/* forecast length has to be variablized */
INSERT INTO #PAL_CONTROL_TBL VALUES ('ForecastLength', 6,null,null);
DROP TABLE PAL_ARIMA_RESULT_TBL;
CREATE COLUMN TABLE PAL_ARIMA_RESULT_TBL LIKE PAL_ARIMA_RESULT_T;
CALL PALTEST.PAL_ARIMAFORECAST_PROC(PAL_ARIMA_MODEL_TBL, "#PAL_CONTROL_TBL",PAL_ARIMA_RESULT_TBL) WITH OVERVIEW;
SELECT * FROM PAL_ARIMA_RESULT_TBL;
