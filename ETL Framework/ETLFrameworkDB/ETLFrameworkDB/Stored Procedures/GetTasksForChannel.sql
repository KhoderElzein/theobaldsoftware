CREATE PROCEDURE [dbo].[GetTasksForChannel]
	@ApplicationExecutionInstanceID int,
	@Channel int
AS
	SELECT
		l.TaskExecutionInstanceID
	FROM dbo.TaskExecutionInstance l
	WHERE l.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	AND l.ParallelChannel = @Channel	
	AND (
		(l.StatusCode = 'I')
		OR
		(
			l.StatusCode <> 'S'
			AND l.RecoveryActionCode = 'R'
		)
	)
	ORDER BY l.ExecutionOrder ASC