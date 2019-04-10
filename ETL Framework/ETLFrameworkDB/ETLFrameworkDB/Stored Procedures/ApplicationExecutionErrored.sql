CREATE PROCEDURE [dbo].[ApplicationExecutionErrored]
	@ApplicationExecutionID int,
	@ErrorCode int,
	@ErrorDescription ntext,
	@SourceName nvarchar(255)
AS
	UPDATE dbo.ApplicationExecutionInstance
	SET
		EndDateTime = getdate(),
		StatusCode = 'F'
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionID
	
	INSERT INTO log.ApplicationExecutionError
	(
		ApplicationExecutionInstanceID,
		ErrorCode,
		ErrorDescription,
		ErrorDateTime,
		SourceName	
	)
	VALUES
	(
		@ApplicationExecutionID,
		@ErrorCode,
		@ErrorDescription,
		getdate(),
		@SourceName
	)