local function askDefault(prompt, default)
  term.setTextColor(colors.white)
  term.write(prompt)
  term.setTextColor(colors.lightGray)
  term.write(" (" .. default .. ")")
  term.setTextColor(colors.white)
  term.write(": ")
  local data = read() 
  return data == "" and default or data
end

return function(_, name)
  local dir = shell.dir()
  term.setTextColor(colors.lightBlue)
  print("Creating new mittere package in", dir == "" and "/" or "")
  
  if not name then
    name = askDefault("Package name", "untitled")
  end

  local version = askDefault("Version", "0.1.0")
  local description = askDefault("Description", "")
  local authors = askDefault("Authors, comma-seperated", "")
  local root = askDefault("Root directory", "src")
  local init = askDefault("Init file", "main.lua")
  local output = askDefault("Output file", "bundle.lua")
  local type = askDefault("Type (module or program)", "module")

  local authorsTbl = {}
  for author in authors:gmatch("[^,]+") do
    table.insert(authorsTbl, author)
  end

  local tbl = {
    version = version,
    description = description,
    authors = authorsTbl,
    rootDir = root,
    initFile = init,
    outputFile = output,
    type = type,
    tasks = {},
    preflight = {},
    postflight = {}
  }

  term.setTextColor(colors.lightBlue)
  print("Setting up project...")
  term.setTextColor(colors.gray)
  print("Make directory", fs.combine(dir, root))
  fs.makeDir(fs.combine(dir, root))
  
  print("Make file", fs.combine(dir, root, init))
  local mainFile = fs.open(fs.combine(dir, root, init), "w")
  mainFile.write("-- Main project file! Write some code here.")
  mainFile.close()

  print("Make file", fs.combine(dir, "mittere.package.lua"))
  local packageFile = fs.open(fs.combine(dir, "mittere.package.lua"), "w")
  packageFile.write(textutils.serialise(tbl))
  packageFile.close()
  term.setTextColor(colors.green)
  term.write("Success! ")
  term.setTextColor(colors.white)
  print("Run mittere watch to run the program on changes.")
  term.setTextColor(colors.lightGray)
  print("You can also add in some tests and tasks in mittere.package.lua.")
end