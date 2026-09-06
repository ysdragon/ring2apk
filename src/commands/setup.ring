# Copyright (c) 2026 Youssef Saeed <youssefelkholey@gmail.com>
# All rights reserved.

/*
    setup command for Ring2APK
    Run the project's optional :setup step (e.g. download vendored deps).
    Explicit only: `ring2apk setup`. The build never runs it automatically.
*/

# Execute setup command
func cmdSetup aArgs
    oConfig = loadConfig("ring2apk.ring")
    if isNull(oConfig)
        fail("Configuration could not be loaded")
    ok

    aSetupValue = oConfig[:setup]
    if isString(aSetupValue)
        if len(trim(aSetupValue)) = 0
            logInfo("No :setup step configured, nothing to do.")
            return true
        ok
        aSetupList = [aSetupValue]
    else
        aSetupList = aSetupValue
    ok
    if not isList(aSetupList) or len(aSetupList) = 0
        logInfo("No :setup step configured, nothing to do.")
        return true
    ok

    nSetupTotal = len(aSetupList)
    nSetupStep = 0
    for cSetupCmd in aSetupList
        nSetupStep = nSetupStep + 1
        logStep("Setup", "(" + nSetupStep + "/" + nSetupTotal + ") " + cSetupCmd)
        nSetupCode = shellExec(cSetupCmd)
        if nSetupCode != 0
            fail("Setup step failed (" + nSetupCode + "): " + cSetupCmd)
        ok
    next

    logSuccess("Setup completed!")
    return true
