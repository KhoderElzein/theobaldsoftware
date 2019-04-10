CREATE PROCEDURE [dbo].[AbortApplicationExecution]
	@ApplicationExecutionInstanceID int
AS
	UPDATE dbo.ApplicationExecutionInstance
	SET
		ExecutionAborted = '1',
		StatusCode = 'F'
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
