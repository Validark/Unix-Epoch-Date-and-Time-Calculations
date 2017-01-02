-- Efficient time functions
-- @author Narrev

local ceil = math.ceil
local floor = math.floor
local format = string.format

local function IsLeapYear(Year)
        --- Returns if integer Year is a leapyear
        return Year % 4 == 0 and (Year % 25 ~= 0 or Year % 16 == 0)
        
        -- The numbers above are basically a factored version of the numbers below (prime factorize them)
        -- Year % 4 == 0 and (Year % 100 ~= 0 or Year % 400 == 0)
end

local function SecondsToStamp(Seconds)
    -- Converts 65 seconds to 01:05, and so on
    return format("%d:%02d", Seconds / 60, Seconds % 60)
end

local function GetTimeFromSeconds(Seconds)
	--- Return Hours, Minutes, and seconds from seconds since 1970
	local Hours = floor(Seconds / 3600 % 24)
	local Minutes = floor(Seconds / 60 % 60)
	local Seconds = floor(Seconds % 60)
	
	return Hours, Minutes, Seconds
end

local function GetYMDFromSeconds(Seconds)
	--- Most efficient calculations for finding Year, month, and days.
	-- @returns the Year, Month, and Days, from seconds since 1970
        -- @param number seconds The amount of seconds since January 1st, 1970
	-- Taken from http://howardhinnant.github.io/date_algorithms.html#weekday_from_days
	
	local Days = floor(Seconds / 86400) + 719468
	local wday = (Days + 3) % 7 -- Here is a weekday if you want :D
	local Year = floor((Days >= 0 and Days or Days - 146096) / 146097) -- 400 Year bracket
	Days = (Days - Year * 146097) -- Days into 400 Year bracket [0, 146096]
	local Years = floor((Days - floor(Days/1460) + floor(Days/36524) - floor(Days/146096))/365)	-- Years into 400 Year bracket[0, 399]
	Days = Days - (365*Years + floor(Years/4) - floor(Years/100))			-- Days into Year (March 1st is first day) [0, 365]
	local Month = floor((5*Days + 2)/153) -- Month of Year (March is month 0) [0, 11]
	Days = Days - floor((153*Month + 2)/5) + 1 -- Days into month [1, 31]
	Month = Month + (Month < 10 and 3 or -9) -- Real life month [1, 12]
	Year = Years + Year*400 + (Month < 3 and 1 or 0) -- Actual Year (Shift 1st month from March to January)
	
	return Year, Month, Days
end
