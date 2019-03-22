CREATE DATABASE BRMetadata
Go
Use BRMetadata
GO
CREATE SCHEMA di
CREATE TABLE [di].[Connections] (ConnectionID int identity(1,1) Not NULL
         Constraint PK_Connections Primary Key
      , ConnectionName varchar(255) Not NULL
      , ConnectionString varchar(255) Not NULL
  )
  Go

  INSERT INTO [di].[Connections]
 (ConnectionName
 ,ConnectionString)
VALUES
 ('ContosoSource','Provider=SQLNCLI11;Data Source=vDemo\Demo;Integrated Security=SSPI;Initial Catalog=ContosoOLTP;')
,('ContosoTarget','Provider=SQLNCLI11;Data Source=vDemo\Demo;Integrated Security=SSPI;Initial Catalog=ContosoRetailDW;')

CREATE TABLE [di].[Databases]
  (
        DatabaseID int identity(1,1) Not NULL
         Constraint PK_Databases Primary Key
      , ConnectionID int Not Null
         Constraint FK_Databases_Connections Foreign Key
          References [di].[Connections](ConnectionID)
      , DatabaseName varchar(255) Not NULL
  )
GO
INSERT INTO [di].[Databases]
(ConnectionID
,DatabaseName)
VALUES
 ((Select ConnectionID From [di].[Connections] Where ConnectionName = 'ContosoSource')
 ,'ContosoOLTP')
,((Select ConnectionID From [di].[Connections] Where ConnectionName = 'ContosoTarget')
 ,'ContosoRetailDW')


 CREATE TABLE [di].[Schemas]
  (
        SchemaID int identity(1,1) Not NULL
         Constraint PK_Schemas Primary Key
      , DatabaseID int Not Null
         Constraint FK_Schemas_Databases Foreign Key
          References [di].[Databases](DatabaseID)
      , SchemaName varchar(255) Not NULL
  )
GO
INSERT INTO [di].[Schemas]
(DatabaseID
,SchemaName)
VALUES
 ((Select DatabaseID From [di].[Databases] Where DatabaseName = 'ContosoOLTP')
 ,'dbo')
,((Select DatabaseID From [di].[Databases] Where DatabaseName = 'ContosoRetailDW')
 ,'dbo')


 CREATE TABLE [di].[Tables]
  (
        TableID int identity(1,1) Not NULL
         Constraint PK_Tables Primary Key
      , SchemaID int Not Null
         Constraint FK_Tables_Schemas Foreign Key
          References [di].[Databases](DatabaseID)
      , TableName varchar(255) Not NULL
  )
GO
INSERT INTO [di].[Tables]
(SchemaID
,TableName)
VALUES
 ((Select SchemaID From [di].[Schemas] Where DatabaseID = (Select DatabaseID From [di].[Databases] Where DatabaseName = 'ContosoOLTP'))
 ,'Channel')
,((Select SchemaID From [di].[Schemas] Where DatabaseID = (Select DatabaseID From [di].[Databases] Where DatabaseName = 'ContosoRetailDW'))
 ,'DimChannel')

 CREATE TABLE [di].[Columns]
  (
        ColumnID int identity(1,1) Not NULL
         Constraint PK_Columns Primary Key
      , TableID int Not Null
         Constraint FK_Columns_Tables Foreign Key
          References [di].[Tables](TableID)
      , ColumnName varchar(255) Not NULL
      , DataType  varchar(255) Not NULL
      , [Length] int Not NULL
      , IsNullable bit Not NULL
      , IsIdentity bit Not NULL
  )
GO
INSERT INTO [di].[Columns]
(TableID
,ColumnName
,DataType
,[Length]
,IsNullable
,IsIdentity
)
VALUES
 ((Select TableID From [di].[Tables] Where TableName = 'Channel')
 ,'Label', 'String', 100, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'Channel')
 ,'Name', 'String', 20, 1, 0)
,((Select TableID From [di].[Tables] Where TableName = 'Channel')
 ,'Description', 'String', 50, 1, 0)
,((Select TableID From [di].[Tables] Where TableName = 'Channel')
 ,'LastUpdatedDate', 'Date', 0, 1, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimChannel')
 ,'ChannelLabel', 'String', 100, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimChannel')
 ,'ChannelName', 'String', 20, 1, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimChannel')
 ,'ChannelDescription', 'String', 50, 1, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimChannel')
 ,'UpdateDate', 'DateTime', 0, 1, 0)


CREATE TABLE [di].[Mappings]
  (
        MappingID int identity(1,1) Not NULL
         Constraint PK_Mappings Primary Key
      , SourceColumnID int Not Null
         Constraint FK_Mappings_SourceColumns Foreign Key
          References [di].[Columns](ColumnID)
      , TargetColumnID int Not Null
         Constraint FK_Mappings_TargetColumns Foreign Key
          References [di].[Columns](ColumnID)
      , IsBusinessKey bit Not Null
         Constraint DF_Mappings_IsBusinessKey
          Default(0)
  )

INSERT INTO [di].[Mappings]
(SourceColumnID
,TargetColumnID
,IsBusinessKey)
VALUES
 (1, 5, 1)
,(2, 6, 0)
,(3, 7, 0)
,(4, 8, 0)


Create View [di].[metadataMappings]
As
 SELECT
 scn.ConnectionName As SourceConnectionName
, sd.DatabaseName As SourceDatabaseName
, ss.SchemaName As SourceSchemaName
, st.TableName As SourceTableName
, st.TableID As SourceTableID
, sc.ColumnName As SourceColumnName
, sc.ColumnID As SourceColumnID
, tcn.ConnectionName As TargetConnectionName
, td.DatabaseName As TargetDatabaseName
, ts.SchemaName As TargetSchemaName
, tt.TableName As TargetTableName
, tt.TableID As TargetTableID
, tc.ColumnName As TargetColumnName
, tc.ColumnID As TargetColumnID
, m.IsBusinessKey
From [di].[Mappings] As m
Join [di].Columns sc
  On sc.ColumnID = m.SourceColumnID
Join [di].[Tables] As st
  On st.TableID = sc.TableID
Join [di].[Schemas] As ss
  On ss.SchemaID = st.SchemaID
Join [di].[Databases] As sd
  On sd.DatabaseID = ss.DatabaseID
Join [di].[Connections] As scn
  On scn.ConnectionID = sd.ConnectionID
Join [di].Columns As tc
  On tc.ColumnID = m.TargetColumnID
Join [di].Tables As tt
  On tt.TableID = tc.TableID
Join [di].[Schemas] As ts
  On ts.SchemaID = tt.SchemaID
Join [di].[Databases] As td
  On td.DatabaseID = ts.DatabaseID
Join [di].[Connections] As tcn
  On tcn.ConnectionID = td.ConnectionID


  -- BIML Stairway Level 8 – Using the Relational Database Metadata to Build Packages
  Insert Into [di].[Tables]
(SchemaID
,TableName)
Values
 ((Select SchemaID From [di].[Schemas] Where DatabaseID = (Select DatabaseID From [di].[Databases] Where DatabaseName = 'ContosoOLTP'))
 ,'Currency')
,((Select SchemaID From [di].[Schemas] Where DatabaseID = (Select DatabaseID From [di].[Databases] Where DatabaseName = 'ContosoRetailDW'))
 ,'DimCurrency')

 Insert Into [di].[Columns]
(TableID
,ColumnName
,DataType
,[Length]
,IsNullable
,IsIdentity
)
Values
 ((Select TableID From [di].[Tables] Where TableName = 'Currency')
 ,'CurrencyLabel', 'String', 10, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'Currency')
 ,'CurrencyName', 'String', 20, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'Currency')
 ,'CurrencyDescription', 'String', 50, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'Currency')
 ,'UpdateDate', 'DateTime', 0, 1, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimCurrency')
 ,'CurrencyLabel', 'String', 100, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimCurrency')
 ,'CurrencyName', 'String', 20, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimCurrency')
 ,'CurrencyDescription', 'String', 50, 0, 0)
,((Select TableID From [di].[Tables] Where TableName = 'DimCurrency')
 ,'UpdateDate', 'DateTime', 0, 1, 0)


 Insert Into [di].[Mappings]
(SourceColumnID
,TargetColumnID
,IsBusinessKey)
Values
 (9, 13, 1)
,(10, 14, 0)
,(11, 15, 0)
,(12, 16, 0)

-- chapter 9 

Use BRMetadata
go

Create Table [di].[Patterns] (PatternID int identity(1,1) Not NULL,PatternName varchar(255) Not NULL)

Insert Into [di].[Patterns] (PatternName) Values('InstrumentedNewOnly')

Select * From [di].[Tables]

Create Table [di].[TablePatterns]
(TablePatternID int identity(1,1) Not NULL
,TableID int Not NULL
,PatternID int Not NULL)

Insert Into [di].[TablePatterns]
(TableID, PatternID)
Values
 (2, 1)
,(4, 1)

USE [ContosoRetailDW]
GO
CREATE TABLE [dbo].[stage_DimChannel](
      [ChannelKey] [int] NOT NULL,
      [ChannelLabel] [nvarchar](100) NOT NULL,
      [ChannelName] [nvarchar](20) NULL,
      [ChannelDescription] [nvarchar](50) NULL,
      [ETLLoadID] [int] NULL,
      [LoadDate] [datetime] NULL,
      [UpdateDate] [datetime] NULL)

CREATE TABLE [dbo].[stage_DimCurrency](
      [CurrencyKey] [int] NOT NULL,
      [CurrencyLabel] [nvarchar](10) NOT NULL,
      [CurrencyName] [nvarchar](20) NOT NULL,
      [CurrencyDescription] [nvarchar](50) NOT NULL,
      [ETLLoadID] [int] NULL,
      [LoadDate] [datetime] NULL,
      [UpdateDate] [datetime] NULL)

Use BRMetadata
go
Select * From [di].[Patterns]

Insert Into [di].[Patterns]
(PatternName)
Values
('IncrementalLoad')

Select * From [di].[Patterns]

Select t.TableName, p.[PatternName]
From [di].[Tables] t
Join [di].[TablePatterns] tp
  On tp.[TableID] = t.[TableID]
Join [di].[Patterns] p
  On p.[PatternID] = tp.[PatternID]

Update tp
Set tp.PatternID = (Select [PatternID]
                    From [di].[Patterns]
                              Where [PatternName] = 'IncrementalLoad')
From [di].[Tables] t
Join [di].[TablePatterns] tp
  On tp.[TableID] = t.[TableID]
Join [di].[Patterns] p
  On p.[PatternID] = tp.[PatternID]
Where t.TableName = 'DimChannel'

Select t.TableName, p.[PatternName]
From [di].[Tables] t
Join [di].[TablePatterns] tp
  On tp.[TableID] = t.[TableID]
Join [di].[Patterns] p
  On p.[PatternID] = tp.[PatternID]      