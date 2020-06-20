startup
{
    print("[MK8DX Autosplitter] Starting");
}

init
{
    vars.isLoading = false;
    print("[MK8DX Autosplitter] Initialisation Complete.");
}

update
{
    vars.isLoading = features["lapFlag"] < 90;
}

isLoading
{
    return vars.isLoading;
}