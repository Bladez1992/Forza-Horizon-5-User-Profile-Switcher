# Forza Horizon 5 User Profile Switcher
[A batch script to redirect the Forza Horizon 5 save and config directories per-user - allowing for separate saves with a single copy of the game](https://github.com/Bladez1992/Forza-Horizon-5-User-Profile-Switcher/blob/main/FH5LAUNCH.bat)
 
- If using the Microsoft Store, Steam, or Online-Fix versions of the game, the name in the bottom left on the main menu **will not change** as this is who owns the game/who is logged in to Steam, but the script will still function and let you have different saves for each Windows user.
 
- The way the script works, it uses the currently logged in Windows user profile to determine whose save to launch the game with. If you don't like this, replace all **%username%** variables in the script with whatever you want.

- The script **must be run as an admin** and the currently logged in user **must be an admin as well** - if the currently logged in user isn't an admin it will ask you for an admin's login credentials when running the script, and will run the game and load that admin's save rather than the user's
 
- This will only work without changes with the CODEX crack for the game - if using the Online-Fix crack or a legitimate copy you MUST change the paths as indicated in the script before using it. You can find the locations of the Configuration File and Save Game paths to change in the script on [PCGW](https://www.pcgamingwiki.com/wiki/Forza_Horizon_5#Configuration_file.28s.29_location) according to which version of the game you're using
 
- Place the batch file in the same directory as the game's exe, you should also create a new directory here called Profiles
 
- If using the CODEX crack, make a copy of **steam_emu.ini** and place it in the Profiles folder you just made - make sure this ini file is edited to match your currently logged in Windows user's name and the file should be named the same (ex: if you are logged in as Bladez1992 the name of the file should be Bladez1992.ini) - repeat this for each user you want to have a different save game. This *will* change the username in the bottom left on the main menu (ex: Welcome, Bladez1992). This is not required, but is something you can do if you want to have that name actually changed according to which save is loaded. This is only possible with the CODEX version.
