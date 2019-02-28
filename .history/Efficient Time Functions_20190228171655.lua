-- Efficient time functions
-- @author Validark

local floor = math.floor

-- The numbers used in the following function are a factored version
-- of the numbers directly below (prime factorize them)
-- Year % 4 == 0 and (Year % 100 ~= 0 or Year % 400 == 0)
local function IsLeapYear(Year)
	return Year % 4 == 0 and (Year % 25 ~= 0 or Year % 16 == 0)
end

local function SecondsToStamp(Seconds)
    -- Converts seconds to microwave time
	-- Example: 65 seconds to 1:05
	-- @param Seconds
	-- @returns Minutes:Seconds

    return ("%d:%02d"):format(
		Seconds / 60, -- Minutes
		Seconds % 60  -- Seconds
	)
end

local SECONDS_PER_MINUTE = 60
local MINUTES_PER_HOUR = 60
local HOURS_PER_DAY = 24

local SECONDS_PER_HOUR = SECONDS_PER_MINUTE * MINUTES_PER_HOUR
local SECONDS_PER_DAY = SECONDS_PER_HOUR * HOURS_PER_DAY

local function GetTimeFromSeconds(Seconds)
	-- Return Hours, Minutes, and seconds from seconds

	Seconds = floor(Seconds)

	local Minutes = Seconds % SECONDS_PER_HOUR
	local Hours = (Seconds - Minutes) / SECONDS_PER_HOUR
	Seconds = Minutes % SECONDS_PER_MINUTE
	Minutes = (Minutes - Seconds) / SECONDS_PER_MINUTE

	return Hours % 24, Minutes, Seconds
end

local function GetYMDFromSeconds(Seconds)
	-- Most efficient calculations for finding Year, month, and days
	-- @param number seconds The amount of seconds since January 1st, 1970
	-- @returns the Year, Month, and Days, from seconds since 1970
	-- Math from http://howardhinnant.github.io/date_algorithms.html#weekday_from_days

	local Days = floor(Seconds / SECONDS_PER_DAY) + 719468

--	Here is a weekday if you want :D
--	local Weekday = 1 + (Days + 3) % 7

	local Year

	if Days >= 0 then
        Year = Days
    else
        Year = Days - 146096
	end

	Days = Year % 146097 -- Days into 400 Year bracket [0, 146096]
	Year = (Year - Days) / 146097 -- 400 Year bracket
	local Years = Days - ((Days - Days % 1460) / 1460) + ((Days - Days % 36524) / 36524) - ((Days - Days % 146096) / 146096)
	Years = (Years - Years % 365) / 365 -- Years into 400 Year bracket[0, 399]
	Days = Days - (365 * Years + (Years - Years % 4) * 0.25 - (Years - Years % 100) * 0.01) -- Days into Year (March 1st is first day) [0, 365]
	local Month = 5 * Days + 2
	Month = (Month - Month % 153) / 153 -- Month of Year (March is month 0) [0, 11]
	local x = 153 * Month + 2
	Days = Days - (x - x % 5) * 0.2 + 1 -- Days into month [1, 31]

	if Month < 10 then
		Month = Month + 3 -- Real life month [1, 12]
	else
		Month = Month - 9 -- Real life month [1, 12]
	end

	local YearOffset

	if Month < 3 then
		YearOffset = 1
	else
		YearOffset = 0
	end

	Year = Years + Year * 400 + YearOffset -- Actual Year (Shift 1st month from March to January)

	return Year, Month, Days
end
