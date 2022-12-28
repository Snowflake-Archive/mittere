local build = require("commands/build")

return function(_, name)
  local packageFile = fs.open(fs.combine(shell.dir(), "mittere.package.lua"), "r")
  local package = textutils.unserialise(packageFile.readAll())
  packageFile.close()

  if package.tests == nil or package.tests[name] == nil then
    return printError("No tests found!")
  end

  local f = build()
  if not f then return printError("Build failed, aborting") end

  shell.run(package.tests[name])
end