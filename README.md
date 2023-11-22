# Ssaver - a "screensaver/locker" for Terminals using zsh

ssaver is a pair of utilities. One is a script meant to be sourced into zsh. The other is a python curses
program that does the actual screensaver. 

## .zsh/screensaver.sh
This script creates a screensaver function that is used like a shell command that allows changing of the 
options used. 

## Logo 
The screensaver logo, centered on the screen by default, is two lines of user@hostname and the current time. 

### Screensaver commands
Screenaver commands are invoked with ```screensaver <cmd> <args>```.

|Command|Description                                      |Parameters                |
|----------|----------------------------------------------|--------------------------|
| activate | activates the screen saver                   | noine                    |
| blank    | Displays screensaver settings                | none                     |
| on       | Enables the screensaver with default timeout | none                     |
| off      | Disables the screensaver                     | none                     |
| save     | Saves current options                        | none                     |
| set      | Sets options  (see below)                    | colors,lock,random, time |

#### Set commands

Set commands are invoked with ```set <cmd> <args>```.

|Command|Description                                          |Parameters                |
|-------|-----------------------------------------------------|--------------------------|
|colors |Turns on or off random coloring of the logo.         |on, off                   |
| lock  |Turns on or off screen locking when saver activated. |on, off                   |
|random |Turns on or off random placement of logo             |on, off                   |
| time  |Sets the number of idle seconds for acitvation       | *seconds*                |


### Screenlock
The screenlock pythong program assumes that USER is set to the logged in user name. The screensaver.sh script marks this variable as read-only. When locking is enabled, the screenlock program uses PAM to check the password entered and unlocks the screen if authenticated with PAM. 

Screen lock arguments:

| Argument     | Description                                |
|--------------|--------------------------------------------|
| -h, --help   | Show help message and exit.                |
| -c, --colors | Use random colors on display.              |
| -n, --nolock | Disable requiring a password to deactivate.|
| -r, --random | Use random placement of logo.              | 

## Installation

### Prerequisites 
* zsh
* python 3.9+
* the following python modules: curses, pam, random

1. copy screenlock to somehwere on your path
2. copy  screensaver.zsh to a convenient place
3. add ```source path-to/screensaver.sh```
4. run ```exec zsh```


## License
This program has no license. Use it, copy it, call it yours if you feel a great need. No warranty is expressed or implied. If it breaks something, you own all the pieces. 
