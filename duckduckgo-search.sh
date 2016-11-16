#!/bin/bash
#
# Created by San 'ReDemoN' Monico
# https://github.com/redemonbr
#
#############################################################################
# Opens your default browser to perform a search on DuckDuckGo, with bangs included, from XFCE4 Whisker Menu search input text area.
# Supports private/incognito mode in some browsers if started with two exclamation marks.
# If started with just one exclamation mark it will do a regular search
#
# To add it, download this file and go to 'Search Actions' from XFCE4 Whisker Menu properties to add the actions:
# -1: Regular Search
# 	-Name: DuckDuckGo Search
#	-Pattern: (^!(?!!).*)
#	-Command: sh /path/to/this/file/duckduckgo-search.sh "\1"
#	-Regular expression: true
#
# -2: Private Search (using incognito/private mode from browsers, if available)
#	-Name: DuckDuckGo Private Search
#	-Pattern: (^!!.*)
#	-Command: sh /path/to/this/script/duckduckgo-search.sh "\1"
#	-Regular expression: true
#
##############################################################################
# Browsers with private/incognito mode supported:
#	-Chrome
#	-Chromium
#	-Epiphany (aka GNOME Web)
#	-Firefox
#	-Firefox-ESR
#	-GNU IceCat
#	-IceWeasel
#	-Inox
#	-Opera
#	-QupZilla
#	-SeaMonkey
#	-Vivaldi




#remove multiple spacing, and then possible backslashes, in case it is used from terminals escaping the exclamation mark
val=$(echo $(echo $1 | tr -s " ") | sed 's/\\//g')

#get user's default web browser
browser=$(echo $(xdg-settings get default-web-browser) | cut -f 1 -d '.')
#if it is a custom browser from XFCE Preferred Applications, get which one it is from the file
if [[ $browser = "custom-WebBrowser" ]]
    then browser=$(echo $(tail -2 ~/.local/share/xfce4/helpers/custom-WebBrowser.desktop) | sed 's/.*=//g')
fi

#DuckDuckGo website address
ddg="https:\/\/duckduckgo.com/?q="

#check if it is using double exclamation marks to open in private/incognito mode
if [[ $val = !!* ]]; then
    val=${val:1:${#val}-1}
    #if Firefox, Firefox-ESR, IceWeasel or GNU IceCat
    if [[ $browser = "firefox" ]] || [[ $browser = "firefox-esr" ]] || [[ $browser = "iceweasel" ]] || [[ $browser = "icecat" ]]
        then $browser --private-window "$ddg$val"
    #if Chromium, (Google) Chrome (Stable), Inox, Vivaldi (Stable) or Yandex (Stable)
    elif [[ $browser = "chromium" ]] || [[ $browser = "chrome" ]] || [[ $browser = "google-chrome" ]] || [[ $browser = "google-chrome-stable" ]] || [[ $browser = "inox" ]] || [[ $browser = "vivaldi" ]] || [[ $browser = "vivaldi-stable" ]] || [[ $browser = "yandex-browser" ]] || [[ $browser = "yandex-browser-beta" ]]
        then $browser --incognito "$ddg$val"
    #if Opera
    elif [[ $browser = "opera" ]] || [[ $browser = "opera-browser" ]]
        then $browser --private "$ddg$val"
    #if SeaMonkey
    elif [[ $browser = "seamonkey" ]]
        then $browser -private "$ddg$val"
    #if Epiphany (aka GNOME Web)
    elif [[ $browser = "epiphany" ]] || [[ $browser = "epiphany-browser" ]] || [[ $browser = "gnome-web" ]]
        then $browser --incognito-mode "$ddg$val"
    #if QupZilla
    elif [[ $browser = "qupzilla" ]]
        then $browser --private-browsing "$ddg$val"
    else $browser "$ddg$val"
    fi
else $browser "$ddg$val"
fi
