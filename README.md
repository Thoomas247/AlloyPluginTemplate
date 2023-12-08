# AlloyPluginTemplate
This repository is a template for creating standalone Alloy Game Engine plugins.

# Getting Started
- Click on "Use this template" and create your own repository (you can also just download the files if you do not want to use git).
- Open the premake5.lua file located in the root directory and change the PLUGIN_NAME variable to the name of your plugin. Save the file.
- Execute the GENERATE script which applies to your environment.
- You will now see various new files, including a folder called plugin which contains 2 projects. One is for your plugin (compiles to .lib), and one is for testing (compiles to .exe).
- Start coding!

# Testing
In order to test your plugin, you must first build the AlloyCore library:
- Navigate to the "AlloyCore" directory.
- Execute the GENERATE script which applies to your environment.
- Open the generated project and build it.

Your plugin's test project will now compile successfully!
