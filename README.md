## twitchless
# Requirements
To install the dependencies, simply run the following:
>brew install jq mpv

# How to use
Simply run the script and it will walk you through obtaining the information needed to run properly.

# Run From rc File
To run this from an rc file, download who.sh from the rc folder in to you ~/.config folder and append the following to the end of your rc file

> watch() {
>   if [ "(" = "who" ] 
>   then 
>       ./.config/who.sh 
>   else 
>       mpv -start 15 --force-seekable=yes https://twitch.tv/"$1"
>   fi 
> }

# Usage
From rc file
> watch who - Shows online streamers you follow
> watch <name> - Opens an mpv stream for the streamer
From script
> ./who watch who - Shows online streamers you follow
> watch <name> - Opens an mpv stream for the streamer
