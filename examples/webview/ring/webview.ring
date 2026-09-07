# This file is part of the Ring WebView library.
if isWindows()
	loadlib("ring_webview.dll")
but isMacOSX()
	loadlib("libring_webview.dylib")
but isUnix() and not (isAndroid() or isMacOSX())
	loadlib("libring_webview.so")
ok

# Load the Ring WebView Class and Constants.
load "src/webview.ring"
load "src/webview.rh"
