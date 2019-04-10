CREATE TABLE [dbo].[ApplicationExecutionInstance] (
    [ApplicationExecutionInstanceID] INT              IDENTITY (1, 1) NOT NULL,
    [ApplicationID]                  INT              NOT NULL,
    [ApplicationScheduleID]          INT              NULL,
    [ApplicationName]                NVARCHAR (50)    NOT NULL,
    [RecoveryActionCode]             NCHAR (1)        NOT NULL,
    [StartDateTime]                  DATETIME         NULL,
    [EndDateTime]                    DATETIME         NULL,
    [StatusCode]                     NCHAR (1)        NOT NULL,
    [ExecutionAborted]               BIT              CONSTRAINT [DF_ApplicationExecutionInstance_ExecutionAborted] DEFAULT ('0') NOT NULL,
    [SSISExecutionID]                BIGINT           NULL,
    [PackageExecutionID]             UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_ApplicationExecutionInstance] PRIMARY KEY CLUSTERED ([ApplicationExecutionInstanceID] ASC)
);

