CREATE PROCEDURE [dbo].[GetScheduledApplications]
AS	
	SELECT 
		l.ApplicationExecutionInstanceID,
		l.ApplicationID,
		l.ApplicationScheduleID
	FROM dbo.ApplicationExecutionInstance l
	WHERE l.ApplicationScheduleID IS NOT NULL --Ignore Application that are not run as a result of schedule
	AND (l.StatusCode = 'I' --Initialized Apps
	OR (l.StatusCode = 'F' AND l.RecoveryActionCode = 'R')) --Recovering Apps