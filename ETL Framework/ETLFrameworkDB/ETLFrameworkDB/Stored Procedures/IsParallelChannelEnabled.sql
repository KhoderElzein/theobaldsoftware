
CREATE PROCEDURE dbo.IsParallelChannelEnabled
	@Channel int,
	@ApplicationExecutionInstanceID int
AS
	SELECT 
		CASE WHEN (AllowParallelExecution = '1') THEN
			CASE WHEN (ParallelChannels >= @Channel) THEN
				CONVERT(bit, '1')
			ELSE
				CONVERT(bit, '0')
			END
		ELSE
			CASE WHEN (@Channel  = 1) THEN
				CONVERT(bit, '1')
			ELSE
				CONVERT(bit, '0')
			END
		END AS ChannelEnabled
	FROM dbo.ApplicationExecutionInstance e
	JOIN config.[Application] a ON (e.ApplicationID = a.ApplicationID)
	WHERE e.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
