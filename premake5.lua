-- Config --
PLUGIN_NAME = "NewPlugin" -- name of the plugin (UpperCamelCase recommended), used for the workspace and project names
OUTPUT_DIR = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}" -- e.g. Debug-Windows-x86_64

-- Plugin Workspace --
workspace (PLUGIN_NAME .. "_workspace")
	architecture "x64"

	startproject "Test"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

-- Include External Premake Files (Uncomment if you want to use external libraries) --
--include ("plugin/" .. PLUGIN_NAME .. "/external")

-- Include Directories Table --
IncludeDirs = {}

IncludeDirs["AlloyCore"] = "AlloyCore/lib/AlloyCore/include"
IncludeDirs["AlloyCoreExt"] = "AlloyCore/lib/AlloyCore/external"
IncludeDirs["Plugin"] = "plugin/" .. PLUGIN_NAME .. "/include"
IncludeDirs["External"] = "plugin/" .. PLUGIN_NAME .. "/external"
IncludeDirs["Test"] = "plugin/Test/src"

-- Global Macro Definitions --
defines 
{ 
	"_CRT_SECURE_NO_WARNINGS",   		   			-- some external projects use unsafe stl functions, remove the warning
	"NOGDI",				   						-- WinGDI.h defines dumb macros, remove it
	"_SILENCE_STDEXT_ARR_ITERS_DEPRECATION_WARNING" -- spdlog causes warnings, suppress them
}

-- Plugin Project --
project (PLUGIN_NAME)
	location ("plugin/" .. PLUGIN_NAME)

	kind "StaticLib"
	staticruntime "On"

	language "C++"
	cppdialect "C++20"

	targetdir ("bin/" .. OUTPUT_DIR .. "/%{prj.name}")
	objdir ("int/" .. OUTPUT_DIR .. "/%{prj.name}")

	os.mkdir("plugin/" .. PLUGIN_NAME .. "/src/" .. PLUGIN_NAME)
	os.mkdir("plugin/" .. PLUGIN_NAME .. "/include/" .. PLUGIN_NAME)
	os.mkdir(IncludeDirs["External"])

	links
	{
		-- if compiling external libs using premake, include their project names here to link
	}

	files
	{
		"plugin/" .. PLUGIN_NAME .. "/src/**.h",
		"plugin/" .. PLUGIN_NAME .. "/src/**.c",
		"plugin/" .. PLUGIN_NAME .. "/src/**.hpp",
		"plugin/" .. PLUGIN_NAME .. "/src/**.cpp"
	}

	includedirs
	{
		IncludeDirs["AlloyCore"],
		IncludeDirs["AlloyCoreExt"],
		IncludeDirs["Plugin"],
		IncludeDirs["External"]
	}


	filter "configurations:Debug"
		defines "AL_DEBUG"
		runtime "Debug"
		symbols "On"
	
	filter "configurations:Release"
		defines "AL_RELEASE"
		runtime "Release"
		optimize "On"
	
	filter "configurations:Dist"
		defines "AL_DIST"
		runtime "Release"
		optimize "On"

    	-- system specific macro definitions
	filter "system:Windows"
		defines "AL_SYSTEM_WINDOWS"

	filter "system:Unix"
      		defines "AL_SYSTEM_LINUX"

   	filter "system:Mac"
      		defines "AL_SYSTEM_MAC"

-- Test Project --
project "Test"
	location "plugin/Test"
	
	kind "ConsoleApp"
	staticruntime "On"

	language "C++"
	cppdialect "C++20"

	targetdir ("bin/" .. OUTPUT_DIR .. "/%{prj.name}")
	objdir ("int/" .. OUTPUT_DIR .. "/%{prj.name}")

	os.mkdir(IncludeDirs["Test"])

	links
	{
		"AlloyCore/bin/" .. OUTPUT_DIR .. "/AlloyCore/AlloyCore.lib",
		PLUGIN_NAME
	}
	
	files
	{
		IncludeDirs["Test"] .. "/**.h",
		IncludeDirs["Test"] .. "/**.c",
		IncludeDirs["Test"] .. "/**.hpp",
		IncludeDirs["Test"] .. "/**.cpp"
	}

	includedirs
	{
		IncludeDirs["AlloyCore"],
		IncludeDirs["AlloyCoreExt"],
		IncludeDirs["Plugin"],
		IncludeDirs["External"],
		IncludeDirs["Test"]
	}

	linkoptions
	{ 
		"-IGNORE:4099"  -- hide .pdb file missing warning
	}

	filter "configurations:Debug"
		defines "AL_DEBUG"
		runtime "Debug"
		symbols "On"
	
	filter "configurations:Release"
		defines "AL_RELEASE"
		runtime "Release"
		optimize "On"
	
	filter "configurations:Dist"
		defines "AL_DIST"
		runtime "Release"
		optimize "On"
