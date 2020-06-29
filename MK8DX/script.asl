init
{
    // wrapper for the timer that lets us manually split in the update code
    vars.timerModel = new TimerModel { CurrentState = timer };

    // time between the flag icon appearing and the race starting
    vars.startOffset = TimeSpan.FromSeconds(2.97);

    // time between the race ending and the flag icon disappearing
    vars.endOffset = TimeSpan.FromSeconds(3.16);

    // the phase of the timer the last time the update was run
    vars.prevPhase = TimerPhase.NotRunning;

    // represents if the game was loading the last time the update was run
    vars.isLoading = true;

    // stores a value representing the time when loading should stop and game time should start
    // this will be calculated by taking the time the lap flag is  seen and adding startOffset to it.
    vars.timeToDisableLoading = (DateTime?)null;

    // disable looking for the lap flag on startup as the timer is not active
    //features["lapFlag1"].pause();
}

update
{
    // Detect if the user has reset the timer and resets the variables if so.
    if (vars.prevPhase != timer.CurrentPhase && timer.CurrentPhase == TimerPhase.NotRunning)
    {
        vars.prevPhase = TimerPhase.NotRunning;
        vars.isLoading = true;
        vars.timeToDisableLoading = (DateTime?)null;
        //features["lapFlag1"].pause();
    }

    if (timer.CurrentPhase == TimerPhase.Running)
    {
        // Detect if the user has just started the timer
        if (vars.prevPhase == TimerPhase.NotRunning)
        {
            // enable feature detection again
            //features["lapFlag1"].resume();

            // Set the game time to zero as without this there is a small amount of time between when the 
            // run starts and the update method is called.
            timer.SetGameTime(TimeSpan.Zero);
        }

        // If we were loading the last time we updated
        if (vars.isLoading)
        {
            if (timer.CurrentTime.GameTime < TimeSpan.Zero)
            {
                timer.SetGameTime(TimeSpan.Zero);
            }
            
            // if we are seeing the flag for the first time after loading
            if (vars.timeToDisableLoading == null && features["lapFlag1"].current > 95)
            {
                // Set a time in the future that loading will be turned off
                vars.timeToDisableLoading = DateTime.UtcNow + vars.startOffset;
            }
            // if we have already seen the flag and have passed the time to disable loading
            else if (vars.timeToDisableLoading != null && DateTime.UtcNow >= vars.timeToDisableLoading)
            {
                // turn off loading if we have passed the time to disable loading
                vars.isLoading = false;
                vars.timeToDisableLoading = null;
            }
        }
        else
        {
            // if the flag disappears
            if (features["lapFlag1"].current < 95)
            {
                // set vars.isLoading early because of potential race conditions
                vars.isLoading = true;

                // subtract endOffset from the split time because that is when we actually crossed the finish line
                timer.CurrentSplit.SplitTime = timer.CurrentTime - new Time(vars.endOffset, vars.endOffset);

                // move to the next split
                timer.CurrentSplitIndex++;

                if (timer.Run.Count == timer.CurrentSplitIndex)
                {
                    // If the run has ended, set the timer to ended
                    timer.CurrentPhase = TimerPhase.Ended;
                    timer.AttemptEnded = TimeStamp.CurrentDateTime;
                }
                else
                {
                    // add endOffset time so that we can indicate that loading started when the split occurred
                    timer.LoadingTimes += vars.endOffset;
                }

                // set the necessary flags for LiveSplit to propagate the split changes to the other components.
                vars.timerModel.OnSplit.Invoke(vars.timerModel, null);
            }
        }
    }
    
    vars.prevPhase = timer.CurrentPhase;
}

isLoading
{
    return vars.isLoading;
}