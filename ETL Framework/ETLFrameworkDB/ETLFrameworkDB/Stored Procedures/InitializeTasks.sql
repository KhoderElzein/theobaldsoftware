CREATE PROCEDURE [dbo].[InitializeTasks]
	@ApplicationExecutionInstanceID int
AS
	SET NOCOUNT ON;
	
	DECLARE @ApplicationID int
	DECLARE @ErrorMessage nvarchar(255)
	
	IF (
		SELECT COUNT(*)
		FROM dbo.TaskExecutionInstance
		WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
		) > 0
	BEGIN
		SET @ErrorMessage = 'Tasks cannot be intialized more than once (Application ExecutionInstance ID: ' +
			CONVERT(nvarchar(50), @ApplicationExecutionInstanceID) + ').'
		RAISERROR(@ErrorMessage, 10, 1)
		
		RETURN
	END
	
	
	SELECT @ApplicationID = ApplicationID
	FROM dbo.ApplicationExecutionInstance
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	
	INSERT INTO dbo.TaskExecutionInstance
	(
		ApplicationExecutionInstanceID,
		TaskID,
		PrecendentTaskID,
		ExecuteAsync,
		FailureActionCode,
		RecoveryActionCode,
		ParallelChannel,
		ExecutionOrder,
		PackagePath,
		PackageName,
		StatusCode,
		StatusUpdateDateTime
	)	
	SELECT
		@ApplicationExecutionInstanceID,
		t.TaskID,
		t.PrecendentTaskID,	
		t.ExecuteAsync,
		t.FailureActionCode,
		t.RecoveryActionCode,
		t.ParallelChannel,
		t.ExecutionOrder,
		p.PackagePath,
		p.PackageName,
		'I', -- Status Code for Pending
		getdate()
	FROM config.Task t
	JOIN config.Package p ON (t.PackageID = p.PackageID)
	WHERE t.ApplicationID = @ApplicationID 
	AND t.IsActive = '1'
	AND t.IsDisabled = '0'