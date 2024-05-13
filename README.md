# sync-script

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
