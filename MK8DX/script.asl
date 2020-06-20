startup
{
    print("[MK8DX Autosplitter] Starting");
}

init
{
    print("[MK8DX Autosplitter] Initialisation Complete.");
}

update
{
    
}

isLoading
{
    return features["lapFlag"] < 60;
}