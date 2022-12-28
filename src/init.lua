local args = { ... }

local commands = {
  init = require("commands/init"),
  watch = require("commands/watch"),
  build = require("commands/build"),  
  test = require("commands/test"),
  help = require("commands/help")
}

local meta = require("mittereMeta")

local target = args[1]
local dir = shell.dir()

term.setTextColor(colors.lime)
print("mittere " .. meta.version)
term.setTextColor(colors.orange)
term.write("WARNING!")
term.setTextColor(colors.yellow)
print(" Mittere is currently in alpha. Bugs may arise and package schemas are likely to change. Use at your own risk!")
print()
term.setTextColor(colors.white)

if fs.exists(fs.combine(dir, "mittere.package.lua")) then
  local packageFile = fs.open(fs.combine(dir, "mittere.package.lua"), "r")
  local package = textutils.unserialise(packageFile.readAll())
  packageFile.close()

  if package.tasks and package.tasks[args[1]] then
    shell.run(package.tasks[target], unpack(args))
    return
  end
end

if commands[args[1]] then
  commands[args[1]](...)
  return
end

if not target then
  return printError("Run mittere help for help.")
end

printError("Command not found: " .. target)