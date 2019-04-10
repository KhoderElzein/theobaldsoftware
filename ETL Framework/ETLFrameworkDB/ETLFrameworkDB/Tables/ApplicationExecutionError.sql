CREATE TABLE [log].[ApplicationExecutionError] (
    [ApplicationErrorID]             INT            IDENTITY (1, 1) NOT NULL,
    [ApplicationExecutionInstanceID] INT            NOT NULL,
    [ErrorCode]                      INT            NOT NULL,
    [ErrorDescription]               NTEXT          NOT NULL,
    [ErrorDateTime]                  DATETIME       NOT NULL,
    [SourceName]                     NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_ApplicationExecutionError] PRIMARY KEY CLUSTERED ([ApplicationErrorID] ASC)
);

