Readme

Purpose : code review

Original version: [2d game tutorial](https://docs.godotengine.org/en/4.0/getting_started/first_2d_game/index.html)

The idea behind new version: add random wind timer that switches mob direction + display the value on the HUD.

Differences from vanilla version:
- added WindTimer into the HUD scene
- added WindLabel into the HUD scene
- added wind_starts and noclip (debug purposes) signals to the HUD scene
- modified *_on_mob_timer_timeout* behavior in the Main.gd
