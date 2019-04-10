CREATE TABLE [log].[TaskExecutionVariableLog] (
    [VariableLogID]           INT            IDENTITY (1, 1) NOT NULL,
    [TaskExecutionInstanceID] INT            NOT NULL,
    [VariableName]            NVARCHAR (255) NOT NULL,
    [VariableValue]           NTEXT          NULL,
    [LoggedDateTime]          DATETIME       NOT NULL,
    CONSTRAINT [PK_TaskExecutionVariableLog] PRIMARY KEY CLUSTERED ([VariableLogID] ASC)
);

