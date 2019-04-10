
CREATE PROCEDURE [dbo].[CompleteTaskExecutionInstance]
	@TaskExecutionInstanceID int,
	@TaskFailed bit
AS
	DECLARE @LogDtTime DATETIME
	
	SET @LogDtTime = getdate()
	
	UPDATE dbo.TaskExecutionInstance
	SET
		StatusCode = CASE WHEN (@TaskFailed = '0') THEN 'S' ELSE 'F' END,
		StatusUpdateDateTime = @LogDtTime,
		EndDateTime = @LogDtTime
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
	
	IF (@TaskFailed= '0')
	BEGIN
		UPDATE t
		SET LastRunDateTime = @LogDtTime
		FROM config.Task t
		JOIN dbo.TaskExecutionInstance l ON (l.TaskID = t.TaskID)
		WHERE l.TaskExecutionInstanceID = @TaskExecutionInstanceID
	END
		