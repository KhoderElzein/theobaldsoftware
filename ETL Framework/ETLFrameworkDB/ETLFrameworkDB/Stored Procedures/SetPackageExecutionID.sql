CREATE PROCEDURE [dbo].[SetPackageExecutionID]
	@TaskExecutionInstanceID int,
	@PkgExecutionID nvarchar(50),
	@PkgID nvarchar(50)
AS
	DECLARE @PackageExecutionID uniqueidentifier
	DECLARE @PackageID uniqueidentifier

	SET @PackageExecutionID = CAST(@PkgExecutionID AS uniqueidentifier)
	SET @PackageID = CAST(@PkgID AS uniqueidentifier)

	UPDATE dbo.TaskExecutionInstance
	SET
		TaskPackageID = @PackageID,
		TaskPackageExecutionID = @PackageExecutionID
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
	
	
		
		