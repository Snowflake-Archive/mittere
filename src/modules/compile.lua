--[[
Based off Crunch (https://github.com/dmarcuse/crunch/)

The MIT License (MIT)

Copyright (c) 2018 Dominic "apemanzilla" Marcuse

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local compiler = {}

-- recursively collect input files
local function collectSources(dir)
	local sources = {}

	for i, path in ipairs(fs.list(dir)) do
		local absPath = fs.combine(dir, path)

		if fs.isDir(absPath) then
			for k, v in pairs(collectSources(absPath)) do
				sources[fs.combine(path, k)] = v
			end
		else
			local f = fs.open(absPath, "r")
			sources[path] = f.readAll()
			f.close()
		end
	end

	return sources
end

function compiler.compile(rootS, initFile)
	local root = shell.resolve(rootS)

	if not fs.isDir(root) then
		return error("Project root must be a directory")
	end

	local packageFile = fs.open(fs.combine(shell.dir(), "mittere.package.lua"), "r")
	local packageContents = packageFile.readAll()
  packageFile.close()

	local sources = collectSources(root)

	local output = [[
-- bundle created using mittere, based on crunch
-- https://github.com/Snowflake-Software/mittere
-- https://github.com/apemanzilla/crunch]]
	output = output .. "\n"

	if fs.exists(fs.combine(shell.dir(), "LICENSE")) then
		local f = fs.open(fs.combine(shell.dir(), "LICENSE"), "r")
		local data = f.readAll()
		f.close()
		output = output .. "--[[\n---BEGIN LICENSE---\n\n"
		output = output .. data
		output = output .. "\n\n---END LICENSE---\n]]\n\n"
	end

	-- input contents
	output = output .. "local sources = {\n"

	for k, v in pairs(sources) do
		output = output .. ([[	[%q] = %q,
	]]):format(k, v)
	end

	output = output .. '["mittereMeta.lua"] = [[return ' .. packageContents .. ']]'

	output = output .. "}\n\n"

	-- module loader
	output = output .. [[
assert(package, "package API is required")
table.insert(package.loaders, 1, function(name)
	for path in package.path:gmatch("[^;]+") do
		local p = name:gsub("%.", "/")
		local test = path:gsub("%?", p)
		if sources[test] then
			return function(...)
				return load(sources[test], name, nil, _ENV)(...)
			end
		end
	end

	return nil, "no matching embedded file"
end)

]]

-- launcher
	output = output .. 'load(sources["' .. initFile .. '"] or "", "main.lua", nil, _ENV)(...)'

	return output
end

return compiler