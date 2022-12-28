local compiler = require("modules/compile")

return function()
  if fs.combine(shell.dir(), "mittere.package.lua") then
    local packageFile = fs.open(fs.combine(shell.dir(), "mittere.package.lua"), "r")
    local package = textutils.unserialise(packageFile.readAll())
    packageFile.close()

    term.setTextColor(colors.lightBlue)
    print("Building project", package.name)
    local output = compiler.compile(
      fs.combine(shell.dir(), package.rootDir),
      fs.combine(package.initFile)
    )

    local f = fs.open(fs.combine(shell.dir(), package.outputFile), "w")
    f.write(output)
    f.close()
    term.setTextColor(colors.green)
    term.write("Success! ")
    term.setTextColor(colors.white)
    print("Built project to", fs.combine(shell.dir(), package.outputFile))
    return fs.combine(shell.dir(), package.outputFile)
  else
    printError("Build error: no mittere.package.lua file found")
  end
end