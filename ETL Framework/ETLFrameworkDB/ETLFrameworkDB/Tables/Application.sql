CREATE TABLE [config].[Application] (
    [ApplicationID]          INT           IDENTITY (1, 1) NOT NULL,
    [ApplicationName]        NVARCHAR (50) NOT NULL,
    [RecoveryActionCode]     NCHAR (1)     NOT NULL,
    [AllowParallelExecution] BIT           NOT NULL,
    [ParallelChannels]       INT           NOT NULL,
    [IsDisabled]             BIT           CONSTRAINT [DF_Application_IsDisabled] DEFAULT ('0') NOT NULL,
    CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED ([ApplicationID] ASC)
);

