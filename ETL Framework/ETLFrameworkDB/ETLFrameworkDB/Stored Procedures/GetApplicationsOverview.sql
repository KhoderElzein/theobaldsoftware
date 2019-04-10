CREATE PROCEDURE [reports].[GetApplicationsOverview]

AS
	WITH cte AS
	(
		SELECT
			a.ApplicationID,
			a.ApplicationName,
			l.StartDateTime AS LastStartDateTime,
			l.EndDateTime AS LastEndDateTime,
			CAST(DATEDIFF(n, l.StartDateTime, l.EndDateTime) AS varchar(50)) + ':' +
				RIGHT('0' + CAST(DATEDIFF(s, l.StartDateTime, l.EndDateTime) AS varchar(50)), 2) + ':' +
					CAST(DATEDIFF(ms, l.StartDateTime, l.EndDateTime) AS varchar(50))
				AS LastExecutionTime,
			CASE WHEN (l.ExecutionAborted = '0') THEN 'False' ELSE 'True' END AS LastExecutionAborted,
			f.CodeDescription AS LastStatusCodeDescription,
			s.NextScheduleRunDateTime,
			ExecutionRank = ROW_NUMBER() OVER (
				PARTITION BY l.ApplicationID
				ORDER BY l.StartDateTime DESC
			)
		FROM dbo.ApplicationExecutionInstance l
		OUTER APPLY (
			SELECT
				s.ApplicationID,
				MIN(s.NextRunDateTime) AS NextScheduleRunDateTime
			FROM config.ApplicationSchedule s
			WHERE s.ApplicationID = l.ApplicationID
			GROUP BY s.ApplicationID		
		) s
		JOIN config.Application a ON (l.ApplicationID = a.ApplicationID)
		JOIN config.FrameworkCodes f ON (f.FrameworkCode=l.StatusCode AND f.CodeType='Run Status')
		WHERE a.IsDisabled = '0'
	)

	SELECT
		ApplicationID,
		ApplicationName,
		LastStartDateTime,
		LastEndDateTime,
		LastExecutionTime,
		LastExecutionAborted,
		LastStatusCodeDescription,
		NextScheduleRunDateTime
	FROM cte
	WHERE ExecutionRank = 1
	ORDER BY ApplicationName