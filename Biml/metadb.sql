CREATE DATABASE SAP_Meta
GO
USE [SAP_Meta]
GO
CREATE SCHEMA meta
GO


CREATE TABLE [meta].[Connections](
	[ConnectionID] [int] IDENTITY(1,1) NOT NULL,
	[ConnectionName] [varchar](255) NOT NULL,
	[ConnectionString] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Connections] PRIMARY KEY CLUSTERED 
(
	[ConnectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [meta].[Connections] (ConnectionName,ConnectionString) VALUES ('SAP_Warehouse','Data Source=.;Initial Catalog=SAP_Warehouse;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;');
INSERT INTO [meta].[Connections] (ConnectionName,ConnectionString) VALUES ('Meta','Data Source=.;Initial Catalog=SAP_Meta;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;');
INSERT INTO [meta].[Connections] (ConnectionName,ConnectionString) VALUES ('SAP','USER=Elzein PASSWD=Erfolg12 LANG=DE CLIENT=800 ASHOST=ec5.theobald-software.com SYSNR=0');

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

CREATE TABLE [meta].[SAP_FieldInfo](
	[TABNAME] [nvarchar](30) NULL,
	[FIELDNAME] [nvarchar](30) NULL,
	[POSITION] [nvarchar](4) NULL,
	[INTTYPE] [nvarchar](1) NULL,
	[LENG] [nvarchar](6) NULL,
	[DECIMALS] [nvarchar](6) NULL,
	[KEYFLAG] [nvarchar](1) NULL,
	[CHECKTABLE] [nvarchar](30) NULL,
	[DDTEXT] [nvarchar](60) NULL
) ON [PRIMARY]
GO

CREATE VIEW [meta].[SAP_UseColumns] AS
SELECT *, CASE WHEN inttype IN ('P') THEN 'Decimal'
          WHEN inttype IN ('C', 'N', 'D', 'T', 'F', 'X') THEN 'String'
          WHEN inttype IN ('I') THEN 'Int64' ELSE 'UNKNOWN' END BimlType
FROM(SELECT SAP.*
     FROM [meta].[SAP_FieldInfo] SAP
          INNER JOIN meta.sap_columns COL ON SAP.tabname=COL.tabname AND SAP.FIELDNAME=COL.fieldname
     UNION ALL
     SELECT SAP.*
     FROM [meta].[SAP_FieldInfo] SAP
          LEFT JOIN meta.sap_columns COL ON SAP.tabname=COL.tabname
     WHERE COL.tabname IS NULL)a;

-- Insert into SAP_Tables
INSERT INTO [meta].[SAP_Tables] (TABNAME,Custom_Function) VALUES ('MAKT','')
INSERT INTO [meta].[SAP_Tables] (TABNAME,Custom_Function) VALUES ('T001','Z_XTRACT_IS_TABLE')
-- Insert into SAP_Columns
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MAKT','MANDT')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MAKT','MATNR')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MAKT','SPRAS')
INSERT INTO [meta].[SAP_Columns] (TABNAME,FIELDNAME) VALUES ('MAKT','MAKTX')
