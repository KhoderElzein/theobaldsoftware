CREATE PROCEDURE [log].[LogTaskExecutionError]
	@TaskExecutionInstanceID int,
	@ErrorCode int = NULL,
	@ErrorDescription ntext = NULL,
	@SourceName nvarchar(255) = NULL
AS
	IF @ErrorCode IS NOT NULL AND
		@ErrorDescription IS NOT NULL AND
		@SourceName IS NOT NULL 
	BEGIN
		INSERT INTO log.TaskExecutionError
		(
			TaskExecutionInstanceID,
			ErrorCode,
			ErrorDescription,
			ErrorDateTime,
			SourceName	
		)
		VALUES
		(
			@TaskExecutionInstanceID,
			@ErrorCode,
			@ErrorDescription,
			getdate(),
			@SourceName
		)
	END