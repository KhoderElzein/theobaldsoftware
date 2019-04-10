CREATE PROCEDURE [log].[LogTaskRowCount]
	@TaskExecutionInstanceID int,
	@ExtractRowCount int,
	@InsertRowCount int,
	@UpdateRowCount int,
	@DeleteRowCount int,
	@ErrorRowCount int	
AS
	UPDATE dbo.TaskExecutionInstance
	SET
		ExtractRowCount = @ExtractRowCount,
		InsertRowCount = @InsertRowCount,
		UpdateRowCount = @UpdateRowCount,
		DeleteRowCount = @DeleteRowCount,
		ErrorRowCount = @ErrorRowCount
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID