--[[
	Unit tests. Please run before making a commit!
	Right now they're hardcoded in this file but if necessary this can be moved to its own module
--]]

local ini = require"ini"

function table_dump_string(z)
	local out = ""
	local n = -2
	local function f(t,i)
		n = n + 1
		if type(t) == "table" then
			if i then
				out = out .. (string.rep("  ",n) .. i .. ": {\n")
			end
			for i,v in pairs(t) do
				f(v,i)
			end
			if i then
				out = out .. (string.rep("  ",n) .. "}\n")
			end
		elseif i then
			out = out ..(string.rep("  ",n) .. i .. "=" .. (type(t) == "string" and "\"" or "") .. tostring(t) .. (type(t) == "string" and "\"" or "") .. "\n")
		end
		n = n - 1
	end
	f(z)
	return out
end

function table_dump(z)
	print(table_dump_string(z))
end

local tests = {
	{
		name = "various value types",
		fn = ini.read,
		input = [=[
			[initest]
			booltest = true
			numtest = 69420
			strtest = Hello, World!
			quotedstrtest = "Hello, Foo!"

			[secondsection]
			fixAllErrors = true
		]=],
		expectedOutput = {
			initest = {
				booltest = true,
				numtest = 69420,
				strtest = "Hello, World!",
				quotedstrtest = "Hello, Foo!"
			},
			secondsection = {
				fixAllErrors = true
			}
		},
		verify = function(a, b)
			local a1, b1 = table_dump_string(a), table_dump_string(b)
			local success = a1, b1
			if success then return true end
			print(a1, b1)
		end
	}
}

local successfulTests = 0
for _, test in pairs(tests) do
	io.write("Running '" .. test.name .. "' test..")
	local output = test.fn(test.input)
	local success = test.verify and test.verify(output, test.expectedOutput) or output == test.expectedOutput
	io.write(success and "...success\n" or "..failure\n")
	successfulTests = successfulTests + 1
end
