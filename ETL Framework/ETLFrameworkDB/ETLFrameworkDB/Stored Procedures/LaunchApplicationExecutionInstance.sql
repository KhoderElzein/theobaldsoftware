CREATE PROCEDURE [dbo].[LaunchApplicationExecutionInstance]
	@ApplicationID int,
	@ApplicationScheduleID int,
	@SSISExecutionInstanceID bigint,
	@PkgExecutionID nvarchar(50)
AS
	SET NOCOUNT ON;
	
	DECLARE @ApplicationExecutionInstanceID int
	DECLARE @out TABLE (ExecutionInstanceID int);
	DECLARE @RecoveryActionCode nchar(1)
	DECLARE @StatusCode nchar(1)
	DECLARE @ApplicationName nvarchar(50)
	DECLARE @IsApplicationRecovery bit
	DECLARE @PackageExecutionID uniqueidentifier

	SET @PackageExecutionID = CAST(@PkgExecutionID AS uniqueidentifier)

	--Determine if we are either running an initialized app
	--or if we are recovering an app
	SELECT
		@ApplicationName = ApplicationName,
		@ApplicationExecutionInstanceID = ApplicationExecutionInstanceID,
		@StatusCode = StatusCode
	FROM dbo.ApplicationExecutionInstance
	WHERE ApplicationID = @ApplicationID
	AND (StatusCode = 'I'
	OR (StatusCode = 'F' AND RecoveryActionCode = 'R'))
			
	IF (@ApplicationExecutionInstanceID IS NULL)
	BEGIN
		--Get the application info
		SELECT 
			@ApplicationName = ApplicationName,
			@RecoveryActionCode = RecoveryActionCode
		FROM config.Application
		WHERE ApplicationID = @ApplicationID
		
		SET @IsApplicationRecovery = '0'
		SET @ApplicationScheduleID = NULL
		
		--Insert our app ExecutionInstance record and get the id		
		INSERT INTO dbo.ApplicationExecutionInstance
		(
			ApplicationID,
			ApplicationScheduleID,
			ApplicationName,
			RecoveryActionCode,
			SSISExecutionID,
			PackageExecutionID,
			StartDateTime,
			StatusCode,
			ExecutionAborted			
		)
		OUTPUT INSERTED.ApplicationExecutionInstanceID INTO @out
		VALUES
		(
			@ApplicationID,
			@ApplicationScheduleID,
			@ApplicationName,
			@RecoveryActionCode,
			@SSISExecutionInstanceID,
			@PackageExecutionID,
			getdate(),
			'E',
			'0'
		)
		
		SELECT @ApplicationExecutionInstanceID = ExecutionInstanceID FROM @out
	END
	ELSE
	BEGIN
		--This is either an initialized ExecutionInstance or we are recovering		
		IF (@StatusCode = 'F') --We are recovering the app
		BEGIN		
			SET @IsApplicationRecovery = '1'
		END
		
		UPDATE dbo.ApplicationExecutionInstance
		SET
			SSISExecutionID = @SSISExecutionInstanceID,
			PackageExecutionID = @PackageExecutionID,
			StartDateTime = getdate(),
			StatusCode = 'E',
			ExecutionAborted = '0'
		WHERE
			ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	END
	
	SELECT @ApplicationExecutionInstanceID, @ApplicationName, @IsApplicationRecovery