CREATE PROCEDURE [config].[UpdateApplicationSchedule]
	@ApplicationScheduleID int
AS
	DECLARE @LastRunDate datetime
	DECLARE @FrequencyType nchar(1)
	DECLARE @FrequencyInterval int
	DECLARE @FrequencySubDayType nchar(1)
	DECLARE @FrequencySubDayInterval int
	DECLARE @nthInterval int	
	DECLARE @StartTime int
	DECLARE @EndTime int
	DECLARE @NextRunDate datetime

	SELECT
		@LastRunDate = COALESCE(COALESCE(NextRunDateTime, LastRunDateTime), getdate()),
		@FrequencyType = FrequencyType,
		@FrequencyInterval = FrequencyInterval,
		@FrequencySubDayType = SubdayType,
		@FrequencySubDayInterval = SubdayInterval,
		@nthInterval = RelativeInterval,
		@StartTime = StartTime,
		@EndTime = EndTime
	FROM config.ApplicationSchedule a
	JOIN config.Schedule s ON (a.ScheduleID = s.ScheduleID)
	WHERE a.ApplicationScheduleID = @ApplicationScheduleID
	AND a.IsEnabled = '1'
	AND a.IsDisabled = '0'
	
	EXEC config.CalculateNextScheduleRunDate 
		@LastRunDate,
		@FrequencyType,
		@FrequencyInterval,
		@FrequencySubDayType,
		@FrequencySubDayInterval,
		@nthInterval,
		@StartTime,
		@EndTime,
		@NextRunDate OUT

	UPDATE config.ApplicationSchedule
	SET
		LastRunDateTime	= NextRunDateTime,
		NextRunDateTime = @NextRunDate
	WHERE ApplicationScheduleID = @ApplicationScheduleID