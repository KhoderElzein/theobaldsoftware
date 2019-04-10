CREATE PROCEDURE [dbo].[IsApplicationRunning]
	@ApplicationID int
AS
	DECLARE @IsRunning bit
	
	IF (
		SELECT
			COUNT(*)
		FROM dbo.ApplicationExecutionInstance
		WHERE ApplicationID = @ApplicationID
		AND StatusCode = 'E'
		) > 0
	BEGIN
		SET @IsRunning = '1'
	END
	ELSE
	BEGIN
		SET @IsRunning = '0'
	END
	
	SELECT @IsRunning