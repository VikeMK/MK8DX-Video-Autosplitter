init
{
    vars.hasLapFlag = false;
    print("[MK8DX Autosplitter] Initialisation Complete.");
}

update
{
    vars.hasLapFlag = features["lapFlag1"].current > 95;
}

isLoading
{
    return !vars.hasLapFlag;
}