CREATE PROCEDURE [log].[TaskExecutionInstanceHeartBeat]
	@TaskExecutionInstanceID int
AS
	UPDATE dbo.TaskExecutionInstance
	SET
		StatusUpdateDateTime = getdate()
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
	
	
		
		