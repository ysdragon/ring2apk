aPackageInfo = [
	:name = "ring2apk",
	:description = "Build Android APKs from Ring applications",
	:folder = "ring2apk",
	:developer = "ysdragon",
	:email = "",
	:license = "MIT License",
	:version = "1.2.0",
	:ringversion = "1.27",
	:versions = 	[
		[
			:version = "1.2.0",
			:branch = "master"
		]
	],
	:libs = 	[
		[
			:name = "ringcurl",
			:version = "1.0.18",
			:providerusername = "ringpackages"
		],
		[
			:name = "ring-html",
			:version = "1.0.5",
			:providerusername = "ysdragon"
		],
		[
			:name = "archive",
			:version = "1.0.2",
			:providerusername = "ysdragon"
		]
	],
	:files = 	[
		"ring2apk.ring",
		"lib.ring",
		"main.ring",
		"LICENSE",
		"README.md",
		"src/app.ring",
		"src/config.ring",
		"src/environment.ring",
		"src/commands/build.ring",
		"src/commands/run.ring",
		"src/commands/sign.ring",
		"src/commands/clean.ring",
		"src/commands/setup.ring",
		"src/commands/init.ring",
		"src/utils/colors.ring",
		"src/utils/json.ring",
		"src/utils/install.ring",
		"src/utils/uninstall.ring",
		"src/utils/shared.ring",
		"src/utils/shell.ring",
		"tools/setup-env.ring",

		# Hello example
		"examples/hello/ring2apk.ring",
		"examples/hello/ring/main.ring",
		"examples/hello/README.md",
		"examples/hello/res/values/colors.xml",
		"examples/hello/res/values/strings.xml",
		"examples/hello/res/values/styles.xml",
		"examples/hello/src/cpp/CMakeLists.txt",
		"examples/hello/src/cpp/main.c",
		"examples/hello/src/cpp/README.md",

		# RingRayLib example
		"examples/raylib/.gitignore",
		"examples/raylib/AndroidManifest.xml",
		"examples/raylib/README.md",
		"examples/raylib/download_deps.ring",
		"examples/raylib/res/mipmap-hdpi/ic_launcher.png",
		"examples/raylib/res/mipmap-mdpi/ic_launcher.png",
		"examples/raylib/res/mipmap-xhdpi/ic_launcher.png",
		"examples/raylib/res/mipmap-xxhdpi/ic_launcher.png",
		"examples/raylib/res/values/colors.xml",
		"examples/raylib/res/values/strings.xml",
		"examples/raylib/res/values/styles.xml",
		"examples/raylib/ring/classes.ring",
		"examples/raylib/ring/functions.ring",
		"examples/raylib/ring/main.ring",
		"examples/raylib/ring/raygui.rh",
		"examples/raylib/ring/raylib.rh",
		"examples/raylib/ring/raylib.ring",
		"examples/raylib/ring/shader.ring",
		"examples/raylib/ring2apk.ring",
		"examples/raylib/screenshots/screens.png",
		"examples/raylib/src/cpp/CMakeLists.txt",
		"examples/raylib/src/cpp/main.c",
		"examples/raylib/src/cpp/ring_raylib.c",
		"examples/raylib/src/java/com/ring/ringraylib/MainActivity.java"
	],
	:ringfolderfiles = 	[

	],
	:windowsfiles = 	[

	],
	:linuxfiles = 	[

	],
	:ubuntufiles = 	[

	],
	:fedorafiles = 	[

	],
	:freebsdfiles = 	[

	],
	:macosfiles = 	[

	],
	:windowsringfolderfiles = 	[

	],
	:linuxringfolderfiles = 	[

	],
	:ubunturingfolderfiles = 	[

	],
	:fedoraringfolderfiles = 	[

	],
	:freebsdringfolderfiles = 	[

	],
	:macosringfolderfiles = 	[

	],
	:run = "ring ring2apk.ring",
	:windowsrun = "",
	:linuxrun = "",
	:macosrun = "",
	:ubunturun = "",
	:fedorarun = "",
	:setup = "ring src/utils/install.ring",
	:windowssetup = "",
	:linuxsetup = "",
	:macossetup = "",
	:ubuntusetup = "",
	:fedorasetup = "",
	:remove = "ring src/utils/uninstall.ring",
	:windowsremove = "",
	:linuxremove = "",
	:macosremove = "",
	:ubunturemove = "",
	:fedoraremove = ""
]
