
CREATE PROCEDURE [dbo].[CheckTaskPrecendent]
	@TaskExecutionID int
AS
	SET NOCOUNT ON;
	
	DECLARE @ApplicationExecutionID int
	DECLARE @PrecendentTaskID int
	DECLARE @PrecendentStatus nchar(1)
	DECLARE @PrecendentComplete	int
	
	SELECT
		@ApplicationExecutionID = ApplicationExecutionInstanceID,
		@PrecendentTaskID = PrecendentTaskID
	FROM dbo.TaskExecutionInstance
	WHERE TaskExecutionInstanceID = @TaskExecutionID
		
	SELECT
		@PrecendentStatus = StatusCode
	FROM dbo.TaskExecutionInstance
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionID
	AND TaskID = @PrecendentTaskID
	
	IF (@PrecendentStatus IS NULL OR @PrecendentStatus = 'S')
	BEGIN
		SET @PrecendentComplete = '1'
	END
	ELSE IF (@PrecendentStatus = 'E' OR @PrecendentStatus = 'F' OR @PrecendentStatus = 'U' OR @PrecendentStatus = 'P')
	BEGIN
		SET @PrecendentComplete = '-1'
	END
	ELSE
	BEGIN
		SET @PrecendentComplete = '0'
	END
	
	SELECT @PrecendentComplete