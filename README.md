# MK8DX Video Autosplitter

## How to use

### Requirements
- [LiveSplit 1.8.11 or later](http://livesplit.org/).
- A DirectShow output which has the game capture.
  - For OBS, this can be done using [VirtualCam](https://obsproject.com/forum/resources/obs-virtualcam.949/).
    - I recommend setting this up using the Source Filter option on the game capture.
    - To do this, right click on the Game Capture under your sources in OBS > Filters > Add Effect Filter (+) > VirtualCam
    - You will need to open this filter every time you open OBS and press the Start button.
  - XSplit has a [built-in Virtual Camera](https://www.youtube.com/watch?v=WxPJdUtEae8) you can use.
  - If you want to use Streamlabs OBS:
    - Run OBS and Streamlabs OBS at the same time.
    - In OBS add the VirtualCam as described above.
    - Use the VirtualCam created by OBS in LiveSplit and Streamlabs OBS.

### Installation
1. Download the [latest version](https://github.com/ROMaster2/LiveSplit.VideoAutoSplit/releases) of the `LiveSplit.VideoAutoSplit` component.
1. Find your LiveSplit folder and extract the contents into the Components folder. If you are updating from a previous version, replace the existing files.
1. Download the [latest version](https://github.com/VikeMK/MK8DX-Video-Autosplitter/releases) of the MK8DX auto-splitter. You want to download the `MK8DX.vas` file.
1. Start LiveSplit as Administrator (you must always run LiveSplit as Administrator)
1. In LiveSplit's layout editor, click the big (+) button, hover over control, and add the `Video Auto Splitter` component.
1. Open the component's settings by double clicking on "Video Auto Splitter" in the list.
1. For `Game Profile` find the MK8DX.vas file you downloaded earlier.
1. For `Capture Device`, select the virtual camera which is capturing MK8DX.
1. Under the `Scan Region` tab, ensure that you have the width and height set to the dimensions of the virtual camera.
    -  For OBS this will be the output resolution set under the video settings in OBS.
1. In-game, start a time trial and verify that in the `Scan Region` tab you see a preview of the game and that there is a blue square covering the flag icon in the bottom left. 
    - Please see this [example screenshot](https://i.imgur.com/wtpRe2K.png) of the blue square in the correct spot.
    - You may need to restart LiveSplit first for the preview to work, make sure to save the layout file when you do restart it.
    - If you still can't see this see the preview, please see the [Troubleshooting section](#troubleshooting).
1. Now, close the layout settings and restart livesplit.

### Usage
1. Make sure that you can see the Game Time on LiveSplit. You have a few options for this:
    - Right Click > `Compare Against` > `Game Time`.
      - If you select this, it means that will LiveSplit will use game time as the primary comparison time and use that to determine if you should override your PB.
      - Since MK8DX uses real time as the primary timing method, I would recommend keeping it on Real Time and using one of the other two approachs.
    - In your layout settings, you can add a 2nd timer component and configure it to use Game Time. 
      - By adding a 2nd timer, you can see the real time and game time at the same time.
    - In your layout settings, edit the splits settings and add a column where the timing method is set to Game Time.
1. Go to the "OK" screen where you start the speedrun.
1. Press the split button to start the run when you press OK.
1. If everything was set up properly, you shouldn't need to touch the split button for the rest of the run.
1. When you start the race, you should see that the Game Time is stopped because it starts on a loading screen, and that the Real Time is not stopped.
1. When the first race starts you should see that Game Time starts the moment the countdown ends.
1. When the race ends, you should see that it should take about 3 seconds and the game will auto-split.
    - The split occurs when the flag icon in the bottom-left disappears.
    - The auto-splitter will adjust the split time so that it splits
1. If any of steps 5-7 fail, see the [troubleshooting section](#troubleshooting).

A demo of how the load time removal and auto-splitter should work can be seen in [this video](https://www.youtube.com/watch?v=JiVRPFryKb0).

### Troubleshooting
- The VideoAutoSplit plugin is very flaky/buggy and tends to break on the `Scan Region` tab, so if things seem to just stop working, restart LiveSplit.
- If you are unable to see the OBS Camera in the dropdown for the `Capture Device` setting, make sure that you have started the VirtualCam in OBS. If it has started but you still can't see it, try uninstalling and reinstalling VirtualCam. If that doesn't work, also try restarting your computer.
- Make sure you have the color range set to "Full" on your game capture. In OBS this is found under the game capture settings.
- If you can see a preview of the game, but the blue square does not appear on top of the flag, make sure that you have the width and height set correctly. And that the game capture takes up the full screen.
  - Make sure you don't have any zoom set in your switch settings (`TV Settings` > `Adjust Screen Size`).
- If all that doesn't work, join the [MK8DX Speedrunning Discord](https://discord.gg/Z5sHc3X) and ping me (tag: Vike#9470) and I will try help you out.
