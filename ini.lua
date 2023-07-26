local ini = {}

local matchers = {
	section = "%[(.+)%]",
	setting = "([%a%d]+) *= *(.+)"
}
local valmatchers = {
	string = "^\"(.+)\"",
	number = "^%d+"
}
local function ini_line(str)
	local t,vl
	for i,v in pairs(matchers) do
		local asd = {string.match(str,v)}
		if #asd > 0 then
			t = i
			vl = asd
			break
		end
	end
	return t,vl
end
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
		t = str == "true" and "boolean" or (str == "false" and "boolean" or nil)
		if t then
			vl = str == "true"
		end
	end
	return t,vl	
end
function ini.read(dat)
	local data = dat
	if not data then
		error"argument #1 missing or nil"
	end

	local out = {}
	local nsec = {}
	local weretheresection = false
	local cur = nsec
	local curn = ""
	for v in string.gmatch(data,"[^\n]+") do
		-- remove comments (ironically enough this is a comment)
		v = string.gsub(v," *;.+", "")

		local t,vl = ini_line(v)
		if t == "section" and vl[1] then
			weretheresection = true
			out[vl[1]] = out[vl[1]] or {}
			cur = out[vl[1]]
			curn = vl[1] -- for testing purpose
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

function ini.readfile(file)
	local data
	if file then
		local f = io.open(file,"r")
		if f then
			data = f:read("*a")
			f:close()
		else
			error"file not found"
		end
	else
		error"argument #1 missing or nil"
	end
	return ini.read(data)
end

return ini