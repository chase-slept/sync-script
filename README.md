<h1 align="center">
  Hello! 👋
</h1>

This repository is the home for a script created to facilitate LFTP file transfers between servers.

## Table of Contents
- [Table of Contents](#table-of-contents)
- [About The Project](#about-the-project)
- [Sync-Script](#sync-script)
  - [sync-script v3](#sync-script-v3)
  - [sync-script v2](#sync-script-v2)
  - [sync-script v1](#sync-script-v1)

## About The Project

The goal of this Sync-Script project is to automate a portion of the [Media Workflow](https://github.com/chase-slept/media-workflow) that my media server uses to manage available files for users. Check out that project for more information about the whole workflow.

Specifically, this script receives data from a webhook, parses it and searches for files which match, then moves those files into a sync folder where a separate LFTP script picks it up for transfer. Most of the work done in this script relates to passing-in webhook data as variables and the file-match logic.

## Sync-Script

There were several iterations of this script, so for posterity I've left the original notes below. Version 3 is the current implementation; any further version control updates will be based on that file. This script runs locally on the Raspberry Pi on my local network.

<hr>

### sync-script v3

Version 3 includes **numerous** improvements. The Jellyseerr issue which sends the webhook is now automatically commented and closed via an API call; variables are more legibly named; the `cp` command now properly links without throwing an error (something about my NFSv4 mount point and the -a flag weren't quite vibing together--permissions and ownership are ultimately set on the destination server anyway so retaining the original owner/perms through to the sync folder was a moot effort).

What? 3 improvements counts as *numerous*! 🙃

(Ignore the lack of versioning and commits here. I did not intend for this project to be version-controlled and am simply using this repository as a *repository*.)

### sync-script v2

Version 2 uses a webhook to receive info from Jellyseerr (media type, title, tvdb/tmdb IDs, and Jellyseerr issue message) which is passed into the script. This makes the whole process of selecting media automated (except for closing the Open Issue).

### sync-script v1

This is just a simple script to take user input and pass it to a cp command to move files to a folder on-prem. Later this folder is synced off-site with LFTP. Essentially, syncing specific files from an local server to a remote server.

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
