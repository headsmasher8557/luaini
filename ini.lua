local ini = {}

local matchers = {
	section = "%[(.+)%]",
	setting = "([%a%d]+) *= *(.+)"
}
local valmatchers = {
	string = "^\"(.+)\"",
	number = "^%d+"
}

--- Parse a line, returning whether its a section or a setting, and the .
---@param line string The line to parse.
---@return t string The type of the line. Either "section" or "string"
---@return vl string[] If a "section", then contains only one string value containing its name. Otherwise, return {name, value} (Would be equivalent to name=value in the line)
---@see matchers
local function ini_line(line)
	local t,vl
	for i,v in pairs(matchers) do
		local asd = {string.match(line,v)}
		if #asd > 0 then
			t = i
			vl = asd
			break
		end
	end
	return t,vl
end

--- Return the type of a value and its corresponding Lua value.
---@param str string The string to interpret.
---@return t string The type of the value.
---@return vl any The Lua equivalent of the value.
---@see valmatchers
local function ini_typeof(str)
	local t,vl = "plain",str
	for i,v in pairs(valmatchers) do
		local asd = string.match(str,v)
		if asd then
			t = i
			vl = asd
			break
		end
	end
	if t == "number" then
		vl = tonumber(vl)
	end
	if not t then
		t = str == "true" and "boolean" or (str == "false" and "boolean")
		if t then
			vl = str == "true"
		end
	end
	return t,vl
end

--- Parse ini data.
---@param data string The data.
---@return out table The final lua table.
function ini.read(data)
	assert(data, "argument #1 missing or nil")
	local out = {}
	local nsec = {}
	local weretheresection = false
	local cur = nsec
	local curn = ""
	for line in string.gmatch(data,"[^\n]+") do -- read line by line
		local t,vl = ini_line(string.gsub(line," *;.+", ""))
		if t == "section" and vl[1] then
			weretheresection = true
			out[vl[1]] = out[vl[1]] or {}
			cur = out[vl[1]]
			curn = vl[1]
		elseif t == "setting" and (#vl == 2) then
			local index = vl[1]
			local value = vl[2]
			local tval,oval = ini_typeof(value)
			cur[index] = oval
		end
	end
	out._nsec = nsec
	return out
end

--- Equivalent to ini.read, but accepts a filename instead.
---@param filename string
---@return out table
---@see ini.read
function ini.readfile(filename)
	assert(filename, "argument #1 missing or nil")
	local data
	local f = assert(io.open(filename,"r"), "file not found")
	data = f:read("*a")
	f:close()
	return ini.read(data)
end

return ini
