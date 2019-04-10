CREATE  PROC [dbo].[RethrowError]
AS
	DECLARE @ErrorMessage NVARCHAR(4000),
	@ErrorNumber INT,
	@ErrorSeverity INT,
	@ErrorState INT,
	@ErrorLine INT,
	@ErrorProcedure NVARCHAR(200);
	
	SELECT 
		@ErrorNumber = ERROR_NUMBER(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = CASE WHEN ERROR_STATE() > 0 THEN ERROR_STATE() ELSE 1 END,
		@ErrorLine = ERROR_LINE(),
		@ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'),
		@ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + ERROR_MESSAGE();

	RAISERROR ( @ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber,@ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine );