#!/bin/bash
#variables
unset movies i
unset shows i
unset anime i

#read logic to fill path names into variables
while IFS= read -r -d$'\n' d; do
  movies[i++]="$d"
done < <(find /mnt/data/media/movies/ -mindepth 1 -maxdepth 1 -type d | cut -d'/' -f6- | sort)
#^ the above find lists the subdirs, cuts the prefix, sorts by alphanum...

while IFS= read -r -d$'\n' d; do
  shows[i++]="$d"
done < <(find /mnt/data/media/tv/ -mindepth 1 -maxdepth 1 -type d | cut -d'/' -f6- | sort)

while IFS= read -r -d$'\n' d; do
  anime[i++]="$d"
done < <(find /mnt/data/media/anime/ -mindepth 1 -maxdepth 1 -type d | cut -d'/' -f6- | sort)

#logic for menu
PS3="What are we importing?"
media=("Movies" "Shows" "Anime" "Search" "Quit")

select opt in "${media[@]}"; do
#top menu
  case $opt in
    Movies)
      select opt in "${movies[@]}" "Cancel"; do
      #second menu
        case $opt in
          "Cancel")
            break ;;
          *)
            echo "Selected $opt"
            cp -alv "/mnt/data/media/movies/$opt" "/mnt/data/sync/movies/$opt"
            break;;
        esac
      done
      break;;
    Shows)
      select opt in "${shows[@]}" "Cancel"; do
        case $opt in
          "Cancel")
            break;;
          *)
            echo "Selected $opt"
            cp -alv "/mnt/data/media/tv/$opt" "/mnt/data/sync/shows/$opt"
            break;;
        esac
      done
      break;;
    Anime)
      select opt in "${anime[@]}" "Cancel"; do
        case $opt in
          "Cancel")
            break;;
          *)
          echo "Selected $opt"
          cp -alv "/mnt/data/media/anime/$opt" "/mnt/data/sync/anime/$opt"
          break;;
        esac
      done
      break;;
    Search)
      # add some search function later
      break;;
    Quit)
      break;;
  esac
done
