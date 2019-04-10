CREATE TABLE [config].[Task] (
    [TaskID]             INT           IDENTITY (1, 1) NOT NULL,
    [TaskName]           NVARCHAR (50) NOT NULL,
    [ApplicationID]      INT           NOT NULL,
    [PackageID]          INT           NOT NULL,
    [ParallelChannel]    INT           NOT NULL,
    [ExecutionOrder]     INT           NOT NULL,
    [PrecendentTaskID]   INT           NULL,
    [ExecuteAsync]       BIT           NOT NULL,
    [FailureActionCode]  NCHAR (1)     NOT NULL,
    [RecoveryActionCode] NCHAR (1)     NOT NULL,
    [LastRunDateTime]    DATETIME      NULL,
    [IsActive]           BIT           NOT NULL,
    [IsDisabled]         BIT           CONSTRAINT [DF_Task_IsDisabled] DEFAULT ('0') NOT NULL,
    CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED ([TaskID] ASC),
    CONSTRAINT [FK_Task_Application] FOREIGN KEY ([ApplicationID]) REFERENCES [config].[Application] ([ApplicationID]),
    CONSTRAINT [FK_Task_Package] FOREIGN KEY ([PackageID]) REFERENCES [config].[Package] ([PackageID]),
    CONSTRAINT [FK_Task_Task] FOREIGN KEY ([PrecendentTaskID]) REFERENCES [config].[Task] ([TaskID])
);

