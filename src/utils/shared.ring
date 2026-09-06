# Copyright (c) 2026 Youssef Saeed <youssefelkholey@gmail.com>
# All rights reserved.

/*
    Shared utilities for Ring2APK
*/

# Convert boolean to string
func bool2str lValue
    if lValue
        return "true"
    ok
    return "false"

# Canonical string form of an SDK version, accepting number or string input
func sdkVersionString xVersion
    if isnumber(xVersion)
        # SDK minor versions are single-digit (android-36.1, android-37.2):
        # a decimals(1) window stringifies exactly, immune to ambient precision.
        decimals(1)
        cVersion = string(xVersion)
        decimals(2)   # restore Ring default
    else
        cVersion = trim("" + xVersion)
    ok

    # Strip trailing zeros after a decimal point, then the dot itself
    if substr(cVersion, ".") != 0
        while right(cVersion, 1) = "0"
            cVersion = left(cVersion, len(cVersion) - 1)
        end
        if right(cVersion, 1) = "."
            cVersion = left(cVersion, len(cVersion) - 1)
        ok
    ok
    return cVersion

# List all files recursively
func listAllFilesEx cDir, cExt
    aOut = []
    if not dirExists(cDir)
        return aOut
    ok

    nExtLen = len(cExt)
    cSep = pathSeparator()
    aSeen = dir(cDir)
    for aOne in aSeen
        cFull = cDir + cSep + aOne[1]
        if aOne[2]  # Directory
            add(aOut, listAllFilesEx(cFull, cExt), true)
        else  # File
            if nExtLen = 0 or right(cFull, nExtLen) = cExt
                aOut + cFull
            ok
        ok
    next

    return aOut