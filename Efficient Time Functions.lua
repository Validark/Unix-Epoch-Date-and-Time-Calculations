-- Efficient time functions
-- @author Narrev

local floor, ceil = math.floor, math.ceil

local function isLeapYear(year)
        --- Returns if integer year is a leapYear
        return year % 4 == 0 and (year % 25 ~= 0 or year % 16 == 0)
        
        -- The numbers above are basically a factored version of the numbers below (prime factorize them)
        -- year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

local function GetTimeFromSeconds(seconds)
	--- Return hours, minutes, and seconds from seconds since 1970
	local hours	= floor(seconds / 3600 % 24)
	local minutes	= floor(seconds / 60 % 60)
	local seconds	= floor(seconds % 60)
	
	return hours, minutes, seconds
end

local function GetYMDFromSeconds(seconds)
	--- Most efficient calculations for finding year, month, and days.
	-- @returns the Year, Month, and Days, from seconds since 1970
        -- @param number seconds The amount of seconds since January 1st, 1970
	-- Taken from http://howardhinnant.github.io/date_algorithms.html#weekday_from_days
	
	local days	= floor(seconds / 86400) + 719468
	local wday	= (days + 3) % 7
	local year	= floor((days >= 0 and days or days - 146096) / 146097)				-- 400 Year bracket
	days		= (days - year * 146097)							-- Days into 400 year bracket [0, 146096]
	local years	= floor((days - floor(days/1460) + floor(days/36524) - floor(days/146096))/365)	-- Years into 400 Year bracket[0, 399]
	days		= days - (365*years + floor(years/4) - floor(years/100))			-- Days into year (March 1st is first day) [0, 365]
	local month	= floor((5*days + 2)/153)							-- Month of year (March is month 0) [0, 11]
	local yDay	= days										-- Hi readers :)
	days		= days - floor((153*month + 2)/5) + 1						-- Days into month [1, 31]
	month		= month + (month < 10 and 3 or -9)						-- Real life month [1, 12]
	year		= years + year*400 + (month < 3 and 1 or 0)					-- Actual year (Shift 1st month from March to January)
	return year, month, days
end
