CREATE TABLE [log].[TaskExecutionError] (
    [TaskErrorID]             INT            IDENTITY (1, 1) NOT NULL,
    [TaskExecutionInstanceID] INT            NOT NULL,
    [ErrorCode]               INT            NOT NULL,
    [ErrorDescription]        NTEXT          NOT NULL,
    [ErrorDateTime]           DATETIME       NOT NULL,
    [SourceName]              NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_TaskExecutionError] PRIMARY KEY CLUSTERED ([TaskErrorID] ASC)
);

