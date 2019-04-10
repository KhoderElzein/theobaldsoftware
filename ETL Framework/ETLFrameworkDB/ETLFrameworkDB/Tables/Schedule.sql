CREATE TABLE [config].[Schedule] (
    [ScheduleID]        INT           IDENTITY (1, 1) NOT NULL,
    [ScheduleName]      NVARCHAR (50) NOT NULL,
    [FrequencyType]     NCHAR (1)     NOT NULL,
    [FrequencyInterval] INT           NULL,
    [SubdayType]        NCHAR (1)     NULL,
    [SubdayInterval]    INT           NULL,
    [RelativeInterval]  INT           NULL,
    [StartTime]         INT           NULL,
    [EndTime]           INT           NULL,
    CONSTRAINT [PK_Schedules] PRIMARY KEY CLUSTERED ([ScheduleID] ASC)
);

