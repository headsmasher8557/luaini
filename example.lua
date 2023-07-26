ini = require("ini")

function dump(z,i) -- free table dump function
	local n = -2
	local function f(t,i)
		n = n + 1
		if type(t) == "table" then
			if i then
				print(string.rep("  ",n) .. i .. ": {")
			end
			for i,v in pairs(t) do
				f(v,i)
			end
			if i then
				print(string.rep("  ",n) .. "}")
			end
		elseif i then
			print(string.rep("  ",n) .. i .. "=" .. (type(t) == "string" and "\"" or "") .. tostring(t) .. (type(t) == "string" and "\"" or ""))
		end
		n = n - 1
	end
	f(z,i)
end

dump(ini.readfile("example.ini"))