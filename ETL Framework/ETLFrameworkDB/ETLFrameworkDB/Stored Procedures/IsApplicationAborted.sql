CREATE PROCEDURE dbo.IsApplicationAborted
	@ApplicationExecutionInstanceID int
AS
	SELECT
		ExecutionAborted
	FROM dbo.ApplicationExecutionInstance
	WHERE ApplicationExecutionInstanceID=@ApplicationExecutionInstanceID