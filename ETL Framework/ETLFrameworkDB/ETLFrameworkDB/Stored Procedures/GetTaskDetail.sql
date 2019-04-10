CREATE PROCEDURE [dbo].[GetTaskDetail]
	@TaskExecutionInstanceID int
AS
	SELECT
		ApplicationExecutionInstanceID,
		PackageName,
		PackagePath,
		FailureActionCode,
		ExecuteAsync
	FROM dbo.TaskExecutionInstance
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID