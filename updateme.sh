#/bin/sh

# This file was downloaded from
# ....
# check the repo for docs

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

# =================================================
# This is where the magic happens :D
# Don't touch it unless you know what you're doing

# let's check inotify-tools package is present
CMD_CHECK=$(inotifywait 2> /dev/null)
PACKAGE_STATUS=$?

if [ $PACKAGE_STATUS -eq 127 ]; then
    _OS_NAME=$(cat /etc/os-release|grep "^ID"|awk '{split($0, a, "="); print a[2]}')
    clear
    echo "Woow, something failed!"
    echo "======================="
    echo
    echo "inotify-tools package not present on your system. Install it first!"
    echo
    echo "How?"
    echo
    echo "I can see you're using $_OS_NAME linux."
    echo "So just search for: install inotify-tools package on $_OS_NAME linux"
    echo "or click here https://duckduckgo.com/?q=install+inotify-tools+package+on+$_OS_NAME+linux"
    echo
    echo "Try again after that ;)..."
    echo
    exit 1;
fi

# check path is given
if [ -z "$PATH_TO_WATCH" ]; then
    clear
    echo "Hold on!"
    echo
    echo "You didn't set a path on the var PATH_TO_WATCH"
    echo "Edit this file and add the path to continue.."
    echo
    exit 1;
fi

# Let's keep an eye on those bastards!
inotifywait -m -r -e $EVENTS_TO_LISTEN --format '%w%f %e' --exclude $FILES_TO_EXCLUDE $PATH_TO_WATCH | \
  while read FILE
  do
    _MOD_FILE=$(echo $FILE|awk '{print $1}' )
    _EVENTS=$(echo $FILE|awk '{print $2}')
    touch $_MOD_FILE
    if [ $DEBUG -ne 0 ]; then
        echo "touch on file $_MOD_FILE because of event(s) $_EVENTS"   
    fi
done