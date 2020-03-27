# Javascript HMR (Hot Module Replacement) mac docker helper or JSHMRMDH for shorter 🤪

Sometimes HMR tools don't work quite right when using docker on some OS (OSX) with a mounted volume. You change a file and nothing happens, it doesn't detect the change and no rebuild happens.

This hack-script will make sure your HMR tools (webpack, parcel, etc) sees that a file has been changed/created/deleted/etc.

It uses the command **[touch](https://linux.die.net/man/1/touch)** to update the file from inside the container helping the HMR tools to be aware of the update.

# Installation

Clone this repo or just download the **updateme.sh** file **inside your container**

```
git clone https://github.com/gdi3d/js-hmr-osx-docker-helper
```
or

```
wget https://raw.githubusercontent.com/gdi3d/js-hmr-osx-docker-helper/master/updateme.sh
```


The script relays on **[inotify](https://linux.die.net/man/7/inotify)** and inotify-tools to work.

Assuming that you're using docker you must likely need to to install the package **inotify-tools** on your container:

#### Apline
```
apk add inotify-tools
```

#### Debian/Ubuntu
```
apt-get update && apt-get install inotify-tools
```

#### CentOS
```
yum install inotify-tools
```

# Config
Edit the file and change whatever you need within the **<config>** tag at the beging of the script

```
# <config>

# Define the absolute path where your files are
# Ex.: /users/bob/workspace/myAwsomeApp
PATH_TO_WATCH=""

# Available events at https://linux.die.net/man/1/inotifywait
# on Events section
EVENTS_TO_LISTEN="create,close_write,delete,modify,moved_from,moved_to"

# Use regular expressions here to select all files
# that you want to exclude from beign watch
FILES_TO_EXCLUDE="(\.git|.log|.md|.lock)"

# Log to terminal the filenames and events
# to help you debug
DEBUG=0

# </config>

```


# How to use it

The script must be runing inside the container to be able to detect changes.

### Add it to your package.json script
```
....
"scripts": {
    "serve": "sh updateme.sh & parcel index.html -p 8080",
    ....
```
So it will be automatically be launched when you spin up your dev server

### Let it run in the background
```
sh updateme.sh &
``` 

This will detach it from the console. If you need to stop it you need to get the process ID (PID) using `ps aux` and then `kill ID`

# Thanks
Special thanks to [@Mixtomeister](https://github.com/Mixtomeister) who's the guy responsible that I had to build this hack tool 😒
