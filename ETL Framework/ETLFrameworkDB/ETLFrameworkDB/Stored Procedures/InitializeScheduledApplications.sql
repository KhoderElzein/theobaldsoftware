
CREATE PROCEDURE [dbo].[InitializeScheduledApplications]

AS
	INSERT INTO dbo.ApplicationExecutionInstance (
		ApplicationID,
		ApplicationScheduleID,
		ApplicationName,
		RecoveryActionCode,
		StatusCode,
		ExecutionAborted
	)
	SELECT
		a.ApplicationID,
		s.ApplicationScheduleID,
		a.ApplicationName,
		a.RecoveryActionCode,
		'I' AS StatusCode, --Status Code Initialized
		'0' AS ExecutionInstanceAborted
	FROM config.Application a
	JOIN config.ApplicationSchedule s ON (a.ApplicationID = s.ApplicationID)
	WHERE NextRunDateTime <= getdate()
	AND a.IsDisabled = '0'
	AND NOT EXISTS (
		SELECT *
		FROM dbo.ApplicationExecutionInstance l
		WHERE (
			(StatusCode = 'I' OR StatusCode = 'E')  OR --pending or active runs
			(StatusCode = 'F' AND RecoveryActionCode = 'R') --failed runs that will be retried
		)
	)