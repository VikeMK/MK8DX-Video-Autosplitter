init
{
    // wrapper for the timer that lets us manually split in the update code
    vars.timerModel = new TimerModel { CurrentState = timer };

    // time between the flag icon appearing and the race starting
    vars.startOffset = TimeSpan.FromSeconds(2.97);

    // time between the race ending and the flag icon disappearing
    vars.endOffset = TimeSpan.FromSeconds(3.16);

    // represents if the game was loading the last time "update" was run
    vars.isLoading = true;

    // represents the time when loading should stop and game time should start
    // this will be calculated by taking the time the lap flag is  seen and adding startOffset to it.
    vars.timeToDisableLoading = DateTime.MinValue;

    // This stores the time when we first saw the flag disappear.
    vars.firstTimeFlagDisappeared = DateTime.MinValue;
}

update
{
    // Only run the auto-splitter while the timer is running
    if (timer.CurrentPhase != TimerPhase.Running)
    {
        // If the timer phase is "NotRunning", ensure the variables are their defaults.
        if (timer.CurrentPhase == TimerPhase.NotRunning)
        {
            vars.isLoading = true;
            vars.timeToDisableLoading = DateTime.MinValue;
            vars.firstTimeFlagDisappeared = DateTime.MinValue;
        }

        return false;
    }

    var isFlagVisible = features["lapFlag1"].current > 95;

    if (vars.isLoading)
    {
        // Ensure the game time is set to 0 before the first loading time.
        var gameTime = timer.CurrentTime.GameTime;
        if (gameTime != TimeSpan.Zero && gameTime < vars.startOffset)
        {
            timer.SetGameTime(TimeSpan.Zero);
        }

        // Check if the flag icon is showing
        if (isFlagVisible)
        {
            // If we have not set a time to disable loading yet, set it.
            // This will occur when the flag appears for the first time after loading
            if (vars.timeToDisableLoading == DateTime.MinValue)
            {
                // Set a time in the future that loading will be turned off
                vars.timeToDisableLoading = DateTime.UtcNow + vars.startOffset;
            }
            else if (DateTime.UtcNow >= vars.timeToDisableLoading)
            {
                // turn off loading if we have passed the time to disable loading
                vars.isLoading = false;
                vars.timeToDisableLoading = DateTime.MinValue;
            }
        }
        else
        {
            // make sure we aren't planning to disable loading any time soon if the flag has disappeared.
            // This can occur if the flag is falsely detected at the wrong time, so we want to ignore those
            // false positives.
            vars.timeToDisableLoading = DateTime.MinValue;
        }
    }
    else if (!isFlagVisible)
    {
        if (vars.firstTimeFlagDisappeared == DateTime.MinValue)
        {
            vars.firstTimeFlagDisappeared = DateTime.UtcNow;
        }
        else
        {
            var timeSinceDisappearence = DateTime.UtcNow - vars.firstTimeFlagDisappeared;
            if (timeSinceDisappearence >= TimeSpan.FromSeconds(1))
            {
                vars.isLoading = true;
                vars.firstTimeFlagDisappeared = DateTime.MinValue;

                // Determine when we would have crossed the line. This is calculated by adding the endOffset which
                // represents the time bewteen crossing the line and the flag disappearing to the time between when
                // we saw it first disappear and now.
                var timeToSubtract = vars.endOffset + timeSinceDisappearence;

                // Set the split time of the current split to the correct value.
                timer.CurrentSplit.SplitTime = timer.CurrentTime - new Time(timeToSubtract, timeToSubtract);

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
    else
    {
        // Reset the number of frames that the flag is gone to 0 just in case it accidentally triggered.
        vars.firstTimeFlagDisappeared = DateTime.MinValue;
    }
}

isLoading
{
    return vars.isLoading;
}