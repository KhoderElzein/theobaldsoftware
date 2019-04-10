CREATE PROCEDURE [dbo].[LaunchTaskExecutionInstance]
	@TaskExecutionInstanceID int,
	@PkgExecutionID nvarchar(50)
AS
	DECLARE @PackageExecutionID uniqueidentifier

	SET @PackageExecutionID = CAST(@PkgExecutionID AS uniqueidentifier)

	UPDATE dbo.TaskExecutionInstance
	SET
		StatusCode = 'R', -- Started Code
		PackageExecutionID = @PackageExecutionID,
		StatusUpdateDateTime = getdate(),
		StartDateTime = getdate()
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
	
	
		
		