## Usage

This directory contains the configuration file for [Karabiner](https://pqrs.org/osx/karabiner/index.html.en), which remaps keyboard events. Open the private.xml from within the app, and simply replace it with a symlink to file in this directory.

### Remap capslock
This is largely based on [Brett Terpstra's article](http://brettterpstra.com/2012/12/08/a-useful-caps-lock-key/), but instead of Hyper I just want Control, as I've gotten quite used to using Capslock for that. Why go to all this trouble? Because tapping Capslock to switch into normal mode in vim is sweet.

- You'll need to [install Seil](https://pqrs.org/osx/karabiner/seil.html.en)
- Then, remap Capslock to keycode 80 (F19)
- Disable Capslock in System Preferences > Keyboard > Modifier Keys... for every keyboard you're going to use (built-in and external)
- Activate the "F19 to F19" item in Karabiner that this repo's private.xml provides

You should be good to go. 
