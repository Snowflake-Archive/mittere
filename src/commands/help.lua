return function()
  term.setTextColor(colors.lightBlue)
  term.write(" build: ")
  term.setTextColor(colors.white)
  print("Builds the current project. If a LICENSE is in the root of the project, it will be prepended to the build file.")

  term.setTextColor(colors.lightBlue)
  term.write(" help: ")
  term.setTextColor(colors.white)
  print("Show this list")

  term.setTextColor(colors.lightBlue)
  term.write(" init: ")
  term.setTextColor(colors.white)
  print("Initalize a new project")

  term.setTextColor(colors.lightBlue)
  term.write(" test: ")
  term.setTextColor(colors.white)
  print("Runs a test specified in the package file")

  term.setTextColor(colors.lightBlue)
  term.write(" watch: ")
  term.setTextColor(colors.white)
  print("Watches files in the project for updates, builds the project, and runs it. Optionally, running can be disabled by appending --no-run.")
end