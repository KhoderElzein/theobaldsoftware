CREATE PROCEDURE [dbo].[CompleteApplicationExecutionInstance]
	@ApplicationExecutionInstanceID int
AS
	DECLARE @Status nchar(1)
	
	SET @Status = 'S' -- Default to 'Successful' ExecutionInstance
	
	-- Any task that were initialized but not attempted set them to unattempted
	UPDATE dbo.TaskExecutionInstance
	SET
		StatusCode = 'U',
		StatusUpdateDateTime = getdate()
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	AND StatusCode = 'I'
	
	--If the application aborted set the status to 'Failed'
	IF (SELECT ExecutionAborted 
		FROM dbo.ApplicationExecutionInstance
		WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID) = '1'
	BEGIN
		SET @Status = 'F' 
	END
	
	UPDATE dbo.ApplicationExecutionInstance
	SET
		EndDateTime = getdate(),
		StatusCode = @Status
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID