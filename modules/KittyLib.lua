local table = setmetatable({}, {__index = table})
local math = setmetatable({}, {__index = math})
local string = setmetatable({}, {__index = string})

local KittyLib = {_VERSION = "0.1.2"}

do -- string
	function string.split(s, sep)
		if sep == nil then
			sep = "%s"
		end

		local t = {}
		local splits = 0

		for str in string.gmatch(s, "([^"..sep.."]+)") do
			table.insert(t, str)
			splits = splits + 1
		end

		return t, splits
	end

	function string.divide(s, div)
		local t = {}
		for i=1, div do
			local len = string.len(s) / div
			local strend = i * len
			local start = (strend - len) + (i > 1 and 1 or 0)

			t[i] = string.sub(s, start, strend)
		end
		return t
	end
end

do -- math
	function math.rounddec(n, decimal)
		local mult = 10 ^ (decimal)
		return math.modf(n * mult) / mult
	end

	function math.round2(n, d)
		return math.floor(n / d) * d
	end

	function math.tobinary(n)
		assert(math.type(n) == "integer", "input value must be an integer.")

		local ret=""
		while n ~= 1 and n ~= 0 do
			ret = tostring(n % 2) .. ret
			n = math.modf(n / 2)
		end
		ret = tostring(n) .. ret
		return ret
	end

	function math.frombinary(binary)
		return tonumber(binary, 2)
	end

	function math.randomfloat(min, max, decimal)
		local decimal = decimal or 1000
		return math.random(min * decimal, max * decimal) / decimal
	end
end

do -- table
	local function tostringTable(t, mode, indent, tostringed)
		local tostringed = tostringed or {}
		tostringed[tostring(t)] = true

		local stringTable = "{" .. (mode == 1 and "\n" or "")
		for i, v in next, t do
			local indexType = type(i)
			local valueType = type(v)

			local index = i
			if indexType == "number" then
				index = '[' .. i .. ']'
			elseif indexType == "string" and string.find(i, " ") then
				index = '["' .. i .. '"]'
			elseif indexType == "table" then
				index = "[" .. tostringTable(i, 0, 0) .. "]"
			end

			local value = ""
			if valueType == "string" then
				value = '"' .. v .. '"'
			elseif valueType == "number" or valueType == "nil" or valueType == "boolean" then
				value = tostring(v)
			elseif valueType == "table" then
				if tostringed[tostring(v)] == nil then
					value = tostringTable(v, mode, indent + 1, tostringed)
				end
			else
				value = tostring(v)
			end

			stringTable = stringTable .. string.rep("\t", (mode == 1 and indent or 0)) .. index .. " = " .. value

			if table.findkey(t, i) ~= table.len(t) then
				stringTable = stringTable .. ", "
			end

			stringTable = stringTable .. (mode == 1 and "\n" or "")
		end
		stringTable = stringTable .. string.rep("\t", (mode == 1 and indent - 1 or 0)) .. "}"

		return stringTable
	end

	function table.tostring(t, mode)
		local mode = mode or 0
		assert(not (mode > 1 or mode < 0), "mode is out of range.")
		assert(type(t) == "table", "t must be a table.")
		return tostringTable(t, mode, 1)
	end

	function table.copy(t)
		local copied = {}
		for i, v in next, t do
			if type(v) == "table" then
				copied[i] = table.copy(v)
			else
				copied[i] = v
			end
		end
		return copied
	end

	function table.destroy(t)
		for i, v in next, t do
			if type(v) == "table" then
				table.destroy(v)
			end
		end
		table.clear(t)
		return t
	end

	function table.clear(t)
		for i, v in next, t do
			t[i] = nil
		end

		return t
	end

	function table.replace(t, vt)
		for i, v in next, vt do
			if t[i] then
				t[i] = v
			end
		end
		return t
	end

	function table.deepreplace(t, vt)
		for i, v in next, vt do
			if t[i] then
				if type(t[i]) == "table" and type(v) == "table" then
					table.deepreplace(t[i], v)
				else
					t[i] = v
				end
			end
		end
		return t
	end

	function table.find(t, value)
		local key = 0
		for i, v in next, t do
			key = key + 1
			if v == value then
				break
			end
		end

		if key == 0 then
			key = nil
		end

		return key
	end

	function table.findkey(t, index)
		if type(index) == "number" then
			return index
		else
			if table.find(t, index) == nil then
				error(tostring(index) .. " is not found in " .. tostring(t))
			end

			local key = 0
			for i, v in next, t do
				key = key + 1

				if i == index then
					return key
				end
			end
			return nil
		end
	end

	function table.len(t)
		local len = 0
		for i, v in next, t do
			len = len + 1
		end
		return len
	end

	function table.deeplen(t)
		local len = 0
		for i, v in next, t do
			len = len + 1
			if type(v) == "table" then
				len = len + table.deeplen(v)
			end
		end
		return len
	end
end

KittyLib.math = math
KittyLib.table = table
KittyLib.string = string

return KittyLib