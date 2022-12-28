local includes = require("modules/includes")
local build = require("commands/build")
local watchInterval = 1

return function( ... )
  local args = { ... }
  local last = {}
  local buildTimes = 0

  local packageFile = fs.open(fs.combine(shell.dir(), "mittere.package.lua"), "r")
  local package = textutils.unserialise(packageFile.readAll())
  packageFile.close()

  while true do
    parallel.waitForAll(function()
      while true do
        local hasFoundUpdates = false

        local function scanDir(dir)
          for i, v in pairs(fs.list(dir)) do
            local f = fs.combine(dir, v)
            if fs.isDir(f) then
              local result = scanDir(f)
            else
              local size = fs.getSize(f)

              if last[f] == nil or last[f] ~= size then
                last[f] = size
                hasFoundUpdates = true
              end 
            end
          end
        end

        local result = scanDir(fs.combine(shell.dir(), package.rootDir))
        if hasFoundUpdates == true then
          term.setTextColor(colors.lightBlue)
          print("Detected updates!")
          term.setTextColor(colors.white)
          buildTimes = buildTimes + 1
          break
        end
        sleep(watchInterval)
      end
    end, function()
      if buildTimes > 1 then
        local f = build()
        if not f then return printError("Build failed!") end

        if not includes(args, "--no-run") then
          term.setTextColor(colors.lightGray)
          print("Executing built file")
          term.setTextColor(colors.white)
          shell.run(fs.combine(shell.dir(), package.outputFile))
          term.setTextColor(colors.lightGray)
          print("Execution complete.")
          term.setTextColor(colors.white)
        end
      end
    end)
  end
end