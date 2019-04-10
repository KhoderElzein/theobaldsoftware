CREATE TABLE [config].[ApplicationSchedule] (
    [ApplicationScheduleID] INT      IDENTITY (1, 1) NOT NULL,
    [ApplicationID]         INT      NOT NULL,
    [ScheduleID]            INT      NOT NULL,
    [LastRunDateTime]       DATETIME NULL,
    [NextRunDateTime]       DATETIME NULL,
    [IsEnabled]             BIT      NOT NULL,
    [IsDisabled]            BIT      CONSTRAINT [DF_ApplicationSchedule_IsDisabled] DEFAULT ('0') NOT NULL,
    CONSTRAINT [PK_ApplicationSchedule] PRIMARY KEY CLUSTERED ([ApplicationScheduleID] ASC),
    CONSTRAINT [FK_ApplicationSchedule_Application] FOREIGN KEY ([ApplicationID]) REFERENCES [config].[Application] ([ApplicationID]),
    CONSTRAINT [FK_ApplicationSchedule_Schedule] FOREIGN KEY ([ScheduleID]) REFERENCES [config].[Schedule] ([ScheduleID])
);

