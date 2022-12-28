# mittere
Build tools for ComputerCraft based off npm and yarn.

## Creating a project
Download or build mittere, and run the following command:
```
mittere init
```
It will walk you through setting up your project, similar to setting up a npm project.  
Once completed, files will be created for your project. All build files for your project should fall into the created sources directory. If you are making a program, you can use `mittere watch` to run your program and restart it when changes occur.

## Building mittere
Building mittere is the same as building a mittere project. **When building, ALWAYS BACK UP THE OLD MITTERE EXECUTABLE!** Not doing so can cause huge headaches in building again. When built, the executable will be outputted to `mittere.lua`. This can be modified in `mittere.package.lua` if necessary. 

## mittereMeta.lua
A project can `require("mittereMeta")` to get the package information the project was built with. This can be used for version checking and other uses.

## Package spec
Below is a spec outlining the `mittere.package.lua` file.  

- `string` **`name`**: Name of the project
- `string` **`version`**: Version of the project. This should follow [semvar](https://semver.org/).
- `string` **`description`**: A short description of the project
- `string[]` **`authors`**: An array of authors of the project
- `string` **`rootDir`**: The sources directory of the project
- `string` **`initFile`**: The first file that will be ran when executing the project
- `string` **`outputFile`**: The file that will be built to
- `string` **`type`**: Either module or program
- `string[string]` **`tests`**: An array of tests that can be ran. The key should be a string, and the value an executable path.
- `string[string]` **`tasks`**: See tests.