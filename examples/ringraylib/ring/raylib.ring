if iswindows()
	LoadLib("ring_raylib.dll",False)
but ismacosx()
	LoadLib("libringraylib.dylib")
but isUnix() and not (isAndroid() or isMacOSX())
	LoadLib("libringraylib.so")
ok

load "raylib.rh"
load "raygui.rh"
load "functions.ring"
load "shader.ring"
load package "classes.ring"
