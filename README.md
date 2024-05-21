# sync-script v3

Version 3 includes **numerous** improvements. The Jellyseerr issue which sends the webhook is now automatically commented and closed via an API call; variables are more legibly named; the `cp` command now properly links without throwing an error (something about my NFSv4 mount point and the -a flag weren't quite vibing together--permissions and ownership are ultimately set on the destination server anyway so retaining the original owner/perms through to the sync folder was a moot effort).

What? 3 improvments counts as *numerous*! :)

(Ignore the lack of versioning and commits here. I did not intend for this project to be version-controlled and am simply using this repository as a *repository*.)

## sync-script v2

Version 2 uses a webhook to receive info from Jellyseerr (media type, title, tvdb/tmdb IDs, and Jellyseerr issue message) which is passed into the script. This makes the whole process automated (except for closing the Open Issue).

<hr>

This is just a simple script to take user input and pass it to a cp command to move files to a folder on-prem. Later this folder is synced off-site with LFTP.

The main component here is creating an interactive menu for the user to select from which lists all of the available subdirectories (as variables to use throughout the rest of the script). Looks like this

Prompt:
"What are we importing?"
1) Movies
2) Shows
3) Anime
4) Quit
> $1

Movies
1) A Christmas Carol (1990)
2) Batman (2025)
...

> $2
Copying...
