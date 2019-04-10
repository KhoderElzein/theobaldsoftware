CREATE PROCEDURE log.LogTaskVariableChange
	@TaskExecutionInstanceID int, 
	@VariableName varchar(255), 
	@VariableValue ntext
AS
	INSERT [log].[TaskExecutionVariableLog] (
		TaskExecutionInstanceID, VariableName, VariableValue, LoggedDateTime
	) VALUES (
		@TaskExecutionInstanceID, 
		@VariableName, 
		@VariableValue, 
		GETDATE()
	)