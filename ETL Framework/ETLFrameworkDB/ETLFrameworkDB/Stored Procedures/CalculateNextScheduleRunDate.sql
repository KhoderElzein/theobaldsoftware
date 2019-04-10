CREATE  PROCEDURE [config].[CalculateNextScheduleRunDate]
	@LastRunDate datetime,
	@FrequencyType nchar(1),
	@FrequencyInterval int = null,
	@FrequencySubDayType nchar(1) = null,
	@FrequencySubDayInterval int = null,
	@nthInterval int = null,	
	@StartTime int = null,
	@EndTime int = null,
	@NextRunDate datetime OUTPUT
AS
	IF @LastRunDate IS NULL
	BEGIN
		RAISERROR('Last Run Date is Required.', 10, 1);
		RETURN;
	END
	
	IF @FrequencyType IS NULL
	BEGIN
		RAISERROR('Frequence Type Is Required.', 10, 1);
		RETURN;
	END
		
	--Daily Schedule
	IF @FrequencyType = 'D'
	BEGIN
		IF @FrequencySubDayType IS NULL
		BEGIN
			RAISERROR('Frequency Sub-Day Is Required.', 10, 1);
			RETURN;
		END
		
		--Schedule runs at a specified time each day
		IF @FrequencySubDayType = 'T'
		BEGIN
			SET @NextRunDate = DATEADD(dd, 1, @LastRunDate)
		END
		--Schedule runs evey XX minutes
		ELSE IF @FrequencySubDayType = 'M'
		BEGIN
			SET @NextRunDate = DATEADD(mi, @FrequencySubDayInterval, @LastRunDate)
		END
		--Schedule runs every XX hours
		ELSE IF @FrequencySubDayType = 'H'
		BEGIN
			SET @NextRunDate = DATEADD(hh, @FrequencySubDayInterval, @LastRunDate)
		END
		ELSE
		BEGIN
			RAISERROR('Invalid Frequency Sub-Day Type', 10, 1);
			RETURN;
		END
		
		--Determine if the next run time is outside the running window
		IF (@StartTime IS NOT NULL) AND (@EndTime IS NOT NULL)
		BEGIN
			DECLARE @RunTime int
			
			--Convert the runtime to an integer
			SET @RunTime = DATEPART(hh, @NextRunDate) * 100 +
							DATEPART(mi, @NextRunDate) * 10
			
			-- If the schedule run time is before the start time or after the end time modify it
			IF (@RunTime < @StartTime) OR (@RunTime > @EndTime)
			BEGIN
				IF (@RunTime < @StartTime)
					--Stay with the current day but drop the time
					SET @NextRunDate = DATEADD(dd, DATEDIFF(d, 0, @NextRunDate), 0)
				ELSE
					--Advance to the next day
					SET @NextRunDate = DATEADD(dd, DATEDIFF(d, -1, @NextRunDate), 0)
				
				DECLARE @hours int
				DECLARE @minutes int
				
				SET @hours = @StartTime / 100
				SET @minutes = (@StartTime - (@hours * 100))/10
				
				--Use the start time to correctly set the schedule
				SET @NextRunDate = DATEADD(hh, @hours, @NextRunDate)
				SET @NextRunDate = DATEADD(mi, @minutes, @NextRunDate)
			END
		END
	END
	--Weekly Schedule
	ELSE IF @FrequencyType = 'W'
	BEGIN
		IF @FrequencyInterval IS NULL
		BEGIN
			RAISERROR('Frequency Interval Is Required.', 10, 1);
			RETURN;
		END
		
		--Use bitwise operators to determine which days of the week the schedule is set to run for
		--Frequency interval is a bitwise or of the weekday values (1,2,4,8,16,32,64)
		--Calculate the next rundate based on the last run date week day
		
		DECLARE @WeekDays AS TABLE ([weekday] int, value tinyint, result tinyint, nextrundate datetime);
		DECLARE @LastRunDayOfWeek int
		
		SET @LastRunDayOfWeek = DATEPART(dw, @LastRunDate)

		INSERT INTO @WeekDays
		SELECT 1, 1, @FrequencyInterval & 1, DATEADD(wk, 1, DATEADD(dw, (7 - @LastRunDayOfWeek) - 6, @LastRunDate))
		UNION ALL
		SELECT 2, 2, @FrequencyInterval & 2, CASE WHEN (@LastRunDayOfWeek < 2) THEN DATEADD(dw, (7 - @LastRunDayOfWeek) - 5, @LastRunDate) ELSE DATEADD(wk, 1, DATEADD(dw, (7 - @LastRunDayOfWeek) - 5, @LastRunDate)) END
		UNION ALL
		SELECT 3, 4, @FrequencyInterval & 4, CASE WHEN (@LastRunDayOfWeek < 3) THEN DATEADD(dw, (7 - @LastRunDayOfWeek) - 4, @LastRunDate) ELSE DATEADD(wk, 1, DATEADD(dw, (7 - @LastRunDayOfWeek) - 4, @LastRunDate)) END
		UNION ALL
		SELECT 4, 8, @FrequencyInterval & 8, CASE WHEN (@LastRunDayOfWeek < 4) THEN DATEADD(dw, (7 - @LastRunDayOfWeek) - 3, @LastRunDate) ELSE DATEADD(wk, 1, DATEADD(dw, (7 - @LastRunDayOfWeek) - 3, @LastRunDate)) END
		UNION ALL
		SELECT 5, 16, @FrequencyInterval & 16, CASE WHEN (@LastRunDayOfWeek < 5) THEN DATEADD(dw, (7 - @LastRunDayOfWeek) - 2, @LastRunDate) ELSE DATEADD(wk, 1, DATEADD(dw, (7 - @LastRunDayOfWeek) - 2, @LastRunDate)) END
		UNION ALL
		SELECT 6, 32, @FrequencyInterval & 32, CASE WHEN (@LastRunDayOfWeek < 6) THEN DATEADD(dw, (7 - @LastRunDayOfWeek) - 1, @LastRunDate) ELSE DATEADD(wk, 1, DATEADD(dw, (7 - @LastRunDayOfWeek) - 1, @LastRunDate)) END
		UNION ALL
		SELECT 7, 64, @FrequencyInterval & 64, CASE WHEN (@LastRunDayOfWeek < 7) THEN DATEADD(dw, (7 - @LastRunDayOfWeek), @LastRunDate) ELSE DATEADD(wk, 1, DATEADD(dw, (7 - @LastRunDayOfWeek), @LastRunDate)) END
		
		SELECT TOP 1 @NextRunDate = nextrundate
		FROM @WeekDays
		WHERE result <> 0
		ORDER BY nextrundate
	END	
	--Monthly Schedule
	ELSE IF @FrequencyType = 'M'
	BEGIN
		IF @FrequencyInterval IS NULL
		BEGIN
			RAISERROR('Frequency Interval Is Required.', 10, 1);
			RETURN;
		END
		
		IF @nthInterval IS NULL
		BEGIN
			RAISERROR('Relative Interval Is Required.', 10, 1);
			RETURN;
		END
		
		DECLARE @FirstOfMonth datetime
		DECLARE @DaysToAdd int
		DECLARE @FirstOccurence datetime

		--Get the first day of the month
		SET @FirstOfMonth = CONVERT(smalldatetime, 
			 CONVERT(varchar(4), YEAR(DATEADD(mm, 1, @LastRunDate))) + '/' +
			 CONVERT(varchar(2), MONTH(DATEADD(mm, 1, @LastRunDate))) + '/01'
			, 110)

		--Figure out how many days we need to get to the first occurence of the specified day
		SET @DaysToAdd = (7 - (DATEPART(dw, @FirstOfMonth) - @FrequencyInterval)) % 7

		--Find the first occuring date
		SET @FirstOccurence = DATEADD(d, @DaysToAdd, @FirstOfMonth)

		--Find the next run date
		SET @NextRunDate = DATEADD(d, 7 * (@nthInterval - 1), @FirstOccurence)

		--Safety-check just in case we over shoot the end of the month
		--(i.e. We say the last(5th) Saturday of a month when there are only 4)
		IF MONTH(@NextRunDate) <> MONTH(@FirstOfMonth)
		BEGIN
			SET @NextRunDate = DATEADD(d, 7 * (@nthInterval - 2), @FirstOccurence)	
		END
	END
	ELSE
	BEGIN
		RAISERROR('Invalid Frequency Type.', 10, 1);
		RETURN;
	END