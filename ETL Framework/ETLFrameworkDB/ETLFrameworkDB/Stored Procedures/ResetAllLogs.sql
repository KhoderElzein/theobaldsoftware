CREATE PROCEDURE config.ResetAllLogs
AS
truncate table [dbo].[ApplicationExecutionInstance]
truncate table [dbo].[TaskExecutionInstance]
truncate table [log].[ApplicationExecutionError]
truncate table [log].[TaskExecutionError]
truncate table [log].[TaskExecutionVariableLog]