init
{
    vars.hasLapFlag = false;
    print("[MK8DX Autosplitter] Initialisation Complete.");
}

update
{
    vars.hasLapFlag = (features["lapFlag"] > 90);
}

isLoading
{
    return vars.hasLapFlag == false;
}