GetTimeFromSeconds = function(unix)
	--- Return hours, minutes, and seconds from unix
	local hours	= floor(unix / 3600 % 24)
	local minutes	= floor(unix / 60 % 60)
	local seconds	= floor(unix % 60)

	return hours, minutes, seconds
end
