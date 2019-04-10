CREATE PROCEDURE [reports].[GetTaskHistory]
	@TaskID int
AS
	SELECT
		l.TaskExecutionInstanceID,
		l.TaskID,
		l.TaskPackageExecutionID,
		l.TaskPackageID,
		a.SSISExecutionID,
		t.TaskName,
		l.PackageName,
		l.StartDateTime,
		l.EndDateTime,
		CAST(DATEDIFF(n, l.StartDateTime, l.EndDateTime) AS varchar(50)) + ':' +
					RIGHT('0' + CAST(DATEDIFF(s, l.StartDateTime, l.EndDateTime) AS varchar(50)), 2) + ':' +
						CAST(DATEDIFF(ms, l.StartDateTime, l.EndDateTime) AS varchar(50))
					AS ExecutionTime,
		s.CodeDescription AS StatusCodeDescription,
		f.CodeDescription AS FailureActionCodeDescription,
		r.CodeDescription AS RecoveryActionCodeDescription,
		l.ParallelChannel,
		l.ExecutionOrder,
		l.ExecuteAsync,
		l.ExtractRowCount,
		l.InsertRowCount,
		l.UpdateRowCount,
		l.DeleteRowCount,
		l.ErrorRowCount
	FROM dbo.TaskExecutionInstance l
	JOIN dbo.ApplicationExecutionInstance a ON (l.ApplicationExecutionInstanceID = a.ApplicationExecutionInstanceID)
	JOIN config.Task t ON (t.TaskID = l.TaskID)
	JOIN config.FrameworkCodes f ON (l.FailureActionCode = f.FrameworkCode AND f.CodeType='Failure Action')
	JOIN config.FrameworkCodes r ON (l.RecoveryActionCode = r.FrameworkCode AND r.CodeType='Recovery Mode')
	JOIN config.FrameworkCodes s ON (l.StatusCode = s.FrameworkCode AND s.CodeType='Task Status')
	WHERE l.TaskID=@TaskID
	ORDER BY l.StartDateTime DESC