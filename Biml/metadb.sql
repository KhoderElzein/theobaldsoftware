CREATE DATABASE BimlDemo_Theobald
GO
USE [BimlDemo_Theobald]
GO
CREATE SCHEMA meta
GO
CREATE TABLE [meta].[SAP_Tables](
    [TABNAME] [NVARCHAR](30) NULL,
    [CUSTOM_Function] [NVARCHAR](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [meta].[SAP_Tables] ADD  CONSTRAINT [DF_SAP_Tables_CUSTOM_Function]  DEFAULT ('') FOR [CUSTOM_Function]
GO
CREATE TABLE [meta].[SAP_Columns](
    [TABNAME] [NVARCHAR](50) NULL,
    [FIELDNAME] [NVARCHAR](50) NULL
) ON [PRIMARY]
GO
CREATE TABLE [meta].[SAP_DD03L](
    [TABNAME] [NVARCHAR](30) NULL,
    [FIELDNAME] [NVARCHAR](30) NULL,
    [POSITION] [NVARCHAR](4) NULL,
    [INTTYPE] [NVARCHAR](1) NULL,
    [LENG] [NVARCHAR](6) NULL,
    [DECIMALS] [NVARCHAR](6) NULL
) ON [PRIMARY]
GO
CREATE VIEW [meta].[SAP_UseColumns] AS
SELECT *, CASE WHEN inttype IN ('P') THEN 'Decimal'
          WHEN inttype IN ('C', 'N', 'D', 'T', 'F', 'X') THEN 'String'
          WHEN inttype IN ('I') THEN 'Int64' ELSE 'UNKNOWN' END BimlType
FROM(SELECT SAP.*
     FROM [meta].[SAP_DD03L] SAP
          INNER JOIN meta.sap_columns COL ON SAP.tabname=COL.tabname AND SAP.FIELDNAME=COL.fieldname
     UNION ALL
     SELECT SAP.*
     FROM [meta].[SAP_DD03L] SAP
          LEFT JOIN meta.sap_columns COL ON SAP.tabname=COL.tabname
     WHERE COL.tabname IS NULL)a;


INSERT INTO [meta].[SAP_Tables] (TABNAME,Custom_Function) VALUES ('MARA','')
INSERT INTO [meta].[SAP_Tables] (TABNAME,Custom_Function) VALUES ('T001','Z_XTRACT_IS_TABLE')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','MANDT')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','MATNR')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','ERSDA')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','ERNAM')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','MBRSH')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','MATKL')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','MEINS')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','BSTME')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','WRKST')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','BRGEW')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','NTGEW')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','GEWEI')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MARA','VOLUM')