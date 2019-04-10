CREATE PROCEDURE [dbo].[UpdateTaskExecutionStatus]
	@TaskExecutionID int,
	@StatusCode nchar(1)
AS
	UPDATE dbo.TaskExecutionInstance
	SET
		StatusCode = @StatusCode,
		StatusUpdateDateTime = getdate()
	WHERE TaskExecutionInstanceID = @TaskExecutionID